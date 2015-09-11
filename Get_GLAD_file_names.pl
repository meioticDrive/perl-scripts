#!/usr/bin/perl -w
##############################################################################
### Name: Get_GLAD_file_names.pl
### Version: 1.0
### Date: 04/18/2013
### Author: Michael E. Zwick
##############################################################################
### Program designed to obtain unique sample names for GLAD files split by
### chromosome. Note: There are 22 files per individual sample. As a shortcut
### only need to get the name from all the chr1 files.
### Assume: All the files are in a single directory
### Usage
### 1. User should provide directory name
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################
my(@data_files, @name, @sample_IDs, $file, $file_name, $count, $version, $file_number);
my($data_file_number, $sample_IDs_number, $total_files, $m, $n, $total_source, $test, $data, $fixed_name);
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
$version = "1.0";

# Set file number for output here
$file_number = 600;
$data_file_number = 0;
$sample_IDs_number = 0;
$n = 0;
$m = 0;
$test = 0;

##############################################################################
### Program Overview
### Change to user supplied directory
### Open filehandle for output
### Read and output all fasta file names
##############################################################################
system ("rm *source*");

# Change to Alignment directory, in user provided directory
chdir "$ARGV[0]"
	or die "Cannot change to directory $ARGV[0]\n";

# Glob all files to extract names
@data_files = glob("*chr21*");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *chr21* files.\n Check directory. Exiting program";
}

# Loop over all @data_files
foreach $data (@data_files) {
	# Obtain the sample ID from the datafiles
	# Sample name from chr1 file written into the @data_files
	@name = split (/\./, $data);
	$fixed_name = "$name[0]." . "$name[1]." . "$name[2]";
	print "The sample ID is: $fixed_name\n";
	push (@sample_IDs, $fixed_name);
}

#Get total number of sample IDs
$sample_IDs_number = ($#sample_IDs + 1);
print "The total number of samples is $sample_IDs_number\n";
$test = (int($sample_IDs_number/$file_number) + 1);
print "Number of source files: $test\n";

for ($m = 0; $m <= $test; $m++) {
	open(OUT_GLAD_FILES, ">", "GLAD.filenames." . "$m" . ".txt")
		or die "Cannot open filehandle OUT_GLAD_FILES for data output";
	#Output $file_number number of file_names
	for ($n = ($file_number * $m); $n < ($file_number * ($m + 1)); $n++) {
		print OUT_GLAD_FILES "$sample_IDs[$n]\n";
	}
	close(OUT_GLAD_FILES);

#Open output file
#Output 100 files from array
#Track where I am in array - 
#	0 - 99
#	100 - 199
#		200 - 299
#		until end of array contents
#	Close output file

}

print "Completed Get_GLAD_file_names.pl script version $version\n";
