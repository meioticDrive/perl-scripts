#!/usr/bin/perl
# Updated by Michael Zwick on 10/18/2012
# Added code to process multiple GLAD breakpoint files in a folder
# Launch program from within directory containing files

use warnings;
#use strict;
use Cwd;

my ($j, $i, $k, $f, $l, $dirname, @temp, @sort, $sort, @lines, @a_fields, @b_fields, @sorted_lines, $sample, $norm, $file_523, $file_635, @chr6, @chr7, @chr8, @chr9, @chr10, @chr11, @chr12, @chr13, @chr14, @chr15, @chr16, @chr17, @sorted);
my ($start, $stop, @chr20, @chr21, @lines_23, @chrX, @chrY, $file_532, $ratio, $intensity);
my ($size, $LR, @pair1, @pair2, $pair1, $pair2, @line_635, @line_532, $line_635, $line_532, $name, $norm2, $norm3);
my (@data_files, $data_file_nmbr, @temp_sample_ID, @sample_ID);

# Glob file names of all chr10 breakpoint files
####################################################################################################
@data_files = glob("*chr10*");
$data_file_nmbr = ($#data_files + 1);
if ($data_file_nmbr == 0) {
  die "Detected $data_file_nmbr *chr10* files.\n Check directory. Exiting program";
}
print "Loaded all chr10 files into memory to get unique file names\n";

# Collect unique sample IDs in array @sample_ID
foreach my $data_name (@data_files) {
	@temp_sample_ID = split('.chr', $data_name);
	# Add file name to array
	push @sample_ID, $temp_sample_ID[0]; 
	@temp_sample_ID = ();
}

# Loop over file names and assign to $sample and $name
foreach my $samp (@sample_ID) {
print "\nProcessing sample $samp\n\n\n";

$dirname = ".";
$sample = $samp;
$name = $samp;

#$sample = $ARGV[0];
#$name = $ARGV[0];
#$norm2 = $ARGV[2];
#$norm3 = $ARGV[3];

#$file_532 = $ARGV[2];
#$file_635 = $ARGV[3];

#This file takes the individual chromosome breakpoint files after GLAD analysis 
#and sews them together into one file.

$j = 1;
$size = 10000000;
$LR = 0.2;
open (ACCEPT_BREAKPOINT, ">>$name.GLAD_breakpoint.txt");
open (REJECT_BREAKPOINT, ">>$name.GLAD_breakpoint_reject.txt");

####################################################################################################
## CHR1
####################################################################################################
open (CHR1, "$sample.chr1_breakpoint.txt");
@lines = <CHR1>;
$k = @lines;
print "chr1 k is $k\n";
$j = 1;
@temp = split('\t',$lines[$j]);

#####Chr 1 starts copy number 2

if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
			print "j is $j and temp is @temp\n";
		
			if ( ($j == ($k - 1) ) and ($temp[10] == 0) )  {
			print "entered this loop: j is $j and K is $k\n";
			print "line is $lines[$j]\n";
			$start = $temp[2];
			$stop = 247190999;
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere";
				}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere";
					}
					}

		$stop = $temp[2];
		if ($temp[10] != 0)  {
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
				}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
				}
				}
		$start = $stop;
		
		}
		}

#####Chr 1 starts Copy number other than 2 


if ($temp[10] != 0)  {
	$start = 51586;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
				}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
				}
				}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
			if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
			print "line is $lines[$j]\n";
			$start = $temp[2];
			$stop = 247190999;
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere";
				}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere";
					}
					}
		$stop = $temp[2];
		if ($temp[10] != 0)  {
		if ( ($stop - $start < $size) and (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
				}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
				}
				}
				}
	

	close (CHR1);
	
	
#####CHR2#####
	
open (CHR2, "$sample.chr2_breakpoint.txt");
@lines = <CHR2>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
	
		
			if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
			print "line is $lines[$j]\n";
			$start = $temp[2];
			$stop = 242738117;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}

			$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 2772;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);

	
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 242738117;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}

			$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}

	}
	}

	
	close (CHR2);
	
#####CHR3#####
	
open (CHR3, "$sample.chr3_breakpoint.txt");
@lines = <CHR3>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		
			if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
			print "line is $lines[$j]\n";
			$start = $temp[2];
			$stop = 199380402;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}

		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 35333;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 199380402;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}

	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
	}
	}
	
	
	close (CHR3);
	
	
#####CHR4#####
	
open (CHR4, "$sample.chr4_breakpoint.txt");
@lines = <CHR4>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		
			if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
			print "line is $lines[$j]\n";
			$start = $temp[2];
			$stop = 191254119;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}

		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
			}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 2269;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 191254119;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}

	$stop = $temp[2];
	if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
	}
	}
	
	
	close (CHR4);
	
#####CHR5#####
	
open (CHR5, "$sample.chr5_breakpoint.txt");
@lines = <CHR5>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 180652396;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}

		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 68520;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 180652396;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
	if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
	}
	}

	
	close (CHR5);
	
#####CHR6#####
	
open (CHR6, "$sample.chr6_breakpoint.txt");
@lines = <CHR6>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 170824447;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 94649;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 170824447;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
	}
	}

	
	close (CHR6);
	
#####CHR7#####
	
open (CHR7, "$sample.chr7_breakpoint.txt");
@lines = <CHR7>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 158812469;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 52899;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 158812469;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR7);
	
#####CHR8#####
	
open (CHR8, "$sample.chr8_breakpoint.txt");
@lines = <CHR8>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 146268947;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 36386;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 146268947;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}


	
	close (CHR8);
	
#####CHR9#####
	
open (CHR9, "$sample.chr9_breakpoint.txt");
@lines = <CHR9>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 140211203;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 30910;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 140211203;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}


	
	close (CHR9);
	
#####CHR10#####
	
open (CHR10, "$sample.chr10_breakpoint.txt");
@lines = <CHR10>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 135356682;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 62797;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 135356682;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
		}
	}


	
	close (CHR10);
	
#####CHR11#####
	
open (CHR11, "$sample.chr11_breakpoint.txt");
@lines = <CHR11>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 134449982;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 188510;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 134449982;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}

	
	close (CHR11);
	
#####CHR12#####
	
open (CHR12, "$sample.chr12_breakpoint.txt");
@lines = <CHR12>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 132288250;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 20691;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 132288250;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR12);
	
#####CHR13#####
	
open (CHR13, "$sample.chr13_breakpoint.txt");
@lines = <CHR13>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 114126487;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 17943628;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 114126487;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR13);
	
#####CHR14#####
	
open (CHR14, "$sample.chr14_breakpoint.txt");
@lines = <CHR14>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 106356482;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 18072112;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 106356482;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR14);
	
#####CHR15#####
	
	open (CHR15, "$sample.chr15_breakpoint.txt");
@lines = <CHR15>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 100276767;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 18276329;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 100276767;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR15);
	
#####CHR16#####
	
	open (CHR16, "$sample.chr16_breakpoint.txt");
@lines = <CHR16>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 88815024;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 765;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 88815024;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	
	$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR16);
	
#####CHR17#####
	
open (CHR17, "$sample.chr17_breakpoint.txt");
@lines = <CHR17>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 78643088;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 514;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 78643088;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR17);
	
#####CHR18#####
	
open (CHR18, "$sample.chr18_breakpoint.txt");
@lines = <CHR18>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 76116029;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 1543;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 76116029;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR18);
	
	
#####CHR19#####
	
open (CHR19, "$sample.chr19_breakpoint.txt");
@lines = <CHR19>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 63789654;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 41898;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 63789654;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR19);
	
#####CHR20#####
	
open (CHR20, "$sample.chr20_breakpoint.txt");
@lines = <CHR20>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 62426585;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 9293;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 62426585;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	
	$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR20);
	
#####CHR21#####
	
open (CHR21, "$sample.chr21_breakpoint.txt");
@lines = <CHR21>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 46921373;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 9758730;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 46921373;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	

	
	close (CHR21);
	
#####CHR22#####
	
open (CHR22, "$sample.chr22_breakpoint.txt");
@lines = <CHR22>;
$k = @lines;
$j = 1;
@temp = split('\t',$lines[$j]);
if ($temp[10] == 0)  {
		$start = $temp[2];
		while ($j < $k)  {
		$j = $j + 1;
		@temp = split('\t',$lines[$j]);
		
		if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 49581309;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
		
		
		$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
				}
		$start = $stop;
		}
		}
		
if ($temp[10] != 0)  {
	$start = 14435171;
	$stop = $temp[2];
	if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
					}
	while ($j < $k)  {
	$start = $stop;
	$j = $j + 1;
	@temp = split('\t',$lines[$j]);
	
	if ( ($j == ($k - 1)) and ($temp[10] == 0) )  {
		print "line is $lines[$j]\n";
		$start = $temp[2];
		$stop = 49581309;
		if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
		print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
			}
		else {
		print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t99\ttelomere\n";
					}
					}
	
	$stop = $temp[2];
	#$j = $j + 1;
	#@temp = split('\t',$lines[$j]);
	#$stop = $temp[2];
		if ($temp[10] != 0)  {
			if ( ($stop - $start < $size) & (abs($temp[9]) > $LR) ) {
			print ACCEPT_BREAKPOINT "$name\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
			else {
			print REJECT_BREAKPOINT "$sample\t$temp[3]\t$start\t$stop\t$temp[9]\t$temp[10]\n";
					}
							}
	}
	close (CHR22);
	
	close(ACCEPT_BREAKPOINT);
	close(REJECT_BREAKPOINT);

}





