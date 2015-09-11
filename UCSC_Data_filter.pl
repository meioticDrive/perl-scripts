#!/usr/bin/perl
#
# Name: UCSC_Data_filter.pl
# Version: 1.0
# Date: 3/30/2012
################################################################################
# The purpose of this script is to filter duplicates from SeqAnt output files
# Need to add file name to script - need to update to make easier to use
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

# Glob file names (add future code)
# Open .txt file for input
# Open output file
####################################################################################################
open (IN_SAMPLE_ID, "<", "Human_XChrom_hg19.txt") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
open (OUTFILE_0, ">", "Human_XChrom_hg19.out");

# Process .txt file
####################################################################################################
while (<IN_SAMPLE_ID>) {
	chomp $_;
	
	# Skip first line
	if ($_ =~ /^#bin/) {
		print "\nEntered the first loop - detected header\n\n";
		print OUTFILE_0 "$_\n";
		next;
		}
	
	# Split line
	@test_line = split('\t', $_);
	
	# Check if value exists in hash
	 if (exists $genome_positions{"$test_line[12]"}) {
	 	next;
	 	}
	 	else {
	 	# Assign to hash and output line
	 	$genome_positions{"$test_line[12]"} = "$test_line[12]";
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
