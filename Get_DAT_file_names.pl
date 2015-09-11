#!/usr/bin/perl -w
##############################################################################
### Name: Get_fasta_file_names.pl
### Version: 1.0
### Date: 03/13/2008
### Author: Michael E. Zwick
##############################################################################
### Program designed to read names of all .DAT files (pass through multiple
### directories), place into a text file
### The directory structure assumed as follows:
### Chip_Design_Scanned_Chips[FOLDER]
###    Date[FOLDER]
###       .DAT[FILES]
###        exp_files[FOLDER]
### Program should:
### 1. Read the names of all Date[FOLDER]
### 2. For each Date[FOLDER], read the names of all .DAT[FILES]
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################

my(@all_fasta_files, $file, $file_name, $count, $version);

my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

$version = "1.0";


##############################################################################
### Program Overview
### Change to user supplied directory
### Open filehandle for output
### Read and output all fasta file names
##############################################################################
system ("rm Get_DAT_file_names.out.txt");

# Change to Alignment directory, in user provided directory
chdir "$ARGV[0]" 
	or die "Cannot change to directory $ARGV[0]\n";

# Open filehandle to output fasta file names
open(OUT_FASTA_FILES, ">", "Get_DAT_file_names.out.txt")
    or die "Cannot open filehandle OUT_CONFORMANCE for data output";

# Glob all .fasta files
#@all_fasta_files = glob("*.popgen.fasta")
#	or die "Did not find any files ending with *.popgen.fasta\n";

@all_fasta_files = glob("*.DAT")
	or die "Did not find any files ending with *.final.fasta\n";

#@all_fasta_files = glob("*.ref.fasta")
#	or die "Did not find any files ending with *.ref.fasta\n";

for $file_name (@all_fasta_files) {
	print OUT_FASTA_FILES "$file_name\n";
}
close (OUT_FASTA_FILES);
print "Completed Get_DAT_file_names.pl script version $version\n";
