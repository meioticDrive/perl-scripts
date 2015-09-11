#!/usr/bin/perl
#
# Name: total_X_variants.pl
# Version: 1.0
# Date: 4/15/20112
################################################################################
# The purpose of this script is read input from .count.out files which report
# variant sites/alleles for a subset of X chromosome genes, and summarize them over all 
# X chromosome genes. Genes with no variants are shown as 0. Genes with different names 
# are output for hand annotation-counting.
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@xchrome_files, $xchrome_file_number, @count_files, $count_file_number, @test_line, @variant_counts, $variant_counts_size, $match_indicator);

# Initialize variable values
################################################################################
$xchrome_file_number = 0;
$count_file_number = 0;
$variant_counts_size = 0;
@xchrome_files  = ();
@count_files = ();
@test_line = ();
@variant_counts =();
$match_indicator = 0;

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: EVS_Data_filter.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

#Glob file names
####################################################################################################
@xchrome_files = glob("*.all.genes.txt");
$xchrome_file_number = ($#xchrome_files + 1);
if ($xchrome_file_number == 0) {
  die "Detected $xchrome_file_number *.all.genes.txt files.\n Check directory. Exiting program";
}

@count_files = glob("*.count.*");
$count_file_number = ($#count_files + 1);
if ($count_file_number == 0) {
  die "Detected $count_file_number *.count.* files.\n Check directory. Exiting program";
}

# Open .txt file for input
# Open output file
####################################################################################################
open (IN_XCHROME_IN, "<", "$xchrome_files[0]") or die "Cannot open IN_XCHROME_ID filehandle to read file";
open(IN_COUNT_IN, "<", "$count_files[0]") or die "Cannot open IN_COUNT_IN filehandle to read file";

open (OUTFILE_0, ">", "$count_files[0]" . ".total.txt");
open (OUTFILE_1, ">", "$count_files[0]" . ".problems.txt");

# Process X chromosome reference file
####################################################################################################
while(<IN_XCHROME_IN>) {
	chomp $_; 
	
	# Fill array with gene names and initial count of 0
	# Split line to get gene names
	@test_line = split('\t', $_);
	print "\nGene name is $test_line[2]\n";
	
	# Generate X chromosome file with default counts of 0
	push(@variant_counts, $test_line[2]);
	push(@variant_counts, 0);

	# Reset array
	@test_line = ();
}

# Process count file, update @variant_counts array
while(<IN_COUNT_IN>) {
	chomp $_;
	@test_line = split('\t', $_);
	print "\nGene name is $test_line[0] with count $test_line[1]\n";
	$variant_counts_size =  ($#variant_counts + 1);
	
	# Search @variants array for match
	for (my $i=0; $i < $variant_counts_size; $i = $i + 2) {
		# Find matches
		if ($test_line[0] eq $variant_counts[$i]) {
			$variant_counts[$i+1] = $variant_counts[$i+1] + $test_line[1];
			$match_indicator = 1;
		}
	}
	
	if ($match_indicator == 0) {
		print "\nFailed to find match in for loop!!\n";
		print "Gene name is: $test_line[0]\n";
		print OUTFILE_1 "Failed to match with gene name and count value: $test_line[0]\t$test_line[1]\n";
	} else {
		$match_indicator = 0;
	}
}

# Output @variant_counts array to file
for (my $i = 0; $i < $variant_counts_size; $i = $i + 2) {
	print OUTFILE_0 "$variant_counts[$i]\t$variant_counts[$i+1]\n";
}

print "Completed total_X_variants.pl script\n";

