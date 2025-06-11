#!/usr/bin/awk -f

BEGIN {
    OFS = "\t"; # Output field separator is tab
}

# Read genotypes from converted_output.txt into an associative array
NR == FNR {
    FS = " "; # Field separator is space for the converted_output.txt
    variantID = $1;
    genotypeStr = ""; # Initialize an empty string to store genotypes

    # Concatenate genotypes starting from the third column
    for (i = 3; i <= NF; i++) {
        genotypeStr = genotypeStr (genotypeStr ? OFS : "") $i;
    }

    genotypes[variantID] = genotypeStr;
    next;
}

# Process biallelic_variants.txt
FNR < NR {
    FS = "\t"; # Field separator is tab for biallelic_variants.txt
    split($1, parts, "_");
    origVariantID = parts[1] "_" parts[2] "_" parts[3]; # Extract the original variant ID
    allele = parts[4];

    # Print the biallelic variant ID
    printf "%s", $1;

    # Recode genotypes
    n = split(genotypes[origVariantID], gts, OFS);
    for (i = 1; i <= n; i++) {
        split(gts[i], gtParts, "/");
        for (gt in gtParts) {
            if (gtParts[gt] == ".") {
                gtParts[gt] = ".";
            } else if (gtParts[gt] == allele) {
                gtParts[gt] = "0";
            } else {
                gtParts[gt] = "1";
            }
        }
        printf "\t%s/%s", gtParts[1], gtParts[2];
    }
    print "";
}

