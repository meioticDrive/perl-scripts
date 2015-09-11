#!/usr/bin/perl
#
# Name: count_CNCHP_files.pl
# Version: 1.0
# Date: 9/12/2012
####################################################################################################
# The purpose of this script count the number of CNCHP files in a directory that have been analyzed for CNVs.
# I wrote the script to just verify that the file count at the end of an analysis is correct.
####################################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
####################################################################################################
my (@data_files, $data_file_nmbr, $i, @test_line, $total_samples, $allele_freq, $cases, $controls, $parents);

# Initialize variable values
####################################################################################################
$data_file_nmbr = 0;
$i = 0;
$total_samples = 0;
$allele_freq = 0;
$cases = 0;
$controls = 0;
$parents = 0;

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: SeqAnt_Data_to_DataGraph.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Glob file names - *.CNCHP.* files
####################################################################################################
@data_files = glob("*.CNCHP.*");
$data_file_nmbr = ($#data_files + 1);
if ($data_file_nmbr == 0) {
  die "Detected $data_file_nmbr *.CNCHP.* files.\n Check directory. Exiting program";
}

# Open output file to receive formatted data
####################################################################################################
open (OUTFILE_0, ">", "count_CNCHP_Files_Names.txt");
open (OUTFILE_1, ">", "count_CNCHP_Files_Info.txt");

# Loop over all @data_files
for($i = 0; $i < $data_file_nmbr; $i++) {
	print "$data_files[$i]\n";
	print OUTFILE_0 "$data_files[$i]\n";
	
	# Number of case files
	if ($data_files[$i] =~ /^case/) {
		$cases++;
		next;
	} elsif ($data_files[$i] =~ /^control/) {
		$controls++;
		next;
	} elsif ($data_files[$i] =~ /^parent/) {
		$parents++;
		next;
	} else {
		print "Failed to find a match with $data_files[$i]\n";
		next;
	}
}

# Output file information
print OUTFILE_1 "Total number of CNCHP files is $data_file_nmbr\n";
print OUTFILE_1 "Total number of case files is $cases\n";
print OUTFILE_1 "Total number of control files is $controls\n";
print OUTFILE_1 "Total number of parent files is $parents\n";

close(OUTFILE_0);
close(OUTFILE_1);

print "Completed count_CNCHP_files.pl script\n";

####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################
