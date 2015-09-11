#!/usr/bin/perl -w

use strict 'vars';
my ($j, $i, $k, $f, $dirname, @temp, @sort, $sort, @lines, @a_fields, @b_fields, @sorted_lines, $sample, $norm, $file_523, $file_635, @chr6, @chr7, @chr8, @chr9, @chr10, @chr11, @chr12, @chr13, @chr14, @chr15, @chr16, @chr17, @sorted);
my (@chr18, @chr19, @chr20, @chr21, @lines_23, @chrX, @chrY, $file_532, $ratio, $intensity);
my ($file, @name, @file, @pair1, @pair2, $pair1, $pair2, @line_635, @line_532, $line_635, $line_532, $norm1, $norm2, $source);

$dirname = ".";
$file = $ARGV[0];
$source = $ARGV[1];

open (INFILE, "$file");
open (SOURCE, ">$source");

print SOURCE "library(gada)\n";

@file = <INFILE>;
foreach $i (@file)  {

chomp $i;
$_ = $i;


#@name = split (/_/);
#@tag = join("\.", @name[0..2]);
#$sample = join("\_", @name[0..1]);
#print "$sample\n";

@name = split (/\./);
$sample = $name[0];
print "$sample\n";


print SOURCE "dataAffy <- setupGADAaffy(file=\"$i\", NumCols=8, log2ratioCol=5)\n";

print SOURCE "step1 <- SBL(dataAffy, estim.sigma2=TRUE, aAlpha = 0.5)\n";

print SOURCE "step2 <- BackwardElimination(step1, T=5, MinSegLen = 10)\n";

print SOURCE "write.table(summary(step2), file = \"$sample.txt\", quote = FALSE, sep = \'\\t\', row.names = FALSE)\n";

print SOURCE "rm(list = ls())\n";

}