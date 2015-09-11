#!/usr/bin/perl -w
##############################################################################
### Name: GLAD_Rename_chrFiles.pl
### Version: 1.0
### Date: 04/19/2013
### Author: Michael E. Zwick
##############################################################################
### Program designed to rename GLAD chromosome files to work with Source files
### in R
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################
my(@data_files, @name, @name_second, @sample_IDs, @dup_files, @dup_name, $file, $file_name, $count, $version, $file_number, $fixed_name);
my($data_file_number, $sample_IDs_number, $total_files, $m, $n, $total_source, $test, $data, $dup_file_number, $dup);
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
$version = "1.0";

# Set file number for output here
$file_number = 20;
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
# Change to Alignment directory, in user provided directory
chdir "$ARGV[0]"
	or die "Cannot change to directory $ARGV[0]\n";

# Glob all files with names that include a "_dup" characters
@dup_files = glob("*dup*");
$dup_file_number = ($#dup_files + 1);
if ($dup_file_number == 0) {
  die "Detected $dup_file_number *dup* files.\n Check directory. Exiting program";
}

# Loop over all files in @data_files
foreach $dup (@dup_files) {
	# Obtain the sample ID from the dupfiles
	# Split first based on "_" character
	@dup_name = split (/\_/, $dup);
	print " is: $dup_name[0]\n";
	print " is: $dup_name[3]\n";
	$fixed_name = "$dup_name[0]." . "$dup_name[3]." . "txt";
	rename($dup, $fixed_name);
}

# Glob all files with names that include a "_" character
@data_files = glob("*_*");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *chr21* files.\n Check directory. Exiting program";
}

# Loop over all files in @data_files
foreach $data (@data_files) {
	# Obtain the sample ID from the datafiles
	# Split first based on "." character
	@name = split (/\_/, $data);
	print " is: $name[0]\n";
	print " is: $name[2]\n";
	@name_second = split (/\./, $name[0]);
	$fixed_name = "$name_second[0]." . "$name_second[1]." . "$name_second[2]." . "$name[2]." . "txt";
	rename($data, $fixed_name);
}

print "Completed Get_Rename_chrFiles.pl script version $version\n";
