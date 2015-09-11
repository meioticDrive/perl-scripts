#!/usr/bin/perl -w
# PPMS_parseProjects.pl
# Version 1.0
# copyright Michael E. Zwick, 07/31/2014
################################################################################
# Program designed to parse projects.csv file from PPMS to determine the
# number of different projects in each phase
# Website location: https://ppms.us/emory/vproj/?pf=3
# 1. Launch from above directory containing file
# 2.
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
my(@ppms_file, $ppms_file_number, @temp_line, @phases);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@ppms_file = ();
$ppms_file_number = 0;
@temp_line = ();
@phases = ();

################################################################################
# Main Program
################################################################################

# Change to file directory, in user provided directory
chdir "$ARGV[0]"
    or die "Cannot change to directory $ARGV[0]\n";

# Remove old files
unlink("ppmsProjects.parsed.txt");
unlink("log.ppmsProjects.parsed.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.ppmsProjects.parsed.txt")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of ppms files
@ppms_file = glob("projects.csv");
$ppms_file_number = ($#ppms_file + 1);
if ($ppms_file_number == 0) {
	die "$ppms_file_number ppms files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $ppms_file_number projects.csv file(s)\n";
print OUT_LOG "Detected $ppms_file_number projects.csv file(s)\n";

# Open output file for complete association data
open (OUT_PROJECTS, ">>", "ppmsProjects.parsed.txt")
    or die "Cannot open OUT_PROJECTS filehandle to parsed output file info";

# Output header
print OUT_PROJECTS "Projects in each phases 1 - 8:\n";

# Set up an array to hold phase counts
for(my $i = 0;$i < 16; $i++) {
    $phases[$i] = 0;
}

# Process ppms projects.csv file
foreach my $files (@ppms_file) {

    #Open $files to be read
    open (IN_PROJECTS, "<", "$files")
        or die "Cannot open IN_PROJECTS filehandle to read file";

    while (<IN_PROJECTS>) {
        chomp $_;
        #print "$_\n";

        # Remove header row
        if ($_ =~ /^#,Type/) {
            print "Removed header\n";
            next;
        }

        # Find a project line
        if ($_ =~ /^\"\s+#/) {
            
            @temp_line = split(/,/, $_);
            print "Made it in here with $temp_line[0]\n";
            print "$temp_line[3]\n";
            $temp_line[3]=$temp_line[3]+0;
            $phases[$temp_line[3]]++;
        }
    }
close (IN_PROJECTS);
}

# Print values from array phase counts
for(my $i = 0;$i < 16; $i++) {
    print OUT_PROJECTS "Number of Phase $i: $phases[$i]\n";
}

close (OUT_PROJECTS);
print "Completed ppms_parseProjects.pl script\n";
print OUT_LOG "Completed ppms_parseProjects.pl script\n";
close (OUT_LOG);

################################################################################
### Subroutines ###
################################################################################

