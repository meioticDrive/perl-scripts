#!/usr/bin/perl -w
# RA_accu_compare_ref_parse_out.pl
# Version 1.0
# Michael E. Zwick
# 01/10/07
# Program designed to take read the output of RA_accu_compare_ref_Basecaller.pl
# (filename: accuracy.discrepancy.count) and extract summary data for subsequent 
# analysis. Put the output into a text file named accuracy.discrepancy.summary.txt 
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
use strict;
#use Bio::Perl;
#use Bio::SeqIO;

#-------------------------------------------------------------------------------
# Local variable definitions
#-------------------------------------------------------------------------------
# Define local variable for composite seq functions

my(@experimental_files, $exp_file_number, $experiment_sequence, $experiment_sequence_size, @parameter_line, @parameter_values, $parameter_out, @grand_total, $grand_out, $i);

# Define local variables for localtime function
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);

#-------------------------------------------------------------------------------
# Initialize global variable values
#-------------------------------------------------------------------------------


# Get the name of the accuracy.discrepancy.count file
#-------------------------------------------------------------------------------
@experimental_files = glob("accuracy.discrepancy.count");
$exp_file_number = ($#experimental_files + 1);
print "Processing a total of $exp_file_number accuracy.discrepancy.count files\n\n";
if ($exp_file_number == 0) {
	die "$exp_file_number accuracy.discrepancy.count files detected.\n
		Check directory. Exiting program";
	}

# Open output file: accuracy.discrepancy.summary.txt
#---------------------------------------------------------------------------
open(OUT_COUNT, ">", "accuracy.discrepancy.summary.txt") 
	or die "Cannot open OUT_COUNT for data output";

# Process the accuracy.discrepancy.count file
#-------------------------------------------------------------------------------
foreach my $files (@experimental_files) {

	open(IN_ACCURACY, "<", "$files")
		or die "Cannot open FILEHANDLE_SECOND";

	while (<IN_ACCURACY>) {
		chomp($_);
	
		if ($_ =~ /^Parameter/) {
			@parameter_line = split( ':',$_);
			print OUT_COUNT "$parameter_line[0]\t";
			@parameter_values = split( '_',$parameter_line[1]);
			$parameter_out = join ( "\t", @parameter_values);
			print OUT_COUNT "$parameter_out\n";
			# Reset arrays
			@parameter_line = '';
			@parameter_values = '';
		}
	
		if ($_ =~ /^Grand/) {
			@grand_total = split( ':', $_);
			$grand_out = join ("\t", @grand_total);
			print OUT_COUNT "$grand_out";
			print OUT_COUNT "\n";
			# Reset array
			@grand_total = '';
		}
	}
}
print "Finished running the RA_accu_compare_ref_parse_out.pl";
