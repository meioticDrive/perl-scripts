#!/usr/bin/perl
#
# Name: SeqAnt_Data_filter.pl
# Version: 1.0
# Date: 3/27/2012
################################################################################
# The purpose of this script is to filter duplicates from SeqAnt output files
# Need to add file name to script - need to update to make easier to use
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@test_line, %genome_positions, @data_files, $data_file_number);

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

# Glob file names
####################################################################################################
@data_files = glob("*.txt");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *.txt files.\n Check directory. Exiting program";
}

# Open .txt file for input
# Open output file
####################################################################################################
open (IN_SAMPLE_ID, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
open (OUTFILE_0, ">", "$data_files[0]" . ".filter.out");

# Process .txt file
####################################################################################################
while (<IN_SAMPLE_ID>) {
	chomp $_;
	
	# Skip first line
	if ($_ =~ /^Variation/) {
		print "\nEntered the first loop - detected header\n\n";
		print OUTFILE_0 "$_\n";
		next;
		}
	
	# Split line
	@test_line = split('\t', $_);
	
	# Check if value exists in hash
	 if (exists $genome_positions{"$test_line[3]"}) {
	 	next;
	 	}
	 	else {
	 	# Assign to hash and output line
	 	$genome_positions{"$test_line[3]"} = "$test_line[3]";
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
