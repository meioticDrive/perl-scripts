#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 4/27/09
# Program designed to:
# 1. Run over a primer file and output a header line, primer postions,
# and primer selection information.
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
use strict;
use Cwd;
#-----------------------------------------------------------------------------
# Local variable definitions
#-----------------------------------------------------------------------------
# Define local variables

my(@primer_file, $primer_file_number, @temp_primer_start, $fragment_size);


#(fasta_file, $fasta_file_number, @reverse_fasta_file, $reverse_fasta_file_number, $file_to_process, $files, @fasta_file_data, $fasta_file_data_number, @lines, $fasta_temp, $count, @temp, $temp_DNA_seq, $true_array_size, $start_fragment, $end_fragment, $temp_start_fragment, $temp_end_fragment, $genomic_region, $file_count);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@primer_file = ();
$primer_file_number = 0;
$fragment_size = 0;

#-----------------------------------------------------------------------------# Program Overview:
# Start in a folder containing a set of .fasta and .reverse.fasta files
# Read in the names of all the files
#-----------------------------------------------------------------------------

# Open for output of log files
open(OUT_LOG, ">>", "log.parse_primer.out")
	or die "Cannot open OUT_FASTA for data output";
	
# Obtain name of primer files files
@primer_file = glob("*done.txt");
$primer_file_number = ($#primer_file + 1);
if ($primer_file_number == 0) {
	die "$primer_file_number fasta files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $primer_file_number primer files";
print OUT_LOG "Detected $primer_file_number primer files";

for (my $i = 0; $i < $primer_file_number; $i++) {
	print OUT_LOG "$primer_file[$i]\n";
	print OUT_LOG "Processing primer file\n";
	print "Processing fasta files\n";
}
	
# Open output file for parsed primers
open (OUT_ANNOT, ">>", "primers.parsed.txt")
	or die "Cannot open OUT_ANNOT filehandle to output file info";

# Output Header Labels
print OUT_ANNOT "Product Start\tProduct End\t5' Forward Site 3'\t5' Reverse Site 3\tSize\tForward tm\tReverse tm\tForward Start Position\tForward End Position\tReverse Start\tReverse End\n";

# Process primer files
foreach my $files (@primer_file) {

    # Open $files to be read
    open (IN_ANNOT, "<", "$files")
	    or die "Cannot open IN_ANNOT filehandle to read file";
	    
	# Read in the fasta fragments from file
	while (<IN_ANNOT>) {
		chomp($_);
		
		if ($_ =~ /^[A,C,G,T][A,C,G,T][A,C,G,T][A,C,G,T][A,C,G,T]/) {
		    @temp_primer_start = split('\t',$_);
		    $fragment_size = ($temp_primer_start[7] - $temp_primer_start[4]);
            print OUT_ANNOT "$temp_primer_start[4]\t$temp_primer_start[5]\t$temp_primer_start[0]\t$temp_primer_start[2]\t$fragment_size\t$temp_primer_start[1]\t$temp_primer_start[3]\t$temp_primer_start[4]\t$temp_primer_start[5]\t$temp_primer_start[6]\t$temp_primer_start[7]\n";
        }
		# Clear/increment variables and arrays
		@temp_primer_start = ();

	}
}

close (IN_ANNOT);
close (OUT_ANNOT);
print OUT_LOG "Completed parse_primer_file.pl program.\n";
close (OUT_LOG);
print "Completed parse_primer_file.pl program.\n";








































