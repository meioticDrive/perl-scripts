#!/usr/bin/perl -w
# Version 1.1
# Michael E. Zwick
# 1/6/05
# Program designed to:
# 1. Start in a folder containing the following files:
# Genome fasta files (like human genome files)
# Parsed dbSNP file (i.e. ds_flat_chX.flat.line). Raw file from dbSNP can be parsed with Cutler 
# script called parse_dbsnp.pl
# primer_region - compiled program
# 2. For a given chromosomal search region, fragment size, generate the in.region.in file
# 3. Call the primer_region program with in.region.in - i.e. primer_region <in.region.in
# 4. Find the primers
# 5. Parse the output file to keep the primers
# 6. Discard the output file
# 7. Loop over and repeat for the next tiled region
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
use Cwd;
#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variables

my($output_location, $temp_output_file, $primer_picker_sum_name, $minimum_primer, $maximum_primer, $contig, $dbSNPfile, $minimum_gc, $maximum_gc, $minimum_tm_primer, $maximum_tm_primer, $genomic_region_start, $genomic_region_end, $search_size, $average_amplicon, @temp_primer_file, $temp_primer_file_number,);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
# Set Values for Primer Selection Here
#-------------------------------------------------------------------------------
# Output to Screen or Disk [S,D]
$output_location = "d";

$temp_output_file = "temp.primers.txt";

#Primer Picker Summary Filename
$primer_picker_sum_name = "human_genome.sdx";

#Minimum primer length
$minimum_primer = 20;

#Maximum primer length
$maximum_primer = 32;

#Chromosome/Contig (from the SDX file, starts counting at 1)
$contig = 23;

#dbSNP file
$dbSNPfile = "ds_flat_chX.flat.line";

# Mimimum primer GC content
$minimum_gc = 0.1;

# Maximum primer GC content
$maximum_gc = 0.9;

# Mimimum tm_primer in degrees C
$minimum_tm_primer = 50;

# Maximum tm_primer in degrees C
$maximum_tm_primer = 65;

# Genome starting coordinate - like from the UCSC browser 
$genomic_region_start = 146700000;

# Genome ending coordinate - like from the UCSC browser 
$genomic_region_end = 146800000;

# Size of region to search around boundaries
$search_size = 20000;

# Average amplicon length
$average_amplicon = 8000;
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Program Overview:
# Start in a folder containing the necessary files listed above
#-------------------------------------------------------------------------------

# Remove old files
	system ("rm in.region.in");
	system ("rm *.primers.txt");

# Open for output of log files
open(OUT_LOG, ">", "log.tile_primers.out")
	or die "Cannot open OUT_FASTA for data output";

# Open for output of primer info 
open (FINAL_OUT, ">>", "$contig.$genomic_region_start.$genomic_region_end.primers.txt")
	or die "Cannot open OUT_ANNOT filehandle to output file info";

for (my $i = $genomic_region_start; $i < $genomic_region_end; $i = $i + $average_amplicon) {

	# Open for output of primer info - in.region.in file 
	open (IN_REGION_IN, ">", "in.region.in")
		or die "Cannot open OUT_ANNOT filehandle to output file info";
		
	# Make in.region.in file
	print IN_REGION_IN "$output_location\n";
	#Comment out this line if S is selected
	print IN_REGION_IN "$temp_output_file\n";
	print IN_REGION_IN "$primer_picker_sum_name\n";
	print IN_REGION_IN "$minimum_primer\n";
	print IN_REGION_IN "$maximum_primer\n";
	print IN_REGION_IN "$contig\n";
	print IN_REGION_IN "$dbSNPfile\n";
	print IN_REGION_IN "$minimum_gc\n";
	print IN_REGION_IN "$maximum_gc\n";
	print IN_REGION_IN "$minimum_tm_primer\n";
	print IN_REGION_IN "$maximum_tm_primer\n";
	print IN_REGION_IN "$i\n";
	print IN_REGION_IN ($i + $average_amplicon) . "\n";
	print IN_REGION_IN "$search_size\n";

	# Call primer_region program (does the primer selection)
	system ("primer_region <in.region.in");
	
	# Read and parse the temporary output file
	open (IN_TEMP_PRIMER, "<", "$temp_output_file")
		or die "Cannot open IN_TEMP_PRIMER filehandle to read file";
	
	#Output primer positions
	print FINAL_OUT "Search Start Position: $i\n";
	print FINAL_OUT "Search End Position: ";
	print FINAL_OUT ($i + $average_amplicon) . "\n";
	
	while (<IN_TEMP_PRIMER>) {
		# Output primer info
		if ($_ =~ /5' [ACGT]/) {
			print FINAL_OUT "$_";
		}
	}
	print FINAL_OUT "\n\n";

	system ("rm $temp_output_file");
	system ("rm in.region.in");
	close (IN_TEMP_PRIMER);
	close (IN_REGION_IN);
}


print OUT_LOG "Completed tile_primers.ver1.0.pl program.\n";
close (OUT_LOG);
close (FINAL_OUT);
print "Completed tile_primers.ver1.0.pl program.\n";




































