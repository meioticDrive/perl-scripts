#!/usr/bin/perl -w
##############################################################################
### Name: RA_Mask_fasta_files.pl
### Version: 1.0
### Date: 09/23/2010
### Author: Michael E. Zwick
##############################################################################
### Program designed to mask RA fasta files using Uniquemer .gff output
### 1. Files required:
### .fasta files
### .genpos file
### .gff uniquemer file
### 2. .gff uniquemer file can be made from RA.screen.SNPs.pl
### 3. Call program directory that holds files
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################

my(@all_fasta_files, @fasta_file, $fasta_size, @fasta_temp, $fasta_temp_size, $fasta_test, $file_name, @genpos_file, @genpos_positions, @genpos_temp, $genpos, @uniquemer_file, @uniquemer_positions, @uniquemer_temp, $uniquemer, $i, $j, $k, $l, $nmbr_bases_mask, $mask_start, $mask_end, $fragment_start, $fragment_end, $uniquemer_positions_size, $version);

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
### Read genpos file name
### Read uniquemer file name
### 
##############################################################################

# Change to user provided directory
chdir "$ARGV[0]" 
	or die "Cannot change to directory $ARGV[0]\n";

# Remove old output files
# system ("rm *.edit.fasta");

# Glob all file names
@all_fasta_files = glob("*.mask.fasta")
	or die "Did not find any files ending with *.mask.fasta\n";
	
@genpos_file = glob("*.genpos.txt")
	or die "Did not find any files ending with *.genpos.txt\n";

@uniquemer_file = glob("*.gff")
	or die "Did not find any files ending with *.gff\n";


# Read in genpos coordinates into array @genpos_positions
#-----------------------------------------------------------------------------
for $genpos (@genpos_file) {
    
    # Open filehandle to read genpos input
    open(FILEHANDLE_FIRST, $genpos)
        or die "Cannot open FILEHANDLE_FIRST";
        
    while (<FILEHANDLE_FIRST>) {
        chomp $_;
        # Split over tab in file
        @genpos_temp = split /\s+/, $_;
        # Push two values onto end of @genpos_positions array
        # Start of fragment, end of fragement
        push (@genpos_positions, $genpos_temp[0]);
        push (@genpos_positions, $genpos_temp[1]);
        @genpos_temp = ();
    }
    close(FILEHANDLE_FIRST);
}

# Read in uniquemer file coordinates into array @uniquemer_positions
#-----------------------------------------------------------------------------
for $uniquemer (@uniquemer_file) {

    # Open file handle to read uniquemer input
    open(FILEHANDLE_SECOND, $uniquemer)
        or die "Cannot open FILEHANDLE_SECOND";

    while (<FILEHANDLE_SECOND>) {
        chomp $_;
        #Split over tab in file
        @uniquemer_temp = split /\s+/, $_;
        # Push two values onto end of @uniquermer_positions array
        push (@uniquemer_positions, $uniquemer_temp[3]);
        push (@uniquemer_positions, $uniquemer_temp[4]);
        @uniquemer_temp = ();
    }
    close(FILEHANDLE_SECOND);
    # Determine size of uniquemer_positions arrays
    $uniquemer_positions_size = @uniquemer_positions;
}

# Edit individual fasta files
#-----------------------------------------------------------------------------
for $file_name (@all_fasta_files) {

    print "Working with file $file_name\n\n";
    
    # Open filehandle to read file input
    open(FILEHANDLE_THIRD, $file_name)
        or die "Cannot open FILEHANDLE_THIRD";

    # Open filehandle to output fasta file names
    # Change name of default output file if processing different *mer.gff 
    # files
    open(OUT_FASTA_FILES, ">", "$file_name.30mer.mask2.95.fasta")
        or die "Cannot open filehandle OUT_FASTA_FILES for data output";

    # Read each fasta fragment into an array
    @fasta_file = <FILEHANDLE_THIRD>;
    # Determine size of array
    $fasta_size = @fasta_file;
    
    # Odd values in array @fasta file are fasta headers
    # Even values contain DNA sequences that we want to mask
    
    for ($i = 1; $i < $fasta_size; $i += 2) {
        
        # Split fasta sequence
        chomp $fasta_file[$i];
        @fasta_temp = split('', $fasta_file[$i]);
        $fasta_temp_size = @fasta_temp;
        
        # Fragment position base upon genpos file
        $fragment_start = $genpos_positions[$i-1];
        #print "Fragment start = $fragment_start\n";
        $fragment_end = $genpos_positions[$i];
        #print "Fragment end = $fragment_end\n";
        
        # Loop over positions in uniquemer file
        for ($j = 0; $j < $uniquemer_positions_size; $j += 2) {
            
            # Find uniquemer fragments that fall within fasta fragment
            if (($uniquemer_positions[$j] >= $fragment_start) && ($uniquemer_positions[$j] <= $fragment_end)) {
            
                print "Entered the if loop\n";
                print "Uniquemer start: $uniquemer_positions[$j]\n";
                print "Uniquemer end: $uniquemer_positions[$j+1]\n";
                print "Fragment start: $fragment_start\n";
                print "Fragment end: $fragment_end\n";
            
                # Determine size of region to mask
                $nmbr_bases_mask = ($uniquemer_positions[$j+1] - $uniquemer_positions[$j] + 1);
                print "Mask size: $nmbr_bases_mask\n";
                
                $mask_start = ($uniquemer_positions[$j] - $genpos_positions[$i-1]);
                print "Start position: $mask_start\n";
                
                if (($mask_start + $nmbr_bases_mask) > $fragment_end) {
                    $mask_end = $fragment_end;
                    print "Found an example of this condition here\n";
                }
                else {
                    $mask_end = ($mask_start + $nmbr_bases_mask);
                }
                
                # Mask sequence in loop
                for ($k = $mask_start; $k < $mask_end; $k++) {
                    #print "Made it into the desired for loop\n";
                    #print "k value: $k\t";
                    # Mask $k base
                    $fasta_temp[$k] = "N";
                }
                print "\n";
            }
            else {
                next;
            }
        }
        
        # Write out original fasta header
        print OUT_FASTA_FILES "$fasta_file[$i-1]";
        # Write out masked sequence
        for ($l = 0; $l < $fasta_temp_size; $l++) {
            print OUT_FASTA_FILES "$fasta_temp[$l]";
        }
        print OUT_FASTA_FILES "\n";
        # Reset variables
        @fasta_temp = ();
        $fasta_temp_size = 0;
        $fragment_start = 0;
        $fragment_end = 0;
    }

    close (OUT_FASTA_FILES);
    close (FILEHANDLE_THIRD);
}

print "Completed RA.mask.fasta.files.pl script version $version\n";












































