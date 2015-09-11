#!/usr/bin/perl
#
# Name: select_AGRE_sequenced.pl
# Version: 1.0
# Date: 4/16/20112
################################################################################
# The purpose of this script is to select AGRE samples we sequenced from listing of samples 
# genotyped on the AFFY platform from AGRE
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@xchrome_files, $xchrome_file_number, @count_files, $count_file_number, @test_line, @ID_file, $ID_file_size, $match_indicator, $a, $b);

# Initialize variable values
################################################################################
$xchrome_file_number = 0;
$count_file_number = 0;
$ID_file_size = 0;
@xchrome_files  = ();
@count_files = ();
@test_line = ();
@ID_file =();
$match_indicator = 0;

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: EVS_Data_filter.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

#Glob file names
####################################################################################################
@xchrome_files = glob("*IDmatch.txt");
$xchrome_file_number = ($#xchrome_files + 1);
if ($xchrome_file_number == 0) {
  die "Detected $xchrome_file_number *IDmatch.txt files.\n Check directory. Exiting program";
}

@count_files = glob("*samples.sequenced.txt");
$count_file_number = ($#count_files + 1);
if ($count_file_number == 0) {
  die "Detected $count_file_number *samples.sequenced.txt files.\n Check directory. Exiting program";
}

# Open .txt file for input
# Open output file
####################################################################################################
open (IN_XCHROME_IN, "<", "$xchrome_files[0]") or die "Cannot open IN_XCHROME_ID filehandle to read file";
open(IN_COUNT_IN, "<", "$count_files[0]") or die "Cannot open IN_COUNT_IN filehandle to read file";

open (OUTFILE_0, ">", "$count_files[0]" . ".total.txt");
#open (OUTFILE_1, ">", "$count_files[0]" . ".problems.txt");

# Process X chromosome reference file
####################################################################################################
while(<IN_XCHROME_IN>) {
	chomp $_; 
	
		# Skip first line - header
	if ($_ =~ /^Participant/) {
		print "\nEntered the first loop - detected header\n\n";
		next;
		}
	
		# Split line to family ID[1] and individual ID[2]
	@test_line = split('\t', $_);
	
	# Generate with family and individual IDs
	push(@ID_file, $test_line[1]);
	push(@ID_file, $test_line[2]);
}

# Get size of ID array
$ID_file_size = ($#ID_file + 1);
print "Size of ID_file array is $ID_file_size\n";

# Search ID_file for matching records using our list of sequenced samples
while(<IN_COUNT_IN>) {
	chomp $_;
	print "Value in loop: $_\n";
	
	for (my $i=0; $i<$ID_file_size; $i=$i+2) {
		chomp $ID_file[$i+1];
		
		if ("$_" eq "$ID_file[$i+1]") {
			print "Found a matching sample ID\n";
			print OUTFILE_0 "$ID_file[$i]\t";
			print OUTFILE_0 "$ID_file[$i+1]\n";
		}
	}
}

print "Completed select_AGRE_sequenced.pl script\n";

