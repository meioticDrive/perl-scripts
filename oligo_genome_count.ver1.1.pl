#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 06/27/05
# Program designed build an input file (in.jen.in) call Dave Cutler's 
# exact_match C program to determine the number of times a given oligo is found # in an indexed genome. Requires that an index be present - product of 
# digestion_map C program, written by Dave Cutler.
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@reference_file, $ref_file_number, $oligo_size, $oligo_sequence, $position, $oligo_temp, $loop_count,

@experimental_files, @ref_seq, $exp_file_number,  $reference_seq, $reference_seq_size,
@ref_compare, $experiment_sequence, $experiment_sequence_size, @experiment_compare, $bases_different, 
$total_bases, $bases_called_N, $check_total, $chip_reference_sequence, $chip_reference_sequence_size);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
$oligo_size = 50;
$loop_count = 0;


#-------------------------------------------------------------------------------
# Program Overview:
# Get the name of a reference .fasta file
# Read this file's contents into an array
# Determine the size of the oligo being searched for
# Starting at the beginning of the .fasta file, read a DNA sequence
# Make the in.jen.in text file
# Call the exact_match program
# Append output to a file that shows oligo position, oligo sequence, number of 
# times observed
# Delete the in.jen.in file
# Loop over all possible oligos until the end of the file (finish at fasta file length - oligo size + 1?)
#-------------------------------------------------------------------------------

# Obtain name of reference fasta file to be compared to genome
@reference_file = glob("*.genomic.fasta");
$ref_file_number = ($#reference_file + 1);

print "Loaded $ref_file_number reference file\n";
if (($ref_file_number == 0) || ($ref_file_number > 1)) {
	die "$ref_file_number reference files detected.\n
		Check directory. Exiting program";
}

# Open file that collects oligo position, oligo sequence 
# and results from exact_match program
open(OUT_CRAP_TEXT, ">", "out.crap.txt") 
	or die "Cannot open OUT_CRAP_TEXT to collect data output";

# Read DNA sequence from reference fasta file into array
# Process reference chip file to generate single DNA sequence file
# Read file in line by line, discard fasta header
# Remove spaces, put string into array called @ref_seq
#-------------------------------------------------------------------------------
foreach my $ref_chip_file (@reference_file) {

	open(FILEHANDLE_FIRST, $ref_chip_file)
		or die "Cannot open FILEHANDLE_FIRST";

	while (<FILEHANDLE_FIRST>) {
		# Skips fasta header line
		if ($_ =~ /^>/) {
			next;
		}
		# Reads in remaining sequence from fasta file
		else {
			$reference_seq .= $_;
		}
	}	
	close FILEHANDLE_FIRST;
	
	# Remove spaces from string, put into array
	$reference_seq =~ s/\s//g;
	@ref_seq = split( '', $reference_seq);
	$reference_seq_size = ($#ref_seq + 1);
	print "Size of chip reference sequence $reference_seq_size\n";
	print "\n";
	#print "$reference_seq\n";
}

# Loop over all possible oligos
for (my $position = 0; $position < ($reference_seq_size - $oligo_size - 1); $position++) {

	# Get oligo sequence from array
	for (my $i = 0; $i <= $oligo_size; $i++) {
	$oligo_temp = $oligo_temp . $ref_seq[$position + $i];
	}
	$oligo_sequence = $oligo_temp;
	$oligo_temp = "";

	# Output $position and $oligo_sequence
	print OUT_CRAP_TEXT "$position\t" . "$oligo_sequence" . "\n";

	# Open file used to call exact_match
	open(IN_EXACT_MATCH_IN, ">", "in.jen.in.test") 
	or die "Cannot open IN_EXACT_MATCH_IN for data output";

	# Generate in.jen.in file to call exact_match C program
	print IN_EXACT_MATCH_IN "s\n";
	#print IN_EXACT_MATCH_IN "d\n";
	#print IN_EXACT_MATCH_IN "rp11-489k19.test.txt\n";
	print IN_EXACT_MATCH_IN "human_genome_build35.sdx\n";
	print IN_EXACT_MATCH_IN "chr1.fa\n";
	print IN_EXACT_MATCH_IN "chr2.fa\n";
	print IN_EXACT_MATCH_IN "chr3.fa\n";
	print IN_EXACT_MATCH_IN "chr4.fa\n";
	print IN_EXACT_MATCH_IN "chr5.fa\n";
	print IN_EXACT_MATCH_IN "chr6.fa\n";
	print IN_EXACT_MATCH_IN "chr7.fa\n";
	print IN_EXACT_MATCH_IN "chr8.fa\n";
	print IN_EXACT_MATCH_IN "chr9.fa\n";
	print IN_EXACT_MATCH_IN "chr10.fa\n";
	print IN_EXACT_MATCH_IN "chr11.fa\n";
	print IN_EXACT_MATCH_IN "chr12.fa\n";
	print IN_EXACT_MATCH_IN "chr13.fa\n";
	print IN_EXACT_MATCH_IN "chr14.fa\n";
	print IN_EXACT_MATCH_IN "chr15.fa\n";
	print IN_EXACT_MATCH_IN "chr16.fa\n";
	print IN_EXACT_MATCH_IN "chr17.fa\n";
	print IN_EXACT_MATCH_IN "chr18.fa\n";
	print IN_EXACT_MATCH_IN "chr19.fa\n";
	print IN_EXACT_MATCH_IN "chr20.fa\n";
	print IN_EXACT_MATCH_IN "chr21.fa\n";
	print IN_EXACT_MATCH_IN "chr22.fa\n";
	print IN_EXACT_MATCH_IN "chrM.fa\n";
	print IN_EXACT_MATCH_IN "chrX.fa\n";
	print IN_EXACT_MATCH_IN "chrY.fa\n";
	print IN_EXACT_MATCH_IN "8\n";
	print IN_EXACT_MATCH_IN "$oligo_sequence";
	close IN_EXACT_MATCH_IN;

	

	system ("exact_match < in.jen.in.test >>supercrap.txt");
	
	#exit;
	
	system ("rm in.jen.in.test");
	
	#exit;
	$loop_count++;
	print "Made it to end of loop, $loop_count times\n";
	
	#exit;
	
	
}





print "Completed oligo_genome_count.ver1.0.pl program.\n";
