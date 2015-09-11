#!/usr/bin/perl
use warnings;
use strict;

##############################################################################################
# Benjamin Rambo-Martin
# July 24, 2013
#
#	This script identifies genes that are overlapped by CNVs. Requires a PLINK formatted
# gene list file (http://pngu.mgh.harvard.edu/~purcell/plink/dist/glist-hg18) as well as PLINK
# formatted CNV data file (http://pngu.mgh.harvard.edu/~purcell/plink/cnv.shtml#format) for 
# deletions and duplications seperately. Launch script from directory with these files present.
#
##############################################################################################


# Variable declaration 
my ($sDelFile, $sDupFile, $sGeneFile, $sDelLine, $sDupLine, @aDelLine, @aDupLine, $sDelChr, $sDupChr,
	$sDelStart, $sDupStart, $sDelStop, $sDupStop, $sGeneLine, @aGeneLine, $sGenesHit, $sDelOutputLine, 
	$sDupOutputLine, $sGeneOutputLine);


# User Input
print "\n\tWhat is the file name for deletion calls?\n\t(Hit 'return' if there is no deletion file)\n";
chomp ($sDelFile = <STDIN>);
print "\n\tWhat is the file name for duplication calls?\n\t(Hit 'return' if there is no duplication file)\n";
chomp ($sDupFile = <STDIN>);
print "\n\tWhat is the file name for gene coordinates?\n";
chomp ($sGeneFile = <STDIN>);
if ($sGeneFile eq ""){
	die "\n!!!!!!!!!!!!! Must input genefile name !!!!!!!!!!!!!\n\n";
}

# Main loop for deletion file
unless ($sDelFile eq ""){
	open DELOUTPUT, ">>", "GenesInDeletions.txt";
	print DELOUTPUT "FamilyID\tIndividualID\tChromosome\tDelStart\tDelStop\tNumGenesHit\tGene(s)\n";
	
	open DELINPUT, "<", "$sDelFile" or die "\n\tCan't open $sDelFile: $!\n\n";
	while(defined($sDelLine = <DELINPUT>)){
		next if ($sDelLine =~ "SCORE");
		@aDelLine = split (/\s+/, $sDelLine);
		
		$sGenesHit = 0;
	
		$sDelChr = $aDelLine[3];
		$sDelStart = $aDelLine[4];
		$sDelStop = $aDelLine[5];
		$sDelOutputLine = "$aDelLine[1]\t$aDelLine[2]\t$sDelChr\t$sDelStart\t$sDelStop";
		$sGeneOutputLine = "";
	
		open GENEINPUT, "<", "$sGeneFile" or die "\n\tCan't open $sGeneFile: $!\n\n";
		while( defined( $sGeneLine = <GENEINPUT> )){
			@aGeneLine = split (/\s+/, $sGeneLine);
			if ($sDelChr =~ /^$aGeneLine[0]$/){
				if((($sDelStart > $aGeneLine[1] && $sDelStart < $aGeneLine[2]) || 
				($sDelStop > $aGeneLine[1] && $sDelStop < $aGeneLine[2]) || 
				($aGeneLine[1] > $sDelStart && $aGeneLine[2] < $sDelStop))
				&& $sGeneOutputLine !~ $aGeneLine[3]){
	
					$sGeneOutputLine .= "$aGeneLine[3] ";
					$sGenesHit++;
	
				}
			}
			if (eof (GENEINPUT)){
				chomp ($sGeneOutputLine);
				print DELOUTPUT "$sDelOutputLine\t$sGenesHit\t$sGeneOutputLine\n";
			}
		}
		close GENEINPUT;
	}
	close DELINPUT;
}

# Main loop for duplication file
unless($sDupFile eq ""){
	open DUPOUTPUT, ">>", "GenesInDuplications.txt";
	print DUPOUTPUT "FamilyID\tIndividualID\tChromosome\tDupStart\tDupStop\tNumGenesHit\tGene(s)\n";
	
	open DUPINPUT, "<", "$sDupFile" or die "\n\tCan't open $sDupFile: $!\n\n";
	while(defined($sDupLine = <DUPINPUT>)){
		next if ($sDupLine =~ "SCORE");
		@aDupLine = split (/\s+/, $sDupLine);
	
		$sGenesHit = 0;
		
		$sDupChr = $aDupLine[3];
		$sDupStart = $aDupLine[4];
		$sDupStop = $aDupLine[5];
		$sDupOutputLine = "$aDupLine[1]\t$aDupLine[2]\t$sDupChr\t$sDupStart\t$sDupStop";
		$sGeneOutputLine = "";
	
		open GENEINPUT, "<", "$sGeneFile" or die "\n\tCan't open $sGeneFile: $!\n\n";
		while( defined( $sGeneLine = <GENEINPUT> )){
			@aGeneLine = split (/\s+/, $sGeneLine);
			if ($sDupChr =~ /^$aGeneLine[0]$/){
				if((($sDupStart > $aGeneLine[1] && $sDupStart < $aGeneLine[2]) || 
				($sDupStop > $aGeneLine[1] && $sDupStop < $aGeneLine[2]) || 
				($aGeneLine[1] > $sDupStart && $aGeneLine[2] < $sDupStop))
				&& $sGeneOutputLine !~ $aGeneLine[3]){
			
				$sGeneOutputLine .= "$aGeneLine[3] ";
				$sGenesHit++;
			}

		}
		if( eof(GENEINPUT)){
			chomp ($sGeneOutputLine);
			print DUPOUTPUT "$sDupOutputLine\t$sGenesHit\t$sGeneOutputLine\n";				
		}
	}
	close GENEINPUT;
	}
	close DUPINPUT;
}
print "\n\n";
