#!/usr/bin/perl
#
# Name: match_AGRE_ID.pl
# Version: 1.0
# Date: 4/167/2012
################################################################################
# The purpose of this script match and replace AGRE individual IDs with Broad IDs
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@xchrome_files, $xchrome_file_number, @count_files, $count_file_number, @test_line, @ID_file, $ID_file_size, $match_indicator, %ID_match, @temp_match);

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

@count_files = glob("*samples.sequenced.*");
$count_file_number = ($#count_files + 1);
if ($count_file_number == 0) {
  die "Detected $count_file_number *samples.sequenced.txt files.\n Check directory. Exiting program";
}

# Open .txt file for input
# Open output file
####################################################################################################
open (INFILE_1, "<", "$xchrome_files[0]") or die "Cannot open IN_XCHROME_ID filehandle to read file";
open(INFILE_2, "<", "$count_files[0]") or die "Cannot open IN_COUNT_IN filehandle to read file";

open (OUTFILE_0, ">", "$count_files[0]" . ".updated.txt");

# Make hash relating AGRE ID to BROAD ID
####################################################################################################
while(<INFILE_1>) {
	#print "Entered the first while loop\n";
	chomp $_; 
	
		# Skip first line - header
	if ($_ =~ /^Participant/) {
		#print "\nEntered the first loop - detected header\n\n";
		next;
		}
	
	# Split line to Broad ID[0], family ID[1], and individual ID[2]
	@test_line = split('\t', $_);
	
	# Generate hash relating individual ID to Broad ID
	$ID_match{"$test_line[2]"} = "$test_line[0]";
}

# Read in sequenced samples, output file with correct Broad ID
while(<INFILE_2>) {
	#print "Entered the second while loop\n";
	chomp $_;
	@temp_match = split('\t', $_);

	#Output correct information
	print OUTFILE_0 "$temp_match[0]\t";
	print OUTFILE_0 "$ID_match{$temp_match[1]}\n";

	#Reset array
	@temp_match = ();
}

print "Completed match_AGRE_ID.pl script\n";

