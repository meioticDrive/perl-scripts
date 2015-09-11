#!/usr/bin/perl
##############################################################################
### Name: RA_extract_hapmap_data.pl
### Version: 1.0
### Date: 05/31/2007
### Author: Michael E. Zwick
##############################################################################
### 1. The purpose of this script is to extract SNP position and genotype from ### a hapmap file in order # to make an individual hapmap genotype file for ### subsequent analysis
### 2. Requires the following files:
###  - hapmap raw data from a single chromosome

use warnings;
use strict;
use Cwd;

##############################################################################
### Globals
##############################################################################

my ($dirname, $version, $temp_seq, @temp_label, $count, @hapmap_file, @temp_hapmap, $position, $sample_id, @label_genpos, @hapmap_files, @temp_genpos, @genpos_name, @genpos_start, @genpos_end, $nmbr_genpos_name, $nmbr_genpos_start, $nmbr_genpos_end, @temp_ra_seq, $temp_location, @files, @filess, @fasta_labels, @temp_seq, %fasta_info, $file_name, $i);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
@temp_label = ();
$count = 0;
$file_name = "";
$temp_location = 0;

# Field containing SNP Position from HapMap
# Same for all SNPs
$position = 3;

# Position of HapMap ID and Genotype
$sample_id = 25; 

##############################################################################
### Main
##############################################################################

# Change to directory entered by user when calling the program
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.hapmap.txt");

# Collect the name of Hapmap Data File for processing
@hapmap_file = glob("*fwd.txt")
    or die "No hapmap data file found\n";

# Output sequence information
open(OUT_HAPMAP_DATA, ">", 'individual_name' . '.hapmap.txt')
    or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

# Process hapmap file, extract relevant data for an individual
foreach my $process_file (@hapmap_file) {
	
	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for hapmap data file";
	
	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		@temp_hapmap = split('\s',$_);
	
	print OUT_HAPMAP_DATA "REPLACE_*\t";
	print OUT_HAPMAP_DATA "$temp_hapmap[$position]\t";
	print OUT_HAPMAP_DATA "$temp_hapmap[$sample_id]\n";
	}
}

close (FILEHANDLE_FIRST);
close (OUT_HAPMAP_DATA);

print "Completed HAP_extract_data.pl version $version script\n";

##############################################################################
### Subroutines
##############################################################################