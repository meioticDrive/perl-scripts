#!/usr/bin/perl -w
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

#-------------------------------------------------------------------------------
# Variable Definitions
# Set number of fasta files
#-------------------------------------------------------------------------------
my(@files, @base_quality, @score_distribute, $file_number, $fasta_files, $count, $i, $start, $end, $average, $total_qs, $total_bases);
$start = (times)[0];

#-------------------------------------------------------------------------------
# Check these parameter values before running
# $fasta_files - number of fasta files in the directory
#-------------------------------------------------------------------------------
$fasta_files = 1;
$total_bases = (36627 * $fasta_files);
$total_qs = 0;

#-------------------------------------------------------------------------------
# Get names of all .txt.score files, determine number of files
#-------------------------------------------------------------------------------
@files = glob("*.txt.score");
$file_number = ($#files + 1);
print "Processing a total of $file_number files\n\n";
print "The original number of fasta files contributing is $fasta_files\n";

#-------------------------------------------------------------------------------
# Check to see that file exist
# Check to ensure and even number of files
#-------------------------------------------------------------------------------
if ($file_number == 0) {
	die "$file_number .txt.score files detected. Check directory.\n Exiting program";
}
if ($file_number == 2) {
	die "Error! Too many .txt.score files. Check directory. Exiting program";
}

#-------------------------------------------------------------------------------
# Should be only a single 
# Open file handle, read in first fasta file, close file handle
# Determine number of lines read in
#-------------------------------------------------------------------------------
open(FILEHANDLE_FIRST, $files[0]) 
	or die "Cannot open FILEHANDLE_FIRST";
#@fasta_first = <FILEHANDLE_FIRST>;

open(FILEHANDLE_OUT_1, ">", "score.distribute.txt")
		or die "Cannot open FILEHANDLE_OUT_1";

#-------------------------------------------------------------------------------
# Put entire file into an array - read one line at a time
# Read out summary qs values from array (count correct number)
# Put output values from array into a score classification (number of categories #on the x axis
# Output table - then done
#-------------------------------------------------------------------------------
while (<FILEHANDLE_FIRST>) {

#Works on single lines - split at tabs
@base_quality = split(/\t/, $_);

	# Loop over all bases in .score.txt file
	for (my $j = 1; $j < ($fasta_files * 6); $j = $j + 6 ) {
		
		$total_qs = $total_qs + $base_quality[$j];
		
		# Loop over scores for a given base, categorize
		for (my $score = 0; $score < 300; $score = $score + 10) {
		
			if ($base_quality[$j] <= $score) {
			$score_distribute[$score]++;
			last;
			}
			elsif ($base_quality[$j] >= 300) {
			$score_distribute[300]++;
			last;
			}
		}
	}
}
close(FILEHANDLE_FIRST);

	#Calculate average quality score
	$average = ($total_qs / $total_bases);
	# Output data
	# loop over score categories
	for (my $score = 0; $score < 300; $score = $score + 10) {
		print FILEHANDLE_OUT_1 "$score\t$score_distribute[$score]\n";
	}
		print FILEHANDLE_OUT_1 ">300 \t $score_distribute[300]\n";
		print FILEHANDLE_OUT_1 "Average Quality Score is $average";


close(FILEHANDLE_OUT_1);

#-------------------------------------------------------------------------------
print "Completed score_distribute_w.\n";
$end = (times)[0];
printf "Elapsed time: %.2f seconds!\n", $end - $start;

