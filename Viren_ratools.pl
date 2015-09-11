#!/usr/bin/perl
#
# RATools Overview
#--------------------------------------------------------------------------
# RATools is software developed for the Drosophila Population
# Genomics Project (available at http://x-dpgp.ucdavis.edu/RA/ra.htm).  
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# This code can aligh a "locally perfect" grid onto Affymetrix, Inc. or 
# Nimblegen, Inc. resequencing arrays (RA). Currently the code supports 
# Affymetrix RAs. Support for Nimblegen arrays is pending (and Nimblegen 
# has a data extraction tool that puts the intensity data in the format 
# necessary for basecalling below)
#
# This Perl script will descend into all directories beginning 
# the passed directory name passed.  Within each directory, the RATool 
# input files will be created.  Within each directory, another 
# directory named BaseCaller will be created.  RATool output will be 
# placed in this directory. Lastly, another directory within BaseCaller 
# called FINAL will be created, and final reliablity rules will be applied.
# The thresholds used correspond to those described in Zwick et al 2004
#
# A variety of parameters can be examined using the run_parameter_search.pl 
# script.
#
# RATools Basecalling Parameters 
#--------------------------------------------------------------------------
# $TotThresh 
# The total quality score threshold that a given base has to exceed to be 
# called. Increasing this value requires increased support for basecalls. 
# As a consequence, fewer bases are called. Bases that fail to reach this
# thresold are callled "N."

# $StrThresh 
# The strand minimum score. Sets a threshold governing the degree to
# which different strands can support different hypotheses. Decreasing 
# this value reduces the degree to which the forward/reverse strands can 
# differ, hence, reducing the number of bases called. If this threshold is 
# exceeded, the base will be called "N".

# RATools - Final Reliability Rules
#--------------------------------------------------------------------------
# $InvalidateBase 
# This parameter is used in the final reliability rules section of the code. 
# This parameter defines the proportion of samples that can fail at a
# given site. If this threshold is exceeded, the given base in all samples is
# called "N."

# $InvalidateFrag
# This parameter is used in the final reliability rules section of the code. 
# This parameter defines the proportion of bases that can fail withing a 
# given PCR product. If this threshold is exceeded, all the bases
# in the PCR product are called "N".

# $WindowSize 
# This parameter is used in the final reliability rules section of the
# code. This parameter defines the size of a neighborhood window.

# $FailThresh 
# This parameter is used in the final reliability rules section of
# the code. This parameter defines the proportion of bases in a neighborhood
# window (defined by $WindowSize) that can fail. If this threshold is exceeded,
# all the bases in the window are called "N".

# Code Updates
#--------------------------------------------------------------------------
# Version 1.1
# Date: 19 January 2005 by Michael E. Zwick
# Changes:
# 1. Added additional documentation about the RATools Model Parameters - for 
# basecalling and final_reliability rules
# 2. Restructured the .pl script to include subroutines in an attempt to make 
# the code more easily followed.
# 3. There are now three scripts for running RATools:
#  - run_all.pl - which runs all programs
#  - run_basecaller.pl - which run everything except grid_alignment
#  - run_parameter_search - which does not run grid_alignment, searches over 
#    a user defined parameter space
# Version 1.2

use warnings;
use strict;
use version;
use Cwd;
use Carp;
use Getopt::Std;
use File::Spec;
use Config::Tiny;
use File::Temp qw/ tempfile tempdir /;
use File::Copy;


##############################################################################
### Constants
##############################################################################

use constant DEBUG => 0;    # change to 0 for production

use constant FALSE => 0;
use constant TRUE  => 1;

use constant VERSION => qv('3.0.0');
use constant PROGRAM => eval { ($0 =~ m/(\w+\.pl)$/) ? $1 : $0 };

##############################################################################
### Globals
##############################################################################

my %hCmdLineOption;
my $sCmdLineSpec = 'i:v';

my (@aInputDirs, @aInputFiles, @aNewInputFiles, @aLqFiles);
my ($sIniFile, $sPrimerFile, $sGenposFile);
my ($oRunConfig, $oStatusConfig) ;
my ($nNumInputFiles, $nNumNewInputFiles);
my $nLQvsCDF;
my $bVerbose;

if (DEBUG) {
    $hCmdLineOption{'i'} = 'Test1';
    $hCmdLineOption{'v'} = TRUE;
}
else {
    # Process command line options
    $Getopt::Std::STANDARD_HELP_VERSION = TRUE;
    getopts($sCmdLineSpec, \%hCmdLineOption);
}

if (! (defined $hCmdLineOption{'i'})) {
    Getopt::Std->version_mess($sCmdLineSpec);
    Getopt::Std->help_mess($sCmdLineSpec);
    exit 0;
}
else {
    @aInputDirs = ();
    foreach (glob($hCmdLineOption{'i'})) {
        if (-d $_) {
            push @aInputDirs, $_;
        }
    }
}

$bVerbose = FALSE;
if (defined $hCmdLineOption{'v'}) {
    $bVerbose = TRUE;
}

# Obtain file names, run grid_alignment, basecaller, final_reliability 
# subroutines
foreach my $sDir (@aInputDirs) {

    if ($bVerbose) {
        print STDERR "Processing $sDir...\n";
    }

    chdir $sDir || croak "Cannot change to directory $sDir\n";

    Print_Curr_Dir($bVerbose);

    if ($sDir =~ /.*\/(.*)$/) {
        $sDir = $1;
    }

    undef @_;
    @_ = glob('*.ini');
    if (defined @_) {
        if ($#_ > 0) {
            croak "Error! More than one .ini file found in $sDir\n";
        }
        $sIniFile = $_[0];
        $oRunConfig = Config::Tiny->read($sIniFile);

        if (defined $oRunConfig->{DataType}->{LQvsCDF}) {
            Convert_Ini($oRunConfig);
            $oRunConfig->write($sIniFile);
        }
    }
    else {
        croak "Error! .ini file not found in $sDir\n";
    }

    undef @_;
    @_ = glob('*.primers.txt');
    if (defined @_) {
        if ($#_ > 0) {
            croak "Error! More than one .primer.txt file found in $sDir\n";
        }
        $sPrimerFile = $_[0];
    }
    else {
        croak "Error! .primers.txt file not found in $sDir\n";
    }

    undef @_;
    @_ = glob('*.genpos.txt');
    if (defined @_) {
        if ($#_ > 0) {
            croak "Error! More than one .genpos.txt file found in $sDir\n";
        }
        $sGenposFile = $_[0];
    }
    else {
        croak "Error! .genpos.txt file not found in $sDir\n";
    }

    @aInputFiles = ();
    my $nDataFileType = $oRunConfig->{Data}->{FileType};

	# Code for Affymetrix .DAT and .cdf files
    if ($nDataFileType == 1 || $nDataFileType == 2 || $nDataFileType == 3) {
		# Get .DAT file names, number of files
		@aInputFiles = glob('*.DAT');
		@aLqFiles = glob('*.cdf');
        if (@aLqFiles < 1) {
            @aLqFiles = glob('*.1lq');
            if (@aLqFiles < 1) {
                croak "Error: Affymetrix .cdf or .1lq files not found\n";
            }
            else {
                $oRunConfig->{Data}->{FileType} = '1';

            }
        }
    }
	# Code for Nimblegen .tif and .ndf files
    elsif ($nDataFileType == 4) {
	    # Get .DAT file names, number of files
        @aInputFiles = glob('*.tif');
        @aLqFiles = glob('*.ndf');
	}

    $nNumInputFiles = @aInputFiles;
    @aNewInputFiles = @aInputFiles;

    # Check for already processed files
    if (-e 'status') {
    
    	$oStatusConfig = Config::Tiny->read('status');

        my @aTmp = ();

    	for (my $x = 0; $x < @aNewInputFiles; $x++) {
            next if (defined $oStatusConfig->{_}->{$aNewInputFiles[$x]});
            push @aTmp, $aNewInputFiles[$x];
            $oStatusConfig->{_}{$aNewInputFiles[$x]} = TRUE;
        }
        @aNewInputFiles = @aTmp;
        @aTmp = ();
    }
    else {
    	$oStatusConfig = Config::Tiny->new();
    }
    

    if (@aNewInputFiles) {
    
    	@aNewInputFiles = sort @aNewInputFiles;
	    $nNumNewInputFiles = @aNewInputFiles;

		# Perform Grid Alignment
		Run_Grid_Alignment(\@aNewInputFiles, \@aLqFiles, $oRunConfig,
						   $nNumNewInputFiles, $sDir, $bVerbose);
	
    }
    else {
        print STDERR "\tNo new input samples ... Grid alignment skipped\n";
    }

    # Perform Basecalling (assumes grid alignment already performed)
    Run_BaseCaller($oRunConfig, $nNumInputFiles, $sDir, $bVerbose);

    # Execute Popgen Caller
    if ( (lc($oRunConfig->{PopGenCaller}->{RunPopGenCaller}) =~ /^y/ ) &&
        ($nNumInputFiles >= 2)) {
        Run_PopGenCaller($oRunConfig, $nNumInputFiles, $sDir, $bVerbose);
    }
    elsif ( (lc($oRunConfig->{PopGenCaller}->{RunPopGenCaller}) =~ /^y/ ) &&
            ($nNumInputFiles < 2)) {
        print STDERR "Warning: insufficient sample size for PopGenCaller\n";
    }

    # Apply Final Reliability Rules to Data (assumes grid alignment, base
    # calling already performed)
    Run_Final_Reliability(\@aInputFiles, $oRunConfig, $sPrimerFile,
                            $sGenposFile, $nNumInputFiles, $sDir,
                            $bVerbose);

    # Save status of processed files
    foreach (@aInputFiles) {
        $oStatusConfig->{_}->{$_} = TRUE;
    }
    $oStatusConfig->write('status');

    chdir('..');

    Print_Curr_Dir($bVerbose);

}

exit;

##############################################################################
### Subroutines
##############################################################################

sub VERSION_MESSAGE {

    print STDERR "\nThis is ".PROGRAM." version ".VERSION."\n";
}

sub HELP_MESSAGE {

    print STDERR "\nUsage: ".PROGRAM." -i <directory> [-v]";

    print STDERR <<USAGE;

    -i <directory> = location of initialization and data files
    -v             = be verbose (optional)

USAGE

}

#-----------------------------------------------------------------------------

sub Run_Grid_Alignment {

    my $paInputFiles = shift;
    my $paLqFiles = shift;
    my $oConfig = shift;
    my $nNumInputFiles = shift;
    my $sDir = shift;
    my $bVerbose = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $sGridAlign = $oConfig->{RATools}->{Path}."/RA_GridAlign";
    my @aInputFiles = ();
    my $bMerge = FALSE;
    my $oStatusConfig;
    my $FP;

    if (DEBUG || $bVerbose) {
        print STDERR "In Run_Grid_Alignment()\n";
    }

    # Check for already processed files
    if (-e 'status') {

        if (-e "$sDir.txt") {
            rename("$sDir.txt", "$sDir.txt.merge");
        }
        else {
            croak "$sSubName - Cannot find $sDir.txt\n";
        }
        $bMerge = TRUE;

    }

    open($FP, '>', 'align.in') ||
        croak "$sSubName - Cannot open align.in\n";

    print $FP "d\n",
                "$sDir.txt\n",
                "$oConfig->{GridAlignment}->{TargetConformance}\n",
                "$oConfig->{GridAlignment}->{ColumnWidth}\n",
                "$oConfig->{GridAlignment}->{RowWidth}\n",
                "$oConfig->{Data}->{FileType}\n",
                "@$paLqFiles\n",
                "$nNumInputFiles\n";

    for (my $c = 0; $c < $nNumInputFiles; $c++) {
        print $FP "@$paInputFiles[$c]\n";
    }

    close($FP);

    if ($bVerbose) {
        print STDERR "\t$sGridAlign < align.in > alignment.txt\n";

        print STDERR "\tGridAlign Candidates:\n";

        {
            $" = "\n\t";
            print STDERR "\t@$paInputFiles\n";
        }
    }

    `$sGridAlign < align.in > alignment.txt`;

    if ($bMerge) {
        Merge_GridAlign_Files("$sDir.txt.merge", "$sDir.txt", $bVerbose);
    }

    return;
}

#-----------------------------------------------------------------------------

sub Run_BaseCaller {

    my $oConfig = shift;
    my $nNumInputFiles = shift;
    my $sDir = shift;
    my $bVerbose = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $sBaseCaller = $oConfig->{RATools}->{Path}."/RA_BaseCaller";
    my $FP;

    if (DEBUG || $bVerbose) {
        print STDERR "In Run_BaseCaller...\n";
    }

    if (-e 'BaseCaller') {
        system('/bin/rm -R BaseCaller');
    }
    
    mkdir('BaseCaller', 0755);

    chdir('BaseCaller') ||
        croak "$sSubName - Cannot change to directory BaseCaller\n";

    Print_Curr_Dir($bVerbose);

    symlink("../$sDir.txt", "$sDir.txt");

    open($FP, '>', 'basecaller.in') ||
        croak "$sSubName - Cannot open basecaller.in\n";

    print $FP "d\n",
              "$sDir.summary.txt\n",
              "$sDir.txt\n",
              "$oConfig->{Data}->{OutputFastA}\n",
              "../$sDir.ref.fasta\n",
              "$oConfig->{BaseCaller}->{TotalThreshold}\n",
              "$oConfig->{BaseCaller}->{StrandThreshold}\n",
              "$oConfig->{Data}->{DataType}\n";

    close($FP);

    if ($bVerbose) {
        print STDERR "\t$sBaseCaller < basecaller.in\n";
    }

	`$sBaseCaller < basecaller.in`;
	
    chdir('..');

    Print_Curr_Dir($bVerbose);

    return;
}

#-----------------------------------------------------------------------------

sub Run_PopGenCaller {

    my $oConfig = shift;
    my $nNumInputFiles = shift;
    my $sDir = shift;
    my $bVerbose = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $sPopGenCaller = $oConfig->{RATools}->{Path}."/RA_PopGenCaller";
    my $FP;

    if (DEBUG || $bVerbose) {
        print STDERR "In Run_PopGenCaller...\n";
    }

    chdir('BaseCaller') ||
        croak "$sSubName - Cannot change to directory BaseCaller\n";

    Print_Curr_Dir($bVerbose);

    open($FP, '>', 'popgencaller.in') ||
        croak "$sSubName - Cannot open popgencaller.in\n";

    print $FP "d\n",
              "$sDir.popgen_out.txt\n",
              "$sDir.txt\n",
              "$oConfig->{PopGenCaller}->{PopGenThreshold}\n",
              "$oConfig->{PopGenCaller}->{PopGenTheta}\n",
              "$oConfig->{Data}->{DataType}\n";

    close($FP);

    if ($bVerbose) {
        print STDERR "\t$sPopGenCaller < popgencaller.in\n";
    }

    `$sPopGenCaller < popgencaller.in`;

    chdir('..');

    Print_Curr_Dir($bVerbose);

    return;
}

#-----------------------------------------------------------------------------

sub Run_Final_Reliability {

    my $paInputFiles = shift;
    my $oConfig = shift;
    my $sPrimerFile = shift;
    my $sGenposFile = shift;
    my $nNumInputFiles = shift;
    my $sDir = shift;
    my $bVerbose = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $sFinal = $oConfig->{RATools}->{Path}."/RA_Final";
    my $FP;


    if (DEBUG || $bVerbose) {
        print STDERR "In Run_Final_Reliability()\n";
    }

    chdir('BaseCaller') || 
        croak "$sSubName - Cannot change to directory BaseCaller\n";

    Print_Curr_Dir($bVerbose);

    if (! -d 'FINAL') {
        mkdir ('FINAL',0755);
    }

    chdir('FINAL') || croak "$sSubName - Cannot change to directory FINAL\n";

    Print_Curr_Dir($bVerbose);

    open($FP, '>', 'final.in') ||
        croak "$sSubName - Cannot open final.in for writing\n";

    print $FP "d\n",
              "$sDir.final.summary.txt\n",
              "$nNumInputFiles\n",
              "../../$sDir.ref.fasta\n",
              "$oConfig->{Data}->{NumPrimers}\n",
              "../../$sPrimerFile\n",
              "$oConfig->{Data}->{RewriteFastA}\n",
              "$sDir.final\n",
              "$oConfig->{Reliability}->{InvalidateBase}\n",
              "$oConfig->{Reliability}->{InvalidateFragment}\n",
              "$oConfig->{Reliability}->{WindowSize}\n",
              "$oConfig->{Reliability}->{FailThreshold}\n";

	for ( my $i = 0; $i < $nNumInputFiles; $i++) {
        print $FP "../@$paInputFiles[$i].fasta\n";
	}

    print $FP "$oConfig->{Data}->{NumSegments}\n",
              "$oConfig->{Data}->{Offset}\n",
              "$oConfig->{Data}->{MaxNumSites}\n",
              "../../$sGenposFile\n",
              "../$sDir.txt.fail\n";

    close($FP);

    if ($bVerbose) {
        print STDERR "\t$sFinal < final.in\n";
    }

	`$sFinal < final.in`;
	
    chdir('../../');
    
    Print_Curr_Dir($bVerbose);

    return;
}

#-----------------------------------------------------------------------------

sub Merge_GridAlign_Files {
    my $sFile1 = shift;
    my $sFile2 = shift;
    my $bVerbose = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $sFile3;
    my ($sLine1, $sLine2, $sLine3);
    my ($FP1, $FP2, $FP3);

    if (DEBUG || $bVerbose) {
        print STDERR "In Merge_GridAlign_Files()\n";
    }

    if (Count_Lines($sFile1) != Count_Lines($sFile2)) {
        croak "$sSubName - number of records do not match\n";
    }

    open($FP1, '<', $sFile1) ||
        croak "$sSubName - Cannot open $sFile1 for reading\n";

    open($FP2, '<', $sFile2) ||
        croak "$sSubName - Cannot open $sFile2 for reading\n";

    ($FP3, $sFile3) = tempfile();

    # copy first line
    $sLine1 = <$FP1>;
    $sLine2 = <$FP2>;
    print $FP3 "$sLine1";

    # merge second line
    $sLine1 = <$FP1>;
    $sLine2 = <$FP2>;
    chomp $sLine1;
    chomp $sLine2;
    print $FP3 "$sLine1";
    ($_, $_, $sLine1) = split(/\s/, $sLine2, 3);
    print $FP3 "\t$sLine1\n";

    # copy third line
    $sLine1 = <$FP1>;
    $sLine2 = <$FP2>;
    chomp $sLine1;
    print $FP3 "$sLine1";

    # merge remainining lines
    while ( defined($sLine1 = <$FP1>) && defined($sLine2 = <$FP2>)) {
        chomp $sLine1;
        chomp $sLine2;

        print $FP3 "\n$sLine1";
        ($_,$_,$_,$_,$_,$sLine1) = split(/\s/, $sLine2, 6);
        print $FP3 "\t$sLine1";

    }

    close($FP3);
    close($FP2);
    close($FP1);

    unlink($sFile1);
    unlink($sFile2);
    copy($sFile3, $sFile2);
    
    return;
}

#-----------------------------------------------------------------------------

sub Count_Lines {
    my $sFile = shift;

    # Local variables
    my $sSubName = (caller(0))[3];
    my $x = 0;
    my $FP;

    open($FP, '<', $sFile) ||
        croak "$sSubName - Cannot open $sFile for reading\n";

    while (<$FP>) {
        $x++;
    }

    close($FP);

    return $x;
}

#-----------------------------------------------------------------------------

sub Print_Curr_Dir {
    my $bVerbose = shift;

    if ($bVerbose) {
        print STDERR "\tCurr. Dir.: ".getcwd()."\n";
    }
}

#-----------------------------------------------------------------------------

sub Convert_Ini {
    my $phIni = shift;

    $phIni->{Data}->{DataDirectory} = $phIni->{DataType}->{DirName};
    $phIni->{Data}->{FileType} = $phIni->{DataType}->{LQvsCDF};
    $phIni->{Data}->{OutputFastA} = $phIni->{DataType}->{OutputFasta};
    $phIni->{Data}->{RewriteFastA} = $phIni->{DataType}->{RewriteFasta};
    if ($phIni->{DataType}->{Haploid} eq 'y') {
        $phIni->{Data}->{DataType} = 'Haploid';
    }
    else {
        $phIni->{Data}->{DataType} = 'Diploid';
    }
    $phIni->{Data}->{NumPrimers} = $phIni->{DataType}->{PrimersUsed};
    $phIni->{Data}->{NumSegments} = $phIni->{DataType}->{NumSegs};
    $phIni->{Data}->{Offset} = $phIni->{DataType}->{Offset};
    $phIni->{Data}->{MaxNumSites} = $phIni->{DataType}->{MaxSites};

    $phIni->{Cluster}->{Node} = '7';

    $phIni->{GridAlignment}->{ColumnWidth} =
    $phIni->{GridAlignment}->{ColWidth};

    $phIni->{BaseCaller}->{TotalThreshold} =
    $phIni->{BaseCaller}->{TotThresh};
    $phIni->{BaseCaller}->{StrandThreshold} =
    $phIni->{BaseCaller}->{StrThresh};

    $phIni->{PopGenCaller}->{PopGenThreshold} =
    $phIni->{PopGenCaller}->{Threshold};
    $phIni->{PopGenCaller}->{PopGenTheta} = $phIni->{PopGenCaller}->{Theta};

    $phIni->{Reliability}->{InvalidateBase} =
    $phIni->{ReliabilityRules}->{InvalidateBase};
    $phIni->{Reliability}->{InvalidateFragment} =
    $phIni->{ReliabilityRules}->{InvalidateFrag};
    $phIni->{Reliability}->{WindowSize} =
    $phIni->{ReliabilityRules}->{WindowSize};
    $phIni->{Reliability}->{FailThreshold} =
    $phIni->{ReliabilityRules}->{FailThresh};

    delete $phIni->{DataType};
    delete $phIni->{GridAlignment}->{ColWidth};
    delete $phIni->{BaseCaller}->{TotThresh};
    delete $phIni->{BaseCaller}->{StrThresh};
    delete $phIni->{PopGenCaller}->{Threshold};
    delete $phIni->{PopGenCaller}->{Theta};
    delete $phIni->{ReliabilityRules};
}

#-----------------------------------------------------------------------------


