#!/usr/bin/perl
#
# Name: SNP_to_Linkage.pl
# Version: 1.0
# Date: 3/21/09
##############################################################################
##############################################################################
# 1. The purpose of this script is to convert SNP output files from popgen 
# code to generate SNP marker files for analysis with Haploview. The primary 
# data consists of 
##############################################################################
##############################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
##############################################################################
my (@SNPdata, $SNPdata_file_number, @fields, $fields_number, $i);

# Initialize variable values
##############################################################################

# Open for output of log files
open(OUT_LOG, ">>", "log.SNP.raw_to_SNP.edit.out")
	or die "Cannot open OUT_LOG for data output";


# Process Sample ID File
##############################################################################
# Obtain name of sample ID file
@SNPdata = glob("*Total.Region.snp.txt");
$SNPdata_file_number = ($#SNPdata + 1);
if ($SNPdata_file_number == 0) {
	die "$SNPdata_file_number raw.SNPdata files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $SNPdata_file_number files\n";
print OUT_LOG "Detected $SNPdata_file_number sampleID file(s)\n\n";

# Obtain names for samples and place into array
foreach my $files (@SNPdata) {

    # Open $files to be read
    open (IN_SNPDATA, "<", "$files")
        or die "Cannot open IN_SNPDATA filehandle to read file";
    
    # Open output file to write
    open (OUT_SNPDATA, ">>", "SNPmarkers.txt")
        or die "Cannot open OUT_SNPDATA filehandle to read file";
    
    # Reformat Data
    while (<IN_SNPDATA>) {
        chomp($_);
        
        # Split line of SNPdata
        @fields = split /\t/, $_;
        $fields_number = ($#fields + 1);
        
        # Output data to new edit.SNPdata.txt file
        # Combine fragment and reference seq position to generate unique 
        # identifier
        print OUT_SNPDATA "$fields[0]" . "_" . "$fields[2]\t$fields[2]\n";
        
    }
}

print "Complete SNP.raw_to_SNP.markers.pl script\n";
print OUT_LOG "Complete SNP.raw_to_SNP.markers.pl script\n";

