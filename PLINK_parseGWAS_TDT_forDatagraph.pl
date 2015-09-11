#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 05/13/2014
################################################################################
# PLINK_parseGWAS-TDT_forDatagraph.pl
# Program designed to generate and format PLINK gwas-tdt output data from PLINK # for easy entry into DataGraph
# 1. Parse SNP IDs and p-values from plink gwas-tdt file
# 2. Determines start/stop bounds for each chromosomes
#
# Future Updates
# 1. Capture file name from test before *.gwas-tdt file
# 2. Make directory named *file name*_Manhattan_Plot
# 3. Move all output files into the above directory
################################################################################
use strict;
use Cwd;

################################################################################
# Local variable definitions
################################################################################

# Define local variables
my(@plink_file, $plink_file_number, @temp_line, $count, $logPscore, $chr, @startbound, @stopbound, $chrcount, $temp_mean, $i, $n);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@plink_file = ();
$plink_file_number = 0;
@temp_line = ();
$count = 1;
$logPscore = 0;
$chr = 1;
$chrcount = 0;
$temp_mean = 0;

################################################################################
# Main Program
################################################################################

# Remove old files
unlink("gwas-tdt.parsed.txt");
unlink("count.parsed.txt");
unlink("countChr.parsed.txt");
unlink("finalbounds.parsed.txt");
unlink("log.gwas-tdt.parsed.txt");
unlink("logpvalue.parsed.txt");
unlink("midbounds.parsed.txt");
unlink("pvalue.parsed.txt");
unlink("startbound.parsed.txt");
unlink("stopbound.parsed.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.gwas-tdt.parsed.txt")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of plink files
@plink_file = glob("*.gwas-tdt.txt");
$plink_file_number = ($#plink_file + 1);
if ($plink_file_number == 0) {
	die "$plink_file_number plink files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $plink_file_number *.gwas-tdt.txt file\n";
print OUT_LOG "Detected $plink_file_number *.gwas-tdt file\n";

# Open output file for complete gwas-tdt data
open (OUT_ANNOT, ">>", "gwas-tdt.parsed.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Open output file for SNP count
open (OUT_COUNT, ">>", "count.parsed.txt")
	or die "Cannot open OUT_COUNT filehandle to parsed output file info";

# Open output file for SNP count and Chromosome
open (OUT_COUNTCHR, ">>", "countChr.parsed.txt")
	or die "Cannot open OUT_COUNTCHR filehandle to parsed output file info";

# Open output file for SNP p-value
open (OUT_PVALUE, ">>", "pvalue.parsed.txt")
	or die "Cannot open OUT_PVALUE filehandle to parsed output file info";

# Open output file for SNP log -P-value
open (OUT_LOGPVALUE, ">>", "logpvalue.parsed.txt")
	or die "Cannot open OUT_LOGPVALUE filehandle to parsed output file info";

# Open output file for start bounds
open (OUT_STARTBOUND, ">>", "startbound.parsed.txt")
	or die "Cannot open OUT_STARTBOUND filehandle to parsed output file info";

# Open output file for finish bounds
open (OUT_STOPBOUND, ">>", "stopbound.parsed.txt")
	or die "Cannot open OUT_STOPBOUND filehandle to parsed output file info";

# Open output file for final bounds
open (OUT_FINALBOUNDS, ">>", "finalbounds.parsed.txt")
	or die "Cannot open OUT_FINALBOUNDS filehandle to parsed output file info";

# Open output file for final bounds
open (OUT_MIDBOUNDS, ">>", "midbounds.parsed.txt")
	or die "Cannot open OUT_FINALBOUNDS filehandle to parsed output file info";

# Output header
print OUT_ANNOT "Count\tCHR\tSNP\tBP\tA1\tTEST\tNMISS\tOR\tSE\tL95\tU95\tSTAT\tP\t-10logP\n";

# Process plink *.gwas-tdt file
foreach my $files (@plink_file) {

    #Open $files to be read
    open (IN_ANNOT, "<", "$files")
        or die "Cannot open IN_ANNOT filehandle to read file";

    while (<IN_ANNOT>) {
        chomp $_;
        @temp_line = split(/\s+/, $_);
        if ($temp_line[0] eq "CHR") { next;} # Skip header line
        $logPscore = (-1 * log10($temp_line[8])); # Calculate -1Log10P
        print OUT_ANNOT "$count\t$temp_line[0]\t$temp_line[1]\t$temp_line[2]\t$temp_line[3]\t$temp_line[4]\t$temp_line[5]\t$temp_line[6]\t$temp_line[7]\t$temp_line[8]\t$logPscore\n";
        print OUT_COUNT "$count\n";
        print OUT_COUNTCHR "$count\t$temp_line[0]\n";
        print OUT_PVALUE "$temp_line[8]\n";
        print OUT_LOGPVALUE "$logPscore\n";
        $count++;
    }
        @temp_line = ();
}
close (IN_ANNOT);
close (OUT_ANNOT);
close (OUT_COUNT);
close (OUT_COUNTCHR);
close (OUT_PVALUE);
close (OUT_LOGPVALUE);

# Get the chromosome bounds for count
my @starts;
my @stops;
for(my $i=1;$i<24;$i++)
{
    $starts[$i] = 1e50;
    $stops[$i] = -1;
}

open (IN_COUNTCHR, "<", "countChr.parsed.txt")
        or die "Cannot open IN_COUNTCHR filehandle to read file";
    while (<IN_COUNTCHR>) {
        chomp $_;
        @temp_line = split(/\t/, $_);
        #print "Raw line: $_\n";
        #$print "Read line: $temp_line[0]\t$temp_line[1]\n";
        if($temp_line[0] < $starts[$temp_line[1]])
        {
                $starts[$temp_line[1]] = $temp_line[0];
        }
        if($temp_line[0] > $stops[$temp_line[1]])
        {
            $stops[$temp_line[1]] = $temp_line[0];
        }
        
    }
close (IN_COUNTCHR);

    for($i=1;$i<24;$i++)
    {
        print "$i\t$starts[$i]\t$stops[$i]\n";
        print OUT_STARTBOUND "$starts[$i]\n";
        print OUT_STOPBOUND "$stops[$i]\n";
        print OUT_FINALBOUNDS "$starts[$i],$stops[$i]\n";
        $temp_mean = (($starts[$i] + $stops[$i]) / 2);
        $n = sprintf("%.0f", $temp_mean);
        print OUT_MIDBOUNDS "$n\n";
        $temp_mean = 0;
        $n = 0;
    }

close (OUT_STARTBOUND);
close (OUT_STOPBOUND);
close (OUT_FINALBOUNDS);
close (OUT_MIDBOUNDS);

print "Completed Plink_parseAssocation script\n";
print OUT_LOG "Completed Plink_parseAssocation script\n";
close (OUT_LOG);



################################################################################
### Subroutines ###
################################################################################
sub log10 {
    my $n = shift;
    return log($n)/log(10);
    }

