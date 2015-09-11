#!/usr/bin/perl
#
# Name: RA_repl_discrep_count
# Version: 1.0
# Date: 09/05/2006
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to extract the number of dicrepancies from the .compare.txt file # located within each Folder (Replicat experiment on raw Basecaller data - i.e. data before 
# application of final rules. Copy the name of the folder (a series of parameters) and output those # also.
# Future Changes
# 1. Add an output log
# 2. Program exit is not graceful occasionally (errors in identifying folders?). Make this regular expression more # robust (vicinity of line 61 is the source of the problem)
#--------------------------------------------------------------------------------------------

use warnings;
use strict;
use Cwd;

my ($LQvsCDF, $outputFasta, $haploid, $primersUsed, $numSegs, $offset, $maxSites, $rewriteFasta, $dirname, $nInvalidateBase, $nInvalidateFrag, $winSize, $failThresh, @primer_file, $primer_file_nmbr, @genpos_file, $genpos_file_nmbr, @files, @filess, @param_dirs, @param_dirss, @compare_files, @fasta_filess, $z, $zz, $nofiles, $test, $dir, $dir_final, $param_dir_nmbr, @folder_name, $folder_out);

# Data Type Parameters: These parameters are typically fixed for a given dataset.
# These parameters are passed to subroutines below
#--------------------------------------------------------------------------
$LQvsCDF = 2;
$outputFasta = 'y';
$haploid = 'y';
$primersUsed = 50;
$numSegs = 100;
# Set to 0 is you map sequences on chip. Set to 12 if you map sequences submitted for chip design.
$offset = 0;
$maxSites = 350000;
$rewriteFasta = 'y';
$dirname = ".";
#RA_Basecalled Parameters - for this script select values that do not eliminate any bases
$nInvalidateBase = 1.1;
$nInvalidateFrag = 1.1;
$winSize = 20;
$failThresh = 1.1;

# Obtain directory name entered by user, contains directories of param_folders for subsequent 
# analysis. Standard directory location used in RATools for other scripts
#---------------------------------------------------------------------------------------------------
opendir(DIR,$dirname) || die "Cannot open $dirname";
@files = grep {/$ARGV[0]/} readdir(DIR);
@filess = sort @files;
close(DIR);

foreach $z (@filess) {
	chdir $z || die "Cannot change to directory $z";

# Open for output of log files
open(OUT_LOG, ">", "RA_repl_discrep_count.log.out")
	or die "Cannot open OUT_LOG for data log output";
print OUT_LOG "Working directory is: @files\n"; 
print "Working directory is: @files\n"; 

# Open for output of data
open(OUT_DISCREP, ">", "RA_repl_discrepancies.out")
	or die "Cannot open OUT_DISCREP for outputting discrepancy number";

	# Get list of all parameter named folders holding fasta files to be analyzed
	# Only selects directories starting with a number
	opendir(DIR,$dirname) || die "Cannot open $dirname";
	@param_dirs = grep {/^\d\d/} readdir(DIR);
	@param_dirss = sort @param_dirs;
	$param_dir_nmbr = ($#param_dirs + 1);
	print "The number of folders is $param_dir_nmbr\n";
	print OUT_LOG "The number of folders is $param_dir_nmbr\n";
	close(DIR);
	
	print OUT_LOG "The folders are: @param_dirss\n\n";
	
	print OUT_DISCREP "Total Threshold\tStrand Minimum\tInvalidate Base\t";
	print OUT_DISCREP "Invalidate Fragment\tWindow Size\tFail Threshold\n";
	
	# Analysis for each nested directory containing data
	foreach $zz (@param_dirss) {
		
		# Remove symbolic links
		$dir = getcwd();
		# Change to directory containing data
		chdir ("$dir/$zz");
		$dir = getcwd();
		print OUT_LOG "Current working directory is $dir\n";
		print OUT_LOG "Extracting data from file: $zz.compare.txt\n";
		
		# Open file for input
		open(COMPARE_IN, "<$zz.compare.txt")
			or die "Cannot open COMPARE_IN in directory $zz";
		
		while (defined($_ = <COMPARE_IN>)) {
		
			if (/^Total bases/) {
				# Output folder name, split on "_" character
				@folder_name = split /_/, $zz;
				$folder_out = join "\t", @folder_name;
				print OUT_DISCREP "$folder_out\t";
				# Output line counting total bases, total comparisons, total discrepancies
				print OUT_DISCREP "$_";
			}
		}
		close(COMPARE_IN);
		chdir ("../");
	}
}

print ("Exiting RA_repl_discrep_count.pl script\n");
close(OUT_LOG);

#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
# Subroutines
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
