#!/usr/bin/perl -w
# Michael E. Zwick
# 6/25/04
# User puts coordinates into the script
# Script runs and returns a subsequence
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;

#-------------------------------------------------------------------------------
# Variable Definitions
#-------------------------------------------------------------------------------
my(@files, @cut_seq, @ref_compare, $file, $reference_sequence, $file_number, $reference_sequence_size, $i, $start, $end );

#-------------------------------------------------------------------------------
# Use just starting and ending coordinates
#-------------------------------------------------------------------------------

@cut_seq = qw(1 2550);

#-------------------------------------------------------------------------------	
# Read in a fasta file
# Use split/join procedure to put into an array (remove whitespace)
# Output array of sequence matching coordinates
#-------------------------------------------------------------------------------

@files = glob("*.fasta");
$file_number = ($#files + 1);
#print "File Number is $file_number\n";

#-------------------------------------------------------------------------------
# Make sure file exists
#-------------------------------------------------------------------------------
if ($file_number == 0) {
    die "Error! No ref.fasta file present. Check directory. Exiting program";
}
if ($file_number > 1) {
    die "Error! Too many ref.fasta files present. Check directory. Exiting program";
}
#---------------------------------------------------------------------------
# Open output file: Subsequence Out
#---------------------------------------------------------------------------
open(OUT_SUBSEQUENCE, ">", "subsequence.out.txt") 
	or die "Cannot open OUT_FASTA for data output";


#-------------------------------------------------------------------------------
# Process reference file to generate single DNA sequence file
# Read file in line by line, discard fasta header
# Remove spaces, put string into array called @ref_compare
# Determine size of array @ref_compare
#-------------------------------------------------------------------------------
foreach my $ref_file (@files) {

	open(FILEHANDLE_FIRST, $ref_file)
		or die "Cannot open FILEHANDLE_FIRST";

	while (<FILEHANDLE_FIRST>) {
		if ($_ =~ /^>/) {
			next;
		}
		else {
			$reference_sequence .= $_;
		}
	}	
	close FILEHANDLE_FIRST;
	$reference_sequence =~ s/\s//g;
	@ref_compare = split( '', $reference_sequence);
	$reference_sequence_size = ($#ref_compare + 1);
	print "Size of reference sequence: $reference_sequence_size\n";
}

#---------------------------------------------------------------------------
# Get fasta sequence
#---------------------------------------------------------------------------
print "Just before the for loop\n";

for ($i = ($cut_seq[0] - 1); $i < ($cut_seq[1]); $i++) {

	print OUT_SUBSEQUENCE "$ref_compare[$i]";
}

close(OUT_SUBSEQUENCE);


print "Reached end of get_fasta_subsequence.pl script.\n";
