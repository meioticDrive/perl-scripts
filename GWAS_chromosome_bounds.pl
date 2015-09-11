#!/usr/bin/perl -w
##############################################################################
### Name: GWAS_chromosome_bounds.pl
### Version: 1.0
### Date: 04/29/2013
### Author: Michael E. Zwick
##############################################################################
### Program designed to extract number of samples per chromosome
### from a GWAS dataset
### This version assumes that Chrom is listed in first column (check $data_line[0])
### Need to add a 23 to the processed file at the end (for chrom 23)
#############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################
my(@data_files, @header, @data_line, @chromosome_count, $temp, $file, $file_name, $version, $file_number, $fixed_name);
my($data_file_number, $sample_IDs_number, $total_files, $m, $n, $total_source, $test, $data, $chromosome, $count);
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
$version = "1.0";

# Set file number for output here
$data_file_number = 0;
$chromosome = 1;
$count = 0;
$temp = 0;


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
@data_files = glob("*Snps.txt*");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number *Snps.txt* files.\n Check directory. Exiting program";
}

# Open input file to read pvalues
open (OUTFILE_0, ">", "Chromosome_bounds.txt");

# Need to count number of SNPs for each Chromosome 1 - 22
for ($m = $chromosome; $m < 23; $m++)
{
    print "The variable m value is $m\n";
    open (IN_DATA_IN, "<", "$data_files[0]") or die "Cannot open IN_SAMPLE_ID filehandle to read file";
    while(<IN_DATA_IN>)
    {
        chomp $_;
        print "The line is $_\n";
        
        # Skip header line
        if ($_ =~ /^SNP/)
        {
            next;
        }
        if ($_ =~ /^Chromosome/)
        {
            next;
        }
         if ($_ =~ /^Chrom/)
        {
            next;
        }
        if ($_ =~ /^Chr/)
        {
            next;
        }
        
        @data_line = split (/\t/, $_);
        #print "variable m equals $m\n";
        
        # Chromosome data in column 1
	    if ($data_line[0] == $m)
	    {
	        #print "Value of temp before increment is: $temp\t";
	        $temp++;
	    } 

        if ($data_line[0] > $m)
            {
	        print "Value of temp before push is: $temp\n";
	        push(@chromosome_count, $temp);
	        print "Value of temp is: $temp\n";
	        $temp = 0;
	        close (IN_DATA_IN);
	    }
	    
	}
}

for ($n = 0; $n < 22; $n++)
{
    print OUTFILE_0 "$chromosome_count[$n]\n";
}

print "Completed GWAS_chromosome_bounds.pl script version $version\n";
