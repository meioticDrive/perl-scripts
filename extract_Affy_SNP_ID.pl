#!/usr/bin/perl
#
# Name: extract_Affy_SNP_ID.pl
# Version: 1.0
# Date: 4/19/2012
################################################################################
# The purpose of this script match extract SNP information from Affymetrix annot files
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@xchrome_files, $xchrome_file_number, @count_files, $count_file_number, @test_line, $a, $b, $c);

# Initialize variable values
################################################################################
$xchrome_file_number = 0;
$count_file_number = 0;
@xchrome_files  = ();
@count_files = ();
@test_line = ();
$a = "";
$b = "";
$c = "";


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
@xchrome_files = glob("*.annot.csv");
$xchrome_file_number = ($#xchrome_files + 1);
if ($xchrome_file_number == 0) {
  die "Detected $xchrome_file_number *.annot.csv files.\n Check directory. Exiting program";
}

# Open .txt file for input
# Open output file
####################################################################################################
open (INFILE_1, "<", "$xchrome_files[0]") or die "Cannot open INFILE_1 filehandle to read file";

open (OUTFILE_0, ">", "Affy_SNP_ID.txt");

# Process Affymetrix .annot file
####################################################################################################
while(<INFILE_1>) {
	#print "Entered the first while loop\n";
	chomp $_; 
	
		# Skip header lines
	if ($_ =~ /^#/) {
		next;
		}
	
	# Split line with SNP information
	@test_line = split(',', $_);

	$a = $test_line[0];
	$a =~ s/\"//g;
	$b = $test_line[1];
	$b =~ s/\"//g;
	$c = $test_line[4];
	$c =~ s/\"//g;

# Output SNP information
print OUTFILE_0 "$a\t$b\t$c\n";

}
print "Completed extract_Affy_SNP_ID.pl script\n";

