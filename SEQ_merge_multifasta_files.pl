#!/usr/bin/perl -w
##############################################################################
### Name: SEQ_merge_rename_fasta_files.pl
### Version: 1.0
### Date: 09/24/2008
### Author: Michael E. Zwick
##############################################################################
### Program designed to take a multifasta file and turn it into a single fasta
### file. The fasta header consists of the file name. This script can be used ### to make a single fasta file for each individual/sample for phylogentic 
### analysis (with Phylip for example).
### 1. Files required:
### multi-fasta files
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################

my(@all_fasta_files, @fasta_file, $fasta_size, @fasta_temp, $fasta_temp_size, $fasta_test, $file_name, $dir,
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
# system ("rm *.out.txt");

# Glob all file names
@all_fasta_files = glob("BAN*")
	or die "Did not find any files starting with BAN\n";

# Make directory for output
$dir = getcwd();
mkdir "$dir/OUT" or die "can't make mkdir OUT\n";


# Process individual fasta files
for $file_name (@all_fasta_files) {

    print "Working with file $file_name\n\n";
    
    # Obtain substring from $file_name
    $sample_ID = $file_name;
    
    # Open filehandle to read file input
    open(FILEHANDLE_THIRD, $file_name)
        or die "Cannot open FILEHANDLE_THIRD";

    # Read each fasta fragment into an array
    while(<FILEHANDLE_THIRD>) {
    
        chomp($_);
        
        # Skip fasta header lines
        if ($_ =~ /^>/) {
            next;
        }
        else {
            push (@fasta_file, $_);
        }
    }
    
    # Finish file input - close input filehandle
    close (FILEHANDLE_THIRD);
    
    # Prepare for file output
    # Determine size of array @fasta_file
    $fasta_size = @fasta_file;
    print "File name: $file_name is size $fasta_size\n";
    
    # Change directory and then open output file with same name
    chdir "$dir/OUT";
    open(OUT_FASTA_FILES, ">", "$file_name")
        or die "Cannot open filehandle OUT_FASTA_FILES for data output";
    
    # Output newly formatted fasta file with a single header=
    print OUT_FASTA_FILES ">" . "$file_name\n";
    
    for ($i = 0; $i < $fasta_size; $i++) {
        # Write out fasta sequence
        print OUT_FASTA_FILES "$fasta_file[$i]";
    }
    
    # Return after final line, close filehandle
    print OUT_FASTA_FILES "\n";
    close (OUT_FASTA_FILES);
    
    
    # Reset to working directory
    chdir "$dir";
    
    # Reset variables
    @fasta_file = ();
}

print "Completed SEQ_merge_multifasta_files.pl script version $version\n";












































