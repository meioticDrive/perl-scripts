#!/usr/bin/perl
#
# Name: ALL_count_variants.pl
# Version: 1.0
# Date: 4/3/2012
################################################################################
# The purpose of this script is count the number of variants from a filtered unique EVS file
# 
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@test_line, @data_files, $data_file_number, @target_file, $target_file_number, %genome_positions, @genes_counts, $genes_counts_size);

# Initialize variable values
################################################################################
$data_file_number = 0;
$genes_counts_size = 0;
@genes_counts = ();

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

# All chromosome gene names
@data_files = glob("*.All.Data.txt");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *.txt files.\n Check directory. Exiting program";
}

# Target files
@target_files = glob("*.count.out");
$target_file_number = ($#data_files + 1);
if ($target_file_number == 0) {
  die "Detected $target_file_number *.txt files.\n Check directory. Exiting program";
}

# Open *.All.Data.txt file for input
# Open  target file - *.count.out
# Open output file
####################################################################################################
open (IN_SAMPLE_ID, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
open (IN_TARGET_ID, "<", "$target_files[0]") or die "Cannot open IN_TARGET_ID filehandle to read file";
open (OUTFILE_0, ">", "$data_files[0]" . ".ALL.out");

# Open target file
####################################################################################################






while (<IN_SAMPLE_ID>) {
	chomp $_;
	
	# Skip first line
	if ($_ =~ /^Chromosome/) {
		print "\nEntered the first loop - detected header\n\n";
		#print OUTFILE_0 "$_\n";
		next;
		}
	
	# Split line
	@test_line = split('\t', $_);
	#print "\n\nLine value: $test_line[14]\n\n";
	
	# Store gene name in array - odd positions
	# Store gene number in array - even positions
	####################################################################################################
	 if (exists $genome_positions{"$test_line[14]"}) {
	 	print "\nEntered the exists loop with $test_line[14]\n";
	 	# Check if value exists in hash
	 	$genes_counts_size = ($#genes_counts + 1);
	 	# Determines position of matching gene name and adds one to count
	 	for (my $i  =  0; $i  <  $genes_counts_size; $i = $i + 2) {
	 		#print "Trying to match existing value\n";
	 		#print "Array value: $genes_counts[$i] with Line value: $test_line[14]\n";
			if ("$genes_counts[$i]" eq "$test_line[14]") {
				#print "Found a match!!!\n";
				#print "Current value is $genes_counts[$i+1]\n";
	 			$genes_counts[$i+1] = $genes_counts[$i+1] + 1;
	 			#print "New value is $genes_counts[$i+1]\n";
	 		}
	 	}
	 }
	 else {
	 	# Does not exist in hash
	 	# Assign to hash and output line
	 	$genome_positions{"$test_line[14]"} = "$test_line[14]";
		# Add to end of array @genes_counts
		#print "In the else loop: $test_line[14]\n";
		push(@genes_counts, $test_line[14]);
		#print "First value: $genes_counts[0]\n";
		push(@genes_counts,1);
		#print "Second value: $genes_counts[1]\n";
	 }
}

# Output Gene Names and Counts
####################################################################################################
$genes_counts_size = ($#genes_counts + 1);
for (my $k = 0; $k < $genes_counts_size; $k = $k + 2) {
	print OUTFILE_0 "$genes_counts[$k]\t";
	print OUTFILE_0 "$genes_counts[$k+1]\n";
}

close(IN_SAMPLE_ID);
close(OUTFILE_0);





####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################
