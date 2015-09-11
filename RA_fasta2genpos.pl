#!/usr/bin/perl -w
##############################################################################
### This program processes a file in fasta format and generates genpos
### and primers files from the fasta headers
###
##############################################################################

use strict;
use version;
use Carp;
use Getopt::Std;
use File::Spec;
use File::Copy;
use File::Glob ':glob';

##############################################################################
### Constants
##############################################################################

use constant DEBUG => 0;	# change to 0 for productions

use constant FALSE => 0;
use constant TRUE  => 1;

use constant VERSION => qv('1.0.0');
use constant PROGRAM => eval { ($0 =~ m/(\w+\.pl)$/) ? $1 : $0 };

##############################################################################
### Globals
##############################################################################

my %hCmdLineOption;
my $FP;
my (@aInputFiles, @aRanges);
my ($sOutDir, $sFileName, $sDir, $sFile, $sOutFileSpec, $sLine);

##############################################################################
### Main
##############################################################################

# Process command line options if any
$Getopt::Std::STANDARD_HELP_VERSION = TRUE;
getopts('i:o:', \%hCmdLineOption);

if (! (defined $hCmdLineOption{'i'})) {
    Getopt::Std->version_mess('i:o:');
    Getopt::Std->help_mess('i:o:');
    exit 0;
}

@aInputFiles = undef;
if (-d $hCmdLineOption{'i'}) {
    @aInputFiles = bsd_glob($hCmdLineOption{'i'}."/*.fasta",
                            GLOB_TILDE | GLOB_QUOTE);
}
else {
    @aInputFiles = bsd_glob($hCmdLineOption{'i'}, GLOB_TILDE | GLOB_QUOTE);
}

$sOutDir = File::Spec->curdir();
if (defined $hCmdLineOption{'o'}) {
    if (! -e $hCmdLineOption{'o'}) {
        mkdir($hCmdLineOption{'o'}) ||
            croak "ERROR! Cannot create output directory\n";
        $sOutDir = $hCmdLineOption{'o'};
    }
    elsif (! -d $hCmdLineOption{'o'}) {
            croak "ERROR! $hCmdLineOption{'o'} is not a directory\n";
    }
}
$sOutDir = File::Spec->canonpath($sOutDir);

# process the input files
foreach $sFileName (@aInputFiles) {

    @aRanges = ();

    open($FP, '<', $sFileName) || croak "Cannot open $sFileName for reading\n";

    while (<$FP>) {
        chomp;
        $sLine = $_;

        next unless $sLine =~ /^>.*chr.*_(\d+)_(\d+)_.*$/;

        push @aRanges, [$1, $2];
    }

    close($FP);

    # initialize output file specs
    ($_, $sDir, $sFile) = File::Spec->splitpath($sFileName);
    if ($sOutDir ne File::Spec->curdir()) {
        $sDir = "";
    }
	$sFile =~ m/^(\S+)\.fasta$/;
	if (defined $1) {
	    $sOutFileSpec = $sOutDir."/".$sDir."/".$1;
	}
	else {
	    $sOutFileSpec = $sOutDir."/".$sDir."/".$sFile;
	}
    $sOutFileSpec = File::Spec->canonpath($sOutFileSpec);

    open($FP, '>', $sOutFileSpec.".genpos.txt") ||
        croak "Cannot open $sOutFileSpec.genpos.txt for writing\n";

    {
        $" = "\t";

        foreach (@aRanges) {
            print $FP "@$_\n";
        }
    }

    close($FP);

    copy($sOutFileSpec.".genpos.txt", $sOutFileSpec.".primers.txt");

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
                 " -i <filespec> [-o <output_directory>]\n";

    print STDERR <<USAGE;

    <filespec>         = text file(s) containing sequence data in fasta format.
                         If a directory, it will be searched for files with a
                         .fasta extension. Otherwise the current directory will
                         be searched for file names that contain <filespec>.
                         Wildcards may also be used but <filespec> should be
                         enclosed in quotes, e.g. "NLGN*.fasta"

    <output_directory> = output files will be placed in this directory.
                         Optional. Default is current directory. Output file
                         names will be based on <filespec>

USAGE

}


##############################################################################
### Internal Documentation
##############################################################################

=begin Revision Notes

20070627 - Version 1.0.0

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

RA_fasta2genpos.pl - program to generate genpos and primers files from
multi-fasta file

=head1 VERSION

This documentation refers to process_chipdesign.pl version 1.0.0

=head1 USAGE

RA_fasta2genpos.pl -i <filespec> [-o <output_directory>]

=head1 REQUIRED ARGUMENTS

=head2 -i <filespec>

Text file(s) containing sequence data in fasta format. If a directory, it will
be searched for files with a .fasta extension. Otherwise the current directory
will be searched for file names that contain <filespec>. Wildcards may also be
used but <filespec> should be enclosed in quotes, e.g. "NLGN*.fasta"

=head1 OPTIONAL ARGUMENTS

=head2 -o <output_directory>

output files will be placed in this directory. Default is current directory.
Output file names will be based on <filespec>

=head1 OPTIONS

=head1 DESCRIPTION

This program reads a multi fasta file and extracts the sequence ranges from
the headers. The ranges are saved to genpos and primers files.

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

