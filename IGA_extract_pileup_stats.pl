#!/usr/bin/perl -w
##############################################################################
### Name: IGA_extract_pileup_stats.pl
### Version: 1.0
### Date: 05/25/2008
### Author: Michael E. Zwick
##############################################################################
### Program designed read the file names and extract information from 
### pileup_stats files.
### File name convention: SampleID_ . . .  _pileup.stats
### 
### Program should:
### 1. Move into the folder containing files
### 2. Collect the names of all the _pileup.stats files
### 3. Extract the fragment ID, fragment size
### 4. For each file, extract the average coverage over the sequence
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################

my(@all_pileup_stats_files, $file, @temp_name, @sample_coverage, @sample_ID, $file_count, $line_count, $version, $sample_name, @fragment_ID, @fragment_size, $total_lines, $total_files);

my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

$version = "1.0";
$file_count = 0;
$line_count = 0;

@temp_name = ();
@sample_coverage = ();


##############################################################################
### Program Overview
### Change to user supplied directory
### 
### 
### 
##############################################################################

# Change to Alignment directory, in user provided directory
chdir "$ARGV[0]" 
	or die "Cannot change to directory $ARGV[0]\n";

# Remove old files
system ("rm IGA.extract.pilup.stats.txt");

# Open filehandle to output fasta file names
open(OUT_IGA_PILEUP_STATS, ">", "IGA.extract.pilup.stats.txt")
    or die "Cannot open filehandle OUT_IGA_PILEUP_STATS for data output";

# Glob all pileup.stats files
@all_pileup_stats_files = glob("*pileup.stats")
	or die "Did not find any files ending with *pileup.stats\n";
$total_files = ($#all_pileup_stats_files + 1);

foreach $file (@all_pileup_stats_files) {

    #print "Processing file $file\n";
    open (FILEHANDLE_PROCESS, $file)
        or die "Cannot open FILEHANDLE_PROCESS for *pileup.stats file\n";

    # Process first data file to get fragment IDs and sizes
    if ($file_count == 0) {
        while (<FILEHANDLE_PROCESS>) {
            chomp $_;
            if ($_ =~ /^chr/) {
                @temp_name =  split (/\t/, $_);
                push (@fragment_ID, $temp_name[0]);
                push (@fragment_size, $temp_name[1]);
            }
        }
    close (FILEHANDLE_PROCESS);
    @temp_name = ();
    $file_count++;
    }
    
    # Get sample ID - file name is 7 characters long
    # Push sample_ID into data array: @sample_coverage
    $sample_name = substr($file, 0, 6);
    push (@sample_ID, $sample_name);
  
    open (FILEHANDLE_PROCESS, $file)
        or die "Cannot open FILEHANDLE_PROCESS for *pileup.stats file\n";
  
    if ($file_count > 0) {
        print "Processing file $file\n";
        while (<FILEHANDLE_PROCESS>) {
            #print "$_\n";
            chomp $_;
            if ($_ =~ /^chr/) {
                @temp_name =  split (/\t/, $_);
                # Collect Seq_Depth over fragment
                #print "$temp_name[3]\n";
                push (@sample_coverage, $temp_name[3]);
                $line_count++;
                @temp_name = ();
            }
        }
        #close (FILEHANDLE_PROCESS);
        $total_lines = $line_count;
        $line_count = 0;
        @temp_name = ();
        $file_count++;
    }
    close (FILEHANDLE_PROCESS);
}

# Output data contained in arrays @sample_ID @fragment_ID, @fragment_size, 
# @sample_coverage

# Print out header line
print OUT_IGA_PILEUP_STATS "Seg_ID\tSize\t";
for (my $k = 0; $k < $total_files; $k++) {
    print OUT_IGA_PILEUP_STATS "$sample_ID[$k]\t";
}
print OUT_IGA_PILEUP_STATS "\n";

for (my $i = 0; $i < $total_lines; $i++) { 

    # Print our first two columns
    print OUT_IGA_PILEUP_STATS "$fragment_ID[$i]\t";
    print OUT_IGA_PILEUP_STATS "$fragment_size[$i]\t";
    
    # Loop over all data files
    for (my $j = 0; $j < $total_files; $j++) {
        
        print OUT_IGA_PILEUP_STATS "$sample_coverage[($i+($j*$total_lines))]\t";
    }
    print OUT_IGA_PILEUP_STATS "\n";
}

close (OUT_IGA_PILEUP_STATS);
print "Completed IGA_extract_pileup_stats.pl script version $version\n";

