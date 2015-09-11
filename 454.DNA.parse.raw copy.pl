#!/usr/bin/perl
#
# Name: 454.DNA.parse.raw.pl
# Version: 1.0
# Date: 4/1/2011
################################################################################
# The purpose of this script is to parse raw 454 fna files containing DNA 
# sequences to a format that can be process by the 454.DNA.parse.Emory.Mapper.pl
# script. Main format change is to get rid of returns at end of each DNA 
# sequence line so that the entire DNA sequence ends up on a single line
################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@seq_file, $seq_file_nmbr, $seq_string_temp);

# Initialize variable values
################################################################################
$seq_string_temp = "";

# Process raw 454 fna files
##############################################################################
# Remove all old processed files
unlink "*.parse.txt";

# Read .fna files
@seq_file = glob "*.fna" || print "\nNo 454 sequence files found\n";
$seq_file_nmbr = ($#seq_file + 1);
print "Processing a total of $seq_file_nmbr 454 raw .fna files\n";

# Process fna files
foreach my $files (@seq_file) {
	# Debug
	print "Processing $files\n";
	# Open $files to be read
	open (IN_FILE, "<", "$files") or die "Cannot open IN_ANNOT filehandle to read file";
	# Make output file for Emory Mapper
	open(OUT_FILE, ">", "$files" . ".parse.txt") or die "Cannot open filehandle OUT_FILE to make input file for seqboot";

# Read in text from $files, output to OUT_ANNOT file
	while (<IN_FILE>) {
		# Do not output fasta header lines
		if (/^>/) {
			print OUT_FILE "$seq_string_temp\n";
			#Reset temp string variable
			$seq_string_temp = "";
			print OUT_FILE "$_";
			next;
		}
		else {
			# Collect DNA sequences over multiple lines
			chomp($_);
			$seq_string_temp = $seq_string_temp . $_;
		}
	}

	#At EOF - output final line and reset variable
	print OUT_FILE "$seq_string_temp\n";
	$seq_string_temp = "";

	# Close IN and OUT files
	close (IN_FILE);
	close (OUT_FILE);
}

print "Finished 454.DNA.parse.raw.pl script\n";

