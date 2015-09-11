#!/usr/bin/perl
# Program is designed to take a list of items from a Tag file, seach a data file for
# those tags. If the tag is found, output the line to a text file.

use warnings;
use strict;
my(@data, $data, @linkage, @temp, $c, $columns, $i, $j, $linkage, @line, @geno, @picked, $r, @temp_out, $z, $snps, $hapmap, @snps, $line2, $line, @line2, $casecontrol, $line1, @line1, $a);

#Initialize Variables
$z = 0;
$i = 0;
$r = 0;
#$b = 0;
$a = 0;

open (OUTFILE, ">>Morris_out.txt");

# Tag file
print "Enter Tag file name: ";
$snps = <STDIN>;
chomp $snps;
unless   ( open (SNPS, $snps)  )  {
	print 'cannot open $snps\n';
	exit;
}	

# Data File to Match On
print "Enter Data file name: ";
$hapmap = <STDIN>;
chomp $hapmap;
unless   ( open (HAPMAP, $hapmap)  )  {
	print 'cannot open $hapmap\n';
	exit;
                                         }	
                                         
                                         
open (SNPS, $snps);
@snps = <SNPS>;
foreach $i (@snps)  {
	chomp $i;
	print "$i\n";
	open (HAPMAP, $hapmap);
   while (<HAPMAP>)    { # open 1
	chomp;
	@line = split("\t");
	
	
	#for($a=0;$a<15;$a++) {
	#print "$line[$a]\n";
	#}
	#exit;
	
	# Pick element number here
	if ($i eq $line[3])  { #open2
		print "Found a match!  $i\n";
		@temp = join ("\t", @line);
		print OUTFILE "@temp\n";
		}
	}
}