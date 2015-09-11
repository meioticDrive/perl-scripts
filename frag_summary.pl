#!/usr/bin/perl
# Run all chips
use strict 'vars';
use vars qw(@fields @sample_names %conf %non_conf @data %mean %feature_count $i $j $k $m $temp $no_samples);


open(FILE,"$ARGV[0]") || die "Can't open $ARGV[0] \n";
open(oFILE,">$ARGV[0].report") || die "Can't open $ARGV[0].report for writing \n";
$_ = <FILE>;
$_ = <FILE>;
chomp;
@sample_names = split('\t');
$_ = <FILE>;
$_ = <FILE>;
$j = 0;
while(<FILE>)
{
	chomp;
	@fields = split('\t');
	$k = 1;
	$feature_count{$fields[0]}++;
	for($i=5;$i<@fields;$i+=3,$k++)
	{
		$mean{$fields[0]}[$k]+=$fields[$i];
		$data[$k][$j] = $fields[$i];
	}
	$j++;
	if($j == 8)
	{
		for($i=1;$i<$k;$i++)
	        {
			if( $data[$i][3] >= $data[$i][2] && $data[$i][3] >= $data[$i][1] && $data[$i][3] >= $data[$i][0])
			{
				$conf{$fields[0]}[$i]++;
			}
			else
			{
				$non_conf{$fields[0]}[$i]++;
			}
			if( $data[$i][4] >= $data[$i][5] && $data[$i][4] >= $data[$i][6] && $data[$i][4] >= $data[$i][7])
			{
				$conf{$fields[0]}[$i]++;
			}
			else
			{
				$non_conf{$fields[0]}[$i]++;
			}
		}
		$j = 0;
	}
}
print oFILE "Conformance\n";
for($i=1;$i<@sample_names;$i++)
{
	print oFILE "\t$sample_names[$i]";
}
foreach $i (sort (keys %feature_count) )
{
	print oFILE "\n$i";
	for($j=1;$j<@sample_names;$j++)
	{
		#print "\n i=$i j=$j conf=.$conf{$i}[$j]. nonconf=.$non_conf{$i}[$j].\n"; 
		if($conf{$i}[$j]+$non_conf{$i}[$j] > 0)
		{
			$k = $conf{$i}[$j] / ($conf{$i}[$j] + $non_conf{$i}[$j]);
		}
		else
		{
			$k = "";
		}
		print oFILE "\t$k";
	}
}
print oFILE "\n\nMean Intensity\n";
for($i=1;$i<@sample_names;$i++)
{
	print oFILE "\t$sample_names[$i]";
}
foreach $i (sort (keys %feature_count) )
{
	print oFILE "\n$i";
	for($j=1;$j<@sample_names;$j++)
	{
		$k = $mean{$i}[$j] / $feature_count{$i};
		print oFILE "\t$k";
	}
}
