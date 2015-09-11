#!/usr/bin/perl -w
# RA_count_called_bases.ver1.0.pl
# Version 1.0
# Michael E. Zwick
# 5/5/05
# Program take a collection of fasta files output by RA tools, and quickly 
# provide the number of called and uncalled bases for each fasta fragment. Put 
# the output in a text file *.RA_count.txt
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Bio::Perl;
use Bio::SeqIO;

#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variable for composite seq functions

my(@experimental_files, $exp_file_number,


$experiment_sequence, $experiment_sequence_size, @experiment_compare, $bases_identical, $bases_different, $total_bases, $bases_called_N, $check_total, $chip_reference_sequence, $chip_reference_sequence_size);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

#-------------------------------------------------------------------------------
# Initialize global variable values
#-------------------------------------------------------------------------------
$total_bases = 0;
$bases_identical = 0;
$bases_called_N = 0;
$bases_different = 0;
$check_total = 0;

#-------------------------------------------------------------------------------
# Get the name of all the fasta files
@experimental_files = glob("*fasta");
$exp_file_number = ($#experimental_files + 1);

print "Processing a total of $exp_file_number experimental files\n\n";
if ($exp_file_number == 0) {
	die "$exp_file_number .fasta files detected.\n
		Check directory. Exiting program";
	}

#---------------------------------------------------------------------------
# Open output file: discrepancy Count
#---------------------------------------------------------------------------
open(RA_COUNT, ">", "RA_count.txt") 
	or die "Cannot open OUT_FASTA for data output";

#-------------------------------------------------------------------------------
# Process each experimental file
#-------------------------------------------------------------------------------
foreach my $exp_files (@experimental_files) {

	open(FILEHANDLE_SECOND, $exp_files)
		or die "Cannot open FILEHANDLE_SECOND";

	my $seq_in = Bio::SeqIO->new(-file => $exp_files, -format => 'fasta');

	my $seq;
	my @seq_array;
	while ( $seq = $seq_in->next_seq() ) {
			push (@seq_array, $seq);
		}

#@seq_array = sort { $a->length <=> $b->length } @seq_array;

my $total = 0;
my $count = 0;
foreach my $seq ( @seq_array ) {

	$total += $seq->length;
	print "Total is $total \n";
	$count++;
	}

	print "Mean length ", $total/$count, " Median ", $seq_array[$count/2], "\n";

}