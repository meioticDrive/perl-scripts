#!/usr/bin/perl
#
# Name: SeqAnt_Data_to_DataGraph.pl
# Version: 1.0
# Date: 8/24/2012
####################################################################################################
# The purpose of this script take the output from SeqAnt_Data_filter.pl output to process
# multiple filter files and format the data for a Figure showing the relationship between
# frequency in sample, PhyloP score, and presense/absence in dbSNP in DataGraph.
# We are assuming data is from the X chromosome for allele frequency estimation (would need to update if
# using on data from an autosomal region)
# Outputs PhyloP placental mammals
####################################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
####################################################################################################
my (@data_files, $data_file_nmbr, $i, @test_line, $total_samples, $allele_freq);

# Initialize variable values
####################################################################################################
$data_file_nmbr = 0;
$i = 0;
$total_samples = 95;
$allele_freq = 0;

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: SeqAnt_Data_to_DataGraph.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Glob file names - *.txt.filter.out files
####################################################################################################
@data_files = glob("*.txt.filter.out");
$data_file_nmbr = ($#data_files + 1);
if ($data_file_nmbr == 0) {
  die "Detected $data_file_nmbr *.txt.filter.out files.\n Check directory. Exiting program";
}

# Open output file to receive formatted data
# This data will be able to be opened with Excel and then imported 
# column by column into DataGraph
####################################################################################################
open (OUTFILE_0, ">", "Variants" . ".datagraph.txt");

# Loop over all @data_files
for($i = 0; $i < $data_file_nmbr; $i++) {

	# Open .txt file for input
	####################################################################################################
	open (IN_SAMPLE_ID, "<", "$data_files[$i]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";

	# Process .txt file
	####################################################################################################
	while (<IN_SAMPLE_ID>) {
		chomp $_;
	
		# Process header line first time through
		# Otherwise, skip line
		if (($_ =~ /^Variation/) & ($i==0)) {
			print "\nEntered the first loop - detected header\n\n";
			@test_line = split('\t', $_);
			print OUTFILE_0 "$test_line[0]\t$test_line[1]\tStart Position\tStop Position\tMinor Allele Freq\tPhyloP\tIn dbSNP\tdbSNP Variant Type\n";
			next;
		} 
		
		# Skip header lines in other files - second and later files
		if ($_ =~ /^Variation/) {
			print "\nDetected header in a file. Skipping line.\n";
			next;
		} 
		
		# Process data lines here
		# Split line, output data or perform calculations and output results
		@test_line = split('\t', $_);
		print OUTFILE_0 "$test_line[0]\t$test_line[1]\t$test_line[3]\t$test_line[3]\t";
		
		# Calculate and output allele frequency
		# Check to see that parameters are integers
		if ($test_line[23] =~ /^[+-]?\d+$/ ) {
    		#print "Is a number\n";
		} else {
    		print "Is not a number\n";
    		print "Value of variable is: $test_line[23]\n";
    		print "$_\n";
		}
		
		$allele_freq = ($test_line[23]/$total_samples);
		# Convert frequency of major alleles to minor allele
		if ($allele_freq > 0.5) {
			$allele_freq = (1.0 - $allele_freq);
		}
		print OUTFILE_0 "$allele_freq\t";
		
		# Outputs PhyloP
		print OUTFILE_0 "$test_line[20]\t";
		
		# Determine if variant in dbSNP
		# Output Yes or No
		if ($test_line[14] eq "---") {
			print OUTFILE_0 "No\t2\n";
		} else {
			print OUTFILE_0 "Yes\t1\n";
		}
		
		#Reset variables
		$allele_freq = 0;
		@test_line = ();
	}
}
close(IN_SAMPLE_ID);
close(OUTFILE_0);



print "Ran code assuming $total_samples total samples\n";
print "Completed SeqAnt_Data_to_DataGraph.pl script\n";

####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################
