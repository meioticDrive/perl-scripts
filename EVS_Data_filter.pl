#!/usr/bin/perl
#
# Name: EVS_Data_filter.pl
# Version: 1.0
# Date: 3/27/2012
################################################################################
# The purpose of this script is to filter duplicates from the Exome Variant Server (EVS) text files
# of complete sequenced exomes.
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@test_line, %genome_positions);

# Initialize variable values
################################################################################


# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: EVS_Data_filter.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Open .txt file for input, open output file
####################################################################################################
open (IN_SAMPLE_ID, "<", "ESP5400.chrX.snps_silents_replacements.txt") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
open (OUTFILE_0, ">", "EVS_unique.out");

# Process .txt file
####################################################################################################
while (<IN_SAMPLE_ID>) {
	chomp $_;
	
	# Skip first line
	if ($_ =~ /^#/) {
		print "\nEntered the first loop\n\n";
		print "With line\n";
		print "$_\n";
		next;
		}
	
	# Split line
	@test_line = split('\t', $_);
	
	# Check if value exists in hash
	 if (exists $genome_positions{"$test_line[0]"}) {
	 	next;
	 	}
	 	else {
	 	# Assign to hash and output line
	 	$genome_positions{"$test_line[0]"} = "$test_line[0]";
	 	 print OUTFILE_0 "$_\n";
	 	 next;
	 	 }
}
close(IN_SAMPLE_ID);
close(OUTFILE_0);





####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################
