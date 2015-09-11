#!/usr/bin/perl -w
##############################################################################
### Denovo_CNV_Locus_Caller
###
### Program to determine denovo CNV loci.
###
### Usage: denovo_cnv_locus_caller_v3.pl -i <directory> [-t threshold]
###
##############################################################################
use strict;

use Cwd;
use Carp;
use Getopt::Long;
use Pod::Usage;
use File::Spec;
use File::Temp qw/ tempfile /;
use FindBin qw($RealBin);
use File::Path;
use File::Basename;

##############################################################################
### Constants
##############################################################################
use constant FALSE => 0;
use constant TRUE  => 1;
use constant VERSION => '3.0.1';
use constant PROGRAM => eval { ($0 =~ m/(\w+\.pl)$/) ? $1 : $0 };
use constant NUM_SW => 3;

##############################################################################
### Globals
##############################################################################
my %hCmdLineOption = ();
my $sHelpHeader = "\nThis is ".PROGRAM." version ".VERSION."\n";
my (%hList, %hCandidate, %hBrkPntCount);
my (@aDataFiles);
my ($sOutDir, $sInFile, $sErrorFile);
my ($fpERR);
my ($bDebug, $bVerbose);

##############################################################################
### Main
##############################################################################
# process command line arguments, if any
GetOptions( \%hCmdLineOption,
            'inputdir|i=s', 'outdir|o=s', 'suffix|s=s',
            'verbose|v',
            'debug',
            'help',
            'man') or pod2usage(2);
            
if ($hCmdLineOption{'debug'}) {
	$hCmdLineOption{'inputdir'} = "$RealBin/test_combine/";
	$hCmdLineOption{'outdir'} = "Combined_090514";
	$hCmdLineOption{'suffix'} = "100k";
	$bDebug = TRUE;
}

if ($hCmdLineOption{'help'} || (! defined $hCmdLineOption{'inputdir'})) {
    pod2usage( -msg => $sHelpHeader, -exitval => 1);
}

pod2usage( -exitval => 0, -verbose => 2) if $hCmdLineOption{'man'};

if (! -d $hCmdLineOption{'inputdir'}) {
    die "Error. $hCmdLineOption{'inputdir'} is not a directory\n";
}
else {
	if ($hCmdLineOption{'inputdir'} =~ /\/$/) {
		$hCmdLineOption{'inputdir'} =
			substr($hCmdLineOption{'inputdir'},0,-1);
	}
    @aDataFiles = glob("$hCmdLineOption{'inputdir'}/*.txt");
}

$sOutDir = $hCmdLineOption{'inputdir'};
if ( defined $hCmdLineOption{'outdir'} ) {
	$sOutDir = $hCmdLineOption{'outdir'};
	if (! -e $sOutDir) {
		mkdir("$sOutDir");
	}
}

$sOutDir = File::Spec->canonpath($sOutDir);

my @aDirs = File::Spec->splitdir($hCmdLineOption{'inputdir'});

$bVerbose = (defined $hCmdLineOption{'verbose'}) ? TRUE : FALSE;

foreach my $sFile (@aDataFiles) {
	($_, $_, $sInFile) = File::Spec->splitpath($sFile);
	if (! ($sInFile =~ m/ ^
						  ([A-Za-z_]+)
						  \.
						  ([A-Za-z0-9_]+)
						  \.
						  ([A-Za-z0-9_]+)
						  \.
						  ([A-Za-z0-9_]+)
						  \.
						  ([A-Za-z_]+)
						/x ) ) {
		die "Error - Improper filename $sInFile in ".
			"$hCmdLineOption{'inputdir'} .....\n";
	}
	
	if (! defined $hList{"$1\_$2\_$3\_$4"}) {
		my @aFiles = ();
		
		$hList{"$1\_$2\_$3\_$4"} = \@aFiles;
	}
	
	push @{$hList{"$1\_$2\_$3\_$4"}}, $sFile;
	
}

$sErrorFile = "$hCmdLineOption{'inputdir'}.error.log";

open ($fpERR, ">$sErrorFile") or
	die "\tCannot open $sErrorFile for writing .....\n";

foreach my $sCandidate (sort keys %hList) {
#	%hCandidate = ();
#	%hBrkPntCount = ();
	
	foreach $sInFile ( @{$hList{$sCandidate}} ) {
	    Read_Data(\%hCmdLineOption, \%hCandidate, \%hBrkPntCount, $sInFile);
	}
}
	Find_Common_Breakpoints( \%hCmdLineOption,
							 \%hCandidate,
						 	 \%hBrkPntCount,
						 	 $sOutDir,
							 $fpERR );

    

close($fpERR);
	
if ( -z $sErrorFile ) {
	`echo "No Errors found !!!!!" > $sErrorFile`;
}

exit;

##############################################################################
### Subroutines
##############################################################################

# Read_Data()
#
# Purpose
#
# Required Parameters
#
# Optional Parameters
#
# Side Effects
#
# Returns
# 
# Assumptions
#
# Notes
#
sub Read_Data {
	my $phCmdLineOption	= shift;
    my $phCandidate 	= shift;
    my $phCount			= shift;
    my $sFileName 		= shift;
	
	my $sSubName = (caller(0))[3];
    
    if (! ((defined $phCmdLineOption) &&
    	   (defined $phCandidate) &&
           (defined $phCount) &&
           (defined $sFileName))) {
        die "$sSubName - required parameters missing\n";
    }
    
    # Local variables
    my $bDebug   = (defined $phCmdLineOption->{'debug'}) ? TRUE : FALSE;
    my $bVerbose = (defined $phCmdLineOption->{'verbose'}) ? TRUE : FALSE;
	
    my ($sType, $sFamilyId, $sIndvId, $sIll);
    my ($sSw, $sChr, $sInFile);
    my @aFields;
    my $fpIN;
    #Start
    
#    ($bDebug) ? print STDERR "In $sSubName\n" : ();
	
	($_, $_, $sInFile) = File::Spec->splitpath($sFileName);
	
	if (! ($sInFile =~ m/ ^
						  ([A-Za-z_]+)
						  \.
						  ([A-Za-z0-9_]+)
						  \.
						  ([A-Za-z0-9_]+)
						  \.
						  ([A-Za-z_]+)
						/x ) ) {
		die "Error - Improper filename $sInFile in ".
			"$hCmdLineOption{'inputdir'} .....\n";
	}
	
	$sType = $1;
	$sFamilyId = $2;
	$sIndvId = $3;
	$sSw = $4;
    open($fpIN, '<', $sFileName) ||
        die "Error - cannot open $sFileName for reading\n";
    
    while (<$fpIN>) {
        $_ =~ s/\s+$//;							# extended chomp
        @aFields = split(/\s+/,$_);
        my $rCNVRecord = {
            ID      => $aFields[0],
            START   => $aFields[2],
            STOP    => $aFields[3],
            LNRATIO => $aFields[4],
            GNL     => $aFields[5],
            SW		=> $sSw,
        };
        if ((-1 <= $aFields[5]) && ($aFields[5] <= 1)) {
        	
	        if (! defined $phCandidate->{"$sType\_$sFamilyId\_$sIndvId"}
										{$sSw}
										{$aFields[1]} ) {
    	        my @arCNV = ();
	
    	        $phCandidate->{"$sType\_$sFamilyId\_$sIndvId"}
							  {$sSw}
							  {$aFields[1]} = \@arCNV;
        	}

	        push @{$phCandidate->{"$sType\_$sFamilyId\_$sIndvId"}
								 {$sSw}
								 {$aFields[1]}}, $rCNVRecord;
    	    
        	$phCount->{"$sType\_$sFamilyId\_$sIndvId"}{$sSw}++;
        	
        }
    }
    close($fpIN);
    return;
}

# Find_Common_Breakpoints()
#
# Purpose
#
# Required Parameters
#
# Optional Parameters
#
# Side Effects
#
# Returns
# 
# Assumptions
#
# Notes
#
sub Find_Common_Breakpoints {
	my $phCmdLineOption	= shift;
    my $phCandidate 	= shift;
    my $phCount			= shift;
    my $sOutDir			= shift;
    my $fpERR			= shift;
	
	my $sSubName = (caller(0))[3];
    
    if (! ((defined $phCmdLineOption) &&
    	   (defined $phCandidate) &&
    	   (defined $phCount) &&
    	   (defined $sOutDir))) {
        die "$sSubName - required parameters missing\n";
    }
    
    # Local variables
    my $bDebug   = (defined $phCmdLineOption->{'debug'}) ? TRUE : FALSE;
    my $bVerbose = (defined $phCmdLineOption->{'verbose'}) ? TRUE : FALSE;
	
	my (%hVChr);
	my ($sOutFile);
	my ($parMaster);
    my ($sId, $sSw, $sChr, $nStart);
    my ($sCnvId, $nCnvStart, $nCnvStop, $nCnvGNL, $sCnvSw, $rCNV);
    my ($m, $n);
    my ($bEnd, $bFlag, $bOverLap);
    my ($fpOUT);
    #Start
    
#   ($bDebug) ? print STDERR "In $sSubName\n" : ();
	
	foreach $sId ( sort keys %{$phCandidate}) {

        %hVChr = ();

		my $sPrefix = join('.', split(/_/, $sId));
		$sOutFile = "$sOutDir/$sPrefix.Combined";
		if (defined $phCmdLineOption->{'suffix'}) {
			$sOutFile .= "_$phCmdLineOption->{'suffix'}";
		}
		$sOutFile .= ".txt";

		($bDebug || $bVerbose) ? print STDERR "\tCandidate Id : $sPrefix\n" : undef;
		
		$bFlag = 0;

		my @aSortedKeys =
			sort {$phCount->{$sId}{$a} <=> $phCount->{$sId}{$b}} 
			keys %{$phCount->{$sId}};
		
		if (@aSortedKeys < NUM_SW) {
			{
				$" = "\t";
				print $fpERR "$sPrefix has breakpoints only in @aSortedKeys\n\n";
			}
		}
		
		if (@aSortedKeys > 1) {

			foreach $m ( 0 .. (@aSortedKeys - 1) ) {
				($bDebug || $bVerbose) ?
					print STDERR "\t\tParsing breakpoints in $aSortedKeys[$m]"
					: undef;
				($bDebug) ? print STDERR "\t\t" : undef;
				foreach $sChr (
					sort keys %{$phCandidate->{$sId}{$aSortedKeys[$m]}}) {
					($bDebug) ? print STDERR "\t$sChr" : undef;
					$parMaster = $phCandidate->{$sId}{$aSortedKeys[$m]}{$sChr};
					
					foreach $rCNV ( 0 .. $#{$parMaster} ) {
						if (! defined $hVChr{$sChr}{$parMaster->[$rCNV]->{START}}) {
							my @aCNV = ();
							$hVChr{$sChr}{$parMaster->[$rCNV]->{START}} = \@aCNV;
						}
						push @{$hVChr{$sChr}{$parMaster->[$rCNV]->{START}}}, $parMaster->[$rCNV];
					}
				}
				($bDebug || $bVerbose) ? print STDERR "\n" : undef;
			}
			
			foreach $sChr (sort ByChr keys %hVChr) {
				($bDebug) ?
					print STDERR "\n\t\tCommon Breakpoints in Chromosome $sChr\n"
					: undef;
				$nCnvStart = $nCnvStop = $bEnd = $bOverLap = 0;
				my @aLNRatios = ();
				my @aGNLs = ();
				foreach $nStart (sort {$a <=> $b} keys %{$hVChr{$sChr}}) {
					foreach $rCNV ( 0 .. $#{$hVChr{$sChr}{$nStart}} ) {
						if ($nCnvStart == 0 && $nCnvStop == 0) {
							$sCnvId = $hVChr{$sChr}{$nStart}->[$rCNV]->{ID};
							$nCnvStart = $nStart;
							$nCnvStop =	$hVChr{$sChr}{$nStart}->[$rCNV]->{STOP};
							$nCnvGNL = $hVChr{$sChr}{$nStart}->[$rCNV]->{GNL};
							$sCnvSw = $hVChr{$sChr}{$nStart}->[$rCNV]->{SW};
							push @aLNRatios, $hVChr{$sChr}{$nStart}->[$rCNV]->{LNRATIO};
							push @aGNLs,$hVChr{$sChr}{$nStart}->[$rCNV]->{GNL};

							($bDebug) ?
								print STDERR
								"\t\t\t$nStart".
								"\t$hVChr{$sChr}{$nStart}->[$rCNV]->{STOP}\t".
								"$nCnvStart\t".
								"$nCnvStop\t".
								"$bOverLap\n" : undef;

							next;
						}
						
						if ($nStart < $nCnvStop) {
							my @aPosArray =
								( $nCnvStart,
								  $nCnvStop,
								  $nStart,
								  $hVChr{$sChr}{$nStart}->[$rCNV]->{STOP}
							    );
							@aPosArray = sort {$a<=>$b} @aPosArray;
							
							my $nLen =
								( ( ($nCnvStop - $nCnvStart + 1) <=
									($hVChr{$sChr}{$nStart}->[$rCNV]->{STOP} -
										$nStart + 1)
								  ) ?
								  ($nCnvStop - $nCnvStart + 1)
								  : ($hVChr{$sChr}{$nStart}->[$rCNV]->{STOP} -
									  $nStart + 1)
							    );
							
							my $nOverlap = ($aPosArray[2] - $aPosArray[1] + 1);
							
							if (($nOverlap / $nLen) >= 0.5) {
								
								if ( ($hVChr{$sChr}{$nStart}->[$rCNV]->{ID} ne $sCnvId) ||
								     ($hVChr{$sChr}{$nStart}->[$rCNV]->{GNL} != $nCnvGNL) ) {

									print $fpERR
									"$sPrefix\n\t".
									"$hVChr{$sChr}{$nStart}->[$rCNV]->{SW}  ".
									"$hVChr{$sChr}{$nStart}->[$rCNV]->{ID}  ".
									"$sChr  $nStart  ".
									"$hVChr{$sChr}{$nStart}->[$rCNV]->{GNL} ".
									"does not match $sCnvSw  $sCnvId  $sChr ".
									"$nCnvStart  $nCnvGNL\n\n";
								}
								
								$bOverLap = 1;
								$nCnvStop = $aPosArray[3];
								push @aLNRatios, $hVChr{$sChr}{$nStart}->[$rCNV]->{LNRATIO};
								push @aGNLs, $hVChr{$sChr}{$nStart}->[$rCNV]->{GNL};
								
							}
							else {
								$bEnd = 1;
							}
						}
						else {
							$bEnd = 1;
						}
						
						if ($bEnd) {
							if ($bOverLap) {
								if (! $bFlag) {
									open ($fpOUT, ">$sOutFile") or
										die "\tCannot open $sOutFile ".
											"for writing .....\n";
									$bFlag = 1;
								}
								
								print $fpOUT "$sPrefix\t".
											 "$sChr\t".
											 "$nCnvStart\t".
											 "$nCnvStop\t";
											 
								my $nSum = 0;
								foreach ( @aLNRatios ) {
									$nSum += $_;
								}
								
								my $nRatio = $nSum / @aLNRatios;
								print $fpOUT "$nRatio\t";
								
								@aGNLs = sort {$a <=> $b} @aGNLs;
								my $nGNL = $aGNLs[(int(@aGNLs/2))];
								
								print $fpOUT "$nGNL\n";
							}
								
							$sCnvId = $hVChr{$sChr}{$nStart}->[$rCNV]->{ID};
							$nCnvStart = $nStart;
							$nCnvStop = $hVChr{$sChr}{$nStart}->[$rCNV]->{STOP};
							$nCnvGNL = $hVChr{$sChr}{$nStart}->[$rCNV]->{GNL};
							$sCnvSw = $hVChr{$sChr}{$nStart}->[$rCNV]->{SW};
							@aLNRatios = ();
							push @aLNRatios,
								$hVChr{$sChr}{$nStart}->[$rCNV]->{LNRATIO};
							@aGNLs = ();
							push @aGNLs,
								$hVChr{$sChr}{$nStart}->[$rCNV]->{GNL};
							
							$bEnd = $bOverLap = 0;
						}
						
						($bDebug) ? 
							print STDERR
								"\t\t\t$nStart\t".
								"$hVChr{$sChr}{$nStart}->[$rCNV]->{STOP}\t".
								"$nCnvStart\t$nCnvStop\t$bOverLap\n"
							: undef;
					}
				}
				
				if ($bOverLap) {
					if (! $bFlag) {
						open ($fpOUT, ">$sOutFile") or
							die "\tCannot open $sOutFile for writing .....\n";
						$bFlag = 1;
					}
					
					print $fpOUT "$sPrefix\t".
								 "$sChr\t".
								 "$nCnvStart\t".
								 "$nCnvStop\t";
								 
					my $nSum = 0;
					foreach ( @aLNRatios ) {
						$nSum += $_;
					}
					
					my $nRatio = $nSum / @aLNRatios;
					print $fpOUT "$nRatio\t";
					
					@aGNLs = sort {$a <=> $b} @aGNLs;
					my $nGNL = $aGNLs[(int(@aGNLs/2))];
					
					print $fpOUT "$nGNL\n";
				}
				
			}
			
			
		}
		else {
			if (! $bFlag) {
				open ($fpOUT, ">$sOutFile") or
					die "\tCannot open $sOutFile for writing .....\n";
				$bFlag = 1;
			}
			
			($bDebug || $bVerbose) ?
				print STDERR "\t\tParsing breakpoints in $aSortedKeys[0]\n"
				: undef;
			foreach $sChr (sort keys %{$phCandidate->{$sId}{$aSortedKeys[0]}})
			{
				$parMaster = $phCandidate->{$sId}{$aSortedKeys[0]}{$sChr};
				foreach $rCNV ( 0 .. $#{$parMaster} ) {
					print $fpOUT "$sPrefix\t".
								 "$sChr\t".
								 "$parMaster->[$rCNV]->{START}\t".
								 "$parMaster->[$rCNV]->{STOP}\t".
								 "$parMaster->[$rCNV]->{LNRATIO}\t".
								 "$parMaster->[$rCNV]->{GNL}\n";
				}
			}
		}
		
		if ($bFlag) {
			close($fpOUT);
		}
	}	
	
    return;
}

sub ByChr {
    my $c1 = $a;
    my $c2 = $b;

    $c1 =~ s/^chr//i;
    $c2 =~ s/^chr//i;

    if (($c1 =~ m/[XYM]/i) || ($c2 =~ m/[XYM]/i)) {
        $c1 cmp $c2;
    }
    else {
        $c1 <=> $c2;
    }
}
    
##############################################################################
### POD Documentation
##############################################################################

__END__

=head1 NAME

    combine_breakpoints_v2.pl - Program to determine de-novo CNV loci.

=head1 SYNOPSIS

    combine_breakpoints_v2.pl --i <input_directory> [--o <output_directory>]
    [--s <filename_suffix>] [--v]

    parameters in [] are optional
    do NOT type the carets when specifying options

=head1 OPTIONS
   
    --i <input_directory>    = Location of breakpoint files.

    --o <output_directory>   = Output directory. Optional.
    
    --s <filename_suffix>    = filename suffix. Optional.
    
    --v                      = generate runtime messages. Optional

=head1 DESCRIPTION

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

	PERL5LIB environment variable should be set if ZwickLab::PerlUtils is in
	non-standard location

=head1 DEPENDENCIES

	ZwickLab::PerlUtils

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

	There are no known bugs in this module. Please report problems to
	Amol Shetty (amol.shetty@emory.edu). Patches are welcome.

=head1 AUTHOR

	Amol Shetty
	Zwick Lab (http://www.genetics.emory.edu/labs/zwick/zwick_lab_index.php)
	Department of Human Genetics
	Emory University School of Medicine
	Whitehead Biomedical Research Center, Suite 341
	Atlanta, GA 30322

=head1 LICENSE AND COPYRIGHT

    Copyright (c) 2027 Michael E Zwick (<mzwick@genetics.emory.edu>). All
    rights reserved.

    This program is free software; you can distribute it and/or modify it
    under the same terms as Perl itself. See L<perlartistic>.
    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY
    or FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE COPYRIGHT OWNER
    OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
    EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
    LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
    NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

##############################################################################
### Internal Documentation
##############################################################################
# Revision Notes
#
# 20121101 - Version 3.0.1 - V. Patel
#   - fixed bug where already processed samples were not cleared.
#
# 20121101 - Version 3.0.0 - V. Patel
#   - fixed logic flaw that processed each file individually instead of
#     concurrently.

# Variable/Subroutine Name Conventions
#
# Type Prefixes
#
#    b = boolean
#    c = character
#    i = integer
#    n = number (real or integer)
#    p = pointer aka reference
#    s = string
#    a = array
#    h = hash
#    r = rec (aka hash)
#    f = file (typically combined with p, e.g. $fpIN)
#    o = object (e.g. for vars created/initialized via module->new() methods)
#
#    Type prefixes can be combined where appropriate, e.g. as = array of
#    strings or ph = pointer to a hash, but not cn (character of numbers???)
#
# Variable Names
#
#    Variable names start with a type prefix followed by capitalized words
#    descriptive of the purpose of the variable. Variable names do not have
#    underscores. E.g. sThisIsAString
#
# Subroutine Names
#
#    Subroutine names do not have a type prefix, have capitalized words
#    descriptive of the purpose of the subroutine, and the words are
#    separated by an underscore. E.g. This_Is_A_Subroutine
#
#    Internal utility subroutines begin with an underscrore and follow the
#    naming conventions of subroutines.
#

