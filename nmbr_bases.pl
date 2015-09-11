#!/usr/bin/perl
# Program designed to determine the number of bases in a single multi-fasta file 
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use warnings;
use strict;

#-------------------------------------------------------------------------------
# Variable definitions
#-------------------------------------------------------------------------------
my(@files, @fasta_first, @fasta_second, $file_number, $fasta_files, $count, $i, $j, $file_first_lines, $file_second_lines, $fasta_first_seq, $fasta_second_seq, 
$file_first_size, $file_second_size, $loop_1, $loop_2, $loop_gain, $base_count, );

#-------------------------------------------------------------------------------
# Open Data Output Filehandle
# Outline program steps here
# Read all .fasta files
# Count Number of N's in each text file
# Output to screen
#-------------------------------------------------------------------------------
open(FILEHANDLE_OUT_1, ">", "nmbr_bases.out")
		or die "Cannot open FILEHANDLE_OUT_1";

@files = glob("*.txt");
$file_number = ($#files + 1);
print FILEHANDLE_OUT_1 "Processing a total of $file_number files\n";
if ($file_number == 0) {
	die "$file_number .fasta files detected (should be 0).\n
		Check directory. Exiting program";
}
$base_count = 0;

foreach my $process_file (@files) {

	print "Processing file: $process_file\n";
	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";
		
	open(OUT_FASTA_FILE, ">", "$process_file" . '.txt')
		or die "Cannot open OUT_FASTA_FILE for data output";
		
		
	while (<FILEHANDLE_FIRST>) {
		chomp $_;
		# Select the fasta label line
		if ($_ =~ /^>/) {
			next;
			}
		# select lines with DNA sequence
		# split the line count the bases
		else {
			print OUT_FASTA_FILE "$_\n";
		}
	}
	
	# Close filehandles
	close(OUT_FASTA_FILE);
	close(FILEHANDLE_FIRST);
}



