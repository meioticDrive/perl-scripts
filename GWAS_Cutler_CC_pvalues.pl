#!/usr/bin/perl -w
##############################################################################
### Name: GWAS_Cutler_TDT_pvalues.pl
### Version: 1.0
### Date: 04/29/2013
### Author: Michael E. Zwick
##############################################################################
### Program designed to extract TDT p-values from Cutler GWAS analysis
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
@data_files = glob("*snps_pvalue.txt*");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *snps_pvalue.txt* files.\n Check directory. Exiting program";
}

# Open input file to read pvalues
open (IN_DATA_IN, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
open (OUTFILE_0, ">", "Cutler_CC_pvalue.txt");

while(<IN_DATA_IN>) {
	chomp $_;

    #Skip unwanted header lines - start with Total
    if($_ =~ /^Total/) {
        next;
	}
	#Skip unwanted header lines - start with \t
    if($_ =~ /^\t/) {
        next;
	}
	
	#Get header lines
    if($_ =~ /^SNP/) {
        @header = split (/\t/, $_);
        print OUTFILE_0 "$header[0]\t$header[1]\t$header[2]\t$header[5]\n";
        next;
	}
	
	# Get data from lines
	@data_line = split (/\t/, $_);
	print OUTFILE_0 "$data_line[0]\t$data_line[1]\t$data_line[2]\t$data_line[5]\n";
	
}
print "Completed GWAS_Cutler_TDT_pvalues.pl script version $version\n";
