#!/usr/bin/perl
#
# Name: count_GLAD_files.pl
# Version: 1.0
# Date: 9/27/2012
####################################################################################################
# The purpose of this script count the number of GLAD files in a directory that have been analyzed for CNVs with GLAD.
####################################################################################################
use warnings;
use strict;
use Cwd;

# Local variable definitions
####################################################################################################
my (@data_files, $data_file_nmbr, @sample_ID, $sample_ID_file_nmbr, @temp_sample_ID, $i, $countGladOut,
@test_line, $total_samples, $allele_freq, $cases, $controls, $parents);

# Initialize variable values
####################################################################################################
$data_file_nmbr = 0;
$countGladOut = 0;

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
	die "\n Usage: count_GLAD_files.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Glob file containing list of sample IDs - count_CNCHP_Files_Names.txt
# Glob file names of all GLAD breakpoint output files
####################################################################################################
@data_files = glob("*breakpoint*");
$data_file_nmbr = ($#data_files + 1);
if ($data_file_nmbr == 0) {
  die "Detected $data_file_nmbr *breakpoint* files.\n Check directory. Exiting program";
}
print "Loaded all GLAD files into memory\n";

@sample_ID = glob("*Files_Names*");
$sample_ID_file_nmbr = ($#sample_ID + 1);
if ($sample_ID_file_nmbr == 0) {
  die "Detected $sample_ID_file_nmbr file name files.\n Check directory. Exiting program";
}

# Open output file to receive formatted data
open (OUTFILE_0, ">", "GLAD_File_count.txt");
print "Sample_ID\tNumber of Files\n";

# Open input file to read sample IDs
open (IN_SAMPLE_ID, "<", "$sample_ID[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
####################################################################################################

while(<IN_SAMPLE_ID>) {
	chomp $_;
	#split to get sample ID into @temp_sample_ID[0]
	print "Processing: $_\n";
	@temp_sample_ID = split('.CNCHP.', $_);
	
	# Loop over all @data_files
	for($i = 0; $i < $data_file_nmbr; $i++) {
	
		# if file starts with sample ID, collect, count number
		if($data_files[$i] =~ /^$temp_sample_ID[0]/) {
			$countGladOut++;
		}
		else {
			next;
		}
	}
	# Output results
	print OUTFILE_0 "$temp_sample_ID[0]\t$countGladOut\n";
	
	# Reset variables
	@temp_sample_ID = ();
	$countGladOut = 0;
}


close (OUTFILE_0);
close (IN_SAMPLE_ID);

print "Completed count_GLAD_files.pl script\n";

####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################
