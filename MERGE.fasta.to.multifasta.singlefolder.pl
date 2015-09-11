#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 7/28/2010
################################################################################
# Program designed to:
# 1. Run over single folders containing multiple fasta sequences for different 
# individuals or strains. Run program from withing folder containing all target 
# folders.
# 2. Merge the files into a single fasta file
################################################################################
################################################################################
use warnings;
use strict;
use Cwd;
################################################################################
# Local variable definitions
################################################################################
# Define local variables

my(@data_files, $data_file_number, $files, @all_lines, @fasta_file, $fasta_file_number, $fasta_file_loop, $dirname);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

################################################################################
# Main Program Code
################################################################################

# Get current working directory
$dirname = getcwd();


# Obtain names of all files in a directory
# Update glob below depending upon specific application
################################################################################

@data_files = glob("*");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "$data_file_number data directories detected.\n Check directory. Exiting program";
}

# Make Output directory
################################################################################
mkdir("Output");

# Open for output of log files
################################################################################
open(OUT_LOG, ">", "$dirname/Output/log.MERGE.fasta.to.multifasta.singlefolder.out") or die "Cannot open OUT_FASTA for data output";

print OUT_LOG "Detected $data_file_number data files\n";
print OUT_LOG "File names include:\n";
print OUT_LOG "@data_files\n";

################################################################################
# Process each fasta file, loop over all files
################################################################################
foreach my $files (@data_files) {

  print ("Processing file: $files\n");
  print OUT_LOG "Processing file: $files\n";
  
  # Open $files to be read
  open (IN_ANNOT, "<", "$files") or die "Cannot open IN_ANNOT filehandle to read file";

  # Open output file in correct location - append fasta sequences to file
  open (OUT_ANNOT, ">>", "$dirname/Output/bacillus.fasta") or die "Cannot open OUT_ANNOT filehandle to output file info";

  # Read in text from $files, output to OUT_ANNOT file
	while (<IN_ANNOT>) {
    # Output all lines in $files
		print OUT_ANNOT "$_";
	}
	print OUT_ANNOT "\n";
	close (IN_ANNOT);
}

print OUT_LOG "Completed MERGE.fasta.to.multifasta.singlefolder\n";
close(OUT_LOG);
print "Completed MERGE.fasta.to.multifasta.singlefolder\n";

























