#!/usr/bin/perl
# Run all chips
use strict 'vars';
use POSIX;
use vars qw($dirname $tail %matches @data @files %map_id %count %mapper_name @filess $m $name @fields @line $i $j $k $step_size $snps);

$dirname = ".";

if(@ARGV != 2)
{
	print "\n Usage: ${0} directory genome.sdx n";
	exit(1);
}

chdir("$ARGV[0]") || die "\nCan't Change Directory to $ARGV[0] \n";

opendir(DIR,".") || die "Cannot open directory";
@files =  grep{/fastq/} readdir(DIR);
close(DIR);
my $tot_files = 0;
foreach my $f (@files)
{
	@fields = split('\.',$f);
	$count{$fields[0]}++;
	$tail = "";
	for($i=1;$i<@fields;$i++)
	{
		$tail .= ".$fields[$i]";
	}
	$tot_files++;
}
@filess = sort (keys %count);
for($i=0;$i<@filess;$i++)
{
	$_ = $filess[$i];
	s/_1/_2/;
	s/_R1/_R2/;
	my $s1 = $_;
	for($j=$i+1;$j<@filess;$j++)
	{
		$_ = $filess[$j];
		s/_1_/_2_/g;
		s/_R1_/_R2_/g;
		my $s2 = $_;
		#print "\n $filess[$i] $s1 $files[$j] $s2 \n";
		if($filess[$i] eq $s2 || $filess[$j] eq $s1)
		{
			print("\n Matching $filess[$i] with $filess[$j] \n");
			$matches{$filess[$i]} = $filess[$j];
			$matches{$filess[$j]} = $filess[$i];
			$tot_files--;
		}
	}
}
my %done;
my $last_i = 0;
for($i=0;$i<@filess;$i++)
{
	if(!$done{$filess[$i]})
	{
		my @ff = split('_',$filess[$i]);
		my $nname = $ff[0];
		if(!$matches{$filess[$i]})
		{
			$done{$filess[$i]} = 1;
			if($tot_files > 1)
			{
				open(FILE,">$ARGV[0].$i.sh"); 
				print FILE "#!/bin/sh\n\n";
				print FILE "\n\n/home/dcutler/Software/bin/pemapper $nname $ARGV[1] s $filess[$i]$tail N 0.85 16 200000000 \n\n";
				close(FILE);
				system("qsub -v USER -v PATH -q pe.q -cwd -o /dev/null -j y $ARGV[0].$i.sh"); 
			}
			else
			{
				open(FILE,">$ARGV[0].sh"); 
				print FILE "#!/bin/sh\n\n";
				print FILE "\n\n/home/dcutler/Software/bin/pemapper $nname $ARGV[1] s $filess[$i]$tail N 0.85 16 200000000 \n\n";
				close(FILE);
				system("qsub -v USER -v PATH -cwd -q pe.q -o /dev/null -j y $ARGV[0].sh"); 
			}
			$last_i = $i;
		}
		else
		{
			$done{$filess[$i]} = 1;
			$done{$matches{$filess[$i]}} = 1;
			$_ = $filess[$i];
			if($tot_files > 1)
			{
				open(FILE,">$ARGV[0].$i.sh"); 
				print FILE "#!/bin/sh\n\n";
				print FILE "\n\n/home/dcutler/Software/bin/pemapper $nname $ARGV[1] p $filess[$i]$tail $matches{$filess[$i]}$tail 500 0 N 
0.85 16 200000000\n\n";
				close(FILE);
				system("qsub  -v USER -v PATH -cwd -q pe.q -o /dev/null -j y $ARGV[0].$i.sh"); 
			}
			else
			{
				open(FILE,">$ARGV[0].sh"); 
				print FILE "#!/bin/sh\n\n";
				print FILE "\n\n/home/dcutler/Software/bin/pemapper $nname $ARGV[1] p $filess[$i]$tail $matches{$filess[$i]}$tail 500 0 N 
0.85 16 200000000\n\n";
				close(FILE);
				system("qsub -v USER -v PATH -cwd -q pe.q -o /dev/null -j y $ARGV[0].sh"); 
			}
			
			$last_i = $i;
		}
	}
}