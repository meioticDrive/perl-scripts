#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 06/28/05
# Program designed to:
# 1. Run over multiple folders (multi) containing fasta sequences and annotation # files (.genpos.txt, .msg.txt, .coding.txt).
# 2. Build an input file (in.pop.in) in each folder in the directory, then call # Dave Cutler's popgen_fasta C program to calculate all popgen parameters.
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my(@data_directories, $data_dir_number, @sequence_file, $seq_file_number, @genpos_file, $genpos_file_number, @message_file, $message_file_number, @coding_file, $coding_file_number, @ref_file, $ref_file_number,

$oligo_size, $oligo_sequence, $position, $oligo_temp);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a set of folders, each with data from a single 
# genomic region
# Descend into the first directory
# Read in the names of all the numbered .fasta files
# Read in the name of the message, coding, genpos files
# Read in the name of the reference file.
# Determine the number of fragments from a numbered .fasta file
# Make the in.pop.in file
# Call popgen_fasta with the in.pop.in file
#-------------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">", "log.haploid.popgen_fasta.out")
	or die "Cannot open OUT_FASTA for data output";

# Obtain names of all folders containing data files
@data_directories = glob("[0-9]*");
$data_dir_number = ($#data_directories + 1);
if ($data_dir_number == 0) {
	die "$data_dir_number data directories detected.\n
	Check directory. Exiting program";
}
print OUT_LOG "Detected $data_dir_number data folders\n\n";


# Loop over each of the data directories
foreach my $folders (@data_directories) {

	print OUT_LOG "The directory name is $folders\n";
	# Change to data folder
	chdir("$folders");
	
	# Remove all old popgen files
	system("rm *.popgen.*");
	
	# Obtain name of numbered .fasta sequence files
	@sequence_file = glob("*.[0-9]*.fasta*");
	$seq_file_number = ($#sequence_file + 1);
	if ($seq_file_number == 0) {
		die "$seq_file_number sequence files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $seq_file_number sequence files\n";

	# Obtain name of genpos.txt file
	@genpos_file = glob("*.genpos.txt");
	$genpos_file_number = ($#genpos_file + 1);
	if ($genpos_file_number == 0) {
		die "$genpos_file_number sequence files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $genpos_file_number genpos file, $genpos_file[0]\n";

	# Obtain name of message.txt file
	@message_file = glob("*.message.txt");
	$message_file_number = ($#message_file + 1);
	if ($message_file_number == 0) {
		die "$message_file_number message files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $message_file_number message file, $message_file[0]\n";

	# Obtain name of coding.txt file
	@coding_file = glob("*.coding.txt");
	$coding_file_number = ($#coding_file + 1);
	if ($coding_file_number == 0) {
		die "$coding_file_number sequence files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $coding_file_number coding file, $coding_file[0]\n";

	# Obtain name of ref.fasta file
	@ref_file = glob("*.ref.fasta");
	$ref_file_number = ($#ref_file + 1);
	if ($ref_file_number == 0) {
		die "$ref_file_number sequence files detected.\n
			Check directory. Exiting program";
	}
	print OUT_LOG "Detected $ref_file_number reference file, $ref_file[0]\n";
	print OUT_LOG "\n";
	
	# Open file used to call exact_match
	open(IN_POPGEN_IN, ">", "in.popgen.in") 
	or die "Cannot open IN_POPGEN_IN for data output";
	
	
		# Generate in.popgen.in file to call popgen_fasta C program
	print IN_POPGEN_IN "d\n";
	print IN_POPGEN_IN "$folders".".popgen.txt\n";
	print IN_POPGEN_IN "$seq_file_number\n";
	
	# Put names of sequence files into in.popgen.in file
	for(my $i = 0; $i < $seq_file_number; $i++) {
		print IN_POPGEN_IN "$sequence_file[$i]\n";
	
	}
	
	print IN_POPGEN_IN "3000\n";
	# Expos value (0 or 12)
	print IN_POPGEN_IN "0\n";
	# Number of sites
	print IN_POPGEN_IN "100000\n";
	# Is this haploid data? [Y,N]
	print IN_POPGEN_IN "Y\n";
	print IN_POPGEN_IN "$genpos_file[0]\n";
	print IN_POPGEN_IN "$message_file[0]\n";
	print IN_POPGEN_IN "$coding_file[0]\n";
	print IN_POPGEN_IN "$ref_file[0]\n";

	close(IN_POPGEN_IN);
	# Call popgen_fasta with in.popgen.in file
	system("popgen_fasta <in.popgen.in");
	
	# Return back to starting directory
	chdir "../";
}

close(OUT_LOG);
print "Completed run_multi_popgen.haploid.ver1.1.pl program.\n";
