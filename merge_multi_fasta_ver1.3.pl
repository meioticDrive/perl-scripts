#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 12/2/05
# Program designed to:
# 1. Run over multiple folders (multi) containing multiple fasta sequences for 
# the same individual. Run program from withing folder containing all target 
# folders.
# 2. Merge the files into a single fasta file for each individual
# 3. Need to updated the following before running the program:
# - Update number of files
# - Update path for output of log files
# - Update Working directory path
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
use strict;
use Cwd;
#-----------------------------------------------------------------------------
# Local variable definitions
#-----------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, $files, @all_lines, @fasta_file, $fasta_file_number, $fasta_file_loop, $dirname);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables - number of fasta files
$fasta_file_number = 40;

#print ("\n");
#system ("pwd");
#print ("\n");

#-----------------------------------------------------------------------------
# Program Overview:
# Get all directory names
# Define fasta_file_number above, loop over all file numbers
# Write/Append sequence for same individual to different files
#-----------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "/Users/michaelzwick/Desktop/log.merge_multi_fasta.1.3.out")
	or die "Cannot open OUT_FASTA for data output";

# Obtain names of all folders containing data files
@data_directories = glob("[0-9]*");
$data_dir_number = ($#data_directories + 1);
if ($data_dir_number == 0) {
	die "$data_dir_number data directories detected.\n
	Check directory. Exiting program";
}
print OUT_LOG "Detected $data_dir_number data folders\n\n";

# Loop over $i fasta files
for (my $i = 0; $i < $fasta_file_number; $i++) {

	print ("Starting to process individual $i\n");
	
	# Loop over all directories
	foreach my $dirs (@data_directories) {
	
		# Move into working directory
		chdir ("/Users/michaelzwick/Desktop/Final_Analysis_Autosome/$dirs");
		system ("pwd");
		
	# Obtain name of fasta files for $i = 0
	if ($i == 0) {
		#print ("Entered the first loop\n");
		@fasta_file = glob("*.$i.fasta*");
		$fasta_file_loop = ($#fasta_file + 1);
		if ($fasta_file_loop == 0) {
			die "$fasta_file_loop fasta files detected.\n
			Check $dirs directory. Exiting program";
		}
	}
	
	# Obtain name of fasta files for 0 < $i < 10
	if (($i > 0) && ($i < 10)) {
		#print ("Entered the second loop\n");
		@fasta_file = glob("*.0$i.fasta*");
		$fasta_file_loop = ($#fasta_file + 1);
		if ($fasta_file_loop == 0) {
			die "$fasta_file_loop fasta files detected.\n
			Check $dirs directory. Exiting program";
		}
	}
		
	# Obtain name of fasta files for $i >= 10
	if ($i >= 10) {
		#print ("Entered the third loop");
		@fasta_file = glob("*.$i.fasta*");
		$fasta_file_loop = ($#fasta_file + 1);
		if ($fasta_file_loop == 0) {
			die "$fasta_file_loop fasta files detected.\n
			Check $dirs directory. Exiting program";
		}
	}
		
	print OUT_LOG "Detected $fasta_file_loop fasta file, $fasta_file[0]\n";
	
	# Open output file in correct location - append fasta sequences to file
	open (OUT_ANNOT, ">>", "/Users/michaelzwick/Desktop/superchip.$i.fasta")
 		or die "Cannot open OUT_ANNOT filehandle to ourput file info";
	
	$files = $fasta_file[0];
	
	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
	
	#print ("Made past open input file command\n");
	print ("Current file is $files\n");
	
	# Read in text information from $files
	while (defined($_ = <IN_ANNOT>)) {
		print OUT_ANNOT "$_";
		#print "$_";
	}
	#print OUT_ANNOT "\n";
	print "Exiting after writing file while loop\n";
	close (IN_ANNOT);
		
	}
	close (OUT_ANNOT);
}

close(OUT_LOG);
print "Completed multi_merge.fasta.ver1.2.pl program.\n";










































