#!/usr/bin/perl
# Version 1.0
# Michael E. Zwick
# 2/18/07
# Program designed to obtain all unique exons from ucsc table data
#
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use warnings;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables
my(@ucsc_file, $ucsc_file_number, @ucsc_labels, @ucsc_gene_info, @ucsc_exonStarts, @ucsc_exonEnds, $exon_number, $temp_start, $temp_end, $coding_start, $coding_end, $loop_count, $coding_exon_counter, $strand);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a single uscs gene table file
# Read in the data from the file
# Determine the number of exons, read in the exon start and finish
#-------------------------------------------------------------------------------

# Remove old files
#system ("rm *.annot.coding.txt");
#system ("rm *.annot.message.txt");
system ("rm log*");
system ("rm *.exon.txt");

# Open for output of log files
open(OUT_LOG, ">", "log.ucsc_get_all_exons.txt")
	or die "Cannot open OUT_FASTA for data output";
	
# Obtain name of ucsc gene_annotation.txt files
@ucsc_file = glob("*genes.txt");
$ucsc_file_number = ($#ucsc_file + 1);
if ($ucsc_file_number == 0) {
	die "$ucsc_file_number ucsc gene annotation files detected.
	 Check directory. Exiting program";
}
print OUT_LOG "Detected $ucsc_file_number ucsc.gene.txt file(s)\n";

# Loop over each of the data directories
foreach my $files (@ucsc_file) {
	
	print "\nFile name is: $files\n\n";
	# Open $files to be read
	open (IN_ANNOT, "<", "$files")
		or die "Cannot open IN_ANNOT filehandle to read file";
		
	# Open output file - will append info to file
	open (OUT_EXON, ">>", "$files.exon.txt")
		or die "Cannot open OUT_EXON filehandle to output exon info";
		
	# Output $files name to log file
	print OUT_LOG "$files\n";

	# Read in text information from $files
	# First line is labels
	# Subsequent lines are gene information - one gene per line
	while (<IN_ANNOT>) {
		chomp($_);
		
		# Process the first line of the file - contains labels
		# Read in labels on first line into @ucsc_labels
		# Split by tabs, read in labels
		if ($_ =~ /^#name/) {
			print "Processing the first line of the data file\n";
			@ucsc_labels = split( '\t',$_);
			print OUT_LOG "Labels read into memory\n";
			next;
		}
		else {
				# Process a gene
				# Read in all the fields for a given gene
				# $ucsc_gene_info[1] contains strand information
				# $ucsc_gene_info[6] contains the number of exons
				# $ucsc_gene_info[7] contains exonStarts
				# $ucsc_gene_info[8] contains exonEnds
				@ucsc_gene_info = split( '\t',$_);
				#print OUT_EXON "$ucsc_gene_info[0]\n";
				#print OUT_EXON "$ucsc_gene_info[10]\n";
				#print OUT_EXON "$ucsc_gene_info[7]\n";
				#print OUT_EXON "$ucsc_gene_info[8]\n";
				#print OUT_EXON "$ucsc_gene_info[9]\n";
				
				# Place exonStarts and exonEnds into separate arrays
				# Output data in Message formant
				$exon_number = $ucsc_gene_info[7];
				@ucsc_exonStarts = split( ',', $ucsc_gene_info[8]);
				@ucsc_exonEnds = split( ',', $ucsc_gene_info[9]);
				
				for (my $i=0; $i < $exon_number; $i++ ) {
					print OUT_EXON "$ucsc_exonStarts[$i]\t$ucsc_exonEnds[$i]\n";
				}
				
			}
		
		#print OUT_EXON "The exon number is $exon_number\n";
		#print "Finished reading a line\n\n";
	}
	#print "Finished processing annotation file.\n\n";
}
close (OUT_EXON);
close (IN_ANNOT);
print OUT_LOG "Completed ucsc_get_all_exons.pl program.\n";
close(OUT_LOG);
print "Completed ucsc_get_all_exons.pl program.\n";





























