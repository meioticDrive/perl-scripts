#!/usr/bin/perl
##############################################################################
### Name: RA_change_fasta_labels.pl
### Version 1.0
### Date: 02/15/2007
### Author: Michael E. Zwick
##############################################################################
### 1. The purpose of this script is to change the name of fasta labels from ### one name to another. The hash %chip_strain contains the chip output 
### names and the new names.
### 2. Process multiple fasta files in the same directory
### 3. Launch program from within target directory
##############################################################################
use warnings;
use strict;
use Cwd;

# Define local variables
my(%chip_strain, @chip_files, $chip_file_nmbr);

# Populate the %chip_strain hash with chip names and reference file to use for comparison
# Original Chip strain names for 30kb B. anthracis chip
#'>BAN_ASC_245.fasta' => 'BAN_001',
#'>BAN_34F2.fasta' => 'BAN_002',
#'>BTU_HD571.fasta' => 'BTU_001',
#'>BTU_ATCC_10792.fasta' => 'BTU_002',
#'>BTU_ATCC_39152.fasta' => 'BTU_003',
#'>BTU_NCTC_4041.fasta' => 'BTU_004',
#'>BCE_BGSC_4A1.fasta' => 'BTU_005',
#'>BCE_BGSC_6A1.fasta' => 'BCE_001',
#'>BCE_S74.fasta' => 'BCE_002',
#'>BCE_F3080B.fasta' => 'BCE_003',
#'>BCE_F3942_87.fasta' => 'BCE_004',
#'>BCE_F4801_72.fasta' => 'BCE_005',
#'>BCE_S710.fasta' => 'BCE_006',
#'>BCE_G9241.fasta' => 'BCE_007',
#'>BCE_B33.fasta' => 'BCE_008',
#'>BCE_ET51B.fasta' => 'BCE_009',
#'>BCE_ET76B.fasta' => 'BCE_010',
#'>BCE_ET79B.fasta' => 'BCE_011',
#'>BCE_00-3130.fasta' => 'BCE_012',
#'>BCE_S363.fasta' => 'BCE_013',
#'>BCE_00-3096.fasta' => 'BCE_014',
#'>BCE_97-4144.fasta' => 'BCE_015',
#'>BCE_99-5941.fasta' => 'BCE_016',
#'>BCE_ET-33L.fasta' => 'BCE_017',
#'>BCE_00-3037.fasta' => 'BCE_018',
#'>BCE_00-3086.fasta' => 'BCE_019',
#'>BCE_72-4810.fasta' => 'BCE_020',
#'>BCE_95-9130.fasta' => 'BCE_021',
#'>BCE_M1292.fasta' => 'BCE_022',
#'>BCE_SPS2.fasta' => 'BCE_023',
#'>BCE_77-2809A.fasta' => 'BCE_024',
#'>BCE_95-2410.fasta' => 'BCE_025',
#'>BCE_95-8201.fasta' => 'BCE_026',
#'>BCE_10987.fasta' => 'BCE_027',
#'>BCE_14579.fasta' => 'BCE_028',
#'>BMY_B548.fasta' => 'BMY_001',
#'>BMY_ATCC_6423.fasta' => 'BMY_002',
#'>BMY_B951.fasta' => 'BMY_003',
#'>BMY_B518.fasta' => 'BMY_004',
#'>BMG_98_3792.fasta' => 'BMG_001',
#'>BSU_BGSC1A1.fasta' => 'BSU_001',
#'>BSU_BGSC1A2.fasta' => 'BSU_002',

%chip_strain = (
'2005_0126_ASC159_10ng_WGA300kb_20ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_003',
'2005_0127_LSU442_10ng_WGA300kb_20ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_038',
'2005_0223_A0039_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_012',
'2005_0223_A0174_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_019',
'2005_0223_A0328_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_024',
'2005_0223_A0379_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_027',
'2005_0223_A0419_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_036',
'2005_0223_A0465_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_040',
'2005_0223_ASC050_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_030',
'2005_0223_ASC054_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_031',
'2005_0223_ASC285_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_016',
'2005_0330_A0034_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_029',
'2005_0330_A0193_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_034',
'2005_0330_A0248_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_014',
'2005_0330_A0463_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_028',
'2005_0330_A0489_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_037',
'2005_0330_ASC006_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_021',
'2005_0330_ASC069_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_011',
'2005_0330_ET-76B_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_004',
'2005_0406_ASC004_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_035',
'2005_0406_ASC014_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_018',
'2005_0406_ASC015_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_013',
'2005_0406_ASC016_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_025',
'2005_0406_ASC031_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_020',
'2005_0406_ASC038_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_022',
'2005_0406_ASC061_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_023',
'2005_0406_ASC065_100ng_WGA300kb_10ug_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_026',
'2006_1018_CRP-BACI008-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_039',
'2006_1018_CRP-BACI008-003P-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_007',
'2006_1018_CRP-BACI055-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_033',
'2006_1018_CRP-GT3-007-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_010',
'2006_1018_CRP-GT28-02A1-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_008',
'2006_1018_CRP-GT41-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_005',
'2006_1018_CRP-GT68-003-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_006',
'2006_1018_CRP-VOLLUM-002-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_017',
'2007_0323_CRP-AMES-004-WGA300KB_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_032',
'2007_0323_CRP-DELTA-AMES-004-WGA300KB_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_041',
'2007_0419_CRP-BACI056-001-WGA300kb_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_009',
'2007_0817_7702-2-WGA300KB_S1_R1.DAT.NMRC_02.final.fasta.edit.fasta.15mer.mask.fasta' => 'BAN_015',
);

#-----------------------------------------------------------------------------

# Read in all .fasta files from directory
@chip_files = glob("*.fasta") 
	or print "\nNo fasta files found\n";
$chip_file_nmbr = ($#chip_files + 1);
print "Found $chip_file_nmbr fasta.out files\n";


foreach my $process_file (@chip_files) {

	print "Processing file: $process_file\n";
	open(FILEHANDLE_FIRST, $process_file)
		or die "Cannot open FILEHANDLE_FIRST - for fasta files";
		
	open(OUT_FASTA_FILE, ">", "$process_file" . '.txt')
		or die "Cannot open OUT_FASTA_FILE for data output";
		
		
	while (<FILEHANDLE_FIRST>) {
		chomp $_;
		# Select the fasta label line
		if ($_ =~ /^>/) {
			print OUT_FASTA_FILE ">$chip_strain{$_}\n";
			}
		else {
			print OUT_FASTA_FILE "$_\n";
		}
	}
	
	# Close filehandles
	close(OUT_FASTA_FILE);
	close(FILEHANDLE_FIRST);
}



