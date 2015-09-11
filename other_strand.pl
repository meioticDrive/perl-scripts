#!/usr/bin/perl -w
# Program designed to reverse the order of a fasta DNA sequence while changing
# all the nucleotides to the other strand
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;

#-------------------------------------------------------------------------------
# Variable Definitions
#-------------------------------------------------------------------------------
my(@files, $file_number, $fasta_files, @fasta_first, @gene_name_first, @gene_seq_first, $gene_name_first_lines, $fasta_seq_first_count, $fasta_compare_first, $count, $i, $j, $k, $j_first, );

#-------------------------------------------------------------------------------
# Get names of all .fasta files, determine number of files
#-------------------------------------------------------------------------------
@files = glob("*.out.txt");
#@files = glob("*.fasta");
$file_number = ($#files + 1);
print "Processing a total of $file_number files\n\n";

#-------------------------------------------------------------------------------
# Check to see that file exist
# Check to ensure and even number of files
#-------------------------------------------------------------------------------
if ($file_number == 0) {
	die "$file_number .fasta files detected (should be 0).\n
		Check directory. Exiting program";
}
if (($file_number % 2) > 1) {
	die "Error! More than one fasta file. Check directory. Exiting program";
}

#-------------------------------------------------------------------------------
# Only 1 files in directory - in the @files array
# Open file handle, read in first fasta file, close file handle
# Determine number of lines read in
#-------------------------------------------------------------------------------
open(FILEHANDLE_FIRST, $files[0])
	|| die "Cannot open FILEHANDLE_FIRST";
@fasta_first = <FILEHANDLE_FIRST>;
close(FILEHANDLE_FIRST);
my $file_first_lines = ($#fasta_first + 1);
print "Number of lines is $file_first_lines";

#---------------------------------------------------------------------------
# Open Data Output Filehandles
#---------------------------------------------------------------------------
open(FILEHANDLE_OUT_1, ">", "reverse_fasta.txt")
	or die "Cannot open FILEHANDLE_OUT_1";


$k = 0;
$j_first = 0; # Counts number of genes in first fasta file

foreach my $line (@fasta_first) {
	
	print "Entering the foreach loop \n";
	#-----------------------------------------------------------------------
	# Get fasta label
	# $k - counts beginning of lines
	# $j_first counts genes
	#-----------------------------------------------------------------------
	if ($line =~ /^>/) {
		$gene_name_first[$k] = $line;
		$k++;
		$j_first++;
	}
	
	#-----------------------------------------------------------------------
	# Get gene sequence for each separate fasta fragment
	# Append sequences into element of array, incremment to count genes
	#-----------------------------------------------------------------------
	if ($line =~ /^[ATCGatcg]/) {
		$gene_seq_first[$j_first] .= $line;
		print "$gene_seq_first[$j_first]\n";
	}
}

#-----------------------------------------------------------------------
# Determine number of gene names, make sure same number of genes in files
# Determine number of fasta seqs, make sure same number of seqs in files
#-----------------------------------------------------------------------
$gene_name_first_lines = ($#gene_name_first);
print "$gene_name_first_lines";
$fasta_seq_first_count = ($#gene_seq_first);
print "$fasta_seq_first_count";

#---------------------------------------------------------------------------
# Get sequences from @gene_seq_first into string, reverse, tr// nucleotides
#---------------------------------------------------------------------------
for (my $m = 1; $m < ($fasta_seq_first_count + 1); $m++) {

	print "Entered the loop";
	$fasta_compare_first = $gene_seq_first[$m];
	print "$fasta_compare_first";
	$fasta_compare_first =~ s/\s//g;
	$fasta_compare_first =~ tr/ACGTacgt/TGCAtgca/;
	$fasta_compare_first = reverse $fasta_compare_first;
	
	#print "$gene_name_first[($m-1)]";
	print "$fasta_compare_first\n";
	
	#print FILEHANDLE_OUT_1 "$gene_name_first[($m-1)]";
	print FILEHANDLE_OUT_1 "$fasta_compare_first\n";
}
#-------------------------------------------------------------------------------

close(FILEHANDLE_OUT_1);
print "\n";
print "Completed other_strand program.\n";
