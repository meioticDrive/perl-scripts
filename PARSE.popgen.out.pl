#!/usr/bin/perl -w
# Version 1.0
# Michael E. Zwick
# 12/16/2010
####################################################################################
# Program designed to:
# 1. Parse genetic variation information from a Cutler popgen output file
####################################################################################
use strict;
use Cwd;

####################################################################################
# Local variable definitions
####################################################################################
# Define local variables
my(@popgen_file, $popgen_file_number);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

# Initialize variables
@popgen_file = ();
$popgen_file_number = 0;

####################################################################################
# Program Overview
####################################################################################

# Remove old files
unlink("log.parse.popgen.out.txt");
unlink("popgen.parsed.txt");

# Open for output of log files
open(OUT_LOG, ">>", "log.parse.popgen.out.txt")
	or die "Cannot open OUT_LOG for data output";

# Obtain name of popgen files
@popgen_file = glob("*.popgen.txt");
$popgen_file_number = ($#popgen_file + 1);
if ($popgen_file_number == 0) {
	die "$popgen_file_number fasta files detected.\n
		Check directory. Exiting program";
}

# Output information to log file
print "Detected $popgen_file_number primer files";
print OUT_LOG "Detected $popgen_file_number primer files";

for (my $i = 0; $i < $popgen_file_number; $i++) {
	print OUT_LOG "$popgen_file[$i]\n";
	print OUT_LOG "Processing popgen file\n";
	print "Processing popgen files\n";
}

# Open output file for parsed primers
open (OUT_ANNOT, ">>", "popgen.parsed.txt")
	or die "Cannot open OUT_ANNOT filehandle to parsed output file info";

# Process primer files
foreach my $files (@popgen_file) {

    # Open $files to be read
    open (IN_ANNOT, "<", "$files")
	    or die "Cannot open IN_ANNOT filehandle to read file";
	    
	# Read in the fasta fragments from file
	while (<IN_ANNOT>) {
		
		# Total Sites
		if ($_ =~ /^Total Region Overall Bases Called/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Total Region All Sites/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Total Region Transitions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Total Region Transversions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Total Region Number of sites with/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		
		# Replacement Sites
		if ($_ =~ /^Replacement Overall Bases Called/) {
		  # Print out selected line
		  print OUT_ANNOT "\n";
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Replacement All Sites/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Replacement Transitions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Replacement Transversions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Replacement Number of sites with/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		  
		# Silent Sites
		if ($_ =~ /^Silent Overall Bases Called/) {
		  print OUT_ANNOT "\n";
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Silent All Sites/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Silent Transitions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Silent Transversions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Silent Number of sites with/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		  
		# Intergenic
		if ($_ =~ /^Intergenic Overall Bases Called/) {
		  print OUT_ANNOT "\n";
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Intergenic All Sites/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Intergenic Transitions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Intergenic Transversions/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
		if ($_ =~ /^Intergenic Number of sites with/) {
		  # Print out selected line
		  print OUT_ANNOT $_;
		}
	}
}

close (IN_ANNOT);
close (OUT_ANNOT);
print OUT_LOG "Completed PARSE.popgen.out.pl program.\n";
close (OUT_LOG);
print "Completed PARSE.popgen.out.pl program.\n";