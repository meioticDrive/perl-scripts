#!/usr/bin/perl
#
# Name: Agilent_to_Beast.pl
# Version: 1.0
# Date: 7/19/2012
################################################################################
# The purpose of this script match extract Agilent raw aCGH data and put it in Beast format.
# This version assume all the data comes from a single chromosomes.
################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@beast_files, $beast_file_number, @temp_line, $temp_line_number, $IID, $FID, @temp_name, $files, @PosBase_temp_1, @PosBase_temp_2);

# Initialize variable values
################################################################################
$beast_file_number = 0;
@temp_name = "";
@PosBase_temp_1 = "";
@PosBase_temp_2 = "";
$files = 0;
$FID = "";
$IID = "";

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: Agilent_to_Beast.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

#Glob file names
# Update as needed for Agilent file names
####################################################################################################
@beast_files = glob("*_example.txt");
$beast_file_number = ($#beast_files + 1);
if ($beast_file_number == 0) {
  die "Detected $beast_file_number *_example.txt files.\n Check directory. Exiting program";
}
print "Detected $beast_file_number Agilent files\n";

# Open .txt file for input
# Open output file
####################################################################################################
open (OUTFILE_0, ">", "Beast_AgilentCNV_input.txt");
print OUTFILE_0 "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";

# Process all *_example.txt files
####################################################################################################
for(my $file = 0; $file < $beast_file_number ; $file++) {
	#Open CNV case or control file
	open (INFILE_1, "<", "$beast_files[$file]") or die "Cannot open INFILE_1 filehandle to read file";
	print "Processing $beast_files[$file]\n\n";
	print "Processing file number: $file\n";
	
	while(<INFILE_1>) {
		chomp $_;
	
		if ($_ =~ /^DATA/) {
			@temp_name = split(/\t/, "$_");
			
			# Screen out unwanted lines
			if ($temp_name[6] =~/^\d/) {
				next;
			}
			if ($temp_name[6] =~/^HsCGHBrightCorner/) {
				next;
			}
			if ($temp_name[6] =~/^DarkCorner/) {
				next;
			}
			if ($temp_name[6] =~/^SM/) {
				next;
			}
			if ($temp_name[6] =~/^SRN/) {
				next;
			}
			if ($temp_name[6] =~/^NC/) {
				next;
			}
			if ($temp_name[6] =~/^PC/) {
				next;
			}
			if ($temp_name[6] =~/^DCP/) {
				next;
			}
			if ($temp_name[6] =~/^\(/) {
				next;
			}
			# Output PosOrder
			print OUTFILE_0 "$temp_name[1]\t";
		
			# Output Chromosome - Default is chromosome 21
			print OUTFILE_0 "21\t";
		
			# Output Clone field
			print OUTFILE_0 "$temp_name[6]\t";
		
			# Output PosBase - position of first base in oligo
			# Second element of @PosBase_temp_1 holds desired information
			# First element of @PosBase_temp_2 holds oligo start position
			@PosBase_temp_1 = split(/:/, "$temp_name[7]");
			@PosBase_temp_2 = split(/-/, "$PosBase_temp_1[1]");
			print OUTFILE_0 "$PosBase_temp_2[0]\t";
			#Reset temp arrays
			@PosBase_temp_1 = "";
			@PosBase_temp_2 = "";
		
			# Output LogRatio
			print OUTFILE_0 "$temp_name[10]\n";
		}
		# Reset temp array
		@temp_name = ();
	}
}

close(OUTFILE_0);
print "Agilent_to_Beast.pl script\n";
