#!/usr/bin/perl
#
# Name: Rename_CNCHP_files.pl
# Version: 1.0
# Date: 4/11/2012
################################################################################
# The purpose of this script is to rename a series of CNCHP files to versions that can be analyzed for
# copy number variants in existing pipelines
# Note: Substring below - may need to alter depending upon file names
################################################################################
#use warnings;
use strict;
use Cwd;

# Local variable definitions
################################################################################
my (@data_files, $data_file_number, @linkage_file, $linkage_file_number, %rename_cnchp, @test_line, $files_count,
 %genome_positions, @genes_counts, $genes_counts_size, $temp_name_0, $temp_name_1,
@indel_position, $indel_position_size, $first_value, $second_value, @indel_temp, $indel_temp_size, $indel_count, @test_line);

# Initialize variable values
################################################################################
$data_file_number = 0;
$temp_name_0 = "";
$temp_name_1 = "";

# Perform directory functions
####################################################################################################
# Test if user included directory name when starting program
if(@ARGV != 1)
{
	die "\n Usage: Rename_CNCHP_files.pl <target directory> \n";
}
# Change to user provided directory containing data files
chdir "$ARGV[0]";

# Glob CNCHP file names
####################################################################################################
@data_files = glob("*.CNCHP.txt");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *.txt files.\n Check directory. Exiting program";
}

@linkage_file = glob("*_Linkage.txt");
$linkage_file_number = ($#linkage_file + 1);
if ($linkage_file_number == 0) {
  die "Detected $linkage_file_number *_Linkage.txt files.\n Check directory. Exiting program";
}
print "\nDetected $data_file_number data files\n";
print "Detected $linkage_file_number linkage files\n";

# Make Hash for Linkage file
####################################################################################################
open (IN_LINKAGE, "<", "$linkage_file[0]") or die "Cannot open IN_LINKAGE filehandle to read file";

while(<IN_LINKAGE>) {
	chomp $_;
	#Skip first header line
	if ($_ =~ /^cel/) {
		print "\nEntered the first loop - detected header\n\n";
		next;
	}
	# Process line from master linkage file
	@test_line = split('\t', $_);
	# Check if value exists in hash
	 if (exists $rename_cnchp{"$test_line[0]"}) {
	 	print "Duplicate value found. This is bad! Exiting!!\n";
	 	exit;
	 }
	 else {
	 	# Gets rid of .CEL from file name, enters into hash
	 	$temp_name_0 = substr($test_line[0], 0, -4);
	 	#print "Linkage file substring is $temp_name_0\n";
	 	#print "Associative array value is $test_line[1]\n\n";
	 	$rename_cnchp{"$temp_name_0"} = "$test_line[1]";
	 	$temp_name_0 = "";
	  }
}
print "\n";
close(IN_LINKAGE);

# Process file names
####################################################################################################
open (IN_SAMPLE_ID, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";

for (my $i = 0; $i < $data_file_number; $i++) {
	# rename .cnchp file with correct name from hash
	# Note - size of substring depends upon file name
	# May need to update line below
	$temp_name_1 = substr($data_files[$i], 0,-26);
	print "File temp search substring is $temp_name_1\n";
	print "Full file name is $data_files[$i]\n";
	print "Name from hash is" . " $rename_cnchp{$temp_name_1}" . "\n\n";
	
	if (exists $rename_cnchp{$temp_name_1}) {
		rename "$data_files[$i]", ($rename_cnchp{"$temp_name_1"} . ".CNCHP.txt");
		$temp_name_1 = "";
	}
}

close(IN_SAMPLE_ID);

####################################################################################################
####################################################################################################
### Subroutines
####################################################################################################
####################################################################################################
