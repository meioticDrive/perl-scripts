#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 07/21/2014
################################################################################
# Program designed to generate file of Family ID/Sample IDs to drop samples for # Plink
# 1. Input data: List of family IDs - *.familyIDs.txt (output of eigenstrat is family IDs)
# 2. Input data: *.pedindv file (derived from ped file)
# 3. Run script from inside folder containing files
#
# Future Updates
# 
################################################################################
use strict;
use Cwd;

################################################################################
# Local variable definitions
################################################################################

# Define local variables
my(@plink_file, $plink_file_number, @drop_names, $drop_names_number, @temp_names, @temp_line, %pedindv);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@plink_file = ();
$plink_file_number = 0;
@drop_names = ();
$drop_names_number = 0;
@temp_names = ();
@temp_line = ();

################################################################################
# Main Program
################################################################################

# Remove old files
unlink("*.familiestoDrop.txt");
unlink("log.familiestoDrop.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.familiestoDrop.txt")
	or die "Cannot open OUT_LOG for log output";

# Obtain samples names to drop
@drop_names = glob("*_familyIDs.txt");
$drop_names_number = ($#drop_names + 1);
if ($drop_names_number == 0) {
	die "$drop_names_number *_familyIDs files detected.\n
		Check directory. Exiting program";
}

# Obtain pedindv file - will match and extract names from this file
@plink_file = glob("*.pedindv.txt");
$plink_file_number = ($#plink_file + 1);
if ($plink_file_number == 0) {
	die "$plink_file_number *.pedindv.txt files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected: \n $drop_names_number *_sampleIDs file\n $plink_file_number  file pedindv file\n";
print OUT_LOG print "Detected: \n $drop_names_number *_sampleIDs file\n $plink_file_number  file pedindv file\n";

# Open output file for family IDs to drop
open (OUT_ANNOT, ">>", "PLINK_familiestoDrop.txt")
	or die "Cannot open OUT_ANNOT filehandle to PLINK_familiesToDrop file";

# Process *_familyIDs.txt file
foreach my $name (@drop_names) {
    
    #Open $name to be read
    open (IN_NAMES, "<", "$name")
        or die "Cannot open IN_ANNOT filehandle to read *_familyIDs.txt file";

    while (<IN_NAMES>) {
        chomp $_;
        
        if ($_ eq "SampleID") { # Drop header line
            next;
        }
        push (@temp_names, $_); # Push names onto array
    }
close (IN_NAMES);
}

# Process *.pedindv file into a hash for searching
foreach my $p (@plink_file) {
    
    #Open $name to be read
    open (IN_PLINK, "<", "$p")
        or die "Cannot open IN_ANNOT filehandle to read *.pedindv.txt file";

    while (<IN_PLINK>) {
        chomp $_;
        @temp_line = split(/\s+/, $_);
        #print "$temp_line[0]\t$temp_line[1]\n";
        $pedindv{"$temp_line[0]"} = "$temp_line[1]";
    }
close (IN_PLINK);
}

# Search for %pedindv has for matching @temp_names names

foreach my $n (@temp_names) {
    #Need to check if hash is defined for key
    print "Key: $n ; Value: $pedindv{$n}\n";
    print OUT_ANNOT "$n\t$pedindv{$n}\n";
}

print "Completed PLINK_familiestoDrop script\n";
print OUT_LOG "Completed PLINK_familiestoDrop script\n";
close (OUT_LOG);



################################################################################
### Subroutines ###
################################################################################
