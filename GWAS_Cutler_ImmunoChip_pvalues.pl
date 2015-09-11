#!/usr/bin/perl -w
##############################################################################
### Name: GWAS_Cutler_ImmunoChip_pvalues.pl
### Version: 1.0
### Date: 05/29/2013
### Author: Michael E. Zwick
##############################################################################
### Program designed to extract p-values from Cutler GWAS analysis for
### Immunochip data analysis (IBD, JIA)
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################
my(@data_files, @header, @name, @name_second, @sample_IDs, @data_line);
my($file, $file_name, $count, $version, $fixed_name);
my($data_file_number, $sample_IDs_number, $total_files, $m, $n, $total_source);
my($test, $data, $dup_file_number, $dup);
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
$version = "1.0";

# Set file number for output here
$data_file_number = 0;
$n = 0;
$m = 0;
$test = 0;

##############################################################################
### Program Overview
### Change to user supplied directory
### Open filehandle for input
### Open filehandle for output
##############################################################################
# Change to Alignment directory, in user provided directory
chdir "$ARGV[0]"
	or die "Cannot change to directory $ARGV[0]\n";

# Glob all files with names that include a "*snps_pvalue.txt" character
@data_files = glob("*snp.txt*");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *snp.txt files.\n Check directory. Exiting program";
}

# Open input file to read pvalues
open (IN_DATA_IN, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
open (OUTFILE_0, ">", "$data_files[0]" . ".pvalues.txt");

while(<IN_DATA_IN>) {
	chomp $_;

	##############################################################################
	#Lines to skip
	##############################################################################
	# Skip lines that start with Total
	if($_ =~ /^Total/)
	{
	next;
	}
	
	# Skip lines that start with \t
	if($_ =~ /^\t/)
	{
	next;
	}
	
	# Skip lines that start with X
	# Skipping X chromosome pvalues
	if($_ =~ /X/)
	{
	next;
	}
	##############################################################################
	#Retain data from these lines
	##############################################################################
	#Retain header line for output file
	if($_ =~ /^Chromosome/)
	{
	@header = split (/\t/, $_);
	print OUTFILE_0 "$header[0]\t$header[1]\t$header[2]\t$header[18]\n";
	next;
	}
	
	# Get data from lines
	# Output specific data lines to include: chromosome, position, SNP_name, pvalue
	@data_line = split (/\t/, $_);
	print OUTFILE_0 "$data_line[0]\t$data_line[1]\t$data_line[2]\t$data_line[18]\n";
	
}
	print OUTFILE_0 "23\tPosition\tSNP_NAME\tCase_Control_Pvalue\n";
print "Completed GWAS_Cutler_IBD_pvalues.pl script version $version\n";
