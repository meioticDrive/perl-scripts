#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 12/2/05
# Program designed to:
# 1. Process multiple files, all contained within a single directory
# files.
# 2. Merge the .annot.coding.txt files from multiple regions into a single file
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, @sequence_file, $seq_file_number, @coding_file, $coding_file_number, $files, @all_lines);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of annotation files
# Read in the names of the annot.message.txt files
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "log.multi_annot.coding.out")
	or die "Cannot open OUT_FASTA for data output";

	# Obtain name of annot.coding.txt files
	@coding_file = glob("*annot.coding.txt");
	$coding_file_number = ($#coding_file + 1);
	if ($coding_file_number == 0) {
		die "$coding_file_number coding files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $coding_file_number coding files, $coding_file[0]\n";

# Loop over each of the data directories
foreach my $files (@coding_file) {

	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
		
	# Open output file - append info to file
	open (OUT_ANNOT, ">>", "superchip.annot.coding.txt")
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
print "Completed multi_annot.coding.txt_ver1.1.pl program.\n";
