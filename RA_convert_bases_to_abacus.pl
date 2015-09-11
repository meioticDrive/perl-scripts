#!/usr/bin/perl
# Convert Nimblegen bases file to ABACUS input format 
use strict 'vars';
use vars qw($dirname @files @filess $dirname $f $name @names @fields @subfields
%mean %stdev %feature %pixels %idisp $this_i $count $i $j $k $l);

$dirname = ".";

if(@ARGV < 2)
{
	print "\nUsage: ./convert_bases_to_abacus.pl basesfiles abacusfile\n\n";
	exit(1);
}


opendir(DIR,$dirname) || die "Cannot open $dirname";
@files =  grep{/$ARGV[0]/} grep{/bases/} readdir(DIR);
@filess = sort @files;
close(DIR);
$i = 0;

#print "\n List of names is @filess \n";
foreach my $f (@filess)
{
	print "Reading $f \n";
	open(FILE,"$f") || die "\n Can not open $f for reading \n";
	$_ = <FILE>;
	chomp;
	@fields = split(": ");
	@subfields = split(".tif",$fields[1]);
	$name = $subfields[0];
	<FILE>; <FILE>; <FILE>;
	$this_i = 0;
	$count = 0;
	while(<FILE>)
	{
		chomp;
		@fields = split('\t');		
		$feature{$fields[0]}{$fields[1]}++;
		$j = 8 - $feature{$fields[0]}{$fields[1]};
		$fields[2] = uc $fields[2];
		$fields[3] = uc $fields[3];
		$mean{$fields[0]}{$fields[1]}{"$j\_$fields[2]_$fields[3]"}{$name} = $fields[4]+0;
		$stdev{$fields[0]}{$fields[1]}{"$j\_$fields[2]_$fields[3]"}{$name} = $fields[5]+0;
		$pixels{$fields[0]}{$fields[1]}{"$j\_$fields[2]_$fields[3]"}{$name} = $fields[6]+0;
		if($fields[4]+0 > 2)
		{
			$this_i += ($fields[5]*$fields[5])/$fields[4];
			$count++;
		}
	}
	foreach $i (keys %feature)
	{
		foreach $j (keys %{$feature{$i}})
		{
			delete($feature{$i}{$j});
		}
		delete($feature{$i});
	}
	
	close(FILE);
	if($count > 0)
	{
		$idisp{$name} = $this_i / $count;
		print "\n Index of dispersion for $name is $idisp{$name}\n";
	}
	else
	{
		print "\n.$name. has no data \n";
		$idisp{$name} = 0;
	}
	$names[$i] = $name;
	$i++;
}

open(FILE,">$ARGV[1]") || die "\n Can not open $ARGV[1] for writing\n";
print FILE "CDF Filename\tUnknown\nDat Filenames";
foreach $f (@names)
{
	print FILE "\t$f";
}
print FILE "\nNumber of cols\t1\trows\t1\n";
print FILE "Qualifier\tExpo\tSeq\tcbase\tpbase";
foreach $f (@names)
{
	print FILE "\tmean\t$idisp{$f}\tnpix";
}
foreach $i (sort (keys %mean))
{
	foreach $j (sort {$a <=> $b} (keys %{$mean{$i}}))
	{
		foreach $k (sort {sort_features($a,$b)} (keys %{$mean{$i}{$j}}))
		{
			@fields = split("_",$k);
			if($fields[0] < 4)
			{
				$_ = $fields[1];
				if(/A/)
				{
					$fields[1] = 'T';
				}
				elsif(/G/)
				{
					$fields[1] = 'C';
				}
				elsif(/C/)
				{
					$fields[1] = 'G';
				}
				else
				{
					$fields[1] = 'A';
				}
			}
			print FILE "\n$i\t$j\tN\t$fields[1]\t$fields[2]";
			foreach $f (@names)
			{
				print FILE "\t$mean{$i}{$j}{$k}{$f}\t$stdev{$i}{$j}{$k}{$f}\t$pixels{$i}{$j}{$k}{$f}";
			}
		}
	}
} 

print FILE "\n";

sub sort_features
{
	my ($a, $b) = @_;
	my @fieldsa = split('_',$a);
	my @fieldsb = split('_',$b);
	if($fieldsa[1] eq $fieldsb[1])
	{
		if($fieldsa[0]+0 < 4)
		{
			if($fieldsa[1] eq $fieldsa[2])
			{
				return 1;
			}
			if($fieldsb[1] eq $fieldsb[2])
			{
				return -1;
			}
		}
		else
		{
			if($fieldsa[1] eq $fieldsa[2])
			{
				return -1;
			}
			if($fieldsb[1] eq $fieldsb[2])
			{
				return 1;
			}
		}
		if($fieldsa[2] lt $fieldsb[2])
		{
			return -1;
		}
		if($fieldsa[2] gt $fieldsb[2])
		{
			return 1;
		}
		return 0;
	}
	else
	{
		if($fieldsa[0] < $fieldsb[0])
		{
			return -1;
		}
		elsif($fieldsa[0] > $fieldsb[0])
		{
			return 1;
		}
		return 0;
	}

	return -1;
}
	
