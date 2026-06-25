barber

barber is a DNAnexus applet for the UK Biobank Research Analysis Platform (RAP) that converts multi-allelic STR genotype calls into a biallelic-style VCF representation for downstream analysis.

This repository contains the implementation used in my PhD thesis. The code is preserved for reproducibility

Overview

The applet takes an indexed STR VCF, extracts records for a specified chromosome, simplifies the VCF to the fields needed for recoding, applies a locus-renaming file, converts STR genotypes, and writes a new chromosome-level VCF containing split/reconfigured STR alleles.

The main purpose is to represent multi-allelic STR calls in a format that can be used by downstream tools expecting biallelic variant records.

Inputs
Name	Type	Required	Description
vcf_file	file	Yes	Input bgzipped STR VCF.
vcf_file_index	file	Yes	Index for the input VCF, for example .csi.
chr	string	Yes	Chromosome to process, for example chr1.
rename_file	file	Yes	TSV file used to rename or standardise STR locus identifiers.
output_folder	string	No	DNAnexus output folder for the processed VCF.
project	string	No	Optional DNAnexus project override.

Output
Name	Type	Description
split_chr	file	Bgzipped chromosome-level VCF containing the recoded/split STR representation.

The output file is uploaded as:

<output_folder>/<chr>_split.vcf.gz
Implementation details

The applet uses:

bcftools to subset the input VCF and retain the required fields;
awk scripts to convert genotypes and split/recode STR alleles;
an R script to create the final VCF;
bgzip and bcftools index to compress and index the output VCF.


Intended use

barber was designed as an intermediate preprocessing step in a larger STR analysis pipeline. It is intended to make multi-allelic STR genotype data easier to analyse using tools or workflows that operate more naturally on biallelic-style variant records. STRs are recodeds as biallelic pseudo-snps where each allele is recoded versus all other lengths. 



Example DNAnexus usage
dx run barber \
  -i vcf_file=input_strs.vcf.gz \
  -i vcf_file_index=input_strs.vcf.gz.csi \
  -i chr=chr1 \
  -i rename_file=rename.tsv \
  -i output_folder=/path/to/output/

  
Dependencies

bcftools
tabix
R
R packages:
dplyr
data.table


Scope and limitations

This applet is not a general-purpose VCF normalisation tool. It was written for a specific STR preprocessing task within the thesis analysis pipeline.

Reproducibility

This repository contains the version of the applet used to prepare STR genotype data for downstream analyses described in my PhD thesis. It is provided to document the computational workflow used at the time of analysis.

Author

Jonny Else
