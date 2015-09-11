#!/usr/bin/perl
# Version 1.0
# Michael E. Zwick
# 2/18/07
# Program designed select unique exons from a tab delimited list
# start	stop
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
my(@ucsc_file, $ucsc_file_number, @ucsc_labels, @ucsc_gene_info, @ucsc_exonStarts, @ucsc_exonEnds, $exon_number, $temp_start, $temp_end, $coding_start, $coding_end, $loop_count, $coding_exon_counter, $strand, %exon_id, %exon_starts, %exon_ends, @unique_exons);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
%exon_cords = (0 => 1);

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing a single uscs gene table file
# Read in the data from the file
# Determine the number of exons, read in the exon start and finish
#-------------------------------------------------------------------------------

# Remove old files
system ("rm log*");
system ("rm *.exon.txt");

# Open for output of log files
open(OUT_LOG, ">", "log.ucsc_get_all_exons.txt")
	or die "Cannot open OUT_FASTA for data output";
	
# Obtain name of ucsc gene_annotation.txt files
@ucsc_file = glob("*numbers.txt");
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
	open (OUT_EXON, ">>", "$files.unique.txt")
		or die "Cannot open OUT_EXON filehandle to output exon info";
		
	# Output $files name to log file
	print OUT_LOG "$files\n";

	# Read in text information from $files
	# Lines consist of start and end of exons
	while (<IN_ANNOT>) {
		chomp($_);
		@ucsc_labels = split( '\t',$_);
		
		
		# Use exon start - look for identical end
		# Use exon end - look for identical start
		if ((defined ($exon_starts{$ucsc_labels[0]})) && (defined ($exond_ends{$ucsc_labels[1]})) {
		
		#Value already exists in array - skip
		next;
		}
		else {
			
			push $ucsc_labels[0] @unique_exons;
			
			push $ucsc_labels[1] @unique_exons;
			
			
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





























