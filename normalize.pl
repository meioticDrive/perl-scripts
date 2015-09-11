#!/opt/local/bin/perl5.10.0
##!/usr/bin/perl
# Run all chips
use strict 'vars';
use vars qw(@fields @start @data @var @mean @mean_index @smean_index @var_index @svar_index @sample_mean @vd $np $gmean $step $i $j $k $m $temp $no_samples);


open(FILE,"$ARGV[0]") || die "Can't open $ARGV[0] \n";
open(oFILE,">$ARGV[0].norm") || die "Can't open $ARGV[0].norm for writing \n";
$_ = <FILE>;
print oFILE;
$_ = <FILE>;
print oFILE;
$_ = <FILE>;
print oFILE;
$_ = <FILE>;
print oFILE;
$i = 0;
while(<FILE>)
{
	chomp;
	@fields = split('\t');
	for($j=0;$j<5;$j++)
	{
		$start[$i][$j] = $fields[$j];	
	}
	$k = 0;
	$var[$i] = $mean[$i] = 0;
	$np = $fields[7];
	for($j=5;$j<@fields;$j+=3)
	{
		$data[$i][$k] = $fields[$j]+0;
		$vd[$i][$k] = $fields[$j+1]+0;
		$mean[$i] += $data[$i][$k];
		$var[$i] += $data[$i][$k]*$data[$i][$k];
		$mean_index[$i] = $i;
		$k++;
	}
	$mean[$i] /= $k;
	$var[$i] /= $k;
	$var[$i] -= $mean[$i]*$mean[$i];
	$i++;
}

$no_samples = $k;

@smean_index = sort {$mean[$a] <=> $mean[$b]} @mean_index;
$step = 0.05*@smean_index;
for($i=0;$i<@smean_index;$i+=$step)
  {
    for($j=$i;$j<$i+$step;$j++)
      {
	$var_index[$j-$i] = $smean_index[$j];
      }
    @svar_index = sort {$var[$a] <=> $var[$b]} @var_index;
    for($j=0;$j<$no_samples;$j++)
      {
	$sample_mean[$j] = 0;
      }

    for($k=0;$k<$step*0.25;$k++)
      {
	for($j=0;$j<$no_samples;$j++)
	  {
	    $sample_mean[$j] += $data[$svar_index[$k]][$j];
	  }
      }

    $gmean = 0;

    for($j=0;$j<$no_samples;$j++)
      {
	$gmean += $sample_mean[$j];
      }
    print"\n$i";
    for($j=0;$j<$no_samples;$j++)
      {
	$temp = $gmean / ($sample_mean[$j]*$no_samples);
	printf("\t%.4g",$temp);
	for($k=$i;$k<$i+$step;$k++)
	  {
	    $data[$smean_index[$k]][$j] *= $temp;
	    $vd[$smean_index[$k]][$j] *= $temp;
	  }
      }
    
  }


for($j=0;$j<$i;$j++)
{
	for($m=0;$m<4;$m++)
	{
		print oFILE "$start[$j][$m]\t";
	}
	print oFILE "$start[$j][$m]";
	for($m=0;$m<$no_samples;$m++)
	{
		$temp = int($data[$j][$m]);
		print oFILE "\t$temp";
		$temp = int($vd[$j][$m]);
		print oFILE "\t$temp\t$np";
		
	}
	print oFILE "\n";
}
