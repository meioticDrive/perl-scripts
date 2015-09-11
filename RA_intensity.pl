#!/usr/bin/perl -w
##############################################################################
### Name: RA_intensity.pl
### Version: 1.0
### Date: 04/18/2008
### Author: Michael E. Zwick
##############################################################################
### Program designed read the chip name and mean signal intensity in a
### RA experiment. Assumes the all the chip data is in the <Alignment> folder
### and that each chip has a separate alignment .out file. User should launch from
### the main directory.
### Program should:
### 1. Move into the alignment folder
### 2. Collect the names of all the .out files
### 3. Extract the chip name and mean intensity from each file. Output this
### 2. For each Date[FOLDER], read the names of all .DAT[FILES]
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################

my(@all_align_out_files, $file, @temp_name, @temp_intensity, $count, $version);

my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

$version = "1.0";
@temp_name = ();
@temp_intensity = ();

##############################################################################
### Program Overview
### Change to user supplied directory
### Change to Alignment direcotry
### Open filehandle for output
### 
##############################################################################

# Change to Alignment directory, in user provided directory
chdir "$ARGV[0]/Alignment" 
	or die "Cannot change to directory $ARGV[0]/Alignment\n";

# Remove old files
system ("rm Intensity.data.sum.txt");

# Open filehandle to output fasta file names
open(OUT_INTENSITY, ">", "Intensity.data.sum.txt")
    or die "Cannot open filehandle OUT_INTENSITY for data output";

# Glob all .out files
@all_align_out_files = glob("*.out")
	or die "Did not find any files ending with *.out\n";

foreach $file (@all_align_out_files) {

    #print "Processing file $file\n";
    open (FILEHANDLE_PROCESS, $file)
        or die "Cannot open FILEHANDLE_PROCESS for *.out alignment file\n";

    while (<FILEHANDLE_PROCESS>) {
        chomp $_;
        # Get file name - once per file
        if ($_ =~ /^ I am now working on datfile/){
            @temp_name = split (/\s/,$_);
            print OUT_INTENSITY "$temp_name[11]\t";
        }
        # Get mean intensity - once per file
        if ($_ =~ /^\tMean brightness on whole chip/){
            @temp_intensity = split (/\s/,$_);
            print OUT_INTENSITY "$temp_intensity[6]\n";
        }
        # Reset temp arrays
        @temp_name = ();
        @temp_intensity = ();
    }
}

close (FILEHANDLE_PROCESS);
close (OUT_INTENSITY);
print "Completed RA_intensity.pl script version $version\n";

