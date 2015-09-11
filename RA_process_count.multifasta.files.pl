#!/usr/bin/perl
#
# Name: RA_process_count.multifasta.files.pl
# Version: 1.0
# Date: 7/24/09
##############################################################################
##############################################################################
# 1. The purpose of this script is to convert SNP output files from popgen 
# code to Linkage file format for analysis with Haploview. The primary data 
# anticipated is bacterial genome data (hence single individuals # no family 
# structure, no affected status, haploid # like X chromosome in human males).
# 2. Launch from within folder containing files
# 3. Files required: SNP Data File, Sample ID File
##############################################################################
##############################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
##############################################################################
my (@sample_ID_file, $sampleID_file_number, @sample_ID, @sample_genotype_file, $samplegenotype_file_number, @SNPs, $sample_number, $i, $j, @temp_line, $genotype_number, @Total_bases_called);

# Initialize variable values
##############################################################################

# Open for output of log files
open(OUT_LOG, ">>", "log.RA_process_count.multifasta.files.out")
	or die "Cannot open OUT_LOG for data output";

# Open for output of Linkage file
open(OUT_COUNT, ">>", "Process_count.multifasta.files.txt")
    or die "Cannot open OUT_COUNT for data output";

# Process Sample ID File
##############################################################################
# Obtain name of sample ID file
@sample_ID_file = glob("*multifasta.txt");
$sampleID_file_number = ($#sample_ID_file + 1);
if ($sampleID_file_number == 0) {
	die "$sampleID_file_number SampleID files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $sampleID_file_number files\n";
print OUT_LOG "Detected $sampleID_file_number sampleID file(s)\n\n";

# Obtain names for samples and place into array
foreach my $files (@sample_ID_file) {

    # Open $files to be read
    open (IN_SAMPLEID, "<", "$files")
        or die "Cannot open IN_SAMPLEID filehandle to read file";
    
    # Push Sample IDs onto array @sample_ID
    while (<IN_SAMPLEID>) {
        chomp($_);
        
        # Collect file names
        if ($_ =~ /^200/) {
            push(@sample_ID, $_);
        }
        
        if ($_ =~ /^Total/) {
            push(@Total_bases_called, $_)
        }
    }
}

# Print Output
##############################################################################

for ($i = 0; $i < $#Total_bases_called; $i++) {
    # Sample names - loop by 2
    print OUT_COUNT "$sample_ID[(2*$i)]\t";
    # Total bases - loop by 1
    print OUT_COUNT "$Total_bases_called[$i]\n";
}

close (IN_SAMPLEID);
close (OUT_COUNT);
print "Completed SNP_to_Linkage script\n";
print OUT_LOG "Completed SNP_to_Linkage script\n";
close (OUT_LOG);






