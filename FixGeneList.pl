#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 8/2/13
####################################################################################
# Program designed to:
# 1. Make a hg19 gene list - remove duplicate genes
# 2. Chooses the first splice variant for a gene
# Usage: Launch from within directory containing target files
####################################################################################
use strict;
use Cwd;

####################################################################################
# Local variable definitions
####################################################################################
# Define local variables
my(@popgen_file, $popgen_file_number, @line, %temp_gene);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@popgen_file = ();
$popgen_file_number = 0;

####################################################################################
# Program Overview
####################################################################################

# Remove old files
unlink("log.parse.eigen.out.txt");
unlink("eigen.parsed.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.parse.genelist.out.txt")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of popgen files
@popgen_file = glob("*hg19.txt");
$popgen_file_number = ($#popgen_file + 1);
if ($popgen_file_number == 0) {
	die "$popgen_file_number fasta files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $popgen_file_number gene_name file\n";
print OUT_LOG "Detected $popgen_file_number gene_name files\n";

# Open output file for parsed outut
open (OUT_ANNOT, ">>", "glist-hg19.parsed.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";


# Process gene name file
foreach my $files (@popgen_file) {
    # Open $files to be read
    open (IN_ANNOT, "<", "$files")
	    or die "Cannot open IN_ANNOT filehandle to read file";
	    
	# Read in the glist - make the hash using gene name as key, position as reference
	while (<IN_ANNOT>) {
		chomp $_;
		
		# Try to match remaining lines
		@line = split (/\s/, $_);
		#print "$line[3], $line[1]\n";
		
		# Skip genes that already exist
		if(exists $temp_gene{"$line[3]"}) {
		next;
		}
		
		$temp_gene{"$line[3]"} = "$line[1]";
		print OUT_ANNOT "$_\n";
		@line = ();
		}
	}
close (IN_ANNOT);

close (OUT_ANNOT);
print OUT_LOG "Completed FixGeneList.pl program.\n";
close (OUT_LOG);
print "Completed FixGeneList.pl program.\n";