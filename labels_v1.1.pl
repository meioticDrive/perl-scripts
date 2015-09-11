#!/usr/bin/perl -w
# Michael W. Craige
# Renaming Multi-fasta files
use strict;
use warnings;
my($key, $value);
# Create Hash Table
my (%nameTable) = (	# initialized hash table
# Defining keys and value for renaming files
	"2004_1201_B.anthracisASC245_WGA_S1_R1.DAT.fasta" => "BAN_ASC_245.fasta",
	"2004_1118_Sterne34F2_WGA_S1_R1.DAT.fasta" => "BAN_34F2.fasta",
	"2004_1201_B.thuringiensisNRRL_HD571_WGA_S1_R1.DAT.fasta" => "BTU_HD571.fasta",
	"2004_1015_ATCC10792_WGA_S1_R1.DAT.fasta" => "BTU_ATCC_10792.fasta",
	"2004_1015_ATCC39152_WGA_S1_R1.DAT.fasta" => "BTU_ATCC_39152.fasta",
	"2004_1130_NCTC4041_WGA_S1_R1.DAT.fasta" => "BTU_NCTC_4041.fasta",
	"2004_1007_BTU0003_WGA_S1_R1.DAT.fasta" => "BCE_BGSC_4A1.fasta",
	"2004_1007_BCE0004_WGA_S1_R1.DAT.fasta" => "BCE_BGSC_6A1.fasta",
	"2004_1007_BCE0005_WGA_S1_R1.DAT.fasta" => "BCE_S74.fasta",
	"2004_1007_BCE0008_WGA_S1_R1.DAT.fasta" => "BCE_F3080B.fasta",
	"2004_1007_BCE0009_WGA_S1_R1.DAT.fasta" => "BCE_F3942_87.fasta",
	"2004_1007_BCE0010_WGA_S1_R1.DAT.fasta" => "BCE_F4801_72.fasta",
	"2004_1007_BCE0013_WGA_S1_R1.DAT.fasta" => "BCE_S710.fasta",
	"2004_1007_G9241_WGA_S1_R1.DAT.fasta" => "BCE_G9241.fasta",
	"2004_1015_B33_WGA_S1_R1.DAT.fasta" => "BCE_B33.fasta",
	"2004_1015_ET51B_WGA_S1_R1.DAT.fasta" => "BCE_ET51B.fasta",
	"2004_1015_ET76B_WGA_S1_R1.DAT.fasta" => "BCE_ET76B.fasta",
	"2004_1015_ET79B_WGA_S1_R1.DAT.fasta" => "BCE_ET79B.fasta",
	"2004_1021_B.cereus003130_WGA_S1_R1.DAT.fasta" => "BCE_00-3130.fasta",
	"2004_1114_Bcereus-S363_WGA_S1_R1.DAT.fasta" => "BCE_S363.fasta",
	"2004_1114_Bcereus00-3096_WGA_S1_R1.DAT.fasta" => "BCE_00-3096.fasta",
	"2004_1114_Bcereus97-4144_WGA_S1_R1.DAT.fasta" => "BCE_97-4144.fasta",
	"2004_1114_Bcereus99-5941_WGA_S1_R1.DAT.fasta" => "BCE_99-5941.fasta",
	"2004_1118_BcereusET-33L_WGA_S1_R1.DAT.fasta" => "BCE_ET-33L.fasta",
	"2004_1130_B.cereus00-3037_WGA_S1_R1.DAT.fasta" => "BCE_00-3037.fasta",
	"2004_1130_B.cereus00-3086_WGA_S1_R1.DAT.fasta" => "BCE_00-3086.fasta",
	"2004_1130_B.cereus72-4810_WGA_S1_R1.DAT.fasta" => "BCE_72-4810.fasta",
	"2004_1130_B.cereus95-9130_WGA_S1_R1.DAT.fasta" => "BCE_95-9130.fasta",
	"2004_1130_B.cereusM1292_WGA_S1_R1.DAT.fasta" => "BCE_M1292.fasta",
	"2004_1130_B.cereusSPS2_WGA_S1_R1.DAT.fasta" => "BCE_SPS2.fasta",
	"2004_1201_B.cereus77-2809A_WGA_S1_R1.DAT.fasta" => "BCE_77-2809A.fasta",
	"2004_1201_B.cereus95-2410_WGA_S1_R1.DAT.fasta" => "BCE_95-2410.fasta",
	"2004_1201_B.cereus95-8201_WGA_S1_R1.DAT.fasta" => "BCE_95-8201.fasta",
	"2005_1026_Bce10987_WGA_S1_R1.DAT.fasta" => "BCE_10987.fasta",
	"2005_1026_Bce14579_WGA_S1_R1.DAT.fasta" => "BCE_14579.fasta",
	"2004_1015_B548_WGA_S1_R1.DAT.fasta" => "BMY_B548.fasta",
	"2004_1015_ATCC6423_WGA_S1_R1.DAT.fasta" => "BMY_ATCC_6423.fasta",
	"2004_1130_B.mycoidesB951_WGA_S1_R1.DAT.fasta" => "BMY_B951.fasta",
	"2004_1021_B518_WGA_S1_R1.DAT.fasta" => "BMY_B518.fasta",
	"2004_1201_B.megaterium98-3792_WGA_S1_R1.DAT.fasta" => "BMG_98_3792.fasta",
	"2004_1118_BSU0001_BGSC1A1_WGA_S1_R1.DAT.fasta" => "BSU_BGSC1A1.fasta",
	"2004_1114_BGSC1A2_WGA_S1_R1.DAT.fasta" => "BSU_BGSC1A2.fasta",
);
while ( ($key, $value) = each %nameTable ) {
	rename ($key, $value);
 }

# End of Script
