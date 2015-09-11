#!/usr/bin/perl -w
# Version 1.0
# copyright Michael E. Zwick, 08/5/2014
################################################################################
# Program designed to generate and format data for PLINK pheno.txt file 
# (multiple phenotypes for a given set of files)
# 1. Parses phenotype file that is in linkage format. Specific for IBD data.
# 2. Assumed columns: Family ID	Indiv ID	Dad_ID	Mom_ID	Gender	Affectation	# Disease
#
# Future Updates
# 1. Revise to accept phenotype text as argument from user
################################################################################
use strict;
use Cwd;

################################################################################
# Local variable definitions
################################################################################

# Define local variables
my(@plink_file, $plink_file_number, @temp_line, $count, $logPscore, $chr, @startbound, @stopbound, $chrcount, $temp_mean, $i, $n);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@plink_file = ();
$plink_file_number = 0;
@temp_line = ();
$count = 1;
$logPscore = 0;
$chr = 1;
$chrcount = 0;
$temp_mean = 0;

################################################################################
# Main Program
################################################################################

# Remove old files
unlink("data.pheno.txt");
unlink("log.makePhenoFile.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.makePhenoFile.txt")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of Phenotype file
# Files for AA iChip: *.drop03.txt or *drop03.95WA.txt
@plink_file = glob("*.drop03.95WA.txt");
$plink_file_number = ($#plink_file + 1);
if ($plink_file_number == 0) {
	die "$plink_file_number phenotype files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $plink_file_number *.pedindv.txt file\n";
print OUT_LOG "Detected $plink_file_number *.pedindv.txt file\n";

# Open output file for complete association data
open (OUT_ANNOT, ">>", "data.pheno.txt")
	or die "Cannot open OUT_ANNOT filehandle for parsed output file info";

# Output header
# print OUT_ANNOT "Family ID\tIndiv ID\tDad_ID\tMom_ID\tGender\tAffectation\tDisease\tRace\tJewish ancestry\tAge_at_DxCount\n";

# Process plink association file
foreach my $files (@plink_file) {

    #Open $files to be read
    open (IN_ANNOT, "<", "$files")
        or die "Cannot open IN_ANNOT filehandle to read *.pedindv.txt file";

    while (<IN_ANNOT>) {
        chomp $_;
        @temp_line = split(/\s+/, $_);
        
        # Skip Header Line
        if ($temp_line[0] =~ /^Family/) {
            print "Skipped header line\n";
            next;
        }
        
        # Output CD Cases
        #if ($temp_line[5] == "2" && $temp_line[6] eq "CD") {
         #   print OUT_ANNOT "$temp_line[0]\t$temp_line[1]\t$temp_line[5]\n";
        #}
        
        # Output UC Cases
        if (($temp_line[5] == "2") && ($temp_line[6] eq "UC")) {
            print OUT_ANNOT "$temp_line[0]\t$temp_line[1]\t$temp_line[5]\n";
        }
        
        # Output Controls
        if ($temp_line[5] == "1") {
            print OUT_ANNOT "$temp_line[0]\t$temp_line[1]\t$temp_line[5]\n";
        }
        @temp_line = ();
    }
}
close (IN_ANNOT);
close (OUT_ANNOT);

print "Completed PLINK_makePhenoFile\n";
print OUT_LOG "Completed PLINK_makePhenoFile\n";
close (OUT_LOG);

################################################################################
### Subroutines ###
################################################################################
