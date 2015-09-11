#!/usr/bin/perl -w
####################################################################################################
# Operates on .CNCHP.txt files (Affy output)
# Argument 1: Listing of File names
# Argument 2: Name of source file
# Usage: # Script should be launched from within directory containing files
####################################################################################################
use warnings;
use strict;
use Cwd;

my ($dirname, @data_files, $data_file_number, $source_number);
my ($j, $i, $k, $f, @temp, @sort, $sort, @lines, @a_fields, @b_fields, @sorted_lines, $sample, $norm, $file_523, $file_635, @chr6, @chr7, @chr8, @chr9, @chr10, @chr11, @chr12, @chr13, @chr14, @chr15, @chr16, @chr17, @sorted);
my (@chr18, @chr19, @chr20, @chr21, @lines_23, @chrX, @chrY, $file_532, $ratio, $intensity);
my ($file, @name, @file, @pair1, @pair2, $pair1, $pair2, @line_635, @line_532, $line_635, $line_532, $norm1, $norm2, $source);

####################################################################################################
# Main Program Code
####################################################################################################


# Get current working directory
####################################################################################################
$dirname = getcwd();

# Remove old .source.txt files
unlink glob("*.source.txt");

# Obtain names of all files in a directory
# Update glob below depending upon specific application
####################################################################################################
@data_files = glob("*filenames*");
$data_file_number = ($#data_files + 1);
if ($data_file_number == 0) {
 die "Detected $data_file_number *filenames* files.\n Check directory. Exiting program";
}

# Determine name of source file - from numbered filenames file
# Open $source file for output


@name = split (/\./, $data_files[0]);
$source_number = $name[2];
print "The source file number is: $source_number\n";
$source = "GLAD.source.$source_number.txt";
open (DAGLAD1, ">>$source");

# Open filenames file
# Loop over all sample IDs in file
# Read in sample ID and make source files
open (IN_SAMPLE_ID, "<", "$data_files[0]")
  or die "Cannot open IN_SAMPLE_ID filehandle to read file";

while(<IN_SAMPLE_ID>) {
  chomp $_;
  # Will loop over sample IDs contained in text file
  $sample = $_;

####################################################################################################
#This part below makes the R source files for GLAD.
####################################################################################################
print "starting chr1 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
print DAGLAD1 "sink(file = \"./sink.$sample.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr1.txt\", nrows = 170500, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr1_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr1.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 1, main = \"$sample chr1\", font.main = 4)\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr1a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 1, main = \"$sample chr1\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr1.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr2.txt");
print "starting chr2 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr2.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr2.txt\", nrows = 185100, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr2_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr2.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 2, main = \"$sample chr2\", font.main = 4)\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr2a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 2, main = \"$sample chr2\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr2.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr3.txt");
print "starting chr3 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr3.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr3.txt\", nrows = 150800, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr3_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr3.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 3, main = \"$sample chr3\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr3a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 3, main = \"$sample chr3\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr3.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr4.txt");
print "starting chr4 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr4.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr4.txt\", nrows = 145000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr4_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr4.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 4, main = \"$sample chr4\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr4a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 4, main = \"$sample chr4\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr4.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr5.txt");
print "starting chr5 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr5.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr5.txt\", nrows = 115000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr5_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr5.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 5, main = \"$sample chr5\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr5a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 5, main = \"$sample chr5\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr5.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr6.txt");
print "starting chr6 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr6.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr6.txt\", nrows = 120500, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr6_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr6.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 6, main = \"$sample chr6\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr6a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 6, main = \"$sample chr6\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr6.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr7.txt");
print "starting chr7 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr7.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr7.txt\", nrows = 120100, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr7_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr7.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 7, main = \"$sample chr7\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr7a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 7, main = \"$sample chr7\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr7.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr8.txt");
print "starting chr8 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr8.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr8.txt\", nrows = 120800, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr8_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr8.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 8, main = \"$sample chr8\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr8a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 8, main = \"$sample chr8\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr8.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr9.txt");
print "starting chr9 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr9.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr9.txt\", nrows = 145000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr9_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr9.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 9, main = \"$sample chr9\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr9a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 9, main = \"$sample chr9\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr9.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr10.txt");
print "starting chr10 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr10.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr10.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr10_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr10.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 10, main = \"$sample chr10\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr10a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 10, main = \"$sample chr10\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr10.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr11.txt");
print "starting chr11 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr11.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr11.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr11_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr11.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 11, main = \"$sample chr11\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr11a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 11, main = \"$sample chr11\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr11.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr12.txt");
print "starting chr12 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr12.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr12.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr12_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr12.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 12, main = \"$sample chr12\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr12a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 12, main = \"$sample chr12\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr12.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr13.txt");
print "starting chr13 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr13.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr13.txt\", nrows = 120500, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr13_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr13.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 13, main = \"$sample chr13\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr13a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 13, main = \"$sample chr13\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr13.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr14.txt");
print "starting chr14 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr14.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr14.txt\", nrows = 120100, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr14_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr14.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 14, main = \"$sample chr14\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr14a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 14, main = \"$sample chr14\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr14.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD15, ">source.$sample.chr15.txt");
print "starting chr15 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr15.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr15.txt\", nrows = 120800, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr15_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr15.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 15, main = \"$sample chr15\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr15a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 15, main = \"$sample chr15\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr15.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr16.txt");
print "starting chr16 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr16.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr16.txt\", nrows = 145000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr16_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr16.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 16, main = \"$sample chr16\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr16a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 16, main = \"$sample chr16\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr16.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr17.txt");
print "starting chr17 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr17.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr17.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr17_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr17.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 17, main = \"$sample chr17\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr17a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 17, main = \"$sample chr17\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr17.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr18.txt");
print "starting chr18 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr18.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr18.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr18_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr18.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 18, main = \"$sample chr18\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr18a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 18, main = \"$sample chr18\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr18.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD19, ">source.$sample.chr19.txt");
print "starting chr19 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr19.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr19.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr19_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr19.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 19, main = \"$sample chr19\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr19a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 19, main = \"$sample chr19\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr19.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD1, ">source.$sample.chr20.txt");
print "starting chr20 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr20.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr20.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr20_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr20.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 20, main = \"$sample chr20\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr20a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 20, main = \"$sample chr20\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr20.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD21, ">source.$sample.chr21.txt");
print "starting chr21 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr21.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr21.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr21_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr21.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 21, main = \"$sample chr21\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr21a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 21, main = \"$sample chr21\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr21.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

#open (DAGLAD22, ">source.$sample.chr22.txt");
print "starting chr22 GLAD commands file\n";
print DAGLAD1 "library(GLAD)\n";
print DAGLAD1 "data(cytoband)\n";
#print DAGLAD1 "sink(file = \"./sink.$sample.chr22.txt\")\n";
print DAGLAD1 "table<-read.table(\"$sample.chr22.txt\", nrows = 100000, header = TRUE, sep = \"\\t\")\n";
print DAGLAD1 "profileCGH<-as.profileCGH(table)\n";
print DAGLAD1 "profileCGH <- daglad(profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, genomestep = FALSE, smoothfunc = \"lawsglad\", bandwidth = 1, round = 1.5, model = \"Gaussian\",lkern = \"Exponential\", qlambda = 0.999999, base = FALSE, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), alpha = 0.0001, msize = 2, region.size = 2, method = \"centroid\", nmax = 8, nmin = 1,amplicon = 1, deletion = -5, deltaN = 0.1, forceGL = c(-0.2, 0.2), nbsigma = 3, MinBkpWeight = 0.75, CheckBkpPos = TRUE, verbose = TRUE)\n";
print DAGLAD1 "profileCGH\$BkpInfo\n";
print DAGLAD1 "write.table(profileCGH\$BkpInfo, file = \"$sample.chr22_breakpoint.txt\", sep = \"\\t\", col.names = TRUE)\n";
print DAGLAD1 "png(\"$sample.chr22.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = FALSE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 22, main = \"$sample chr22\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "png(\"$sample.chr22a.png\", width = 1500, height = 1500)\n";
print DAGLAD1 "plotProfile (profileCGH, unit = 3, Bkp = TRUE, labels = TRUE, Smoothing = \"Smoothing\", plotband = TRUE, cytoband = cytoband, Chromosome = 22, main = \"$sample chr22\")\n";
print DAGLAD1 "dev.off()\n";
print DAGLAD1 "save.image(\"$sample.chr22.RData\")\n";
#print DAGLAD1 "sink()\n";
print DAGLAD1 "rm(list = ls())\n\n";

}

close (DAGLAD1);

print "all finished. You should buy Jen A LOT of chocolate. And give it to Mike.\n";
