#!/usr/bin/perl
#
# Name: SeqAnt_count_indels.pl
# Version: 1.0
# Date: 4/6/2012
################################################################################
# The purpose of this script is count the number of indels from a Seqant output file
# 
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@test_line, @data_files, $data_file_number, %genome_positions, @genes_counts, $genes_counts_size,
@indel_position, $indel_position_size, $first_value, $second_value, @indel_temp, $indel_temp_size, $indel_count);

# Initialize variable values
################################################################################
$data_file_number = 0;
$genes_counts_size = 0;
@genes_counts = ();
$indel_count = 0;

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: SeqAnt_count_indels.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Glob file names
####################################################################################################
@data_files = glob("*.indel.txt");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *.txt files.\n Check directory. Exiting program";
}

# Open *.indel.txt file for input
# Open output file
####################################################################################################
open (IN_SAMPLE_ID, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
open (OUTFILE_0, ">", "$data_files[0]" . ".count.out");

# Obtain positions from indel.txt file
####################################################################################################
while (<IN_SAMPLE_ID>) {
	chomp $_;
	
	# Skip first header line
	if ($_ =~ /^Chromosome/) {
		print "\nEntered the first loop - detected header\n\n";
		next;
		}
	
	# Split line
	@test_line = split('\t', $_);
	print "\nAdding indel position: $test_line[1]\n";
	# Read all positions from indel file
	push(@indel_position, $test_line[1]);
}
close(IN_SAMPLE_ID);

# Process @indel_position file to determine number of indels
######################################################################################################
$indel_position_size = ($#indel_position + 1);

for (my $i = 0; $i < $indel_position_size; $i++) {
	$first_value = $indel_position[$i];
	push(@indel_temp, $indel_position[$i]);
	$second_value = $indel_position[$i+1];
	# End of indel
	if (($second_value - 1) == $first_value) {
		#part of indel, go to next value
		next;
	}
	else {
		# print out indel
		$indel_temp_size = ($#indel_temp + 1);
		for (my $k = 0; $k < $indel_temp_size; $k++) {
			print OUTFILE_0 "@indel_temp[$k]\t";
		}
		print OUTFILE_0 "\n";
		#count indels here
		$indel_count++;
	}
	# Reset variables
	@indel_temp = ();
	$first_value = 0;
	$second_value = 0;
}

print OUTFILE_0 "Total number of indels is $indel_count\n";
close(OUTFILE_0);

####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################
