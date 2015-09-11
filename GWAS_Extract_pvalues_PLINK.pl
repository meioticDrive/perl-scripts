#!/usr/bin/perl -w
##############################################################################
### Name: GWAS_Extract_pvalues.pl
### Version: 1.0
### Date: 09/15/2013
### Author: Michael E. Zwick
##############################################################################
### Program designed to extract GWAS p-values (ADD) from PLINK GWAS analysis
###
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################
my(@data_files, @header, @name, @name_second, @sample_IDs, @data_line, $file, $file_name, $count, $version, $file_number, $fixed_name);
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
@data_line = ();
@header = ();

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
@data_files = glob("*.assoc.logistic");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *.logistic_ci_3 files.\n Check directory. Exiting program";
}

# Open input file to read pvalues
open (IN_DATA_IN, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";

open (OUTFILE_0, ">", "PLINK_pvalue.txt");
open (OUTFILE_1, ">", "ADD_line.txt");

while(<IN_DATA_IN>) {
	chomp $_;
	#Get header lines
    if($_ =~ /^ CHR/) {
    	print "Getting header line. Rest of file to follow.\n";
        @header = split (/\s+/, $_);
        print OUTFILE_0 "$header[1]\t$header[2]\t$header[3]\t$header[12]\n";
        @header = ();
        next;
		}
	# Split line and check to see if it is ADD line
	# If ADD, then output SNP Pvalue information to OUTFILE_0
	# IF ADD, then output entire line to OUTFILE_1
	# Get data from lines
	@data_line = split (/\s+/, $_);
	
	if("$data_line[5]" eq 'ADD') {
        print OUTFILE_1 "$_\n";
		print OUTFILE_0 "$data_line[1]\t$data_line[2]\t$data_line[3]\t$data_line[12]\n";
		@data_line = ();
	}
}
print "Completed GWAS_Extract_pvalues.pl script version $version\n";
