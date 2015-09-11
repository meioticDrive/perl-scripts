#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 12/2/05
# Program designed to:
# 1. Run in a single folder containing multiple genpos files
# 2. Merge the .annot.genpos.txt files from multiple regions into a single file
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, @sequence_file, $seq_file_number, @genpos_file, $genpos_file_number, $files, @all_lines);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of annotation files
# Read in the names of the annot.genpos.txt files
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "log.multi_annot.genpos.out")
	or die "Cannot open OUT_FASTA for data output";

	# Obtain name of annot.genpos.txt files
	@genpos_file = glob("*genpos.txt");
	$genpos_file_number = ($#genpos_file + 1);
	if ($genpos_file_number == 0) {
		die "$genpos_file_number genpos files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $genpos_file_number genpos files\n";

# Loop over each of the data directories
foreach my $files (@genpos_file) {
	
	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
		
	# Open output file - append info to file
	open (OUT_ANNOT, ">>", "superchip.annot.genpos.txt")
 		or die "Cannot open OUT_ANNOT filehandle to ourput file info";
 		
	# Output region name to log file
		print OUT_LOG "$files\n";
		
	# Read in text information from $files
	while (<IN_ANNOT>) {
		#chomp($_);
		print OUT_ANNOT "$_";
		}
	#print OUT_ANNOT "\n";
}

	close (OUT_ANNOT);
	close (IN_ANNOT);

close(OUT_LOG);
print "Completed multi_annot.genpos.txt_ver1.1.pl program.\n";
