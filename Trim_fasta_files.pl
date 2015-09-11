#!/usr/bin/perl -w
##############################################################################
### Name: Trim_fasta_files.pl
### Version: 1.0
### Date: 08/12/2008
### Author: Michael E. Zwick
##############################################################################
### Program designed to read names of all .fasta files and then edit a fasta
### fragement.
### 1. Read the names of all .fasta files
### 
##############################################################################
use warnings;
use strict;
use Cwd;

# Global Variables
##############################################################################

my(@all_fasta_files, $file, $file_name, $count, $version, $dna_sequence, $sub_seq_size, $sub_sequence);

my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

$sub_seq_size = 22205;
$dna_sequence = "";
$sub_sequence = "";
$count = 0;
$version = "1.0";


##############################################################################
### Program Overview
### Read all fasta file names
### Modify files
### Rewrite files
##############################################################################

# Change to user provided directory
chdir "$ARGV[0]" 
	or die "Cannot change to directory $ARGV[0]\n";

system ("rm *.edit.fasta");

# Glob all .fasta files

#@all_fasta_files = glob("*.popgen.fasta")
#	or die "Did not find any files ending with *.popgen.fasta\n";

#@all_fasta_files = glob("*.final.fasta")
#	or die "Did not find any files ending with *.final.fasta\n";

@all_fasta_files = glob("*.fasta")
	or die "Did not find any files ending with *.ref.fasta\n";

# Edit fasta files

for $file_name (@all_fasta_files) {

    print "Working with file $file_name\n";
    
    # Open filehandle to read file input
    open(FILEHANDLE_FIRST, $file_name)
        or die "Cannot open FILEHANDLE_FIRST";

    # Open filehandle to output fasta file names
    open(OUT_FASTA_FILES, ">", "$file_name.edit.fasta")
        or die "Cannot open filehandle OUT_FASTA_FILES for data output";

    while (<FILEHANDLE_FIRST>) {
        chomp $_;
        
        if ($_ =~ /^>NMRC/) {
            
            # Condition for first label
            if ($count == 0) {
                #print "No sequence here \n";
                #print "DNA sequence in first loop is: $dna_sequence\n";
                print OUT_FASTA_FILES "$_\n";
                $count++;
                next;
            }
            # Condition for first fragment
            elsif ($count == 1) {
                $sub_sequence = substr($dna_sequence, 0, 22205);
                print OUT_FASTA_FILES "$sub_sequence\n";
                $sub_sequence = "";
                $dna_sequence = "";
                print OUT_FASTA_FILES "$_\n";
                $count++;
                next;
            }
            # Condition for later fragments
            elsif ($count > 1) {
                print OUT_FASTA_FILES "$dna_sequence\n";
                $dna_sequence = "";
                print OUT_FASTA_FILES "$_\n";
                $count++;
                next;
            }
        }
        # Collect DNA sequence lines into single string
        $dna_sequence .= $_;
    }
    
    print OUT_FASTA_FILES "$dna_sequence\n";
    $dna_sequence = "";
    $count = 0;
    close (OUT_FASTA_FILES);
    close (FILEHANDLE_FIRST);
}

print "Completed Trim_fasta_files.pl script version $version\n";






