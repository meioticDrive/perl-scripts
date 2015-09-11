#!/usr/bin/perl
#
use strict 'vars';
use vars qw($last @subfields $i $j @fields %good_base %avg_depth);

if(@ARGV != 2)
{
	die "\n Usage: ${0} regions_file pileup_file \n";
}
open (FILE,"$ARGV[0]") || die "\n Can not open $ARGV[0] which should contain the regions\n"; 

while(<FILE>)
{
  print "entered first while loop\n";
	@fields = split('\s');
	print "@fields\n";
	for($i = $fields[1];$i <=$fields[2];$i++)
	{
		$good_base{$fields[0]}{$i} = 1;
		print "\n$fields[0] $i";
	}
}
close(FILE);



open (FILE,"$ARGV[1]") || die "\n Can not open $ARGV[1] which should contain the combined pileup\n"; 
<FILE>;
while(<FILE>)
{
	@fields = split('\t');
	@subfields = split('[:_\-]',$fields[0]);
	my $pos = $subfields[1] + $fields[1] - 1;
	#print "\n $subfields[0] $pos";
	if($good_base{$subfields[0]}{$pos})
	{
		$j = @fields + 0;
		for($i = 3; $i < $j ; $i++)
		{
			$avg_depth{$subfields[0]}{$pos} += $fields[$i];
		} 
		$avg_depth{$subfields[0]}{$pos} /= ($j - 3)/6;
	}
}
print "Chromosome\tPos\tMean_Depth\n";
foreach $i (sort (keys %avg_depth))
{
	foreach $j (sort {$a <=> $b} (keys %{$avg_depth{$i}}))
	{
		print "$i\t$j\t$avg_depth{$i}{$j}\n";
	}
}

