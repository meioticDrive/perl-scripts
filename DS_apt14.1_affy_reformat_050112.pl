#!/usr/bin/perl
use warnings;
use strict 'vars';
my ($j, $i, $k, $d, $dirname, @temp, @sort, $sort, @lines, @a_fields, @b_fields, @sorted_lines, $sample, $norm, $file_523, $file_635, @chr6, @chr7, @chr8, @chr9, @chr10, @chr11, @chr12, @chr13, @chr14, @chr15, @chr16, @chr17, @sorted);
my (@chr18, @chr19, @chr20, @chr21, @lines_23, @chrX, @chrY, $file_532, $ratio, $intensity);
my ($source, @pair1, @pair2, $pair1, $pair2, $file, @file, @name, $line_532, $norm1, $norm2, $norm3);

# Start program from within directory
# Call script with name of file containing files to be split
# Call script with name of output source file

$dirname = ".";

# Name of input file
$file = $ARGV[0];

# Name of output source file
$source = $ARGV[1];

open (INFILE, "$file");

@file = <INFILE>;
foreach $d (@file)  {

chomp $d;
$_ = $d;

@name = split (/.CNCHP/);
$sample = $name[0];
print "$sample\n";






#$sample = $ARGV[0];
#$norm1 = $ARGV[1];
#$norm2 = $ARGV[2];
#$norm3 = $ARGV[3];

#$file_532 = $ARGV[2];
#$file_635 = $ARGV[3];

#This version is for the HD2 array, design id

#This part splits the normalized.txt file into files with data for individual chromosomes. 
#The normalized.txt file is way too large to process otherwise.
#The individual chromosome files are then formatted for daglad.

$j = 1;
open (CHR1, ">$sample.output_chr1.txt");
open (CHR2, ">$sample.output_chr2.txt");
open (CHR3, ">$sample.output_chr3.txt");
open (CHR4, ">$sample.output_chr4.txt");
open (CHR5, ">$sample.output_chr5.txt");
open (CHR6, ">$sample.output_chr6.txt");
open (CHR7, ">$sample.output_chr7.txt");
open (CHR8, ">$sample.output_chr8.txt");
open (CHR9, ">$sample.output_chr9.txt");
open (CHR10, ">$sample.output_chr10.txt");
open (CHR11, ">$sample.output_chr11.txt");
open (CHR12, ">$sample.output_chr12.txt");
open (CHR13, ">$sample.output_chr13.txt");
open (CHR14, ">$sample.output_chr14.txt");
open (CHR15, ">$sample.output_chr15.txt");
open (CHR16, ">$sample.output_chr16.txt");
open (CHR17, ">$sample.output_chr17.txt");
open (CHR18, ">$sample.output_chr18.txt");
open (CHR19, ">$sample.output_chr19.txt");
open (CHR20, ">$sample.output_chr20.txt");
open (CHR21, ">$sample.output_chr21.txt");
open (CHR22, ">$sample.output_chr22.txt");
open (CHRX, ">$sample.output_chrX.txt");
open (CHRY, ">$sample.output_chrY.txt");

print "starting output files for chr 1 through 24\n";
open (NORM, "$d");
while (<NORM>)  {

if (/\#%/)  {
	print "junk $_\n";
	next;
			}

if (/ProbeSet/)  {
	print "first line $_\n";
	next;
			}

@temp = split('\t');
if ($temp[1] == 1)  {
print CHR1 "$_";
			}

if ($temp[1] eq "Y")  {
#s/Y/24/g;
print CHRY "$_";
			}

			
if ($temp[1] == 2)  {
print CHR2 "$_";
			}
			
if ($temp[1] == 3)  {
print CHR3 "$_";
			}
			
			
if ($temp[1] == 4)  {
print CHR4 "$_";
			}
			
if ($temp[1] == 5)  {
print CHR5 "$_";
			}
			
if ($temp[1] == 6)  {
print CHR6 "$_";
			}

#if (/chr7/)  {
if ($temp[1] == 7)  {
print CHR7 "$_";
			}
			
#if (/chr8/)  {
if ($temp[1] == 8)  {
print CHR8 "$_";
			}
#if (/chr9/)  {
if ($temp[1] == 9)  {
print CHR9 "$_";
			}
			
#if (/chr10/)  {
if ($temp[1] == 10)  {
print CHR10 "$_";
			}
			
#if (/chr11/)  {
if ($temp[1] == 11)  {
print CHR11 "$_";
			}
			
#if (/chr12/)  {
if ($temp[1] == 12)  {
print CHR12 "$_";
			}
			
if ($temp[1] == 13)  {
#$_ =~ s/chr//g;
print CHR13 "$_";
			}
if ($temp[1] == 14)  {
#$_ =~ s/chr//g;
print CHR14 "$_";
			}
if ($temp[1] == 15)  {
#$_ =~ s/chr//g;
print CHR15 "$_";
			}
if ($temp[1] == 16)  {
#$_ =~ s/chr//g;
print CHR16 "$_";
			}
if ($temp[1] == 17)  {
#$_ =~ s/chr//g;
print CHR17 "$_";
			}
if ($temp[1] == 18)  {
#$_ =~ s/chr//g;
print CHR18 "$_";
			}
if ($temp[1] == 19)  {
#$_ =~ s/chr//g;
print CHR19 "$_";
			}
if ($temp[1] == 20)  {
#$_ =~ s/chr//g;
print CHR20 "$_";
			}
if ($temp[1] == 21)  {
#$_ =~ s/chr//g;
print CHR21 "$_";
			}
if ($temp[1] == 22)  {
#$_ =~ s/chr//g;
print CHR22 "$_";
			}
if ($temp[1] eq "X")  {
#s/X/23/g;
print CHRX "$_";
			}


			
					}


close NORM;	
close CHR1;
close CHR2;
close CHR3;
close CHR4;
close CHR5;
close CHR6;
close CHR7;
close CHR8;
close CHR9;
close CHR10;
close CHR11;
close CHR12;
close CHR13;
close CHR14;
close CHR15;
close CHR16;
close CHR17;
close CHR18;
close CHR19;
close CHR20;
close CHR21;
close CHR22;
close CHRX;
close CHRY;

$j = 1;



#this part makes the GLAD input files for each chromosome

open (OUTFILE, ">$sample.chr1.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";

open (CHR1, "$sample.output_chr1.txt");
@lines = <CHR1>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 1\n";

@temp = sort {

	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
    
    $a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
	@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR1);
$j = 0;
	
##################
	

open (OUTFILE, ">$sample.chr2.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR2, "$sample.output_chr2.txt");
@lines = <CHR2>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 2\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
	@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR2);
$j = 0;


##################

					
open (OUTFILE, ">$sample.chr3.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$k = 1;

open (CHR3, "$sample.output_chr3.txt");
@lines = <CHR3>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 3\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$k = $k +1;
					}
close (OUTFILE);
close (CHR3);
$k = 0;


##################

				
open (OUTFILE, ">$sample.chr4.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR4, "$sample.output_chr4.txt");
@lines = <CHR4>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 4\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR4);
					

##################

open (OUTFILE, ">$sample.chr5.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;


open (CHR5, "$sample.output_chr5.txt");
@lines = <CHR5>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 5\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR5);


##################


open (OUTFILE, ">$sample.chr6.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR6, "$sample.output_chr6.txt");
@lines = <CHR6>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 6\n";

@temp = sort {

	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
    
    $a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
	@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR6);
	
	
##################
	
	
open (OUTFILE, ">$sample.chr7.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR7, "$sample.output_chr7.txt");
@lines = <CHR7>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 7\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
	@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR7);

##################

					
open (OUTFILE, ">$sample.chr8.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR8, "$sample.output_chr8.txt");
@lines = <CHR8>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 8\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR8);


##################


open (OUTFILE, ">$sample.chr9.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR9, "$sample.output_chr9.txt");
@lines = <CHR9>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 9\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR9);


##################


open (OUTFILE, ">$sample.chr10.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR10, "$sample.output_chr10.txt");
@lines = <CHR10>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 10\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR10);


##################

open (OUTFILE, ">$sample.chr11.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR11, "$sample.output_chr11.txt");
@lines = <CHR11>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 11\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR11);


##################


open (OUTFILE, ">$sample.chr12.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR12, "$sample.output_chr12.txt");
@lines = <CHR12>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 12\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR12);


##################


open (OUTFILE, ">$sample.chr13.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR13, "$sample.output_chr13.txt");
@lines = <CHR13>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 13\n";

@temp = sort {

	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
    
    $a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
	@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR13);


##################


open (OUTFILE, ">$sample.chr14.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR14, "$sample.output_chr14.txt");
@lines = <CHR14>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 14\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
	@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR14);


##################


open (OUTFILE, ">$sample.chr15.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR15, "$sample.output_chr15.txt");
@lines = <CHR15>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 15\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR15);


##################


open (OUTFILE, ">$sample.chr16.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR16, "$sample.output_chr16.txt");
@lines = <CHR16>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 16\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR16);


##################


open (OUTFILE, ">$sample.chr17.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR17, "$sample.output_chr17.txt");
@lines = <CHR17>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 17\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR17);


##################


open (OUTFILE, ">$sample.chr18.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR18, "$sample.output_chr18.txt");
@lines = <CHR18>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 18\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR18);


##################


open (OUTFILE, ">$sample.chr19.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR19, "$sample.output_chr19.txt");
@lines = <CHR19>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 19\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR19);


##################


open (OUTFILE, ">$sample.chr20.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR20, "$sample.output_chr20.txt");
@lines = <CHR20>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 20\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR20);

##################



open (OUTFILE, ">$sample.chr21.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR21, "$sample.output_chr21.txt");
@lines = <CHR21>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 21\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR21);


##################



open (OUTFILE, ">$sample.chr22.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHR22, "$sample.output_chr22.txt");
@lines = <CHR22>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome 22\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHR22);


##################

open (OUTFILE, ">$sample.chrX.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHRX, "$sample.output_chrX.txt");
@lines = <CHRX>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome X\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
    @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHRX);


##################



open (OUTFILE, ">$sample.chrY.txt");
print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
$j = 1;

open (CHRY, "$sample.output_chrY.txt");
@lines = <CHRY>;
@temp = map { [$_, split('\t')] } @lines;
print "sorting chromosome Y\n";

@temp = sort {
	
	@a_fields = @$a[1..$#$a];
   @b_fields = @$b[1..$#$b];
	
		
	$a_fields[1] <=> $b_fields[1]
	   ||
	$a_fields[2] <=> $b_fields[2]
	
	} @temp;
	
@sorted_lines = map {$_->[0] } @temp;

foreach $i (@sorted_lines)  {
$_ = $i;
@temp = split('\t');
print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[4]\n";
$j = $j +1;
					}
close (OUTFILE);
close (CHRY);

#open (OUTFILE, ">$sample.chrX.txt");
#print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
#$j = 1;

#open (CHRX, "$sample.output_chrX.txt");
#@lines = <CHRX>;
#@temp = map { [$_, split('\t')] } @lines;
#print "sorting chromosome X\n";

#@temp = sort {
	
#	@a_fields = @$a[1..$#$a];
#    @b_fields = @$b[1..$#$b];
	
		
#	$a_fields[1] <=> $b_fields[1]
#	   ||
#	$a_fields[2] <=> $b_fields[2]
	
#	} @temp;
	
#@sorted_lines = map {$_->[0] } @temp;

#foreach $i (@sorted_lines)  {
#$_ = $i;
#@temp = split('\t');
#print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[3]\n";
#$j = $j +1;
#					}
#close (OUTFILE);
#close (CHRX);


##################



#open (OUTFILE, ">$sample.chrY.txt");
#print OUTFILE "PosOrder\tChromosome\tClone\tPosBase\tLogRatio\n";
#$j = 1;

#open (CHRY, "$sample.output_chrY.txt");
#@lines = <CHRY>;
#@temp = map { [$_, split('\t')] } @lines;
#print "sorting chromosome Y\n";

#@temp = sort {
	
#	@a_fields = @$a[1..$#$a];
#   @b_fields = @$b[1..$#$b];
	
		
#	$a_fields[1] <=> $b_fields[1]
#	   ||
#	$a_fields[2] <=> $b_fields[2]
	
#	} @temp;
	
#@sorted_lines = map {$_->[0] } @temp;

#foreach $i (@sorted_lines)  {
#$_ = $i;
#@temp = split('\t');
#print OUTFILE "$j\t$temp[1]\t$temp[0]\t$temp[2]\t$temp[3]\n";
#$j = $j +1;
#					}
#close (OUTFILE);
#close (CHRY);


##################



#This part below makes the source files for Glen's CNV caller.

open (DAGLAD1, ">>$source.txt");
print "starting chr1 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
print DAGLAD1 "sink(file = \"./sink.$sample.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr1.txt\", nrows = 170500, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr1_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr1.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, Chromosome = 1, main = \"$sample chr1\", font.main = 4)\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr1a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 1, main = \"$sample chr1\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr1.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n";


#open (DAGLAD1, ">source.$sample.chr2.txt");
print "starting chr2 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr2.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr2.txt\", nrows = 185100, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr2_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr2.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 2, main = \"$sample chr2\", font.main = 4)\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr2a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 2, main = \"$sample chr2\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr2.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";



#open (DAGLAD1, ">source.$sample.chr3.txt");
print "starting chr3 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr3.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr3.txt\", nrows = 150800, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr3_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr3.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 3, main = \"$sample chr3\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr3a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 3, main = \"$sample chr3\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr3.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr4.txt");
print "starting chr4 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr4.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr4.txt\", nrows = 145000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr4_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr4.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 4, main = \"$sample chr4\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr4a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 4, main = \"$sample chr4\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr4.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr5.txt");
print "starting chr5 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr5.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr5.txt\", nrows = 115000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr5_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr5.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 5, main = \"$sample chr5\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr5a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 5, main = \"$sample chr5\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr5.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#close (DAGLAD1);
#close (DAGLAD2);
#close (DAGLAD3);
#close (DAGLAD4);
#close (DAGLAD5);

$j = 1;

#open (DAGLAD1, ">source.$sample.chr6.txt");
print "starting chr6 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr6.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr6.txt\", nrows = 120500, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr6_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr6.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 6, main = \"$sample chr6\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr6a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 6, main = \"$sample chr6\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr6.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";



#open (DAGLAD1, ">source.$sample.chr7.txt");
print "starting chr7 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr7.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr7.txt\", nrows = 120100, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr7_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr7.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 7, main = \"$sample chr7\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr7a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 7, main = \"$sample chr7\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr7.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";



#open (DAGLAD1, ">source.$sample.chr8.txt");
print "starting chr8 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr8.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr8.txt\", nrows = 120800, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr8_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr8.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 8, main = \"$sample chr8\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr8a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 8, main = \"$sample chr8\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr8.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr9.txt");
print "starting chr9 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr9.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr9.txt\", nrows = 145000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr9_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr9.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 9, main = \"$sample chr9\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr9a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 9, main = \"$sample chr9\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr9.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr10.txt");
print "starting chr10 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr10.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr10.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr10_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr10.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 10, main = \"$sample chr10\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr10a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 10, main = \"$sample chr10\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr10.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr11.txt");
print "starting chr11 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr11.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr11.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr11_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr11.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 11, main = \"$sample chr11\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr11a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 11, main = \"$sample chr11\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr11.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr12.txt");
print "starting chr12 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr12.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr12.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr12_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr12.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 12, main = \"$sample chr12\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr12a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 12, main = \"$sample chr12\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr12.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";




#close (DAGLAD6);
#close (DAGLAD7);
#close (DAGLAD8);
#close (DAGLAD9);
#close (DAGLAD10);
#close (DAGLAD11);
#close (DAGLAD12);


#open (DAGLAD1, ">source.$sample.chr13.txt");
print "starting chr13 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr13.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr13.txt\", nrows = 120500, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr13_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr13.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 13, main = \"$sample chr13\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr13a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 13, main = \"$sample chr13\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr13.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";



#open (DAGLAD1, ">source.$sample.chr14.txt");
print "starting chr14 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr14.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr14.txt\", nrows = 120100, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr14_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr14.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 14, main = \"$sample chr14\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr14a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 14, main = \"$sample chr14\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr14.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";



#open (DAGLAD15, ">source.$sample.chr15.txt");
print "starting chr15 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr15.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr15.txt\", nrows = 120800, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr15_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr15.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 15, main = \"$sample chr15\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr15a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 15, main = \"$sample chr15\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr15.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr16.txt");
print "starting chr16 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr16.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr16.txt\", nrows = 145000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr16_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr16.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 16, main = \"$sample chr16\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr16a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 16, main = \"$sample chr16\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr16.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr17.txt");
print "starting chr17 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr17.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr17.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr17_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr17.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 17, main = \"$sample chr17\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr17a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 17, main = \"$sample chr17\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr17.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr18.txt");
print "starting chr18 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr18.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr18.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr18_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr18.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 18, main = \"$sample chr18\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr18a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 18, main = \"$sample chr18\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr18.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD19, ">source.$sample.chr19.txt");
print "starting chr19 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr19.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr19.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr19_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr19.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 19, main = \"$sample chr19\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr19a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 19, main = \"$sample chr19\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr19.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD1, ">source.$sample.chr20.txt");
print "starting chr20 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr20.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr20.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr20_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr20.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 20, main = \"$sample chr20\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr20a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 20, main = \"$sample chr20\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr20.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD21, ">source.$sample.chr21.txt");
print "starting chr21 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr21.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr21.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr21_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr21.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 21, main = \"$sample chr21\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr21a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 21, main = \"$sample chr21\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr21.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";


#open (DAGLAD22, ">source.$sample.chr22.txt");
print "starting chr22 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr22.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr22.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr22_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr22.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 22, main = \"$sample chr22\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr22a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 22, main = \"$sample chr22\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr22.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";



#open (DAGLADX, ">source.$sample.chrX.txt");
print "starting chrX GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.c.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chrX.txt\", nrows = 200000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = TRUE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chrX_breakpoint_.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chrX.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 23, main = \"$sample chrX\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chrXa.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 23, main = \"$sample chrX\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chrX.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";



#open (DAGLADY, ">source.$sample.chrY.txt");
print "starting chrY GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.glad.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chrY.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = TRUE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 5, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chrY_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chrY.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 24, main = \"$sample chrY\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chrYa.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE,  Chromosome = 24, main = \"$sample chrY\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chrY.RData\")\n";
print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";




close (DAGLAD1);

print "all finished.  You should buy Jen A LOT of chocolate.\n";



}



