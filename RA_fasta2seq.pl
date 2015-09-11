#!/usr/bin/perl -w
##############################################################################
###
### Program to read sequences from a fasta format file and save each sequence
### in a separate file without the header. The program is intended to be used
### with output from RATools.
###
##############################################################################

use strict;
use Carp;
use Getopt::Std;

##############################################################################
### Constants
##############################################################################

use constant DEBUG => 1;    # change to 0 for normal operation

use constant FALSE => 0;
use constant TRUE  => 1;

##############################################################################
### Globals
##############################################################################

my %hCMDLINE;
my @aFileData = ();
my @aInputFiles;
my ($sFile, $sOutDirSpec, $sOutFileSpec);

##############################################################################
### Main
##############################################################################

# process command line arguments
getopts('hi:o:', \%hCMDLINE);

if ((defined $hCMDLINE{"h"}) || (! defined $hCMDLINE{"i"})) {
    print STDERR "\nUsage: $0 -i <input_filespec> [-o <output_directory>]\n";

    print STDERR <<USAGE;

    <input_filespec>   = location and/or name of input files. If this is a
                         directory, it will be searched for files with a
                         .fasta extension. Multiple files may be specified
                         using common wildcards but <filespec> should be
                         enclosed in quotes e.g. -i "07*.fasta".

    <output_directory> = location of output (.seq) files. Optional. Must be
                         a directory if specified. Existing files will be
                         overwritten.

Notes:

1. Input file names must follow conventions as defined in Zwick Lab Standard
Operating Procedures.

2. Headers must end with _NNN (underscore followed by 3-digit number).

USAGE

    exit 0;
}

# process command line options
if (-d $hCMDLINE{"i"}) {
    @aInputFiles = glob($hCMDLINE{"i"}."/*.fasta");
}
else {
    @aInputFiles = glob($hCMDLINE{"i"});
}

$sOutDirSpec = undef;
if (defined $hCMDLINE{"o"}) {
    if (! -d $hCMDLINE{"o"}) {
        croak "$hCMDLINE{'o'} is not a directory.\n";
    }
    else {
        $sOutDirSpec = $hCMDLINE{"o"};
    }

}

# process the files
foreach $sFile (@aInputFiles) {

    # check if valid file name and extract output file and dir specs
    if (! ($sFile =~ /^(\w+)_DMD_(.*)\.tif\.fasta$/)) {
        croak "Error - Input file name is not in valid format\n";
    }
    else {
        if (defined $sOutDirSpec) {
            $sOutDirSpec .= "/$1_DMD_$2";
        }
        else {
            $sOutDirSpec = "./$1_DMD_$2";
        }
        $sOutFileSpec = $1;
    }
    
    @aFileData = ();

    Read_Data_From_File(\@aFileData, $sFile, DEBUG);

    Split_Into_SEQ_Files(\@aFileData, $sOutDirSpec, $sOutFileSpec, DEBUG);
}

exit;


##############################################################################
### Subroutines
##############################################################################

# Read_Data_From_File()
#
# Purpose
#   reads data from specified file or STDIN one line at a time, and returns
#   the data in an array
#
# Required Parameters
#   paFileData = pointer to array to store the data
#
# Optional Parameters
#   bDebug     = boolean indicating debug status
#
# Side Effects
#   modifies external array
#
# Returns
#   number of lines read
#
# Assumptions
#   minimal processing of lines (removal of newline) is required, and done.
#
sub Read_Data_From_File {
    my $paFileData = shift;
    my $sFileName = shift;
    my $bDebug = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $FP;
    my $nNum = 0;

    if (! ((defined $paFileData) && (defined $sFileName))) {
        croak "$sSubName - required parameters missing\n";
    }

    open($FP, '<', $sFileName) ||
        croak "$sSubName = cannot open $sFileName for reading.\n";

    while (<$FP>) {
        chomp;
        if (/(.*)\s$/) {
        	push @$paFileData, $1;
        }
        else {
        	push @$paFileData, $_;
        }
        $nNum++;
    }

    if (defined $bDebug) {
        ($bDebug) ? print STDERR "Lines read: $nNum\n" : undef;
    }

    return $nNum;
}


# Split_Into_SEQ_Files()
#
# Purpose
#   write each sequence to its own .seq file without header
#
# Required Parameters
#   paFileData   = pointer to array containing fasta data
#   sOutFileSpec = string containing output location and name info.
#
# Optional Parameters
#   bDebug = boolean indicating debug status
#
# Side Effects
#   none
#
# Returns
#   number of lines written
#
# Assumptions
#   data array contains sequences in fasta format, one line per array element
#
sub Split_Into_SEQ_Files {
    my $paFileData = shift;
    my $sOutDirSpec = shift;
    my $sOutFileSpec = shift;
    my $bDebug = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $nNum = 0;
    my $nFileNumber = 0;
    my $sFileNumber;
    my $bSplit = FALSE;
    my ($sFileName, $sPath, $sSuffix);
    my $FP;

    if (! ((defined $paFileData) &&
    	   (defined $sOutDirSpec) &&
    	   (defined $sOutFileSpec))) {
        croak "$sSubName - required parameters missing\n";
    }

    foreach my $sLine (@$paFileData) {

        if ($sLine =~ /^\s*$/) {        # discard blank line
            next;
        }
        elsif ($sLine =~ /^\s*#/) {     # discard comment line
            next;
        }
        elsif ($sLine =~ /^>/) {        # fasta header line

            # extract the sequence number from the header
            if ($sLine =~ /.*(_\d{3})$/) {
                $sFileNumber = $1;
            }
            else {
            	carp "$sSubName - invalid header in input file\n";
            	carp "Warning: Using internal sequence number";
                $sFileNumber = sprintf("_%03d", ++$nFileNumber);
            }

            if (defined $FP) {      
                    close($FP);         # ... close the last file
            }
            
            if (! -e $sOutDirSpec) {
            	mkdir($sOutDirSpec) ||
            		croak "$sSubName - cannot create output directory\n";
            }
            
            if (-e "$sOutDirSpec/$sOutFileSpec".$sFileNumber.".seq") {
            	croak "$sSubName - Output file already exists\n";
            }
            else {
                                        # ... and open a new file
	            open($FP, '>', "$sOutDirSpec/$sOutFileSpec".$sFileNumber.".seq") ||
                        croak "$sSubName - cannot open _$sFileNumber for
                        writing\n";
            }
            next;
        }
        else {
            if (! defined $FP) {        # this should not happen!
                croak "$sSubName - unknown error\n";
            }
            print $FP "$sLine\n";
            $nNum++;
        }
    }

    if (defined $bDebug) {
        ($bDebug) ? print STDERR "Lines written: $nNum\n" : undef;
    }

    return $nNum;
}


##############################################################################
### Internal Documentation
##############################################################################

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

fasta2seq.pl - program to save sequences in a fasta file in separate files,
               one sequence per file, and without header information.

=head1 VERSION

This documentation refers to fasta2seq version 0.1.

=head1 USAGE

fasta2seq.pl -i <input_file_spec> [-o <output_directory]

=head1 REQUIRED ARGUMENTS

-i <input_file_spec>  = location and/or name of input files. If this is a
                        directory, it will be searched for files with a
                        .fasta extension. Multiple files may be specified
                        explicitly using common wildcards.
-o <output directory> = location of output (.seq) files. Optional. Must be
                        a directory if specified. Existing files will be
                        overwritten.

=head1 OPTIONS

none

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

