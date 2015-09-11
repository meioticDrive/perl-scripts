#!/usr/bin/perl
#
# Name: RA_repl_compare_BaseCaller
# Version: 1.0
# Date: 09/05/2006
# Author: Michael E. Zwick
#--------------------------------------------------------------------------------------------
# 1. The purpose of this script is to evalute the number of discrepancies from a replication 
# experiment. This is achieved by the following steps:
# A) Using the RATools folder structure, execute the script on a folder containing files previously # analyzed with RATools.
# B) Enters a folder - name starts with a number. Typically, these folders are the output of a 
# parameter search - i.e. RA_run_param_srch.pl
# B) For each folder, build a file named <in.compare.in>. Fasta files to be compared need to be 
# adjacent to each other in the file listing.
# C) Call a compiled program (Dave Cutler author), process_test3: process_test3 <in.compare.in
# D) Write an output file named <folder>.compare.txt
# Future Changes
# 1. Add an output log
# 2. Program exit is not graceful (errors in identifying folders). Make this regular expression more # robust (vicinity of line 61 is the source of the problem)
# 3. Need to update this program to provide the data for the FINAL data
#--------------------------------------------------------------------------------------------

use warnings;
use strict;
use Cwd;

my ($LQvsCDF, $outputFasta, $haploid, $primersUsed, $numSegs, $offset, $maxSites, $rewriteFasta, $dirname, $nInvalidateBase, $nInvalidateFrag, $winSize, $failThresh, @primer_file, $primer_file_nmbr, @genpos_file, $genpos_file_nmbr, @files, @filess, @param_dirs, @param_dirss, @fasta_files, @fasta_filess, $z, $zz, $nofiles, $test, $dir, $dir_final, $param_dir_nmbr);

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
	
	# Get list of all parameter named folders holding fasta files to be analyzed
	# Only selects directories starting with a number
	opendir(DIR,$dirname) || die "Cannot open $dirname";
	@param_dirs = grep {/\d\d/} readdir(DIR);
	@param_dirss = sort @param_dirs;
	$param_dir_nmbr = ($#param_dirs + 1);
	print "The number of folders is $param_dir_nmbr";
	close(DIR);
	
		# Get primer file name, check for single primer file
	@primer_file = glob("*.primers.txt") || print "\nNo primer file found\n";
	$primer_file_nmbr = ($#primer_file + 1);
	if ($primer_file_nmbr > 1) {
		die "Too many primer files" }

	# Get genpos file name, check for single genpos file
	@genpos_file = glob("*.genpos.txt") || print "\nNo genpos file found";
	$genpos_file_nmbr = ($#genpos_file + 1);
	if ($genpos_file_nmbr > 1) { 
		die "Too many genpos files" }
	
	print "@param_dirss\n\n";
	
	# Analysis for each nested directory containing data
	foreach $zz (@param_dirss) {
		
		# Remove symbolic links
		$dir = getcwd();
		# Change to directory containing data
		chdir ("$dir/$zz");
		$dir = getcwd();
		print "Current directory is $dir\n";
		unlink ("in.compare.in");
		unlink glob("*.compare.txt");
		unlink glob("*.ref.fasta");
		unlink glob("*.primers.txt");
		unlink glob("*.genpos.txt");
		chdir("../");
		#$dir_final = getcwd();
		#print "Final directory is: $dir_final\n";
		
		# Get .fasta file names, number of files
		opendir(DIR,$zz) || die "Cannot open $zz";
		@fasta_files = grep {/\.fasta/} readdir(DIR); 
		close(DIR);
		@fasta_filess = sort @fasta_files;
		$nofiles = @fasta_filess;
		print "$nofiles files found in directory $zz\n";
		$dir = getcwd();
		chdir ("$dir/$zz");
		
		replication_compare($z, $nofiles, $zz, $primersUsed, $numSegs, $offset, $maxSites, $nInvalidateBase, $nInvalidateFrag, $winSize, $failThresh, \@fasta_files);
		
		# Parse output data
	}
}

print ("Exiting ra_replication_compare_1.0.pl script\n");


#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
# Subroutines
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
sub replication_compare {

my ($z, $nofiles, $zz, $primersUsed, $numSegs, $offset, $maxSites, $nInvalidateBase, $nInvalidateFrag, $winSize, $failThresh, $fasta_files) = @_;

open (IN_FILE,">in.compare.in");

# Make symbolic links to files needed for process test 3
symlink("../$z.ref.fasta", "$z.ref.fasta");
symlink("../$z.primers.txt", "$z.primers.txt");
symlink("../$z.genpos.txt", "$z.genpos.txt");

# Add initial parameters and file names
print IN_FILE "d\n$zz.compare.txt\n $nofiles\n$z.ref.fasta\n$primersUsed\n$z.primers.txt\n";
print IN_FILE "n\n$nInvalidateBase\n$nInvalidateFrag\n$winSize\n$failThresh\n";

# Add .fasta file names
	for(my $i=0;$i<$nofiles;$i++) {
		print IN_FILE "@$fasta_files[$i]\n";
	}

# Add final paramters and file names
print IN_FILE "$numSegs\n$offset\ny\nn\nn\n$maxSites\n$z.genpos.txt\n$z.txt.fail\n";

close(IN_FILE);

# Runs process_test3 Application
# Assumes application is in path
system("../process_test3 <in.compare.in");
chdir("../");

}
#--------------------------------------------------------------------------
