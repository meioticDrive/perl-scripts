#!/usr/bin/perl
##############################################################################
### Name: RA_compare_hapmap.pl
### Version: 1.1
### Date: 02/01/2008
### Author: Michael E. Zwick
##############################################################################
### 1. The purpose of this script is to determine a series of SNPs from the 
### hapmap, extract the identical bases from a RA, and output the data for 
### comparison.
### 2. Requires the following files:
###  - RA multifasta file with sequence
###  - genpos.txt corresponding to the RA file
###  - hapmap genotype file for individual
### 3. Performs this analysis within the RATools Hierarchy
### 4. Requires a Hapmap_Data folder containing Hapmap files (naming convention)
### 5. popgen version
##############################################################################

use warnings;
use strict;
use Cwd;

##############################################################################
### Globals
##############################################################################
my ($dirname, $start_dir, $version, $temp_seq, @temp_label, $count,
@fasta_files, @label_genpos, @hapmap_files, @temp_genpos, @genpos_name,
@genpos_start, @genpos_end, @temp_hapmap, $nmbr_genpos_name,
$nmbr_genpos_start, $nmbr_genpos_end, @temp_ra_seq, $temp_location,
@files, @filess, @fasta_labels, @temp_seq, %fasta_info, $file_name, $i,
$process_fasta_file, $sample_name, @temp_compare, @compare_files,
@reference_file, @temp_ref_seq, %ref_fasta_info, $ref_fasta_labels,
$process_ref_file, @ref_fasta_labels, $corrected_temp_location, $z);

# Variables for individual files - process_compare
my $hapmap_no_ra_no = 0;
my $hapmap_no_ra_yes = 0;
my $hapmap_yes_ra_no = 0;
my $hapmap_yes_ra_yes_ne = 0;
my $hapmap_yes_ra_yes_eq = 0;
my $hapmap_het_ra_homo_ne = 0;
my $hapmap_homo_ra_het_ne = 0;
my $hapmap_homo_ra_homo_ne = 0;
my $hapmap_het_ra_het_ne = 0;
my $hapmap_het_ra_nocall = 0;
my $hapmap_homo_ra_nocall = 0;
my $hapmap_nocall_ra_het = 0;
my $hapmap_nocall_ra_homo = 0;
my $match_het = 0;
my $match_homo = 0;

# Variables for total data - process_compare
my $total_hapmap_no_ra_no = 0;
my $total_hapmap_no_ra_yes = 0;
my $total_hapmap_yes_ra_no = 0;
my $total_hapmap_yes_ra_yes_ne = 0;
my $total_hapmap_yes_ra_yes_eq = 0;
my $total_hapmap_het_ra_homo_ne = 0;
my $total_hapmap_homo_ra_het_ne = 0;
my $total_hapmap_homo_ra_homo_ne = 0;
my $total_hapmap_het_ra_het_ne = 0;
my $total_hapmap_het_ra_nocall = 0;
my $total_hapmap_homo_ra_nocall = 0;
my $total_hapmap_nocall_ra_het = 0;
my $total_hapmap_nocall_ra_homo = 0;
my $total_match_het = 0;
my $total_match_homo = 0;

# Initialize variables
$version = "1.0";
$dirname = ".";
$temp_seq = "";
@temp_label = ();
$count = 0;
$file_name = "";
$temp_location = 0;
$process_fasta_file = "";

##############################################################################
### Main
##############################################################################

# Change to RATools directory containing data files
# Directory name needs to be entered by user calling program
chdir $ARGV[0] or die "Cannot change to directory $ARGV[0]\n";
$dirname = getcwd();
$start_dir = getcwd();
#print "\n";
#print "$dirname\n";
#print "$start_dir\n";
#print "\n";

# Collect the names of files for processing
##############################################################################
# Genpos for reference sequences
# Located in $ARGV[0] directory
@label_genpos = glob("*.genpos.labels.txt")
    or die "No genpos.labels.txt file found\n";
#print "Successfully found genpos file: $label_genpos[0]\n";

# Reference Sequence File
# There should be only one reference file
@reference_file = glob("*.ref.fasta")
    or die "No ref.fasta file found\n";

# Individual RA sequence from popgen calller
# Change directory to PopGenCaller
chdir "$dirname/PopGenCaller" 
    or die "Cannot change to directory $dirname/BaseCaller\n";
@fasta_files = glob("*.popgen.fasta")
    or die "No popgen fasta files found. Check directory!\n";
#print "Successfully found popgen files: @fasta_files\n";

# Make directory to output results
mkdir "$dirname/Hapmap_Results";
chdir "$dirname/Hapmap_Results" 
    or die "Cannot change to directory Hapmap_Results\n";
# Remove old compare.txt files
unlink glob("*compare.txt");
unlink glob("*.compare.data.txt");
unlink glob("*noracall.txt");
unlink glob("*hap_ne_ra.txt");

# Genotypes from hapmap individual
# Change directory to Hapmap_Data
chdir "$dirname/Hapmap_Data" 
    or die "Cannot change to directory Hapmap_Data\n";
@hapmap_files = glob("*.hapmap.txt") 
    or die "No hapmap.txt file found. Check directory!\n";
#print "Successfully found HapMap files: @hapmap_files\n";

# Reset to original working directory
chdir "$dirname\n";
print "$dirname\n";

# Process genpos.labels.txt File
Process_Genpos_With_Labels();

# Loop over all fasta files - contained in array @fasta_files
foreach $process_fasta_file (@fasta_files) {
    print "##################################################################\n";
    print "Processing fasta file: $process_fasta_file\n";
    print "##################################################################\n";
    $file_name = $process_fasta_file;
    $sample_name = substr($process_fasta_file, 0, 7);
    Process_Fasta_Files($reference_file[0], $process_fasta_file, $start_dir);
}


# Process compare.txt files to calculate summary statistics
# Count total bases called and calculate discrepancy rate
chdir "$start_dir/Hapmap_Results";

# Collect names of all compare.txt files
@compare_files = glob("*_compare.txt");

#Make output file for HapMap call ne to RA call
foreach my $process_comp (@compare_files) {
    #print "Processing file: $process_comp\n";
    # Open file containing Reference, RA and HapMap comparison data
    open(FILEHANDLE_SIXTH, $process_comp)
        or die "Cannot open FILEHANDLE_SIXTH for compare.txt file analysis\n";
    # Output file to capture RA no calls
    open(OUT_HAP_NE_RA_CALL, ">", "$process_comp" . ".hap_ne_ra" . ".txt")
        or die "Cannot open OUT_COMPARE_DATA for output of comparison data";
        
    print OUT_HAP_NE_RA_CALL "Fasta Label\tFragment Position\tFasta Start\tFasta End\tSNP Location\tRef Seq\tHapmap Call\tRA Call\n";
    
    while (<FILEHANDLE_SIXTH>) {
        chomp $_;
        if ($_ =~ /^>/) {
            @temp_compare = split (/\t/,$_);
            if ($temp_compare[6] ne $temp_compare[7]) {
                print OUT_HAP_NE_RA_CALL "$_\n";
            }
        }
    }
    @temp_compare = "";
    close(FILEHANDLE_SIXTH);
    close(OUT_HAP_NE_RA_CALL);
}


#Make output file for HapMap call, no RA call
foreach my $process_comp (@compare_files) {
    # Open file containing Reference, RA and HapMap comparison data
    open(FILEHANDLE_FIFTH, $process_comp)
        or die "Cannot open FILEHANDLE_FIFTH for compare.txt file analysis\n";
    # Output file to capture RA no calls
    open(OUT_NO_RA_CALL, ">", "$process_comp" . ".noracall" . ".txt")
        or die "Cannot open OUT_COMPARE_DATA for output of comparison data";
    print OUT_NO_RA_CALL "Fasta Label\tFragment Position\tFasta Start\tFasta End\tSNP Location\tRef Seq\tHapmap Call\tRA Call\n";
    
    while (<FILEHANDLE_FIFTH>) {
        chomp $_;
        @temp_compare = "";
        if ($_ =~ /^>/) {
            @temp_compare = split (/\t/,$_);
            if ($temp_compare[7] eq "N" && ($temp_compare[6] ne "N")) {
                print OUT_NO_RA_CALL "$_\n";
            }
        }
    }
    close(FILEHANDLE_FIFTH);
    close(OUT_NO_RA_CALL);
}

# Outputs HapMap and RA comparison data
open(OUT_COMPARE_DATA, ">", "summary.compare.data.txt")
    or die "Cannot open OUT_COMPARE_DATA for output of comparison data";

# Outputs HapMap and RA discrepancies
open(OUT_DISCREP_DATA, ">", "summary.discrep.data.txt")
    or die "Cannot open OUT_COMPARE_DATA for output of discrepancy data";

# Print out individual file header information
print OUT_COMPARE_DATA "File Name\t";
print OUT_COMPARE_DATA "HapMap call equals RA call\t";
# Detailed accounting of type of HapMap - RA match
print OUT_COMPARE_DATA "Match call is het\t";
print OUT_COMPARE_DATA "Match call is homo\t";
print OUT_COMPARE_DATA "HapMap call does not equal RA call\t";
# Detailed account of type of HapMap - RA discrepancy
print OUT_COMPARE_DATA "HapMap call het, RA call homo\t";
print OUT_COMPARE_DATA "HapMap call homo, RA call het\t";
print OUT_COMPARE_DATA "HapMap call homo, RA call homo\t";
print OUT_COMPARE_DATA "HapMap call het, RA call het\t";
print OUT_COMPARE_DATA "HapMap call, RA nocall\t";
print OUT_COMPARE_DATA "HapMap calls het, RA nocall\t";
print OUT_COMPARE_DATA "HapMap calls homo, RA nocall\t";
print OUT_COMPARE_DATA "HapMap nocall, RA call\t";
print OUT_COMPARE_DATA "HapMap nocall, RA calls het\t";
print OUT_COMPARE_DATA "HapMap nocall, RA calls homo\t";
print OUT_COMPARE_DATA "HapMap nocall, RA nocall\n";

foreach my $process_compare (@compare_files) {
    # Open file containing RA and Hapmap comparison data
    open(FILEHANDLE_FOURTH, $process_compare)
        or die "Cannot open FILEHANDLE_FOURTH for compare.txt file analysis\n";
    
    # Output file name for discrepancy text
    print OUT_DISCREP_DATA "$process_compare\n";
    
    while (<FILEHANDLE_FOURTH>) {
        chomp($_);
        # Reset @temp_compare
        @temp_compare = "";
        # Choose lines for analysis
        if ($_ =~ /^>/) {
            @temp_compare = split (/\t/,$_);
            #print "@temp_compare\n";
            # Contents of @temp_compare
            # $temp_compare[0] = Fasta Label
            # $temp_compare[1] = Fragment Position
            # $temp_compare[2] = Fasta Start
            # $temp_compare[3] = Fasta End
            # $temp_compare[4] = SNP Location
            # $temp_compare[5] = Reference Sequence
            # $temp_compare[6] = HapMap Call
            # $temp_compare[7] = RA Call
            
            # Possible outcomes - count them all!
            # 1. Hapmap no call, RA no call
            # 1. Hapmap no call, RA call
            # 2. Hapmap call, RA no call
            # 3. RA call not equal to Hapmap call
            # 4. RA call equals Hapmap call
            # Sum for each file, and total over all files
            
            #print "Hapmap call: $temp_compare[4]\n";
            #print "RA call: $temp_compare[5]\n";
            
            # Hapmap no call, RA no call
            if (($temp_compare[6] eq "N") && ($temp_compare[7] eq "N")) {
                #increment file counter
                $hapmap_no_ra_no++;
                #increment total counter
                $total_hapmap_no_ra_no++;
                next;
            }
            # Hapmap no call, RA call
            elsif (($temp_compare[6] eq "N") && ($temp_compare[7] ne "N")) {
                #increment file counter
                $hapmap_no_ra_yes++;
                #increment total counter
                $total_hapmap_no_ra_yes++;
                
                # RA calls heterozygote
                if ($temp_compare[7] !~ m/A|C|G|T/) {
                    $hapmap_nocall_ra_het++;
                    $total_hapmap_nocall_ra_het++;
                }
                # RA calls homozygote
                if ($temp_compare[7] =~ m/A|C|G|T/) {
                    $hapmap_nocall_ra_homo++;
                    $total_hapmap_nocall_ra_homo++;
                }
                
                next;
            }
            # Hapmap call, RA no call
            elsif (($temp_compare[6] ne "N") && ($temp_compare[7] eq "N")) {
                #increment file counter
                $hapmap_yes_ra_no++;
                #increment total counter
                $total_hapmap_yes_ra_no++;
                
                # HapMap calls heterozygote
                if ($temp_compare[6] !~ m/A|C|G|T/) {
                    $hapmap_het_ra_nocall++;
                    $total_hapmap_het_ra_nocall++;
                    
                    # Collect actual discrepancies
                    print OUT_DISCREP_DATA "RA NOCALL\t";
                    for ($z = 0; $z < 8; $z++) {
                    print OUT_DISCREP_DATA "$temp_compare[$z]\t";
                    }
                    print OUT_DISCREP_DATA "\n";
                }
                # HapMap calls homozygote
                elsif ($temp_compare[6] =~ m/A|C|G|T/) {
                    $hapmap_homo_ra_nocall++;
                    $total_hapmap_homo_ra_nocall++;
                    
                    # Collect actual discrepancies
                    print OUT_DISCREP_DATA "RA NOCALL\t";
                    for ($z = 0; $z < 8; $z++) {
                    print OUT_DISCREP_DATA "$temp_compare[$z]\t";
                    }
                    print OUT_DISCREP_DATA "\n";
                }
                next;
            }
            # RA call not equal to Hapmap call
            elsif (($temp_compare[6] ne $temp_compare[7])) {
                #increment file counter for total discrepancies
                $hapmap_yes_ra_yes_ne++;
                #increment total counter for total discrepancies
                $total_hapmap_yes_ra_yes_ne++;
                # Determine nature of discrepancy
                # HapMap = heterozygote, RA = homozygote
                #print "$temp_compare[6]\t$temp_compare[7]\n";
                if (($temp_compare[6] !~ m/A|C|G|T/) && ($temp_compare[7] =~  m/A|C|G|T/)) {
                    $hapmap_het_ra_homo_ne++;
                    $total_hapmap_het_ra_homo_ne++;
                    
                    # Collect actual discrepancies
                    print OUT_DISCREP_DATA "DISCREPANCY\t";
                    for ($z = 0; $z < 8; $z++) {
                    print OUT_DISCREP_DATA "$temp_compare[$z]\t";
                    }
                    print OUT_DISCREP_DATA "\n";
                    
                }
                # HapMap = homozygote, RA = heterozygote
                elsif (($temp_compare[6] =~ m/A|C|G|T/) && ($temp_compare[7] !~  m/A|C|G|T/)) {
                    $hapmap_homo_ra_het_ne++;
                    $total_hapmap_homo_ra_het_ne++;
                    
                    # Collect actual discrepancies
                    print OUT_DISCREP_DATA "DISCREPANCY\t";
                    for ($z = 0; $z < 8; $z++) {
                    print OUT_DISCREP_DATA "$temp_compare[$z]\t";
                    }
                    print OUT_DISCREP_DATA "\n";
                    
                }
                # HapMap = homozygote, RA = heterozygote
                elsif (($temp_compare[6] =~ m/A|C|G|T/) && ($temp_compare[7] =~  m/A|C|G|T/)) {
                    $hapmap_homo_ra_homo_ne++;
                    $total_hapmap_homo_ra_homo_ne++;
                    
                     # Collect actual discrepancies
                    print OUT_DISCREP_DATA "DISCREPANCY\t";
                    for ($z = 0; $z < 8; $z++) {
                    print OUT_DISCREP_DATA "$temp_compare[$z]\t";
                    }
                    print OUT_DISCREP_DATA "\n";
                }
                # HapMap = homozygote, RA = heterozygote
                elsif (($temp_compare[6] !~ m/A|C|G|T/) && ($temp_compare[7] !~  m/A|C|G|T/)) {
                    $hapmap_het_ra_het_ne++;
                    $total_hapmap_het_ra_het_ne++;
                    
                     # Collect actual discrepancies
                    print OUT_DISCREP_DATA "DISCREPANCY\t";
                    for ($z = 0; $z < 8; $z++) {
                    print OUT_DISCREP_DATA "$temp_compare[$z]\t";
                    }
                    print OUT_DISCREP_DATA "\n";
                }
                next;
            }
            # RA call equals to Hapmap call
            elsif (($temp_compare[6] eq $temp_compare[7])) {
                #increment file counter
                $hapmap_yes_ra_yes_eq++;
                #increment total counter
                $total_hapmap_yes_ra_yes_eq++;
                # HapMap - RA Matching call is a heterozygote
                if ($temp_compare[6] !~ m/A|C|G|T/) {
                    $match_het++;
                    $total_match_het++;
                }
                # HapMap - RA Matching call is a homozygote
                if ($temp_compare[6] =~ m/A|C|G|T/) {
                    $match_homo++;
                    $total_match_homo++;
                }
                
                next;
            }
        }
    }
    close(FILEHANDLE_FOURTH);
    # Output header for file specific information
    print OUT_COMPARE_DATA "$process_compare\t";
    # Output file counter information
    # HapMap call matches RA call
    print OUT_COMPARE_DATA "$hapmap_yes_ra_yes_eq\t";
    # Detailed account of HapMap - RA Matches
    print OUT_COMPARE_DATA "$match_het\t";
    print OUT_COMPARE_DATA "$match_homo\t";    
    # HapMap call does not match RA call
    print OUT_COMPARE_DATA "$hapmap_yes_ra_yes_ne\t";
    # Detailed accounting of HapMap - RA discrepancy
    print OUT_COMPARE_DATA "$hapmap_het_ra_homo_ne\t$hapmap_homo_ra_het_ne\t$hapmap_homo_ra_homo_ne\t$hapmap_het_ra_het_ne\t";
    # HapMap call, no RA call
    print OUT_COMPARE_DATA "$hapmap_yes_ra_no\t";
    # Detailed account of type of HapMap call when no RA call
    print OUT_COMPARE_DATA "$hapmap_het_ra_nocall\t$hapmap_homo_ra_nocall\t";
    # No HapMap call, RA call
    print OUT_COMPARE_DATA "$hapmap_no_ra_yes\t";
    # Detailed account of type of RA call when no HapMap call
    print OUT_COMPARE_DATA "$hapmap_nocall_ra_het\t$hapmap_nocall_ra_homo\t";
    # No HapMap call, No RA call
    print OUT_COMPARE_DATA "$hapmap_no_ra_no\n";

    # Reset file counter information
    $hapmap_no_ra_no = 0;
    $hapmap_no_ra_yes = 0;
    $hapmap_yes_ra_no = 0;
    $hapmap_yes_ra_yes_ne = 0;
    $hapmap_yes_ra_yes_eq = 0;
    $hapmap_het_ra_homo_ne = 0;
    $hapmap_homo_ra_het_ne = 0;
    $hapmap_het_ra_nocall = 0;
    $hapmap_homo_ra_nocall = 0;
    $hapmap_nocall_ra_het = 0;
    $hapmap_nocall_ra_homo = 0;
    $match_het = 0;
    $match_homo = 0;
}

# Output total counter information
print OUT_COMPARE_DATA "\n";
print OUT_COMPARE_DATA "\t";
print OUT_COMPARE_DATA "Data Summary\n";

# Print header labels for Total Data
print OUT_COMPARE_DATA "\t";
print OUT_COMPARE_DATA "HapMap call equals RA call\t";
# Detailed accounting of type of HapMap - RA match
print OUT_COMPARE_DATA "Match call is het\t";
print OUT_COMPARE_DATA "Match call is homo\t";
print OUT_COMPARE_DATA "HapMap call does not equal RA call\t";
# Detailed account of type of HapMap - RA discrepancy
print OUT_COMPARE_DATA "HapMap call het, RA call homo\t";
print OUT_COMPARE_DATA "HapMap call homo, RA call het\t";
print OUT_COMPARE_DATA "HapMap call homo, RA call homo\t";
print OUT_COMPARE_DATA "HapMap call het, RA call het\t";
print OUT_COMPARE_DATA "HapMap call, RA nocall\t";
print OUT_COMPARE_DATA "HapMap calls het, RA nocall\t";
print OUT_COMPARE_DATA "HapMap calls homo, RA nocall\t";
print OUT_COMPARE_DATA "HapMap nocall, RA call\t";
print OUT_COMPARE_DATA "HapMap nocall, RA calls het\t";
print OUT_COMPARE_DATA "HapMap nocall, RA calls homo\t";
print OUT_COMPARE_DATA "HapMap nocall, RA nocall\n";


# Print out summary results
# Total HapMap call matches RA call
print OUT_COMPARE_DATA "\t";
print OUT_COMPARE_DATA "$total_hapmap_yes_ra_yes_eq\t";
print OUT_COMPARE_DATA "$total_match_het\t";
print OUT_COMPARE_DATA "$total_match_homo\t";
# Total HapMap call does not match RA call
print OUT_COMPARE_DATA "$total_hapmap_yes_ra_yes_ne\t";
# Total Detailed accounting of HapMap - RA discrepancy
print OUT_COMPARE_DATA "$total_hapmap_het_ra_homo_ne\t$total_hapmap_homo_ra_het_ne\t$total_hapmap_homo_ra_homo_ne\t$total_hapmap_het_ra_het_ne\t";
# Total HapMap call, no RA call
print OUT_COMPARE_DATA "$total_hapmap_yes_ra_no\t";
# Total Detailed account of type of HapMap call when no RA call
print OUT_COMPARE_DATA "$total_hapmap_het_ra_nocall\t$total_hapmap_homo_ra_nocall\t";
# Total No HapMap call, RA call
print OUT_COMPARE_DATA "$total_hapmap_no_ra_yes\t";
# Total Detailed account of type of RA call when no HapMap call
print OUT_COMPARE_DATA "$total_hapmap_nocall_ra_het\t$total_hapmap_nocall_ra_homo\t";
# Total No HapMap call, No RA call
print OUT_COMPARE_DATA "$total_hapmap_no_ra_no\n";

print "Completed RA_compare_hapmap.pl version $version script\n";
exit;

##############################################################################
### Subroutines
##############################################################################

# Purpose
#   Make three arrays that have the fast label, fasta start, and fasta end
#
# Required Parameters
#
# Optional Parameters
#   none
#
# Side Effects
#   none
#
# Assumptions
#   1. A special genpos file exists in BaseCaller directory
#   2. The file's name ends in *.genpos.labels.txt
#   3. The file contains the fasta label identical to that in the RA generated
#   popgen fasta file. If they do not match, the code will fail 
#   (error accessing a hash with no correct keys).
#
sub Process_Genpos_With_Labels {
    # Read in label.genpos information
    # Make three arrays that have the fasta label, fasta start
    # Needs to be turned into a subroutine - called once
    # Reset to original working directory
    chdir "$start_dir";
    
    foreach my $process_label_genpos (@label_genpos) {
        print "Processing label_genpos.txt file: $process_label_genpos\n";
        
        open(FILEHANDLE_SECOND, $process_label_genpos)
            or die "Cannot open FILEHANDLE_SECOND - for genpos.txt file";
            
        while (<FILEHANDLE_SECOND>) {
            chomp($_);
            # Split genpos line, label(0), start(1), end(2)
            @temp_genpos = split('\t',$_);
            #print OUT_FASTA_SEQUENCES "IN THE SECOND LOOP\n";
            #print OUT_FASTA_SEQUENCES "$temp_genpos[0]\t";
            #print OUT_FASTA_SEQUENCES "$temp_genpos[1]\t";
            #print OUT_FASTA_SEQUENCES "$temp_genpos[2]\n";
            # Move values into arrays
            push (@genpos_name, $temp_genpos[0]);
            push (@genpos_start, $temp_genpos[1]);
            push (@genpos_end, $temp_genpos[2]);
            # Reset @genpos_temp array
            @temp_genpos = ();
        }
        close(FILEHANDLE_SECOND);
        # Determine number of lines\fragments in label_genpos file
        $nmbr_genpos_name = ($#genpos_name + 1);
        $nmbr_genpos_start = ($#genpos_start + 1);
        $nmbr_genpos_end = ($#genpos_start + 1);
        #print OUT_FASTA_SEQUENCES "Number of names is $nmbr_genpos_name\n";
        #print OUT_FASTA_SEQUENCES "Number of starts is $nmbr_genpos_start\n";
        #print OUT_FASTA_SEQUENCES "Number of ends is $nmbr_genpos_end\n";
    }
}

sub Process_Fasta_Files {

$process_ref_file =  $_[0];
$process_fasta_file = $_[1];
$start_dir = $_[2];

print "\n";
print "Entering Process_Fasta_Files subroutine\n";
print "File being processed: $process_fasta_file\n";
print "Reference file being processed: $reference_file[0]\n";
#print "Starting directory: $start_dir\n";

# Change directory to PopGenCaller
chdir "$start_dir" 
    or die "Cannot change to directory $start_dir\n";

# Make hash for reference fasta file relating fasta name to sequence
open(FILEHANDLE_REFERENCE, $process_ref_file)
    or die "Cannot open FILEHANDLE_REFERENCE - for fasta file";
    while (<FILEHANDLE_REFERENCE>) {
        chomp($_);
        if($_ =~ />/) {
            if($count > 0) {
                # Make hash relating fasta label with sequence
                # (from previous loop through)
                $ref_fasta_info{ $temp_label[0] } = $temp_seq;
                #print "$temp_label[0]\n$fasta_info{$temp_label[0]}\n";
            }
            # Reset variables
            $temp_seq = "";
            @temp_label = ();
            $count++;
            # Push fasta label onto temporary array
            push (@temp_label, $_);
            # Use array fasta_labels later to sort
            push (@ref_fasta_labels, $_);
        }
        else {
        # Read DNA sequence into string
        $temp_seq .= $_;
        }
    }
    # Process last fasta fragment to hash
    $ref_fasta_info{ $temp_label[0] } = $temp_seq;
    
# Reset variables
$temp_seq = "";
@temp_label = ();
$count = 0;
close(FILEHANDLE_REFERENCE);


# Change directory to PopGenCaller
chdir "$start_dir/PopGenCaller"
    or die "Cannot change to directory $dirname/PopGenCaller\n";

# Make hash for RA fasta file relating fasta name to sequence
open(FILEHANDLE_FIRST, $process_fasta_file)
    or die "Cannot open FILEHANDLE_FIRST - for fasta file";
    while (<FILEHANDLE_FIRST>) {
        chomp($_);
        if($_ =~ />/) {
            if($count > 0) {
                # Make hash relating fasta label with sequence
                # (from previous loop through)
                #print "$temp_seq\n";
                #print "$temp_label[0]\n";
                $fasta_info{ $temp_label[0] } = $temp_seq;
                #print "$temp_label[0]\n$fasta_info{$temp_label[0]}\n";
            }
            # Reset variables
            $temp_seq = "";
            @temp_label = ();
            $count++;
            # Push fasta label onto temporary array
            push (@temp_label, $_);
            # Use array fasta_labels later to sort
            push (@fasta_labels, $_);
        }
        else {
        # Read DNA sequence into string
        $temp_seq .= $_;
        }
    }
    # Process last fasta fragment to hash
    $fasta_info{ $temp_label[0] } = $temp_seq;
    
# Reset variables
$temp_seq = "";
@temp_label = ();
$count = 0;
close(FILEHANDLE_FIRST);


# Open file to output sequence information
chdir "$start_dir/Hapmap_Results";
open(OUT_FASTA_SEQUENCES, ">", "$file_name" . '.seq_compare.txt')
    or die "Cannot open OUT_FASTA_SEQUENCES for sequence output";

# Change directory to Hapmap_Data
chdir "$start_dir/Hapmap_Data"
    or die "Cannot change to directory Hapmap_Data\n";

# Debugging code
# print "Sample name to match Hapmap files: $sample_name\n";


# Identify matching HapMap files (look over all HapMap files)

foreach my $process_hapmap (@hapmap_files) {
    
    # print "Working with hapmap file $process_hapmap\n";
    
    if (substr($process_hapmap, 0, 7) eq $sample_name) {
        print "Processing hapmap.txt file: $process_hapmap\n\n";
        open(FILEHANDLE_THIRD, $process_hapmap)
            or die "Cannot open FILEHANDLE_THIRD - for hapmap.txt file";
        print OUT_FASTA_SEQUENCES "Fasta Label\tFragment Position\tFasta Start\tFasta End\tSNP Location\tRef Seq\tHapmap Call\tRA Call\n";

        while(<FILEHANDLE_THIRD>) {
            chomp($_);
            # Split hapmap line for testing: Values are SNP position(0), SNP genotype(1)
            @temp_hapmap = split('\t',$_);

            # Determine if SNP is in RA region
            for($i = 0; $i < $nmbr_genpos_name; $i++) {

                # SNP overlaps RA sequence
                if ( ($temp_hapmap[0] >= $genpos_start[$i]) 
                    && ($temp_hapmap[0] <= $genpos_end[$i])) {

                #print "$genpos_name[$i]\n";
                #print "$fasta_info{$genpos_name[$i]}\n";
                
                # Get the RA sequence and split it, do the same for the reference sequence
                @temp_ra_seq = split( '',$fasta_info{$genpos_name[$i]});
                @temp_ref_seq = split('',$ref_fasta_info{$genpos_name[$i]});
                $temp_location = (($temp_hapmap[0] - $genpos_start[$i]));
                # Correct for first 12 bases not on array
                $corrected_temp_location = $temp_location + 12;
                print OUT_FASTA_SEQUENCES "$genpos_name[$i]\t$corrected_temp_location\t$genpos_start[$i]\t$genpos_end[$i]\t$temp_hapmap[0]\t$temp_ref_seq[$temp_location]\t$temp_hapmap[1]\t$temp_ra_seq[$temp_location]\n";
                }
                else {
                    next;
                }
            # Reinitialize array
            #@temp_hapmap = ();
            }
        }
        close(FILEHANDLE_THIRD);
    }
    else {
        # Name of sample does not match - check for next hapmap file name
        # print "\n";
        # print "Searching for fasta file: $process_fasta_file\n";
        # print "Current hapmap file: $process_hapmap\n";
        # print "Did not find matching HapMap file\n";
        # print "\n";
        next;
    }

# Return to starting directory
chdir "$start_dir";
print "Leaving the Process_Fasta_File subroutine\n\n";

$dirname = getcwd();
#print "\n";
#print "Directory at end of Process_Fasta_Files is: $dirname\n";
#print "\n";
close(OUT_FASTA_SEQUENCES);
}
}
