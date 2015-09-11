#!/usr/bin/perl -w
# Version 1.2
# Michael E. Zwick
# 1/6/06
# Program designed to:
# 1. Run over a single folder containing multiple genpose files.
# 2. Determine which genpos files need to be reversed.
# 3. Reverse fragment position pairs (top - bottom) - for chips designed on opposite strand
# 4. Swap fragment positions (left and right) - so that they increase in value and reflect 
# annotation from UCSC browser.
# Updates
# ver1.2 - fixed bug whereby @genpos_file_data array was not reinitialized
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, @sequence_file, $seq_file_number, @genpos_file, $genpos_file_number, $files, @all_lines, @genpos_file_data, $genpos_file_data_number, @lines);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of genpos files
# Read in the names of the annot.message.txt files
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "log.reverse_multi_genpos.out")
	or die "Cannot open OUT_FASTA for data output";
	
	# Obtain name of annot.genpos.txt files
	@genpos_file = glob("*annot.genpos.txt");
	$genpos_file_number = ($#genpos_file + 1);
	if ($genpos_file_number == 0) {
		die "$genpos_file_number genpos files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $genpos_file_number genpos files\n";

# Loop over each of the genpos files
foreach my $files (@genpos_file) {

	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
		
	# Open output file - append info to file
	open (OUT_ANNOT, ">", "$files.reverse.genpos.txt")
		or die "Cannot open OUT_ANNOT filehandle to ourput file info";
	
	# Read in a line from a file, split on tabs, put numbers into array
	while (<IN_ANNOT>) {
		chomp($_);
		@lines = split(/\t/, $_);
		push (@genpos_file_data, @lines);
	}
	# Determine array size
	$genpos_file_data_number = ($#genpos_file_data);
	print OUT_LOG "Observed $genpos_file_data_number of elements in array genpos_file_data\n";
	
	# Reverse and swap elements in @genpos_file_data array
	for (my $i = $genpos_file_data_number; $i >= 0; $i=$i-2) {
		
			#print "Made it into loop with i equal to $i\n";
			print OUT_ANNOT "$genpos_file_data[$i]\t";
			print OUT_ANNOT "$genpos_file_data[$i-1]\n";
			next;
	}
	
	#Reinitialize variables
	@genpos_file_data = ();
	$genpos_file_data_number = 0;
	
}
	close (OUT_ANNOT);
	close (IN_ANNOT);

print OUT_LOG "Completed reverse_multi_genpos.txt_ver1.2.pl program.\n";
close(OUT_LOG);
print "Completed reverse_multi_genpos.txt_ver1.2.pl program.\n";
