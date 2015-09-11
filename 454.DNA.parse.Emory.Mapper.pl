#!/usr/bin/perl
#
# Name: 454.DNA.parse.pl
# Version: 1.0
# Date: 3/30/2011
################################################################################
# The purpose of this script is to parse 454 fna files containing DNA 
# sequences
# to run on Emory Mapper. Necessary operations include:
# 1. Demultiplex sequence files
# 2. Put sequences into input file format for Emory Mapper
################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@seq_file, $seq_file_nmbr, $user_input);

my %MIDS = (
"MID1" => "ACGAGTGCGT",
"MID2" => "ACGCTCGACA",
"MID3" => "AGACGCACTC",
"MID4" => "AGCACTGTAG",
"MID5" => "ATCAGACACG",
"MID6" => "ATATCGCGAG",
"MID7" => "CGTGTCTCTA",
"MID8" => "CTCGCGTGTC",
"MID9" => "TAGTATCAGC",
"MID10" => "TCTCTATGCG",
"MID11" => "TGATACGTCT",
"MID12" => "TACTGAGCTA",
"RL1" => "ACACGACGACT",
"RL2" => "ACACGTAGTAT",
"RL3" => "ACACTACTCGT",
"RL4" => "ACGACACGTAT",
"RL5" => "ACGAGTAGACT",
"RL6" => "ACGCGTCTAGT",
"RL7" => "ACGTACACACT",
"RL8" => "ACGTACTGTGT",
"RL9" => "ACGTAGATCGT",
"RL10" => "ACTACGTCTCT",
"RL11" => "ACTATACGAGT",
"RL12" => "ACTCGCGTCGT",
);

# Initialize variable values
################################################################################
$seq_file_nmbr = 0;

# Process fna files
##############################################################################
# Remove old Emory Mapper files
unlink glob "*.Emory.Mapper.txt";

# Query user for multiplex tab ID
print "Please enter the multiplex tab ID (MID) now.\n"
$user_input = <STDIN>;
print "The MID you entered was $user_input\n"; 

if defined ($MIDS{$user_input}) {
	print "The MID you entered is defined.\n";
	print "Processing file.\n";
} else {
	print "The MID you entered is note defined.\n";
	print "Please enter the multiplex tab ID (MID) now.\n"
	$user_input = <STDIN>;
	print "The MID you entered was $user_input\n"; 
}

# Kill program is MID is undefined
if defined ($MIDS{$user_input}) {
	print "The MID you entered is defined.\n";
	print "Processing file.\n";
} else {
	die "Cannot find correct MID\n"
}

# Read .fna file(s)
@seq_file = glob("*.fna") || print "\nNo 454 sequence file found\n";
$seq_file_nmbr = ($#seq_file + 1);

# Process fna files
foreach my $files (@seq_file) {

 # Open $files to be read
  open (IN_ANNOT, "<", "$files") or die "Cannot open IN_ANNOT filehandle to read file";

	# Make output file for Emory Mapper
	open(OUT_FILE, ">", "$files" . ".Emory.Mapper.txt") or die "Cannot open filehandle OUT_FILE to make input file for seqboot";

# Read in text from $files, output to OUT_ANNOT file
	while (<IN_ANNOT>) {
	
		# Do not output fasta header lines
		if (/^>/) {
		next;
		}
		# Match and output sequences with correct multiplex tag
		#if (line begins with "$multiplex_tag") {
    	print OUT_FILE "\@HWI_dummy\n";
    	# Output sequence
    	print OUT_FILE "$_";
    	print OUT_FILE "Dummy_1\n";
    	print OUT_FILE "Dummy_2\n";
		#}    



		#else {
		#next;
		#}
		
		
		
	}

# Close fna test files
close (IN_ANNOT);
}

print "Finished 454.DNA.parse.pl script\n";

