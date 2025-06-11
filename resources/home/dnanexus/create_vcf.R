#!/usr/bin/env Rscript

library(data.table)

args <- commandArgs(trailingOnly = TRUE)

# Check for the correct number of arguments
if (length(args) != 3) {
  cat("Usage: create_vcf.R <genotype_file> <sample_file> <output_vcf_file>\n")
  quit(save = "no", status = 1)
}

# Assign arguments to variables
genotype_file <- args[1]
sample_file <- args[2]
output_vcf_file <- args[3]

# Read the sample IDs
sample_ids <- read.table(sample_file, header = FALSE, colClasses = "character")[[1]]

# Prepare the VCF header lines
vcf_header <- c(
  "##fileformat=VCFv4.2",
  "##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">",
  paste0("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t", paste(sample_ids, collapse = "\t"))
)

# Write the VCF header to the output VCF file
writeLines(vcf_header, output_vcf_file)

# Open the genotype file and process it line by line
con <- file(genotype_file, open = "r")
while(TRUE) {
  line <- readLines(con, n = 1)
  if (length(line) == 0) break  # End of file
  
  # Split the line into fields
  x <- unlist(strsplit(line, "\t"))
  
  # Remove spaces from all genotype columns (ignoring the first column)
  x[-1] <- gsub(" ", "", x[-1])
  
  # Extract variant info from the first column (variant ID)
  variant_info <- unlist(strsplit(as.character(x[1]), "_"))
  chrom <- variant_info[1]
  pos <- variant_info[2]
  id <- x[1]
  ref <- "A"  # Placeholder for the reference allele
  alt <- "C"  # Placeholder for the alternate allele
  
  # Prepare the data for each variant
  variant_line <- c(chrom, pos, id, ref, alt, ".", "PASS", ".", "GT")
  
  # Write to VCF using tabs as separators
  cat(paste(c(variant_line, x[-1]), collapse = "\t"), "\n", file = output_vcf_file, append = TRUE)
}

close(con)

# Post-process the file to remove trailing whitespace
# Process the VCF file line by line to remove trailing whitespace
in_con <- file(output_vcf_file, "r")
out_con <- file(paste0(output_vcf_file, ".tmp"), "w")

while(TRUE) {
  line <- readLines(in_con, n = 1)
  if (length(line) == 0) break  # End of file
  
  # Remove trailing spaces from each line
  line <- gsub(" +$", "", line)
  
  # Write the cleaned line to the new file
  writeLines(line, out_con)
}

# Close file connections
close(in_con)
close(out_con)

# Replace original file with the cleaned one
file.rename(paste0(output_vcf_file, ".tmp"), output_vcf_file)

