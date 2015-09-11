#!/usr/bin/perl
#
# Name: SNP_to_Linkage.pl
# Version: 1.0
# Date: 3/21/09
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
my (@sample_ID_file, $sampleID_file_number, @sample_ID, @sample_genotype_file, $samplegenotype_file_number, @SNPs, $sample_number, $i, $j, @temp_line, $genotype_number);

# Initialize variable values
##############################################################################

# Open for output of log files
open(OUT_LOG, ">>", "log.SNP_to_Linkage.out.txt")
	or die "Cannot open OUT_LOG for data output";

# Open for output of Linkage file
open(OUT_LINKAGE, ">>", "Final.Linkage.txt")
    or die "Cannot open OUT_LINKAGE for data output";

# Process Sample ID File
##############################################################################
# Obtain name of sample ID file
@sample_ID_file = glob("*SampleID.txt");
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
        push(@sample_ID, $_);
    }
}
# Check Sample ID Information: Print out contents of @sample_ID array
print OUT_LOG "Sample Names\n";
foreach my $names (@sample_ID) {
    chomp($names);
    #print "$names\n";
    print OUT_LOG "$names\n";
}

# Process Genotype File
##############################################################################
@sample_genotype_file = glob("*.edit.SNPdata.txt");
#@sample_genotype_file = glob("*.Total.Region.snp.txt");

$samplegenotype_file_number = ($#sample_genotype_file + 1);
if ($samplegenotype_file_number == 0) {
	die "$samplegenotype_file_number sample genotype files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $samplegenotype_file_number files\n";
print OUT_LOG "Detected $samplegenotype_file_number sampleID file(s)\n\n";

# Obtain genotypes for each individual
foreach my $files (@sample_genotype_file) {

    # Open $files to be read
    open (IN_SAMPLESNPS, "<", "$files")
        or die "Cannot open IN_SAMPLESNPS filehandle to read file";

    # Push SNP genotypes onto array @SNPs
    while (<IN_SAMPLESNPS>) {
        chomp($_);
        push(@SNPs, $_);
    }
}

# Generate Final Linkage File
##############################################################################

# Verify same number of sample names and genotypes
# Die if they do not match
if ($#SNPs != $#sample_ID) {
    die "Number of sample IDs do not match number of individuals in SNP file";
}
# Let user know if they match
if ($#SNPs == $#sample_ID) {
    print "Number of sample IDs matches number of individuals in SNP file\n";
    print OUT_LOG "Number of sample IDs matches number of individuals in SNP file\n";
}

# Assign sample number
$sample_number = ($#sample_ID + 1);

# Loop over @sample_ID and @SNPs arrays to generate linkage files
for ($i = 0; $i < $sample_number; $i++) {

# Output Pedigreee Name, Individual ID
print OUT_LINKAGE "$sample_ID[$i]\t$sample_ID[$i]\t";

# Output Father ID, Mother ID, Sex(Male), Affection Status
print OUT_LINKAGE "0\t0\t1\t0\t";

# Split genotype line
@temp_line = split/\t/, $SNPs[$i];
$genotype_number = ($#temp_line + 1);

    # Output genotype info # duplicate for haploid
    for ($j = 0; $j < $genotype_number; $j++) {
        print OUT_LINKAGE "$temp_line[$j]\t$temp_line[$j]\t";
    }

# End of line
print OUT_LINKAGE "\n";

# Reset variables
@temp_line = '';

}

print "Completed SNP_to_Linkage script\n";
print OUT_LOG "Completed SNP_to_Linkage script\n";








