#!/usr/bin/perl -w
##############################################################################
###
### program to compute the start/stop of each fragment in an NDF file and
### output them to a genpos and a primers file.
###
##############################################################################

use strict;
use version;
use Carp;
use Getopt::Std;
use File::Glob ':glob';
use File::Spec;

##############################################################################
### Constants
##############################################################################

use constant DEBUG => 1;    # change to 0 for production

use constant FALSE => 0;
use constant TRUE  => 1;

use constant VERSION => qv('1.0.0');
use constant PROGRAM => eval { ($0 =~ m/.*\/(\w+\.\w+)$/) ? $1 : $0 };

##############################################################################
### Globals
##############################################################################

my %hCmdLineOption = ();
my @aNdfFileNames = ();
my ($sOutDirectory, $sNdfFile);

##############################################################################
### Main
##############################################################################

# Process command line arguments
$Getopt::Std::STANDARD_HELP_VERSION = TRUE;
getopts('i:o:',\%hCmdLineOption);

if (! (defined $hCmdLineOption{'i'})) {
    Getopt::Std->version_mess('i:o:');
    Getopt::Std->help_mess('i:o:');
    exit 0;
}

@aNdfFileNames = undef;
if (-d $hCmdLineOption{'i'}) {
    @aNdfFileNames = bsd_glob($hCmdLineOption{'i'}."/*.ndf", GLOB_TILDE |
        GLOB_QUOTE);
}
else {
    @aNdfFileNames = bsd_glob($hCmdLineOption{'i'}, GLOB_TILDE | GLOB_QUOTE);
}

$sOutDirectory = File::Spec->curdir();
if (defined $hCmdLineOption{'o'}) {
    if (! -e $hCmdLineOption{'o'}) {
        mkdir($hCmdLineOption{'o'}) ||
            croak "ERROR! Cannot create output directory\n";
        $sOutDirectory = $hCmdLineOption{'o'};
    }
    elsif (! -d $hCmdLineOption{'o'}) {
        croak "ERROR! $hCmdLineOption{'o'} is not a directory\n";
    }
}
$sOutDirectory = File::Spec->canonpath($sOutDirectory);

foreach $sNdfFile (@aNdfFileNames) {

    (DEBUG) ? print "\nProcessing $sNdfFile\n" : undef;

    Process_NDF_File($sNdfFile, $sOutDirectory);

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
                 "-i <ndf_filespec> [-o <output_directory>]\n";

    print STDERR <<USAGE;

    <ndf_filespec>     = name of input files. If a directory, it will be searched
                         for files with a .ndf extension. Multiple files can be
                         specified using wildcards, but <filespec> should be
                         enclosed in quotes, e.g. -i "/path/to/blabla*.ndf"

    <output_directory> = directory to store converted files. Optional. Default
                         is current directory, i.e. the directory from where
                         the program is executed or the directory specified
                         in <ndf_filespec> if any. Output file names will be
                         the same as input files names. If /path/to/ndf_file
                         is the same as /path/to/output_file, output file name
                         will have "_converted.ndf" appended at the end.
                         Existing /path/to/output_file_converted.ndf will be
                         overwritten

USAGE
}


# Process_NDF_File()
#
# Purpose
#   Compute the start and stop of all fragments in an NDF file
#
# Required Parameters
#   sNdfFileName = string containing name of NDF file
#   sOutDir      = string containing name of output directory
#
# Optional Parameters
#   none
#
# Side Effects
#   creates disk files
#
# Assumptions
#   1. data file is a tab-separated text file with 17 columns. Sequence_ID is
#       in column 5, Position is in column 14
#
sub Process_NDF_File {
    my $sNdfFileName = shift;
    my $sOutDir = shift;

    # Local Constants
    use constant CONTAINER => 1;
    use constant SEQIDCOL => 4; 
    use constant SEQUENCECOL => 5;
    use constant POSITIONCOL => 13;

    # Local Variables
    my $sSubName = (caller(0))[3];
    my @line;
    my ($sDir, $sFile, $sOutFileSpec, $sOutFile);
    my ($NDF_FP, $OUT_FP, $nStart, $nStop);
    my ($nLine, $nFrag);

    # check required parameters
    if (! ((defined $sNdfFileName) &&
           (defined $sOutDir) ) ) {
        croak "$sSubName - required parameters missing\n";
    }

    # determine ouput file name
    ($_, $sDir, $sFile) = File::Spec->splitpath($sNdfFileName);
    if ($sOutDir ne File::Spec->curdir()) {
        $sDir = "";
    }

    $sFile =~ m/^(\S+)\.ndf$/;
    if (defined $1) {
        $sOutFileSpec = $sOutDir."/".$sDir."/".$1;
    }
    else {
        $sOutFileSpec = $sOutDir."/".$sDir."/".$sFile;
    }
    $sOutFile = $sOutFileSpec . ".genpos.txt";
    $sOutFile = File::Spec->canonpath($sOutFile);

    # initialize file handles
    open($NDF_FP, '<', $sNdfFileName) ||
        croak "$sSubName - Cannot open $sNdfFileName for reading\n";

    open($OUT_FP, '>', $sOutFile) ||
        croak "$sSubName - Cannot open $sOutFile for writing\n";

    $nLine = 0;
    $nFrag = 0;

    # process the file
    while (<$NDF_FP>) {
        chomp;
        @line = split(/\t/,$_,17);

        (DEBUG) ? print STDERR "\t$nLine \ $nFrag\r" : undef;

        $nLine++;

        # check for record with sequence data
        next if ($line[CONTAINER] ne "RESEQ");

        $nFrag++;

        # get the start position of the fragment
        $nStart = $line[POSITIONCOL];

        # compute the stop position
        $nStop = $nStart + length($line[SEQUENCECOL]);

        # store them
        print $OUT_FP "$nStart\t$nStop\n";

    }

    close($OUT_FP) || croak "$sSubName - Cannot close $sOutFile\n";

    close($NDF_FP) || croak "$sSubName - Cannot close $sNdfFileName\n";

    {
        use File::Copy;

        copy($sOutFile,
             File::Spec->canonpath($sOutFileSpec .".primers.txt")) ||
            croak "$sSubName - Could not copy primers.txt\n";
    }

}

##############################################################################
### Internal Documentation
##############################################################################

=begin Revision Notes

1.0.0   Original release version

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
    r = record (aka hash)
    o = object (e.g. for vars created/initialized via module->new() methods)

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

RA_ndf2genpos.pl - program to compute start/stop of each fragment in an NDF
file and create genpos and primers files.

=head1 VERSION

This documentation refers to version 1.0.0

=head1 USAGE

<program_name> -i <ndf_filespec> [-o <output_directory>]

=head1 REQUIRED ARGUMENTS

=head2 -i <ndf_filespec>

Tab-separated (TSV?) text files with 17 columns. Sequence_ID is Column 5;
Position is Column 13.

=head1 OPTIONAL ARGUMENTS

=head2 -o <output_directory>

Directory to store converted files. Optional. Default is current directory,
i.e. the directory from where the program is executed. Converted files will
have _converted.ndf appended at the end.

=head1 OPTIONS

none

=head1 DESCRIPTION

This program reads an NDF file and computes the start/stop positions of the
fragments. It stores the start/stop in a genpos file. 

=head1 DIAGNOSTICS

=head1 CONFIGURATION/ENVIRONMENT

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
 Whitehead Biomedical Research Center, Suite 341
 Atlanta, GA 30322

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2027 Michael E Zwick (<mzwick@genetics.emory.edu>). All rights
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

