#!/usr/bin/perl
#
# Name: SeqAnt_count_variants.pl
# Version: 1.0
# Date: 4/2/2012
################################################################################
# The purpose of this script is count the number of variants from a filtered unique SeqAnt fike
# 
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@test_line, @data_files, $data_file_number, %genome_positions, @genes_counts, $genes_counts_size, @temp_countAlleles, $temp_countAlleles_size);

# Initialize variable values
################################################################################
$data_file_number = 0;
$genes_counts_size = 0;
@genes_counts = ();
@temp_countAlleles = ();
$temp_countAlleles_size = 0;

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
open (OUTFILE_0, ">", "$data_files[0]" . ".count.out");

# Process .txt file
####################################################################################################
while (<IN_SAMPLE_ID>) {
	chomp $_;
	
	# Skip first line
	if ($_ =~ /^Variation/) {
		print "\nEntered the first loop - detected header\n\n";
		#print OUTFILE_0 "$_\n";
		next;
		}
	
	# Split line
	@test_line = split('\t', $_);
	print "\n\nLine value: $test_line[5]\t\t";
	print "Allele number: $test_line[22]\n\n";
	
	# Store gene name in array - odd positions
	# Store gene number in array - even positions
	####################################################################################################
	 if (exists $genome_positions{"$test_line[5]"}) {
	 	print "\nEntered the exists loop with $test_line[5]\n";
	 	# Check if value exists in hash
	 	$genes_counts_size = ($#genes_counts + 1);
	 	# Determines position of matching gene name and adds one to count
	 	for (my $i  =  0; $i  <  $genes_counts_size; $i = $i + 2) {
	 		print "Trying to match existing value\n";
	 		print "Array value: $genes_counts[$i] with Line value: $test_line[5]\n";
			if ("$genes_counts[$i]" eq "$test_line[5]") {
				print "Found a match!!!\n";
				print "Current value is $genes_counts[$i+1]\n";
				
				# Determine number of alleles
				@temp_countAlleles = split(',', $test_line[22]);
				$temp_countAlleles_size = ($#temp_countAlleles + 1);
				# Add number of alleles to array
				$genes_counts[$i+1] = $genes_counts[$i+1] + $temp_countAlleles_size;
	 			print "New value is $genes_counts[$i+1]\n";
	 			# Reset temp variables
	 			@temp_countAlleles = ();
	 			$temp_countAlleles_size = 0;
	 		}
	 	}
	 }
	 else {
	 	# Does not exist in hash
	 	# Assign to hash and output line
	 	$genome_positions{"$test_line[5]"} = "$test_line[5]";
		# Add to end of array @genes_counts
		print "In the else loop: $test_line[5]\n";
		push(@genes_counts, $test_line[5]);
		print "First value: $genes_counts[0]\n";
		
		# Determine number of alleles
		@temp_countAlleles = split(',', $test_line[22]);
		$temp_countAlleles_size = ($#temp_countAlleles + 1);
		# Add number of alleles to array
		push(@genes_counts, $temp_countAlleles_size);
		print "Second value: $genes_counts[1]\n";
		# Reset temp variables
	 	@temp_countAlleles = ();
	 	$temp_countAlleles_size = 0;
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
