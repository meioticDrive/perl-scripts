#!/usr/bin/perl
#
# Name: SNP.raw_to_SNP.edit.pl
# Version: 1.0
# Date: 3/21/09
##############################################################################
##############################################################################
# 1. 
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
#@SNPdata = glob("*raw.SNPdata.txt");
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
    open (OUT_SNPDATA, ">>", "edit.SNPdata.txt")
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
        print OUT_SNPDATA "$fields[0]" . "_" . "$fields[2]\t";
        
        for ($i = 4; $i < $fields_number; $i++) {
            print OUT_SNPDATA "$fields[$i]\t";
        }
        
        # Add final end of line character
        print OUT_SNPDATA "\n";
    }
}

print "Complete SNP.raw_to_SNP.edit.pl script\n";
print OUT_LOG "Complete SNP.raw_to_SNP.edit.pl script\n";

