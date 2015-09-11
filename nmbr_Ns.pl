#!/usr/bin/perl -w
# Program designed to determine the number of N's in a collection of .fasta 
# files
# Allows optimum choice of duplicate sequences
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;

#-------------------------------------------------------------------------------
# Variable definitions
#-------------------------------------------------------------------------------
my(@files, @fasta_first, @fasta_second, $file_number, $fasta_files, $count, $i, $j, $file_first_lines, $file_second_lines, $fasta_first_seq, $fasta_second_seq, 
$file_first_size, $file_second_size, $loop_1, $loop_2, $loop_gain, $N_count);

#-------------------------------------------------------------------------------
# Open Data Output Filehandle
# Outline program steps here
# Read all .fasta files
# Count Number of N's in each text file
# Output to screen
#-------------------------------------------------------------------------------
open(FILEHANDLE_OUT_1, ">", "nmbr_ns.out")
		or die "Cannot open FILEHANDLE_OUT_1";

@files = glob("*.fasta");
$file_number = ($#files + 1);
print FILEHANDLE_OUT_1 "Processing a total of $file_number files\n";
if ($file_number == 0) {
	die "$file_number .fasta files detected (should be 0).\n
		Check directory. Exiting program";
}
#if (($file_number % 2) != 0) {
#	die "Error! Odd number of fasta files. Check directory. Exiting program";
#}

$N_count = 0;

for ($i = 0; $i < $file_number; $i++) {

	#---------------------------------------------------------------------------
	# Open a file handle
	# Read in .fasta file
	# Close file handle
	#---------------------------------------------------------------------------
	open(FILEHANDLE_FIRST, $files[$i]) 
		or die "Cannot open FILEHANDLE_FIRST";
	@fasta_first = <FILEHANDLE_FIRST>;
	close(FILEHANDLE_FIRST);

	#---------------------------------------------------------------------------
	# Determine file size (in terms of number of lines - not characters)
	# Join array to make a single string
	# Remove white space - commmented out because I want to retain \n's
	# Split string into characters, put in @fasta_first array
	# Determine number of characters in first file
	#---------------------------------------------------------------------------
	$file_first_lines = ($#fasta_first + 1);
	$fasta_first_seq = join( '', @fasta_first);
	#$fasta_first_seq =~ s/\s//g;
	@fasta_first = split( '', $fasta_first_seq);
	$file_first_size = ($#fasta_first + 1);
	
	for ($j = 0; $j < $file_first_size; $j++) {
	
	if ($fasta_first[$j] eq "N") {
		$N_count++;
		}
	}
	print FILEHANDLE_OUT_1 "For file $files[$i], the number of N's is \t $N_count\n";
	$N_count = 0;
}
print FILEHANDLE_OUT_1 "Completed nmbr_Ns.pl program.\n";

close(FILEHANDLE_OUT_1);

