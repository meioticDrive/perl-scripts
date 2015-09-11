#!/usr/bin/perl -w
##############################################################################
### Name: RA_fix_alignment.pl
### Version: 1.0
### Date: 05/15/2008
### Author: Michael E. Zwick
##############################################################################
### Program designed to fix alignment file - change paths to .cdf and .DAT 
### file to relative path.
### Program should:
### 1. Move into the alignment folder
### 2. Collect the names of all the .txt files
### 3. Change CDF and Dat Filename paths
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

# Glob all .txt files
@all_align_out_files = glob("*.txt")
	or die "Did not find any files ending with *.out\n";

foreach $file (@all_align_out_files) {

    #print "Processing file $file\n";
    open (FILEHANDLE_PROCESS, $file)
        or die "Cannot open FILEHANDLE_PROCESS for *.txt alignment file\n";
    
    # Open filehandle to output new .txt file
    open(OUT_FIXED_ALIGN, ">", "$file.temp")
        or die "Cannot open filehandle OUT_FIXED_ALIGN for data output";
        
    while (<FILEHANDLE_PROCESS>) {
        chomp $_;
        
        # Get CDF Filename Line
        if ($_ =~ /^CDF Filename/){
            s/\/Users\/kmeltz\/nlgn_controls_low/../;
            print OUT_FIXED_ALIGN "$_\n";
        }
        # Get DAT Filename Line
        elsif ($_ =~ /^Dat Filename/) {
            s/\/Users\/kmeltz\/nlgn_controls_low/../;
            print OUT_FIXED_ALIGN "$_\n";
        }
        else {
            print OUT_FIXED_ALIGN "$_\n";
        }
    }
    close (FILEHANDLE_PROCESS);
    close (OUT_FIXED_ALIGN);
}

#unlink glob "*.txt";



print "Completed RA_fix_alignment.pl script version $version\n";

