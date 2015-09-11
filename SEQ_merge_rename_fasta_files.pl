#!/usr/bin/perl -w
##############################################################################
### Name: SEQ_merge_rename_fasta_files.pl
### Version: 1.0
### Date: 09/24/2008
### Author: Michael E. Zwick
##############################################################################
### Program designed to merge multiple fasta files with the same fasta 
### fragment name. Append the file name to the fragment in order to 
### differentiate each fasta file (for eventual display in clustal).
### 1. Files required:
### fasta files
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################

my(@all_fasta_files, @fasta_file, $fasta_size, @fasta_temp, $fasta_temp_size, $fasta_test, $file_name,
@genpos_file, @genpos_positions, @genpos_temp, $genpos,
@uniquemer_file, @uniquemer_positions, @uniquemer_temp, $uniquemer,
$i, $j, $k, $l, $nmbr_bases_mask, $mask_start, $mask_end,
$fragment_start, $fragment_end, $uniquemer_positions_size, $version, $sample_ID, $fragment_ID);

my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

$fasta_temp_size = 0;
$uniquemer_positions_size = 0;
$nmbr_bases_mask = 0;
$version = "1.0";
@genpos_temp = ();
@uniquemer_temp = ();


##############################################################################
### Program Overview
### Read all fasta file names
### Read all fasta file contents out to new file
### 
### 
### 
##############################################################################

# Change to user provided directory
chdir "$ARGV[0]" 
	or die "Cannot change to directory $ARGV[0]\n";

# Remove old output files
system ("rm *.out.txt");

# Glob all file names
@all_fasta_files = glob("*.fasta")
	or die "Did not find any files ending with *.fasta\n";

# Open filehandle to output fasta file names
open(OUT_FASTA_FILES, ">", "Total_Sequences.out.txt")
        or die "Cannot open filehandle OUT_FASTA_FILES for data output";

# Process individual fasta files
for $file_name (@all_fasta_files) {

    print "Working with file $file_name\n\n";
    
    # Obtain substring from $file_name
    $sample_ID = substr($file_name, 0, 9);
    
    # Open filehandle to read file input
    open(FILEHANDLE_THIRD, $file_name)
        or die "Cannot open FILEHANDLE_THIRD";

    # Read each fasta fragment into an array
    while(<FILEHANDLE_THIRD>) {
        chomp($_);
        push (@fasta_file, $_);
    }
    
    # Determine size of array @fasta_file
    $fasta_size = @fasta_file;
    
    # First value in array @fasta_file is the fasta header
    # Remaining values in the array @fasta_file are the DNA sequences
    # In this case, there should be only 1 header and at least 1 sequence
    
    # Write out original fasta header
    $fragment_ID = substr($fasta_file[0], 1, 12);
    print OUT_FASTA_FILES ">" . "$sample_ID" . "$fragment_ID\n";
    
    for ($i = 1; $i < $fasta_size; $i++) {
        # Write out fasta sequence
        print OUT_FASTA_FILES "$fasta_file[$i]\n";
    }
    
    # Reset variables
    @fasta_file = ();
    
    close (FILEHANDLE_THIRD);
    }

close (OUT_FASTA_FILES);
print "Completed SEQ_merge_rename_fasta_files.pl script version $version\n";












































