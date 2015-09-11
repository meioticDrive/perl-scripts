#!/usr/bin/perl
##############################################################################
### Name: RA_convert_genotypes.pl
### Version: 1.0
### Date: 02/15/2008
### Author: Michael E. Zwick
##############################################################################
### 1. The purpose of this script is to convert two letter HapMap genotypes to ### single letter genotypes.
### 2. Requires the following files:
###  - hapmap raw data from a single chromosome, file named *hapmap.txt

use warnings;
use strict;
use Cwd;

##############################################################################
### Globals
##############################################################################

my ($dirname, $version, $temp_seq, @temp_label, $count, @hapmap_file, @temp_hapmap, $position, $sample_id, @label_genpos, @hapmap_files, @temp_genpos, @genpos_name, @genpos_start, @genpos_end, $nmbr_genpos_name, $nmbr_genpos_start, $nmbr_genpos_end, @temp_ra_seq, $temp_location, @files, @filess, @fasta_labels, @temp_seq, %fasta_info, $file_name, $i, $single_letter_genotype);

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
@temp_label = ();
$count = 0;
$file_name = "";
$temp_location = 0;


##############################################################################
### Main
##############################################################################

# Change to directory entered by user when calling the program
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";

# Remove old sort files
system ("rm *.convert.hapmap.txt");

# Collect the name of Hapmap files for processing
@hapmap_file = glob("*.hapmap.txt")
    or die "No hapmap data file found\n";

# Process hapmap file
foreach my $process_file (@hapmap_file) {
	
	# Open file for output
	$sample_id = substr($process_file, 0, 7);
	open(OUT_HAPMAP_DATA, ">", "$sample_id" . '.convert.hapmap.txt')
    or die "Cannot open OUT_HAPMAP_DATA for converted hapmap sequence output";
	
	# Open file for processing
	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for hapmap data file";
	
	# Read in file line by line, convert genotypes
	while (<FILEHANDLE_FIRST>) {
		chomp($_);
		@temp_hapmap = split('\t',$_);
	    
	    # Print out genotype position
	    print OUT_HAPMAP_DATA "$temp_hapmap[0]\t";
	    # Convert genotype and output to convert.hapmap.txt file
	    $single_letter_genotype = convert_genotype($temp_hapmap[1]);
	    #print "$single_letter_genotype\n";
        print OUT_HAPMAP_DATA "$single_letter_genotype\n";
	}
	close (FILEHANDLE_FIRST);
    close (OUT_HAPMAP_DATA);
}



print "Completed HAP_extract_data.pl version $version script\n";

##############################################################################
### Subroutines
##############################################################################

sub convert_genotype {

my($two_letter_genotype) = $_[0];
my $new_genotype = '';

my (%genetic_singleletter_code) = (

'AA' => 'A',
'AC' => 'M',
'AG' => 'R',
'AT' => 'W',
'CC' => 'C',
'CA' => 'M',
'CG' => 'S',
'CT' => 'Y',
'GG' => 'G',
'GA' => 'R',
'GC' => 'S',
'GT' => 'K',
'TT' => 'T',
'TA' => 'W',
'TC' => 'Y',
'TG' => 'K',
'NN' => 'N',

);

# Convert two letter genotype to single letter genotype

print "No valid key for file value: $two_letter_genotype\n"
    unless exists $genetic_singleletter_code{$two_letter_genotype};

$new_genotype = $genetic_singleletter_code{$two_letter_genotype};

return $new_genotype;

}














