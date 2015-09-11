#!/usr/bin/perl
#
# Name: Beast_to_plink_CNV.pl
# Version: 1.0
# Date: 6/14/2012
################################################################################
# The purpose of this script match extract CNV BEAST calls to plink CNV format
################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@beast_files, $beast_file_number, @temp_line, $temp_line_number, $IID, $FID, @temp_name, $files);

# Initialize variable values
################################################################################
$beast_file_number = 0;
@temp_name = "";
$files = 0;
$FID = "";
$IID = "";

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: Beast_to_plink.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

#Glob file names
####################################################################################################
@beast_files = glob("*.cnvsummaryres.filter.txt");
$beast_file_number = ($#beast_files + 1);
if ($beast_file_number == 0) {
  die "Detected $beast_file_number *.filter.txt files.\n Check directory. Exiting program";
}
print "Detected $beast_file_number Beast files\n";

# Open .txt file for input
# Open output file
####################################################################################################
open (OUTFILE_0, ">", "CNV_deletions.txt");
open (OUTFILE_1, ">", "CNV_duplications.txt");

# Process all *.cnvsummaryres.filter.txt
####################################################################################################
for(my $file = 0; $file < $beast_file_number ; $file++) {
	#Open CNV case or control file
	open (INFILE_1, "<", "$beast_files[$file]") or die "Cannot open INFILE_1 filehandle to read file";
	print "Processing $beast_files[$file]\n\n";
	print "Processing file number: $file\n";
	# Split file name
	# Generate value for FID (Family ID) from file name
	# Generate value for IID (Individual ID) from file name
	# Reset array
	@temp_name = split(/\./, "$beast_files[$file]");
	#print "@temp_name\n";
	
	print "The name value is $temp_name[1]\n";
	print "The second name value is $temp_name[2]\n";
	
	$FID = "$temp_name[1]";
	print "$FID\n";
	$IID = "$temp_name[2]";
	print "$IID\n";
	@temp_name = "" ;
	###############
	# Process INFILE
	###############
	while(<INFILE_1>) {
		chomp $_;
		# Skip header lines
	if ($_ =~ /^Chromosome/) {
		next;
		}
		@temp_line = split('\s+', $_);
		#################
		# Code for deletion
		#################
		if($temp_line[3] < 0) {
			# Output FID
			print OUTFILE_0 "$FID\t";
			# Output IID
			print OUTFILE_0 "$IID\t";
			#CHR
			print OUTFILE_0 "$temp_line[0]\t";
			#BP1
			print OUTFILE_0 "$temp_line[1]\t";
			#BP2
			print OUTFILE_0 "$temp_line[2]\t";
			# TYPE
			print OUTFILE_0 "1\t";
			# SCORE
			print OUTFILE_0 "$temp_line[6]\t";
			# SITE
			print OUTFILE_0 "$temp_line[4]\n";
			# Next line
			next;
			}
		###################
		# Code for duplication
		###################
		if($temp_line[3] > 0) {
			# Output FID
			print OUTFILE_1 "$FID\t";
			# Output IID
			print OUTFILE_1 "$IID\t";
			#CHR
			print OUTFILE_1 "$temp_line[0]\t";
			#BP1
			print OUTFILE_1 "$temp_line[1]\t";
			#BP2
			print OUTFILE_1 "$temp_line[2]\t";
			# TYPE
			print OUTFILE_1 "3\t";
			# SCORE
			print OUTFILE_1 "$temp_line[6]\t";
			# SITE
			print OUTFILE_1 "$temp_line[4]\n";
			# Next line
			next;
			}
	# Reset variables
	@temp_line = ();
	}
	@temp_name =();
	$FID = "";
	$IID = "";
	close(INFILE_1);
} 

close(OUTFILE_0);
close(OUTFILE_1);
print "Beast_to_plink.pl script\n";
