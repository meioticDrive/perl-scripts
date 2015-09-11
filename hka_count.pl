#!/usr/bin/perl
# Program designed to read names of all .DAT files (pass through multiple
# directories), place into a text file
# The directory structure assumed as follows:
# Chip_Design_Scanned_Chips[FOLDER]
#    Date[FOLDER]
#       .DAT[FILES]
#        EXP_Files[FOLDER]
# Program should:
# 1. Read the names of all Date[FOLDER]
# 2. For each Date[FOLDER], read the names of all .DAT[FILES]
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use warnings;

#-------------------------------------------------------------------------------
# Variable Definitions
#-------------------------------------------------------------------------------
my(@files, $file_number, @fasta_first, @fasta_second, $fasta_files, $count, $i, $j_first, $j_second, $k, @gene_name, @gene_seq_first, @gene_seq_second, @gene_name_first, @gene_name_second, $gene_name_first_lines, $gene_name_second_lines, $line_first, $line_second, $fasta_first_seq, @gene_seq_first_test, $fasta_seq_first_count, $fasta_seq_second_count, $fasta_compare_first, $fasta_compare_second, @gene_seq_compare_first, @gene_seq_compare_second, $silent_count, $repl_count, $name_out_first, $name_out_second, $first_codon, $second_codon, $change_first_pos, $change_second_pos, $change_third_pos,);

my ($first_codon_change_1, $first_codon_change_2, $first_codon_change_3);

my (	$temp_replacement_1, $temp_replacement_2, $temp_replacement_3, $temp_replacement_4, 
		$temp_silent_1, $temp_silent_2, $temp_silent_3, $temp_silent_4,
		$temp_silent_total_first, $temp_silent_total_second,
		$temp_silent_total_third, $temp_silent_total_fourth,
		$temp_silent_total_fifth, $temp_silent_total_sixth,
		$temp_repl_total_first, $temp_repl_total_second,
		$temp_repl_total_third, $temp_repl_total_fourth,
		$temp_repl_total_fifth, $temp_repl_total_sixth,
		@best_silent, $best);

#-------------------------------------------------------------------------------
# Get names of all .fasta files, determine number of files
#-------------------------------------------------------------------------------
@files = glob("*.fasta");
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
if (($file_number % 2) != 0) {
	die "Error! Odd number of fasta files. Check directory. Exiting program";
}

#system("rm -R composite");
#system("mkdir composite");

#-------------------------------------------------------------------------------
# Only 2 files in directory - in the @files array
# Open file handle, read in first fasta file, close file handle
# Determine number of lines read in
#-------------------------------------------------------------------------------
open(FILEHANDLE_FIRST, $files[0]) 
	or die "Cannot open FILEHANDLE_FIRST";
@fasta_first = <FILEHANDLE_FIRST>;
close(FILEHANDLE_FIRST);
my $file_first_lines = ($#fasta_first + 1);

#---------------------------------------------------------------------------
# Open file handle, read in second fasta file, close file handle
# Determine number of lines read in
#---------------------------------------------------------------------------
open(FILEHANDLE_SECOND, $files[1]) 
	or die "Cannot open FILEHANDLE_SECOND";
@fasta_second = <FILEHANDLE_SECOND>;
close(FILEHANDLE_SECOND);
my $file_second_lines = ($#fasta_second + 1);

#---------------------------------------------------------------------------
# First Error Check: Ensure same number of lines read from fasta files
#---------------------------------------------------------------------------
if ($file_first_lines != $file_second_lines) {
	die "\n\t\tFile Line Size Mismatch Error!
		First file contained $file_first_lines lines.
		Second file contained $file_second_lines lines.
		Exiting program\n";
}

#---------------------------------------------------------------------------
# Open Data Output Filehandles
#---------------------------------------------------------------------------
open(FILEHANDLE_OUT_1, ">", "b_cereus_anthracis.compare.all.final.txt")
	or die "Cannot open FILEHANDLE_OUT_1";

open(FILEHANDLE_OUT_2, ">", "b_cereus_anthracis.compare.counts_only.final.txt")
	or die "Cannot open FILEHANDLE_OUT_2";

# Data format for inport into excel - file names
print FILEHANDLE_OUT_2 "$files[0]\t$files[1]\n";
print FILEHANDLE_OUT_2 "Gene number\tSilent\tReplacement\n";
	
$k = 0;
$j_first = 0; # Counts number of genes in first fasta file
$line_first = 0;
$line_second = 0;

#---------------------------------------------------------------------------
# Fill array @gene_seq_first with fasta seqs from first file
#---------------------------------------------------------------------------
foreach my $line (@fasta_first) {
	
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
	}
}

#---------------------------------------------------------------------------
# Fill array @gene_seq_first with fasta seqs from second file
#---------------------------------------------------------------------------
$k = 0;
$j_second = 0; # Counts number of genes in first fasta file
foreach my $line (@fasta_second) {
	
	#-----------------------------------------------------------------------
	# Get fasta label
	#-----------------------------------------------------------------------
	if ($line =~ /^>/) {
		$gene_name_second[$k] = $line;
		$k++; #counts beginning of lines
		$j_second++; #counts genes
	}
	
	#-----------------------------------------------------------------------
	# Get gene sequence
	#-----------------------------------------------------------------------
	if ($line =~ /^[ATCGatcg]/) {
		$gene_seq_second[$j_second] .= $line;
	}
}

#-----------------------------------------------------------------------
# Determine number of gene names, make sure same number of genes in files
# Determine number of fasta seqs, make sure same number of seqs in files
#-----------------------------------------------------------------------
$gene_name_first_lines = ($#gene_name_first);
$gene_name_second_lines = ($#gene_name_second);
$fasta_seq_first_count = ($#gene_seq_first);
$fasta_seq_second_count = ($#gene_seq_second);
if ($gene_name_first_lines != $gene_name_second_lines) {
	print "Different number of gene names. Exiting";
	die;
	}
if ($fasta_seq_first_count != $fasta_seq_second_count) {
	print "Different number of fasta seqs. Exiting";
	die;
	}

#---------------------------------------------------------------------------
# Compare DNA sequences in @gene_seq_first, @gene_seq_second
# Loop over number of elements in both arrays
#---------------------------------------------------------------------------
for (my $m = 1; $m < ($fasta_seq_first_count + 1); $m++) {

	$fasta_compare_first = $gene_seq_first[$m];
	$fasta_compare_first =~ s/\s//g;
	@gene_seq_compare_first = split( '', $fasta_compare_first);

	$fasta_compare_second = $gene_seq_second[$m];
	$fasta_compare_second =~ s/\s//g;
	@gene_seq_compare_second = split( '', $fasta_compare_second);

	$silent_count = 0;
	$repl_count = 0;
	$name_out_first = $gene_name_first[$m-1];
	$name_out_second = $gene_name_second[$m-1];
	
	print "Processing the sequence $m\n";
	print "\n";
	print "Fasta file is this size: $#gene_seq_compare_first\n";
#if ($m == 4) { exit;}
	
	for (my $n = 0; $n < (($#gene_seq_compare_first+1)/3); $n++) {
		
		#-----------------------------------------------------------------------
		# Reset indicator substitution positions indicators
		#-----------------------------------------------------------------------
		$change_first_pos = $change_second_pos = $change_third_pos = 0;
		
		#-----------------------------------------------------------------------
		#Check and see if there is a mismatch at the three positions of a codon
		#-----------------------------------------------------------------------
		if (($gene_seq_compare_first[((3 * ($n+1)) - 3)]) ne
				($gene_seq_compare_second[((3 * ($n+1)) - 3)])
			or
			($gene_seq_compare_first[((3 * ($n+1)) - 2)]) ne
				($gene_seq_compare_second[((3 * ($n+1)) - 2)])
			or
			($gene_seq_compare_first[((3 * ($n+1)) - 1)]) ne
				($gene_seq_compare_second[((3 * ($n+1)) - 1)])) {
	
			#-------------------------------------------------------------------
			# Determine codon position of codon changes
			#-------------------------------------------------------------------
			if (($gene_seq_compare_first[((3 * ($n+1)) - 3)]) ne
				($gene_seq_compare_second[((3 * ($n+1)) - 3)])) {
				$change_first_pos = 1;
			}
			
			if (($gene_seq_compare_first[((3 * ($n+1)) - 2)]) ne
				($gene_seq_compare_second[((3 * ($n+1)) - 2)])) {
				$change_second_pos = 1;
			}
			
			if (($gene_seq_compare_first[((3 * ($n+1)) - 1)]) ne
				($gene_seq_compare_second[((3 * ($n+1)) - 1)])) {
				$change_third_pos = 1;
			}
			#-------------------------------------------------------------------
			# Check for change at all three codon positions
			#-------------------------------------------------------------------
			if (($change_first_pos == 1) && 
				($change_second_pos == 1) && ($change_third_pos == 1)) {
				print "Found change at all three codon positions\n";
				
				# Reset counter variables
				#-------------------------------------------------------------------
				$temp_replacement_1 = $temp_replacement_2 = 
				$temp_replacement_3 = $temp_replacement_4 = 0;
				
				$temp_silent_1 = $temp_silent_2 = 
				$temp_silent_3 = $temp_silent_4 = 0;
				
				$temp_repl_total_first = $temp_silent_total_first = 0;
				$temp_repl_total_second = $temp_silent_total_second = 0;
				$temp_repl_total_third = $temp_silent_total_third = 0;
				$temp_repl_total_fourth = $temp_silent_total_fourth = 0;
				$temp_repl_total_fifth = $temp_silent_total_fifth = 0;
				$temp_repl_total_sixth = $temp_silent_total_sixth = 0;
				
				# Change 123
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_3 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes - 123 pattern
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon_change_2, $first_codon_change_3);
				
				$temp_repl_total_first = $temp_replacement_1 + $temp_replacement_2 + $temp_replacement_3;
				$temp_silent_total_first = $temp_silent_1 + $temp_silent_2 + $temp_replacement_3;
				@best_silent = $temp_silent_total_first;
				
				# Change 132
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_3 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes - 132 pattern
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon_change_2, $first_codon_change_3);
				
				$temp_repl_total_second = $temp_replacement_1 + $temp_replacement_2 + $temp_replacement_3;
				$temp_silent_total_second = $temp_silent_1 + $temp_silent_2 + $temp_replacement_3;
				@best_silent = $temp_silent_total_second;
				
				# Change 213
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_3 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes - 213 pattern
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon_change_2, $first_codon_change_3);
				
				$temp_repl_total_third = $temp_replacement_1 + $temp_replacement_2 + $temp_replacement_3;
				$temp_silent_total_third = $temp_silent_1 + $temp_silent_2 + $temp_replacement_3;
				@best_silent = $temp_silent_total_third;
				
				# Change 231
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_3 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes - 231 pattern
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon_change_2, $first_codon_change_3);
				
				$temp_repl_total_fourth = $temp_replacement_1 + $temp_replacement_2 + $temp_replacement_3;
				$temp_silent_total_fourth = $temp_silent_1 + $temp_silent_2 + $temp_replacement_3;
				@best_silent = $temp_silent_total_fourth;
				
				# Change 312
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_3 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes - 312 pattern
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon_change_2, $first_codon_change_3);
				
				$temp_repl_total_fifth = $temp_replacement_1 + $temp_replacement_2 + $temp_replacement_3;
				$temp_silent_total_fifth = $temp_silent_1 + $temp_silent_2 + $temp_replacement_3;
				@best_silent = $temp_silent_total_fifth;
				
				# Change 323
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_3 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes - 321 pattern
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon_change_2, $first_codon_change_3);
				
				$temp_repl_total_sixth = $temp_replacement_1 + $temp_replacement_2 + $temp_replacement_3;
				$temp_silent_total_sixth = $temp_silent_1 + $temp_silent_2 + $temp_replacement_3;
				@best_silent = $temp_silent_total_sixth;
				
				#---------------------------------------------------------------
				# Pick path with greater number of silent subs (among 6 
				# possibilities)
				# Sort to pick largest number of silent subs
				#---------------------------------------------------------------
				
				($best) = sort (@best_silent);
				
				print "Number of silent changes is  $best\n";
				print "repl:$repl_count, silent:$silent_count before addition\n";
				$repl_count = $repl_count + (3 - $best);
				$silent_count = $silent_count + $best;
				print "repl:$repl_count, silent:$silent_count after addition\n";
			} #end change all three positions
			
			#-------------------------------------------------------------------
			#Change in first and second codon positions
			#-------------------------------------------------------------------
			elsif (($change_first_pos == 1) && 
				($change_second_pos == 1) && ($change_third_pos == 0)) {
				
				# Reset counter variables
				#-------------------------------------------------------------------
				$temp_replacement_1 = $temp_replacement_2 = 
				$temp_replacement_3 = $temp_replacement_4 = 0;
				
				$temp_silent_1 = $temp_silent_2 = $temp_silent_3 = $temp_silent_4;
				
				$temp_repl_total_first = $temp_silent_total_first =
				$temp_repl_total_second = $temp_silent_total_second = 0;
				
				# Change first position, then change second position
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = 
					silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = 
					silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				$temp_repl_total_first = $temp_replacement_1 + $temp_replacement_2;
				$temp_silent_total_first = $temp_silent_1 + $temp_silent_2;
				#---------------------------------------------------------------
				
				# Change second pos, then change first pos, count change types
				#---------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes
				#---------------------------------------------------------------
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_4, $temp_silent_4) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				$temp_repl_total_second = $temp_replacement_3 + $temp_replacement_4;
				$temp_silent_total_second = $temp_silent_3 + $temp_silent_4;
				
				# Pick path with greater number of silent subs
				#---------------------------------------------------------------
				if ($temp_silent_total_first >= $temp_silent_total_second) {
					$repl_count = $repl_count + $temp_repl_total_first;
					$silent_count = $silent_count + $temp_silent_total_first;
				}
				else {
					$repl_count = $repl_count + $temp_repl_total_second;
					$repl_count = $repl_count + $temp_silent_total_second;
				}
			}
			#-------------------------------------------------------------------
			#Change in first and third codon positions
			#-------------------------------------------------------------------
			elsif (($change_first_pos == 1) && 
				($change_second_pos == 0) && ($change_third_pos == 1)) {
			
			#print "Made it into 13 change loop\n";
			
				# Reset counter variables
				#-------------------------------------------------------------------
				$temp_replacement_1 = $temp_replacement_2 = 
				$temp_replacement_3 = $temp_replacement_4 = 0;
				
				$temp_silent_1 = $temp_silent_2 = $temp_silent_3 = $temp_silent_4;
				
				$temp_repl_total_first = $temp_silent_total_first =
				$temp_repl_total_second = $temp_silent_total_second = 0;
				
				# Change first position, then change third position
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = 
					silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = 
					silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				$temp_repl_total_first = $temp_replacement_1 + $temp_replacement_2;
				$temp_silent_total_first = $temp_silent_1 + $temp_silent_2;
				#---------------------------------------------------------------
				
				# Change third pos, then change first pos, count change types
				#---------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes
				#---------------------------------------------------------------
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_4, $temp_silent_4) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				$temp_repl_total_second = $temp_replacement_3 + $temp_replacement_4;
				$temp_silent_total_second = $temp_silent_3 + $temp_silent_4;
				
				# Pick path with greater number of silent subs
				#---------------------------------------------------------------
				if ($temp_silent_total_first >= $temp_silent_total_second) {
					$repl_count = $repl_count + $temp_repl_total_first;
					$silent_count = $silent_count + $temp_silent_total_first;
				}
				else {
					$repl_count = $repl_count + $temp_repl_total_second;
					$repl_count = $repl_count + $temp_silent_total_second;
				}
			}	#End of change first and third position
			
			#-------------------------------------------------------------------
			#Change in second and third codon positions
			#-------------------------------------------------------------------
			elsif (($change_first_pos == 0) && 
				($change_second_pos == 1) && ($change_third_pos == 1)) {
			
				#print "Made it into 23 change loop\n";
			
				# Reset counter variables
				#-------------------------------------------------------------------
				$temp_replacement_1 = $temp_replacement_2 = 
				$temp_replacement_3 = $temp_replacement_4 = 0;
				
				$temp_silent_1 = $temp_silent_2 = $temp_silent_3 = $temp_silent_4;
				
				$temp_repl_total_first = $temp_silent_total_first =
				$temp_repl_total_second = $temp_silent_total_second = 0;
				
				# Change second position, then change third position
				#-------------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = 
					silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_2, $temp_silent_2) = 
					silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				$temp_repl_total_first = $temp_replacement_1 + $temp_replacement_2;
				$temp_silent_total_first = $temp_silent_1 + $temp_silent_2;
				#---------------------------------------------------------------
				
				# Change third pos, then change second pos, count change types
				#---------------------------------------------------------------
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_1 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				$first_codon_change_2 = 
				"$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				# Determine type of changes
				#---------------------------------------------------------------
				($temp_replacement_3, $temp_silent_3) = silent_or_replacement ($first_codon, $first_codon_change_1);
				
				($temp_replacement_4, $temp_silent_4) = silent_or_replacement ($first_codon_change_1, $first_codon_change_2);
				
				$temp_repl_total_second = $temp_replacement_3 + $temp_replacement_4;
				$temp_silent_total_second = $temp_silent_3 + $temp_silent_4;
				
				# Pick path with greater number of silent subs
				#---------------------------------------------------------------
				if ($temp_silent_total_first >= $temp_silent_total_second) {
					$repl_count = $repl_count + $temp_repl_total_first;
					$silent_count = $silent_count + $temp_silent_total_first;
				}
				else {
					$repl_count = $repl_count + $temp_repl_total_second;
					$repl_count = $repl_count + $temp_silent_total_second;
				}
				
			} #End of change in second and third position
			
			#-------------------------------------------------------------------
			# Single Change Type Determination
			# Determine if mismatch is replacment (hash lookup)
			#-------------------------------------------------------------------
			else {
			
				$temp_replacement_1 = $temp_silent_1 = 0;
				
				$first_codon = "$gene_seq_compare_first[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_first[((3 * ($n+1)) - 1)]";
				
				$second_codon = "$gene_seq_compare_second[((3 * ($n+1)) - 3)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 2)]" .
				"$gene_seq_compare_second[((3 * ($n+1)) - 1)]";
				
				#print FILEHANDLE_OUT_1 "Comparing $first_codon $second_codon \n";
				
				# Determine type of changes
				#---------------------------------------------------------------
				($temp_replacement_1, $temp_silent_1) = 
					silent_or_replacement ($first_codon, $second_codon);
				
				$repl_count = $repl_count + $temp_replacement_1;
				$silent_count = $silent_count + $temp_silent_1;
			}
		}
	}
	print FILEHANDLE_OUT_1 "$name_out_first";
	print FILEHANDLE_OUT_1 "$name_out_second\n";
	print FILEHANDLE_OUT_1 "Number of silent differences is $silent_count\n";
	print FILEHANDLE_OUT_1 "Number of replacement differences is $repl_count\n";
	print FILEHANDLE_OUT_1 "Total sequence divergence is " . 
		(($silent_count + $repl_count)/$#gene_seq_compare_first) . "\n";
	print FILEHANDLE_OUT_1 "\n";
	
	#data format for inport into excel
	print FILEHANDLE_OUT_2 "$m\t$silent_count\t$repl_count\n";
	
}

	# Find a difference
	# Determine the location of the difference (with respect to reading frame) - 
	# or just read bases three at a time
	# If you find a difference (check to see if there is more than one!), 
	# translate codons and see if it leads to a different amino acid.
	# divide loop by 3, compare three elements of array
	# 1 - 1,2,3
	# 2 - 4,5,6
	# 3 - 7,8,9
	
	# Take each gene sequence in array, remove white space, put back into array?
	# Figure out how to rename arrays?
	# How do I rename arrays? Use a single set of arrays - and just loop over
	# them mulitple times?
	# loop over $gene_seq_first[$j_first]
	#	for (my $m = 0; $m < $j_first; $m++) {
	#	#perform array matching here?
	#	}
	
close(FILEHANDLE_OUT_1);
close(FILEHANDLE_OUT_2);
print "\n";
print "Completed hka_count program.\n";
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Subroutines
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Definition for subroutine "silent_or_replacement"
# Takes as argument two different codons (strings) - determines if they
# the differences result in a silent or replacement change
# Assumes that the codons differ at only 1 site
#-------------------------------------------------------------------------------
sub silent_or_replacement {

	my ($replacement, $silent);
	my(%genetic_code) = (

		'TCA' => 'S',    # Serine
		'TCC' => 'S',    # Serine
		'TCG' => 'S',    # Serine
		'TCT' => 'S',    # Serine
		'TTC' => 'F',    # Phenylalanine
		'TTT' => 'F',    # Phenylalanine
		'TTA' => 'L',    # Leucine
		'TTG' => 'L',    # Leucine
		'TAC' => 'Y',    # Tyrosine
		'TAT' => 'Y',    # Tyrosine
		'TAA' => '_',    # Stop
		'TAG' => '_',    # Stop
		'TGC' => 'C',    # Cysteine
		'TGT' => 'C',    # Cysteine
		'TGA' => '_',    # Stop
		'TGG' => 'W',    # Tryptophan
		'CTA' => 'L',    # Leucine
		'CTC' => 'L',    # Leucine
		'CTG' => 'L',    # Leucine
		'CTT' => 'L',    # Leucine
		'CCA' => 'P',    # Proline
		'CCC' => 'P',    # Proline
		'CCG' => 'P',    # Proline
		'CCT' => 'P',    # Proline
		'CAC' => 'H',    # Histidine
		'CAT' => 'H',    # Histidine
		'CAA' => 'Q',    # Glutamine
		'CAG' => 'Q',    # Glutamine
		'CGA' => 'R',    # Arginine
		'CGC' => 'R',    # Arginine
		'CGG' => 'R',    # Arginine
		'CGT' => 'R',    # Arginine
		'ATA' => 'I',    # Isoleucine
		'ATC' => 'I',    # Isoleucine
		'ATT' => 'I',    # Isoleucine
		'ATG' => 'M',    # Methionine
		'ACA' => 'T',    # Threonine
		'ACC' => 'T',    # Threonine
		'ACG' => 'T',    # Threonine
		'ACT' => 'T',    # Threonine
		'AAC' => 'N',    # Asparagine
		'AAT' => 'N',    # Asparagine
		'AAA' => 'K',    # Lysine
		'AAG' => 'K',    # Lysine
		'AGC' => 'S',    # Serine
		'AGT' => 'S',    # Serine
		'AGA' => 'R',    # Arginine
		'AGG' => 'R',    # Arginine
		'GTA' => 'V',    # Valine
		'GTC' => 'V',    # Valine
		'GTG' => 'V',    # Valine
		'GTT' => 'V',    # Valine
		'GCA' => 'A',    # Alanine
		'GCC' => 'A',    # Alanine
		'GCG' => 'A',    # Alanine
		'GCT' => 'A',    # Alanine
		'GAC' => 'D',    # Aspartic Acid
		'GAT' => 'D',    # Aspartic Acid
		'GAA' => 'E',    # Glutamic Acid
		'GAG' => 'E',    # Glutamic Acid
		'GGA' => 'G',    # Glycine
		'GGC' => 'G',    # Glycine
		'GGG' => 'G',    # Glycine
		'GGT' => 'G',    # Glycine
		);

	my ($first_codon, $second_codon) = @_;
	$replacement = $silent = 0;

	#printf "first codon = $first_codon \t second codon = $second_codon\n";
	
	if ("$genetic_code{$first_codon}" ne "$genetic_code{$second_codon}") {
		#mutation is replacement
		$replacement++;
	}
	else {
		#mutation is silent
		$silent++;
	}

	return ($replacement, $silent);

}
#-------------------------------------------------------------------------------
