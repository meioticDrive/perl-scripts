#!/usr/bin/perl -w
# Version 1.0
# Copyright Michael E. Zwick, 6/10/13
####################################################################################
# Program designed to:
# 1. Parse linkage information from Eigenstrat ped file
# 2. Use this to plot PC1 vs PC2 - need to get case/control status
# Usage: Launch from within directory containing target files
################################################################################
use strict;
use Cwd;

####################################################################################
# Local variable definitions
####################################################################################
# Define local variables
my(@popgen_file, $popgen_file_number, @line);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@popgen_file = ();
$popgen_file_number = 0;

####################################################################################
# Program Overview
####################################################################################

# Remove old files
unlink("log.parse.eigen.out.txt");
unlink("eigen.parsed.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.parse.eigen.out.txt")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of PLINK ped file
@popgen_file = glob("*.ped");
$popgen_file_number = ($#popgen_file + 1);
if ($popgen_file_number == 0) {
	die "$popgen_file_number *.ped files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $popgen_file_number eigenstrat ped files";
print OUT_LOG "Detected $popgen_file_number eigenstrat ped files";

for (my $i = 0; $i < $popgen_file_number; $i++) {
	print OUT_LOG "$popgen_file[$i]\n";
	print OUT_LOG "Processing eigenstrat ped file\n";
	print "Processing eigenstrat ped files\n";
}

# Open output file for parsed primers
open (OUT_ANNOT, ">>", "eigen.parsed.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Process eigenstrat ped files
foreach my $files (@popgen_file) {
    # Open $files to be read
    open (IN_ANNOT, "<", "$files")
	    or die "Cannot open IN_ANNOT filehandle to read file"; 
	# Read in the fasta fragments from file
	while (<IN_ANNOT>) {
		chomp $_;
		@line = split (/\s/, $_);
		# Output linkage file information
		for (my $columns = 0; $columns < 7; $columns++)
		{
			print OUT_ANNOT "$line[$columns]\t";
		}
		print OUT_ANNOT "\n";
	}
}

close (IN_ANNOT);
close (OUT_ANNOT);
print OUT_LOG "Completed EIGN_parse_out.pl program.\n";
close (OUT_LOG);
print "Completed EIGC_parse_out.pl program.\n";