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
#-------------------------------------------------------------------------------
my(@files, $file_number, $fasta_files, $count, $i, $j, $file_nunmber, $file_first_lines, @fasta_first, @temp);

#-------------------------------------------------------------------------------

@files = glob("*.txt");
$file_number = ($#files + 1);

open(FILEHANDLE_FIRST, $files[$i]) 
	or die "Cannot open FILEHANDLE_FIRST";
@fasta_first = <FILEHANDLE_FIRST>;
close(FILEHANDLE_FIRST);
$file_first_lines = ($#fasta_first + 1);
#print "Number of lines in file is $file_first_lines\n";


for ($j = 95000000; $j < 105660000; $j = $j + 10000) {
	$count = 0;
	print "For interval $j to " . ($j+10000) . "\n";
	foreach $_ (@fasta_first) {
		@temp = split(/\t/,$_);
		if(($temp[1] > $j) && ($temp[1] < ($j + 10000))) {
			
			# calculate SNP quality score
			# store first SNP info in a string? try $best_snp = $_;
			# if SNP quality score is higher than previous, replace string
			# at the end - split (if you want)
			# print out the best snp
			
			print "@temp \n";
			$count++;
		}
	}
	
	# Counter to determine if an interval lacks SNPs
	if ($count == 0) {
		print "No SNPs in this interval\n";
	}
	print "\n";
}









print "hello world.\n";





