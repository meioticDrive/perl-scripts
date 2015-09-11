#!/usr/bin/perl -w
# Version 1.1
# Originally written by Jennifer Mulle
# Updated by MEZ on 14 June 2011
####################################################################################################
# Version 1.1
# 1. Updated to glob necessary files from directory
#
# Usage;
# 1. Launch program from within directory containing .CNCHP.txt files
#
####################################################################################################
use warnings;
use strict 'vars';
use Cwd;

my ($dirname, @data_files, $data_file_number);
my ($j, $i, $k, $f, @temp, @sort, $sort, @lines, @a_fields, @b_fields, @sorted_lines, $sample, $norm, $file_523, $file_635, @chr6, @chr7, @chr8, @chr9, @chr10, @chr11, @chr12, @chr13, @chr14, @chr15, @chr16, @chr17, @sorted);
my (@chr18, @chr19, @chr20, @chr21, @lines_23, @chrX, @chrY, $file_532, $ratio, $intensity);
my ($file, @name, @file, @pair1, @pair2, $pair1, $pair2, @line_635, @line_532, $line_635, $line_532, $norm1, $norm2, $source);

# Define default source file name here
$source = "GADA.source.txt";

####################################################################################################
# Main Program Code
####################################################################################################

# Get current working directory
# Script should be launched from within directory containing files
####################################################################################################
$dirname = getcwd();

# Obtain names of all files in a directory
# Update glob below depending upon specific application
####################################################################################################
@data_files = glob("*.CNCHP.txt");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
  die "Detected $data_file_number .CNCHP.txt files.\n Check directory. Exiting program";
}

open (SOURCE, ">$source");
print SOURCE "library(gada)\n";

foreach $i (@data_files)
{
	chomp $i;
	$_ = $i;

	@name = split (/\./);
	$sample = $name[0];
	print "$sample\n";

	print SOURCE "dataAffy <- setupGADAaffy(file=\"$i\", NumCols=8, log2ratioCol=5)\n";
	print SOURCE "step1 <- SBL(dataAffy, estim.sigma2=TRUE, aAlpha = 0.5)\n";
	print SOURCE "step2 <- BackwardElimination(step1, T=5, MinSegLen = 10)\n";
	print SOURCE "write.table(summary(step2), file = \"$sample.txt\", quote = FALSE, sep = \'\\t\', row.names = FALSE)\n";
	print SOURCE "rm(list = ls())\n";
}