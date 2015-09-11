#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 12/2/05
# Program designed to:
# 1. Process multiple files in a single directory.
# 2. Merge the .annot.message.txt files from multiple regions into a single file
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, @sequence_file, $seq_file_number, @message_file, $message_file_number, $files, @all_lines);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of annotation files
# Read in the names of the annot.message.txt files
# Determine the number of fragments from a numbered .fasta file
# Make the in.pop.in file
# Call popgen_fasta with the in.pop.in file
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "log.multi_annot.message.out")
	or die "Cannot open OUT_FASTA for data output";

	# Obtain name of annot.message.txt files
	@message_file = glob("*annot.message.txt");
	$message_file_number = ($#message_file + 1);
	if ($message_file_number == 0) {
		die "$message_file_number message files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $message_file_number message files\n";

# Loop over each of the data directories
foreach my $files (@message_file) {
	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
		
	# Open output file - append info to file
	open (OUT_ANNOT, ">>", "superchip.annot.message.txt")
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
print "Completed multi_annot.message.txt_ver1.1.pl program.\n";
