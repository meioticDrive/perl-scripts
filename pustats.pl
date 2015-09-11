#!/usr/bin/perl -w
##############################################################################
### This program generates statistics from a MAQ pileup file
##############################################################################

use strict;
use Carp;
use Getopt::Std;
use File::Spec;

##############################################################################
### Constants
##############################################################################

use constant DEBUG => 0;	# change to 0 for productions

use constant FALSE => 0;
use constant TRUE  => 1;

use constant VERSION => '1.0.0';
use constant PROGRAM => eval { ($0 =~ m/(\w+\.pl)$/) ? $1 : $0 };

##############################################################################
### Globals
##############################################################################

my %hCmdLineOption;
my $sCmdLineSpec = 'ci:o:p:v';

my (@aInputFiles);
my ($sOutDir, $sFile);

##############################################################################
### Main
##############################################################################

if (DEBUG) {
    $hCmdLineOption{'i'} = 'test.pileup';
    $hCmdLineOption{'o'} = 'test.out';
    $hCmdLineOption{'p'} = '75';
    $hCmdLineOption{'c'} = TRUE;
    $hCmdLineOption{'v'} = TRUE;
}
else {
    # Process command line options if any
    $Getopt::Std::STANDARD_HELP_VERSION = TRUE;
    getopts($sCmdLineSpec, \%hCmdLineOption);
}

if (! ((defined $hCmdLineOption{'i'}) && 
       (defined $hCmdLineOption{'p'})    )) {
    Getopt::Std->version_mess($sCmdLineSpec);
    Getopt::Std->help_mess($sCmdLineSpec);
    exit 0;
}

@aInputFiles = undef;
if (-d $hCmdLineOption{'i'}) {
    @aInputFiles = glob($hCmdLineOption{'i'}."/*.pileup");
}
else {
    @aInputFiles = glob($hCmdLineOption{'i'});
}

$sOutDir = File::Spec->curdir();
if (defined $hCmdLineOption{'o'}) {
    $sOutDir = $hCmdLineOption{'o'};

    if (! -e $sOutDir) {
        mkdir($hCmdLineOption{'o'}) ||
            croak "ERROR! Cannot create output directory\n";
    }
    elsif (! -d $hCmdLineOption{'o'}) {
            croak "ERROR! $hCmdLineOption{'o'} is not a directory\n";
    }
}
$sOutDir = File::Spec->canonpath($sOutDir);

if (defined $hCmdLineOption{'v'}) {
    $hCmdLineOption{'v'} = TRUE;
}

# process the input files
foreach $sFile (@aInputFiles) {

    if ($hCmdLineOption{'v'}) {
        print STDERR "Processing $sFile\n";
    }

	Process_File( $hCmdLineOption{'i'},
                  $hCmdLineOption{'p'},
                  $sOutDir,
                  $hCmdLineOption{'c'},
                  $hCmdLineOption{'v'});
}

exit;

##############################################################################
### Subroutines
##############################################################################

sub VERSION_MESSAGE {

    print STDERR "\nThis is ".PROGRAM." version ".VERSION."\n";
}

sub HELP_MESSAGE {

    print STDERR "\nUsage: ".PROGRAM.
                 " -i [path/to/]pileup_file(s) ".
                 " -p pad_size".
                 " [-c]".
                 " [-o [path/to/]out_dir] [-v]\n";

    print STDERR <<USAGE;

    -i [path/to/]pileup_files(s) = text file(s) containing sequence data in
                                   pileup format. If a directory, it will be
                                   searched for files with a .pileup extension.
                                   Otherwise the current directory will be
                                   searched for file names that contain
                                   <filespec>. Wildcards may also be used but
                                   <filespec> should be enclosed in quotes,
                                   e.g. "NLGN*.pileup"

    -p pad_size                  = size of pad

    -c                           = generate a csv file containing depth of all
                                   segments, one segment per row. This can be
                                   imported into Excel.
    							   
    -o [path/to/]out_dir         = output files will be placed in this
                                   directory. Optional. Default is current
                                   directory. Output file names will be based
                                   on input fasta file names.

    -v                           = display runtime messages to screen.

USAGE

    print STDERR "Run 'perldoc ".PROGRAM."' for more information\n\n";

}


# Process_File()
#
# Purpose
#
#    Compute stats for pileup file
#
# Required Parameters
#   sPileupFile = string containing [/path/to/]pileup_file
#   nPadSize    = pointer to a fasta file record
#   sOutDir     = directory to store results
#
# Optional Parameters
#   bTSV        = boolean flag to generate a TSV file
#   bVerbose    = boolean flag to display run-time messages
#
# Returns
#   nothing
#
# Side Effects
#   creates external disk file
#   
# Assumptions
#
# Notes
#
sub Process_File {
    my $sPileupFile  = shift;
    my $nPadSize     = shift;
    my $sOutDir      = shift;
    my $bCSV         = shift;
    my $bVerbose     = shift;

    # Local variables
    my $sSubName = (caller(0))[3];

    my %hSegment = ();

	my $aTmp;
	my ($sID, $sPrevID, $sCalls);
    my ($nBaseNum, $nBaseDepth, $nLineNum, $nSegNum, $nPostPadStart);
	my ($nAvgSegDepth);
	my ($cBase);
    my ($sOutFileSpec, $sDir, $sFile, $sCSVFile);
    my ($fpPILEUP, $fpOUT, $fpCSV);

    if (DEBUG) {
        print STDERR "In $sSubName\n";
    }

    if (DEBUG || $bVerbose) {
        print STDERR "Computing Stats...\n";
    }

	# check for required parameters
    if (! ( (defined $sPileupFile) &&
            (defined $nPadSize) &&
            (defined $sOutDir) ) ) {
        croak "$sSubName - required parameters missing\n";
    }

	open($fpPILEUP, '<', $sPileupFile) ||
        croak "$sSubName - Cannot open $sPileupFile for reading\n";

    $nSegNum = $nLineNum = 0;

    $sPrevID = ();

    while (<$fpPILEUP>) {

        chomp;

        ($sID, $nBaseNum, $cBase, $nBaseDepth, $sCalls) = split(/\t/,$_);

        $nLineNum++;

		if (((defined $sPrevID) && ($sID ne $sPrevID)) || (! defined $sPrevID)) {
			$nSegNum++;
		}
		$sPrevID = $sID;
		
        if (! defined $hSegment{$sID}) {

            $sID =~ /chr(.*):(\d+)-(\d+)$/ ||
                croak "$sSubName - Cannot parse segment ID\n";

            my $rStats = {
                PRE_PAD_DEPTH  => 0.0,
                POST_PAD_DEPTH => 0.0,
                CHR            => $1,
                START          => $2 + $nPadSize,
                STOP           => $3 - $nPadSize,
                SEG_SIZE       => $3 - $2 + 1,
                SEGMENT_DEPTH  => 0.0,
                DEPTHS         => "$sID"
            };

            $hSegment{$sID} = $rStats;

            $nPostPadStart = $rStats->{SEG_SIZE} - $nPadSize;

        }

        if ($nBaseNum <= $nPadSize) {
            $hSegment{$sID}->{PRE_PAD_DEPTH} += $nBaseDepth;
        }
        elsif ($nBaseNum > $nPostPadStart) {
            $hSegment{$sID}->{POST_PAD_DEPTH} += $nBaseDepth;
        }
        else {
            $hSegment{$sID}->{SEGMENT_DEPTH} += $nBaseDepth;
        }
        
       	$hSegment{$sID}->{DEPTHS} .= ",$nBaseDepth";
        
        if ($bVerbose) {
            print "\rSegment: $nSegNum\tLine: $nLineNum";
        }

    }

    close($fpPILEUP);

	foreach $sID (keys %hSegment) {
	
		$hSegment{$sID}->{PRE_PAD_DEPTH} /= $nPadSize;
        $hSegment{$sID}->{POST_PAD_DEPTH} /= $nPadSize;
        $hSegment{$sID}->{SEGMENT_DEPTH} /= $hSegment{$sID}->{SEG_SIZE};
        
        $nAvgSegDepth += $hSegment{$sID}->{SEGMENT_DEPTH};
        
    }
    
    $nAvgSegDepth /= $nSegNum;
    
    # initialize output file specs
    ($_, $sDir, $sFile) = File::Spec->splitpath($sPileupFile);
    if ($sOutDir ne File::Spec->curdir()) {
        $sDir = "";
    }
	$sFile =~ m/^(\S+)\.pileup$/;
	if (defined $1) {
	    $sOutFileSpec = $sOutDir.'/'.$sDir.'/'.$1.'_pileup.stats';
	    if ($bCSV) {
	    	$sCSVFile = $sOutDir.'/'.$sDir.'/'.$1.'_pileup.csv';
	    }
	}
	else {
	    $sOutFileSpec = $sOutDir.'/'.$sDir.'/'.$sFile.'_pileup.stats';
	    if ($bCSV) {
	    	$sCSVFile = $sOutDir.'/'.$sDir.'/'.$sFile.'_pileup.csv';
	    }
	}
    $sOutFileSpec = File::Spec->canonpath($sOutFileSpec);

    open($fpOUT, '>', $sOutFileSpec) ||
        croak "$sSubName - Cannot open $sOutFileSpec for writing\n";

    if ($bCSV) {
    	open($fpCSV, '>', $sCSVFile) ||
    		croak "$sSubName - Cannot open $sCSVFile for writing\n";
    }
    
    printf $fpOUT "Avg. depth across segments: %5.2f\n",$nAvgSegDepth;

	print $fpOUT "Seg_ID\t\tSize\tPre_Pad\tSeg_Depth\tPost_Pad\n";	
				 
    foreach $sID (sort keys %hSegment) {

        printf $fpOUT "%s\t%d\t%7.2f\t%7.2f\t%7.2f\n",
                      $sID,
                      $hSegment{$sID}->{SEG_SIZE},
                      $hSegment{$sID}->{PRE_PAD_DEPTH},
                      $hSegment{$sID}->{SEGMENT_DEPTH},
                      $hSegment{$sID}->{POST_PAD_DEPTH};
        if ($bCSV) {
        	print $fpCSV "$hSegment{$sID}->{DEPTHS}\n";
        }
    }

	if ($bCSV) {
		close($fpCSV);
	}
	
    close($fpOUT);

    if (DEBUG || $bVerbose) {
        print STDERR "\n";
    }

    if (DEBUG) {
        print STDERR "Leaving $sSubName\n";
    }

    return;

}


##############################################################################
### POD Documentation
##############################################################################

=head1 NAME

pustats.pl - program to compute segment stats from a pileup file

=head1 VERSION

This documentation refers to pustats.pl version 1.0.0

=head1 USAGE

pustats.pl -i pileup_filespec -p pad_size [-c] [-o output_directory] [-v]

=head1 REQUIRED ARGUMENTS

=head2 -i pileup_filespec

Text file(s) containing pileup data generated by MAQ. If a directory, it will
be searched for files with a .pileup extension. Otherwise the current directory
will be searched. Wildcards may also be used but <filespec> should be enclosed
in quotes, e.g. "NLGN*.pileup"

=head2 -p pad_size

The value of the pad on either side of the reference sequence.

=head1 OPTIONAL ARGUMENTS

=head2 -c

Generate a CSV file with the depths of each segment in rows. Facilitates
importing into a spreadsheet or plotting program.

=head2 -o <output_directory>

output files will be placed in this directory. Default is current directory.
Output file names will be denoted by _pileup.stats.

=head2 -v

flag to enable generation of runtime messages

=head1 OPTIONS

=head1 DESCRIPTION

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module. Please report problems to Viren Patel
(vcpatel@genetics.emory.edu). Patches are welcome.

=head1 AUTHOR

 Viren Patel
 Zwick Lab (http://www.genetics.emory.edu/labs/zwick/zwick_lab_index.php)
 Department of Human Genetics
 Emory University School of Medicine
 Whitehead Biomedical Research Building
 615 Michael Street, Suite 301
 Atlanta, GA 30322

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2028 Michael E Zwick (<mzwick@genetics.emory.edu>). All rights
reserved.

This program is free software; you can distribute it and/or modify it under the
same terms as Perl itself. See L<perlartistic>.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or FITNESS
FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

##############################################################################
### Internal Documentation
##############################################################################

# Revision Notes

# 20080418 - Version 1.0.0

# Variable/Subroutine Name Conventions

# Type Prefixes

#    b = boolean
#    c = character
#    n = number
#    p = pointer aka reference
#    s = string
#    a = array
#    h = hash
#    r = rec (aka hash)
#    o = object (e.g. for vars created/initialized via module->new() methods)
#    g = global

#    Type prefixes can be combined where appropriate, e.g. as = array of
#    strings or ph = pointer to a hash, but not cn (character of numbers???)

# Variable Names

#    Variable names start with a type prefix followed by capitalized words
#    descriptive of the purpose of the variable. Variable names do not have
#    underscores. E.g. sThisIsAString

# Subroutine Names

#    Subroutine names do not have a type prefix, have capitalized words
#    descriptive of the purpose of the subroutine, and the words are
#    separated by an underscore. E.g. This_Is_A_Subroutine

#    Internal utility subroutines begin with an underscrore and follow the
#    naming conventions of subroutines.
