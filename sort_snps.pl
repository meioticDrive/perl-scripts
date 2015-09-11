#!/usr/bin/perl
# Run all chips
use strict 'vars';
use vars qw($dirname $f $i %col_name @fields);


$dirname = ".";
$f = @ARGV[0];

open(FILE,"$f") || die "Can't open $f\n";
open(oFILE,">$f.sorted.txt") || die "Can't open $f.sorted.txt for writing\n";

$_ = <FILE>;
chomp;
@fields = split('\t');

for($i=6;$i<@fields;$i++)
{
	$col_name{@fields[$i]} = $i;
}

print oFILE "@fields[0]\t@fields[1]\t@fields[2]\t@fields[3]\t@fields[4]\t@fields[5]";

foreach $i (sort {$a <=> $b} (keys %col_name) )
{
	print oFILE "\t$i";
}

while(<FILE>)
{
	chomp;
	@fields = split('\t');
	print oFILE "\n@fields[0]\t@fields[1]\t@fields[2]\t@fields[3]\t@fields[4]\t@fields[5]";
	
	foreach $i (sort {$a <=> $b} (keys %col_name) )
	{
		print oFILE "\t@fields[$col_name{$i}]";
	}
}
