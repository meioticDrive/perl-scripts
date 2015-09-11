#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 12/2/05
# Program designed to:
# 1. Run over multiple folders (multi) containing multiple fasta sequences for 
# the same individual.
# 2. Merge the files into a single fasta file for each individual (i.e. 
# Superchip)
# 3. Note that you need to define specific directories below.
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

# Initialize variables

#-----------------------------------------------------------------------------
# Program Overview:
# Get all directory names
# Define fasta_file_number above, loop over all file numbers
# Write/Append sequence for same individual to different files
#-----------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "/Users/michaelzwick/Desktop/log.multi_ref.fasta.out")
	or die "Cannot open OUT_FASTA for data output";

# Obtain names of all folders containing data files
@data_directories = glob("[0-9]*");
$data_dir_number = ($#data_directories + 1);
if ($data_dir_number == 0) {
	die "$data_dir_number data directories detected.\n
	Check directory. Exiting program";
}
print OUT_LOG "Detected $data_dir_number data folders\n\n";
	
# Loop over all directories
foreach my $dirs (@data_directories) {
	
	# Move into working directory
	# User needs to define this directory!!
	chdir ("/Users/michaelzwick/Desktop/HumGen_Analysis_X_Chromosome/$dirs");
		
	# Obtain name of ref fasta files
	@fasta_file = glob("*.ref.fasta");
	$fasta_file_loop = ($#fasta_file + 1);
	if ($fasta_file_loop == 0) {
		die "$fasta_file_loop fasta files detected.\n
		Check $dirs directory. Exiting program";
	}

	print OUT_LOG "Detected $fasta_file_loop fasta file, $fasta_file[0]\n";
	
	# Open output file in correct location - append fasta sequences to file
	#
	# Remember to Change this Location!!!
	#
	open (OUT_ANNOT, ">>", "/Users/michaelzwick/Desktop/superchip.xchromosome.ref.fasta")
 		or die "Cannot open OUT_ANNOT filehandle to ourput file info";
	
	$files = $fasta_file[0];
	
	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";

	# Read in text information from $files
	while (defined($_ = <IN_ANNOT>)) {
		print OUT_ANNOT "$_";
	}
	print OUT_ANNOT "\n";
	close (IN_ANNOT);
		
	}
close (OUT_ANNOT);
close(OUT_LOG);
print "Completed merge_multi.ref.fasta.ver1.2.pl program.\n";










































