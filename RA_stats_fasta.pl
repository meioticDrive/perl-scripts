#!/usr/bin/perl -w
##############################################################################
### Given a fasta file, this program:
###     1. counts the number of called (A,C,G,T) and uncalled (N) bases for
###     each fragment.
###     2. determines the total length of each fragment
###     3. output those numbers to a file
###     4. output a new fasta file with call rates above a certain user-
###     specified threshold (e.g. 80%)
##############################################################################

use strict;
use Carp;
use Getopt::Std;

##############################################################################
### Constants
##############################################################################

use constant FALSE => 0;
use constant TRUE  => 1;

use version; my $VERSION = qv('1.0.0');

##############################################################################
### Globals
##############################################################################

my %hCmdLineOption;
my (@aFastaFileNames, @aFastaFiles);
my ($sOutDirectory, $sOutFileSpec, $nFileNumber, $nThreshold, $sFile);
my @aSequences;
my $FP;
my $bDone;

##############################################################################
### Main
##############################################################################

# Process command line options if any
getopts('i:t:o:', \%hCmdLineOption);

if ( ! defined $hCmdLineOption{'i'}) {
    Getopt::Std->version_mess('i:t:o:');
    Getopt::Std->help_mess('i:t:o:');
    exit 0;
}

@aFastaFileNames = undef;
if (-d $hCmdLineOption{'i'}) {
    @aFastaFileNames = glob($hCmdLineOption{'i'}."/*.fasta");
}
else {
    @aFastaFileNames = glob($hCmdLineOption{'i'});
}

$sOutDirectory = ".";
if (defined $hCmdLineOption{'o'}) {
    if (! -d $hCmdLineOption{'o'}) {
        die "ERROR! $hCmdLineOption{'o'} is not a directory\n";
    }
    else {
        $sOutDirectory = $hCmdLineOption{'o'};
    }
}

$nThreshold = 80.0;					# default threshold of 80%
if (defined $hCmdLineOption{'t'}) {
	$nThreshold = $hCmdLineOption{'t'};
}

for $sFile (@aFastaFileNames) {

    @aSequences = ();

    Read_Fasta_File(\@aSequences, $sFile);
    Compute_Stats(\@aSequences);
    
    $sFile =~ m/^(\S+)\.fasta$/;
    if (defined $1) {
    	$sOutFileSpec = $1;
    }
    else {
    	$sOutFileSpec = $sFile;
    }
    
    $sOutFileSpec = $sOutDirectory."/".$sOutFileSpec;
    
    Save_Results(\@aSequences, $nThreshold, $sOutFileSpec);
}

exit;

##############################################################################
### Subroutines
##############################################################################

sub VERSION_MESSAGE {
    $0 =~ m/.*\/(\w+\.\w+)$/;

    print STDERR "\nThis is $1 version $VERSION\n\n";
}

sub HELP_MESSAGE {
    $0 =~ m/.*\/(\w+\.\w+)$/;

    print STDERR "\nUsage: $1 -i <fasta_filespec> [-t <threshold>] [-o ".
    "<output_directory]\n";

    print STDERR <<USAGE;

    <fasta_filespec>    = text file(s) containing sequence data in fasta format.
                          If a directory, it will be searched for files with a
                          .fasta extension. Wildcards may also be used if
                          <fasta_filespec> is enclosed in quotes.

    <threshold>         = output a new fasta file containing sequences with call
                          rates >= to this value. Optional. Default is 80%

    <output_directory>  = output files will be placed in this directory.
                          Optional. Default is current directory.

USAGE

}

# Read_Fasta_File()
#
# Purpose
#   read sequences from a fasta file and store them in an array of hashes
#
# Required Parameters
#   paSequences = pointer to array for storing sequences
#   sFileName   = string containing name of file to read
#
# Optional Parameters
#   none
#
# Returns
#   nothing
#
# Side Effects
#   modifies external array
#
# Assumptions
#
# Notes
#
sub Read_Fasta_File {
    my $paSequences = shift;
    my $sFileName = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $sSequence = undef;
    my $sHeader = undef;
    my $sLine;
    my $FP;

    # check for required parameters
    if (! ((defined $paSequences) &&
           (defined $sFileName))) {
        croak "$sSubName - required parameters missing\n";
    }

    open($FP, '<', $sFileName) ||
        croak "$sSubName - cannot open $sFileName for reading\n";

    while (<$FP>) {
        chomp;
        $sLine = $_;
        if ($sLine =~ /^(.*)\s$/) {     # dos files usually have \r\n
            $sLine = $1;
        }
        
        if ($sLine =~ /^\s*$/) {        # discard blank lines
            next;
        }
        elsif ($sLine =~ /^\s*#/) {     # discard comment lines
            next;
        }
        elsif ($sLine =~ /^>/) {        # fasta header line
            if (defined $sSequence) {
                my %hStats = ( "Called", 0, "Uncalled", 0, "Length", 0,
                    "CallRate", 0);
                my $rec = {
                    HEADER => $sHeader,
                    DATA   => $sSequence,
                    STATS  => \%hStats,
                };
                push @$paSequences, $rec;
                $sSequence = undef;
            }
            $sHeader = $sLine;
        }
        else {
            $sSequence .= $sLine;
        }
    }
    if (defined $sSequence) {
        my %hStats = ( "Called", 0, "Uncalled", 0, "Length", 0, "CallRate", 0);
        my $rec = {
            HEADER => $sHeader,
            DATA   => $sSequence,
            STATS  => \%hStats,
        };
        push @$paSequences, $rec;
    }

    close($FP);

    return;
}



# Compute_Stats()
#
# Purpose
#   compute various statistics on sequences
#
# Required Parameters
#   paSequences = pointer to array containing sequence data
#
# Optional Parameters
#   none
#
# Returns
#   nothing
#
# Side Effects
#   modifies external array
#
# Assumptions
#
# Notes
#
sub Compute_Stats {
    my $paSequences = shift;

    # Local variables
    my $sSubName = (caller(0))[3];

    my $sSequence;
    my %hBaseCount;
    my $nCalledBases;
    my $nUncalledBases;
    my $nTotalSequence = undef;


    # check for required parameters
    if (! defined $paSequences) {
        croak "$sSubName - required parameters missing\n";
    }

    
    for (my $x = 0; $x < scalar(@$paSequences); $x++) {

		$sSequence = undef;
		
        $sSequence = $paSequences->[$x];

        $nTotalSequence = length($sSequence->{DATA});

        %hBaseCount = ( 'A', 0, 'C', 0, 'G', 0, 'N', 0, 'T', 0 );
        foreach (split('', $sSequence->{DATA})) {
            if ($_ =~ /[ACGNT]/) {
                $hBaseCount{$_}++;
            }
        }

        $nCalledBases = $hBaseCount{'A'} + $hBaseCount{'C'} +
                        $hBaseCount{'T'} + $hBaseCount{'G'};

        $nUncalledBases = $hBaseCount{'N'};

        $paSequences->[$x]->{STATS}->{"Called"} = $nCalledBases;
        $paSequences->[$x]->{STATS}->{"Uncalled"} = $nUncalledBases;
        $paSequences->[$x]->{STATS}->{"Length"} = $nTotalSequence;
        $paSequences->[$x]->{STATS}->{"CallRate"} = 
            $nCalledBases / $nTotalSequence * 100.0;

    }

    return;
}


# Save_Results()
#
# Purpose
#   save the results to files
#
# Required Parameters
#   paSequences  = point to an array containing sequences
#   nThreshold   = threshold value for saving sequences
#   sOutFileSpec = output file specification
#
# Optional Parameters
#	none
#
# Returns
#   nothing
#
# Side Effects
#   creates new disk files
#
# Notes
#
sub Save_Results {
    my $paSequences = shift;
    my $nThreshold = shift;
    my $sOutFileSpec = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $nLineLength = 50;
    my $sOutFileName;
    my $sBuffer;
    my $sSeq;
    my $FP;

    # check for required parameters
    if (! ((defined $paSequences) &&
    	   (defined $nThreshold) &&
    	   (defined $sOutFileSpec))) {
        croak "$sSubName - required parameters missing\n";
    }

    # construct the stats output file name
    $sOutFileName = $sOutFileSpec.".stats";

    open($FP, '>', $sOutFileName) ||
        croak "$sSubName - cannot open $sOutFileName for writing\n";

	print $FP "Fasta_ID\tCalled_Bases\tUncalled_Bases\tTotal_Bases\tCall_Rate\n";
	
    foreach $sSeq (@$paSequences) {
        print $FP "$sSeq->{HEADER}\t";
        print $FP sprintf("%5d\t", $sSeq->{STATS}->{"Called"});
        print $FP sprintf("%5d\t", $sSeq->{STATS}->{"Uncalled"});
        print $FP sprintf("%5d\t", $sSeq->{STATS}->{"Length"});
        print $FP sprintf("%6.2f\n",$sSeq->{STATS}->{"CallRate"});
    }

    close($FP) || croak "$sSubName - cannot close $sOutFileName\n";

	# construct the threshold sequences file name
	$sOutFileName = $sOutFileSpec.sprintf("_%4.1f", $nThreshold).".fasta";
	
	open($FP, '>', $sOutFileName) ||
		croak "$sSubName - cannot open $sOutFileName for writing\n";
	
	foreach $sSeq (@$paSequences) {
		if ($sSeq->{STATS}->{"CallRate"} >= $nThreshold) {
			print $FP "$sSeq->{HEADER}\n";
			$sBuffer = $sSeq->{DATA};
			while ($sBuffer =~ /(.{$nLineLength})(.*)$/g) {
				print $FP "$1\n";
				$sBuffer = $2;
			}
			if (length($sBuffer) > 0) {
				print $FP "$sBuffer\n";
			}
		}
	}
	
	close($FP) || croak "$sSubName - cannot close $sOutFileName\n";
				
    return;
}


##############################################################################
### Internal Documentation
##############################################################################

=begin Revision Notes

20070524 - Version 1.0.0

=end Revision Notes

=begin Variable/Subroutine Name Conventions

Type Prefixes

    b = boolean
    c = character
    n = number
    p = pointer aka reference
    s = string
    a = array
    h = hash
    r = rec (aka hash)
    o = object (e.g. for vars created/initialized via module->new() methods)
    g = global

    Type prefixes can be combined where appropriate, e.g. as = array of
    strings or ph = pointer to a hash, but not cn (character of numbers???)

Variable Names

    Variable names start with a type prefix followed by capitalized words
    descriptive of the purpose of the variable. Variable names do not have
    underscores. E.g. sThisIsAString

Subroutine Names

    Subroutine names do not have a type prefix, have capitalized words
    descriptive of the purpose of the subroutine, and the words are
    separated by an underscore. E.g. This_Is_A_Subroutine

    Internal utility subroutines begin with an underscrore and follow the
    naming conventions of subroutines.

=end Variable/Subroutine Name Conventions

=cut

##############################################################################
### POD Documentation
##############################################################################

=head1 NAME

RA_stats_fasta.pl - program to count the number of called (A,C,G,T) and
uncalled (N) bases for each sequence in a fasta file. The program outputs a
file with five columns which contains:

   fasta_id   called_bases   uncalled_bases   total_bases   call_rate

for each sequence (one per line). Additionally the program saves sequences
that exceed a user-specified call-rate threshold in a separate file

=head1 VERSION

This documentation refers to RA_stats_fasta.pl version 1.0.0

=head1 USAGE

RA_stats_fasta.pl -i <fasta_filespec> [-t <threshold>] [-o <output_directory>]

=head1 REQUIRED ARGUMENTS

=head2 <fasta_filespec>

=head1 OPTIONAL ARGUMENTS

=head2 <threshold>

=head2 <output_directory>

=head1 OPTIONS


=head1 DESCRIPTION


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES


=head1 MODULES

=head1 BUGS AND LIMITATIONS


=head1 AUTHOR


=head1 LICENSE AND COPYRIGHT


