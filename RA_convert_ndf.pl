#!/usr/bin/perl -w
##############################################################################
###
### ndf.pl
###
### program to rename the sequence_id in an NDF file based on the probe
### position and it's associated range.
###
### Usage: ndf.pl <regions file> <ndf file>
###
##############################################################################

use strict;
use Carp;

##############################################################################
### Constants
##############################################################################

use constant FALSE => 0;
use constant TRUE  => 1;

##############################################################################
### Globals
##############################################################################

my %hPosition = ();
my @aRegions = ();
my ($sRegionsFile, $sNdfFile);

##############################################################################
### Main
##############################################################################

if ($#ARGV != 1) {
	print "Usage: $0 <regions file> <ndf file>\n";
	exit 1;
}

($sRegionsFile, $sNdfFile) = @ARGV;

my $nX = Read_Regions_File(\@aRegions, $sRegionsFile);
print "Number of regions: $nX\n";

$nX = Construct_Position_Hash(\%hPosition, \@aRegions);
print "Number of positions: $nX\n";

Process_NDF_File(\%hPosition, \@aRegions, $sNdfFile);

exit;

##############################################################################
### Subroutines
##############################################################################

sub Read_Regions_File {
	# reads the specified regions file, stores data in an array passed in via
	# parameter list, returns number of records read
	#
	# Assumed data format is:
	# CHROMOSOME START STOP
	#
	# Assumed START < STOP for all regions
	#
	my $paRegions = shift;
	my $sFileName = shift;

	my $nNumRecs = 0;

	($_, $_, $_, my $sSubName) = caller(0);

	if (! ((defined $paRegions) && (defined $sFileName))) {
		croak "$sSubName - required parameters missing\n";
	}

	open(FP,"<$sFileName") || 
		croak "$sSubName - Cannot open $sFileName for reading\n";

	while (<FP>) {
		my ($sChromosome, $nStart, $nStop) = split;

		(defined $sChromosome) ? $nNumRecs++ : next;

		my $rec = {	
			CHROMOSOME => $sChromosome,
			START      => $nStart,
			STOP       => $nStop,
		};

		@$paRegions[$nNumRecs-1] = $rec;
	}
	
	close(FP);

	return $nNumRecs;
}

sub Construct_Position_Hash {
	# constructs a hash with all positions within all the regions, stores
	# data in hash passed in via parameter list, returns the number of
	# positions
	#
	my $phPosition = shift;
	my $paRegions = shift;

	my $nNumPos = 0;

	($_, $_, $_, my $sSubName) = caller(0);

	if (! ((defined $phPosition) && (defined $paRegions))) {
		croak "$sSubName - required parameters missing\n";
	}

	for (my $nIndex = 0; $nIndex < scalar(@$paRegions); $nIndex++) {
		my $nStart = @$paRegions[$nIndex]->{START};
		my $nStop = @$paRegions[$nIndex]->{STOP};

		for (my $nPos = $nStart; $nPos <= $nStop; $nPos++) {
			$phPosition->{$nPos} = $nIndex;
		}

		$nNumPos += (($nStop - $nStart) + 1);
	}

	return $nNumPos;
}

sub Process_NDF_File {
	# reads an NDF file one record at a time and renames the sequence_id based
	# on the probe position
	#
	# Assumes NDF file has 17 fields per line separated by tabs
	#
	my $phPosition = shift;
	my $paRegions = shift;
	my $sFileName = shift;

	my $SEQIDCOL = 4; # actually 5 but arrays start at 0 in Perl
	my $POSITIONCOL = 13;

	my %hNewID = ();

	($_, $_, $_, my $sSubName) = caller(0);

	if (! ((defined $phPosition) && 
		   (defined $paRegions) &&
		   (defined $sFileName)) ) {
		croak "$sSubName - required parameters missing\n";
	}

	open(FP, "<$sFileName") ||
		croak "$sSubName - Cannot open $sFileName for reading\n";
	
	while (<FP>) {
		my @line = split(/\t/,$_,17);

		# check to see if this a record we need to rename
		if ($line[$SEQIDCOL] eq "chrX") {

			my $nPosition = $line[$POSITIONCOL];

			if (defined $phPosition->{$nPosition}) {
				my $nStart = @$paRegions[$phPosition->{$nPosition}]->{START};
				my $nStop = @$paRegions[$phPosition->{$nPosition}]->{STOP};

				my $sNewID = $line[$SEQIDCOL]."_".$nStart."_".$nStop;

				if (! defined $hNewID{$sNewID}) {
					$hNewID{$sNewID} = sprintf("%03d",0);
				}

				$sNewID = $sNewID."_".++$hNewID{$sNewID};

				$line[$SEQIDCOL] = $sNewID;
					
			}
		}

		for (@line) {
			print "$_\t";
		}
		print "\n";
	}

	close (FP);

	return;
}

##############################################################################
### Documentation
##############################################################################

=head1 NAME

ndf.pl - program to rename sequence_id tag in ndf files based on probe position

=head1 VERSION

This documentation refers to ndf.pl version 0.1

=head1 USAGE

ndf.pl F<regions_file> F<ndf_file>

=head1 REQUIRED ARGUMENTS

=head2 F<regions_file>

A text file with three columns: CHROMOSOME START END

=head2 F<ndf_file>

A text file with 17 columns. Sequence_ID is Column 5; Position is Column 13

=head1 OPTIONS

=head1 DESCRIPTION

The program reads in the regions file. For each region a record is created
that contains the chromosome, start and end information. The record is
stored in an array.

Next a hash is constructed keyed by position for all positions within each
region. The value at a particular key is the index into the array of records
where the corresponding range is located.

Finally the NDF file is processed one line (record) at a time. If the line
contains a Sequence_ID that needs to be renamed, the modifications are made
dynamically. Then the line is written back out.

=head1 DIAGNOSTICS

=head1 CONFIGURATION/ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

 Viren Patel
 Department of Human Genetics
 Emory University School of Medicine
 Whitehead Biomedical Research Center, Suite 341
 Atlanta, GA 30322

=head1 LICENSE AND COPYRIGHT
