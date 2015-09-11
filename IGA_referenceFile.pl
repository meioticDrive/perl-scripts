#!/usr/bin/perl
###
### Name: IGA_referenceFile.pl
### Version: 1.0
### Date: 10/31/2008
### Author: Michael E. Zwick
###---------------------------------------------------------------------------
### 1. The purpose of this script is to convert a *coords.reference.txt file ### to a single column format for analysis with R.
###---------------------------------------------------------------------------
use warnings;
use strict;
use Cwd;

my ($dirname, $version, @pileup_files, @temp_data, $temp_data_size,
@files, @filess, @fasta_files, @fasta_labels, @temp_label, @temp_seq, %fasta_info, @fasta_labelss, $count, $fragment_size);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_data_size = "";
@temp_data = ();

### Change to directory entered by user when calling the program
###---------------------------------------------------------------------------
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old covert files
system ("rm *referenceFile.txt");

# Collect the names of reference fasta file in a directory
@pileup_files = glob("IGA.coords.reference.txt");

# Open output file for coverage values
open(OUT_IGA_PILEUP_STATS, ">", "IGA.referenceFile.txt")
    or die "Cannot open filehandle OUT_IGA_PILEUP_STATS for data output";

foreach my $process_file (@pileup_files) {

	print "Processing IGA.coords.reference.txt file: $process_file\n";

	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";
		
	#print OUT_IGA_PILEUP_STATS "$process_file\n";
	
	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		
		if ($_ =~ /^Reference/) {
		    next;
		}
		else {
		    #Collect start and stop of fragment
		    @temp_data = split(/\t/, $_);
		    $fragment_size = ($temp_data[1] - $temp_data[0]);
            print OUT_IGA_PILEUP_STATS "$temp_data[0]\n";
		    
		    for (my $n = 1; $n <= $fragment_size; $n++) {
		        print OUT_IGA_PILEUP_STATS ($temp_data[0] + $n) . "\n";

	        }
	    # Reset @temp_data array
		@temp_data = ();
        }
    }
}
print "Completed IGA_refCoordinates.pl version $version script\n";