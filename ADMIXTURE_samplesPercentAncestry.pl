#!/usr/bin/perl -w
# Version 1.0
# copyright Michael E. Zwick, 07/23/2014
################################################################################
# Program designed to generate file of Family ID/Sample IDs to drop samples for # Plink
# 1. Input data: List of samples to drop (Family ID/Sample ID)
# 2. Input data: admixture file (sample ID/European Ancestry/West African 
# Ancestry)
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
my(@admixture_file, $admixture_file_number, @drop_names, $drop_names_number, @temp_names, @temp_line, %pedindv);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@admixture_file = ();
$admixture_file_number = 0;


@drop_names = ();
$drop_names_number = 0;
@temp_names = ();
@temp_line = ();

################################################################################
# Main Program
################################################################################

# Remove old files
unlink("*.familiestoDrop.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.ADMIXTURE_samplesPercentAncestry.txt")
	or die "Cannot open OUT_LOG for log output file";

# Obtain admixture file - will match and extract names from this file
@admixture_file = glob("admixture_aa_redo.txt");
$admixture_file_number = ($#admixture_file + 1);
if ($admixture_file_number == 0) {
	die "$admixture_file_number admixture files detected.\n
		Check directory. Exiting program";
}

# Obtain samples names to match to admixture file
@drop_names = glob("*drop.txt");
$drop_names_number = ($#drop_names + 1);
if ($drop_names_number == 0) {
	die "$drop_names_number *drop.txt files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected: \n $admixture_file_number admixture file\n 
 \n drop_names_number samplestoDrop file\n";
print OUT_LOG print "Detected: \n $admixture_file_number admixture file\n 
 \n drop_names_number samplestoDrop file\n";

# Open output file for Samples with related WA ancestry
open (OUT_ANNOT, ">>", "Samples_WA_ancestry.txt")
	or die "Cannot open OUT_ANNOT filehandle to Samples_WA_ancestry.txt file";

# Process @admixture_file into a hash for searching
foreach my $p (@admixture_file) {
    
    #Open $name to be read
    open (IN_PLINK, "<", "$p")
        or die "Cannot open IN_ANNOT filehandle to read *.pedindv.txt file";

    while (<IN_PLINK>) {
        chomp $_;
        if ($_ eq "SampleID") { # Drop header line
        next;
        }
        @temp_line = split(/\s+/, $_);
        #print "$temp_line[0]\t$temp_line[1]\n";
        $pedindv{"$temp_line[0]"} = "$temp_line[2]";
        @temp_line = ();
    }
close (IN_PLINK);
}

# Search has for names from @drop_names file in admixture file
foreach my $name (@drop_names) {
    #Open $name to be read
    open (IN_NAMES, "<", "$name")
        or die "Cannot open IN_ANNOT filehandle to read *_familyIDs.txt file";

    while (<IN_NAMES>) {
        chomp $_;
        if ($_ eq "SampleID") { # Drop header line
            next;
        }
        @temp_line = split(/\s+/, $_);
        #print "$temp_line[0]\t$temp_line[1]\n";
        print "$pedindv{$temp_line[1]}\n";
        print OUT_ANNOT "$temp_line[1]\t$pedindv{$temp_line[1]}\n";
        @temp_line = ();
    }
close (IN_NAMES);
}



# Search for %pedindv has for matching @temp_names names

#foreach my $n (@temp_names) {
#    #Need to check if hash is defined for key
#    print "Key: $n ; Value: $pedindv{$n}\n";
#    print OUT_ANNOT "$n\t$pedindv{$n}\n";
#}

print "ADMIXTURE_samplesPercentAncestry.PL\n";
print OUT_LOG "ADMIXTURE_samplesPercentAncestry.PL\n";
close (OUT_LOG);



################################################################################
### Subroutines ###
################################################################################
