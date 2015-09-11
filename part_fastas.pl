#!/usr/bin/perl -w
# Purpose: Take a collection of chip fasta output files (collection of fasta 
# fragments), and split the file into subsets that reflect the genomic 
# location/organization of the fragments, place into three directories called 
# /pxo1 /pxo2 /mainchrom. Specifically, for B. anthracis: pxo1, pxo2, main.
# Invoke: in the directory containing the fasta files
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;

#-------------------------------------------------------------------------------
# Variable Definitions
#-------------------------------------------------------------------------------
my(@files, @fasta_first, $file_first_lines, $fasta_first_seq, $fasta_second_seq, $file_first_size, $file_number, $fasta_files, $count, @fasta_label, $k, $l, $pxo1, $pxo2, $mainchrom, $path, $path_1, $path_2, $path_3,);

#-------------------------------------------------------------------------------
# Get the names of all the fasta files in a directory
# For each file, read in the text
# Using information relating the fasta label to the genomic location,
# split the remaining files into three directorys, distinct fasta files with
# name appended.
# pXO1: nmrc_001, nmrc_002, nmrc_003, nmrc_004, nmrc_005
# pXO2: nmrc_006, nmrc_007
# mainchrom: nmrc_008, nmrc_009, nmrc_010, nmrc_011, nmrc_012
#-------------------------------------------------------------------------------
$pxo1 = 5;
$pxo2 = 2;
$mainchrom = 5;

#-------------------------------------------------------------------------------
# Remove previous directories
# Obtain the names of all the *.fasta files in a directory
# Determine the number of files
#-------------------------------------------------------------------------------


@files = glob("*.fasta");
$file_number = ($#files + 1);

#-------------------------------------------------------------------------------
# print "The number of fasta files is $file_number\n";
# Check for file error conditions - no file present
#-------------------------------------------------------------------------------
if ($file_number == 0) {
    die "Error! No fasta files present. Check directory. Exiting program";
}

#---------------------------------------------------------------------------
# Remove existing directories
# Make directories for data output
#---------------------------------------------------------------------------
system("rm -R mainchrom");
system("rm -R pxo*");
mkdir("pxo1")
	or die "Could not make pxo1 directory";
mkdir("pxo2")
	or die "Could not make pxo2 directory";
mkdir("mainchrom")
	or die "Could not make mainchrom directory";


#-------------------------------------------------------------------------------
# Loop over all files in directory - in the @files array
#-------------------------------------------------------------------------------
for (my $i = 0; $i < $file_number; $i++) {

	#---------------------------------------------------------------------------
	# Open a file handle
	# Read in .fasta file - assume fasta file has line returns after every line
	# Close file handle
	#---------------------------------------------------------------------------
	open(FILEHANDLE_FIRST, $files[$i]) 
		or die "Cannot open FILEHANDLE_FIRST";
	@fasta_first = <FILEHANDLE_FIRST>;
	close(FILEHANDLE_FIRST);

	#---------------------------------------------------------------------------
	# Determine file size (in terms of number of lines - not characters)
	# Loop over all lines in fasta file
	# If line contains a fasta label (starts with >, has a \n) then
	# save value into @fasta_label
	# @fasta_label values can be used later for s/// operations
	#---------------------------------------------------------------------------
	$file_first_lines = ($#fasta_first + 1);
	$k = 0;
	for (my $j = 0; $j < $file_first_lines; $j++) {
		if ($fasta_first[$j] =~ /^>/) {
			$fasta_label[$k] = $fasta_first[$j];
			chomp($fasta_label[$k]);
			$k++;
		}
	}
	
	#---------------------------------------------------------------------------
	# Join fasta array, @fasta_first to make a single string
	# Remove spaces
	# Add returns around all fasta file names - treat first fasta name
	# differently (no need for \n in front of first fasta_label
	# At the end of this code, fasta file is in a single string, with \n after
	# the fasta label, and at the end of each DNA block
	#---------------------------------------------------------------------------
	$fasta_first_seq = join( '', @fasta_first);
	$fasta_first_seq =~ s/\s//g;
	for (my $j = 0; $j < $k; $j++) {
		if ($j == 0) {
			# Fix first fasta label
			$fasta_first_seq =~ s/$fasta_label[$j]/$fasta_label[$j]\n/;
		}
		elsif ($j > 0) {
			# Deal with all remaining fasta labels
			$fasta_first_seq =~ s/$fasta_label[$j]/\n$fasta_label[$j]\n/;
		}
	}
	@fasta_first = split( '\n', $fasta_first_seq);
	# size of array containing fasta file names and seqs
	$file_first_size = ($#fasta_first + 1);
	#print "File first size is $file_first_size\n";
	
	#---------------------------------------------------------------------------
	# Get present working directory
	# chomp to remove \n
	# Make path and file names for output of files
	#---------------------------------------------------------------------------
	$path = qx("pwd");
	chomp($path);
	$path_1 = "$path" . "/pxo1/" . "$files[$i].pxo1.fasta";
	$path_2 = "$path" . "/pxo2/" . "$files[$i].pxo2.fasta";
	$path_3 = "$path" . "/mainchrom/" . "$files[$i].main.fasta";
	
	#---------------------------------------------------------------------------
	# Open Output File Handles
	#---------------------------------------------------------------------------
	open(FILEHANDLE_OUT_1, ">", "$path_1")
		or die "Cannot open FILEHANDLE_OUT_1";
	open(FILEHANDLE_OUT_2, ">", "$path_2")
		or die "Cannot open FILEHANDLE_OUT_2";
	open(FILEHANDLE_OUT_3, ">", "$path_3") 
		or die "Cannot open FILEHANDLE_OUT_3";
	
	#---------------------------------------------------------------------------
	# pXO1 fragments#
	#---------------------------------------------------------------------------
	for (my $j = 0; $j < ($pxo1 * 2); $j++) {
		print FILEHANDLE_OUT_1 "$fasta_first[$j]\n";
	}
	close(FILEHANDLE_OUT_1);
	
	#---------------------------------------------------------------------------
	# pXO2 fragments
	#---------------------------------------------------------------------------
	for (my $j = ($pxo1 * 2); $j < (($pxo1 + $pxo2) * 2); $j++) {
		print FILEHANDLE_OUT_2 "$fasta_first[$j]\n";
	}
	close(FILEHANDLE_OUT_2);
	
	#---------------------------------------------------------------------------
	# main chromosome fragments
	#---------------------------------------------------------------------------
	for (my $j = (($pxo1 + $pxo2) * 2); $j < $file_first_size; $j++) {
		print FILEHANDLE_OUT_3 "$fasta_first[$j]\n";
	}
	close(FILEHANDLE_OUT_3);
	
}
print "Reached end of part_fastas.pl script.\n";





