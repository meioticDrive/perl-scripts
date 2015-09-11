#!/usr/bin/perl
###
### Name: CONVERT_pileup.pl
### Version: 1.0
### Date: 10/29/2008
### Author: Michael E. Zwick
###---------------------------------------------------------------------------
### 1. The purpose of this script is to covert a sequence coverage file 
### putstats.pl to a format for analysis with R.
###---------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $version, @pileup_files, @temp_data, $temp_data_size,
@files, @filess, @fasta_files, @fasta_labels, @temp_label, @temp_seq, %fasta_info, @fasta_labelss, $count);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_data_size = "";
@temp_data = ();

### Change to directory entered by user when calling the program
###---------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old covert files
system ("rm *.pileup.stats.txt");

# Collect the names of all the csv files in a directory
@pileup_files = glob("*pileup_nopad.csv");

# Open output file for coverage values
open(OUT_IGA_PILEUP_STATS, ">", "IGA.convert.pilup.stats.txt")
    or die "Cannot open filehandle OUT_IGA_PILEUP_STATS for data output";

foreach my $process_file (@pileup_files) {

	print "Processing csv file: $process_file\n";

	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";
		
	print OUT_IGA_PILEUP_STATS "$process_file\n";
	
	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		@temp_data = split (/,/, $_);
		# Get size of @temp_data array
		$temp_data_size = @temp_data;
		
		for (my $n = 1; $n < $temp_data_size; $n++) {
		    print OUT_IGA_PILEUP_STATS "$temp_data[$n]\n";
		}
		@temp_data = ();
	}
}
print "Completed CONVERT_pileup.pl version $version script\n";