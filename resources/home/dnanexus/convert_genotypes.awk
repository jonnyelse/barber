#!/usr/bin/awk -f

BEGIN {
    FS = "\t";  # Set the input field separator to a tab
    OFS = "\t"; # Set the output field separator to a tab
}

{
    # Split the ALT field into an array of alleles (removing <STR and >)
    n = split($3, alleles, ",");
    for (i = 1; i <= n; i++) {
        gsub(/<STR|>/, "", alleles[i]);
    }

    printf "%s %s ", $1, $2;  # Print REPID and REF

    # Process each genotype starting from field 4 to the end
    for (j = 4; j <= NF; j++) {
        split($j, gt, "/");
        # Process each allele in the genotype
        for (k = 1; k <= 2; k++) {
            allele = gt[k];
            if (allele == ".") {
                printf ".";
            } else if (allele == "0") {
                printf "%s", $2;
            } else {
                alleleIndex = allele + 0;  # Convert to numeric
                if (alleleIndex >= 1 && alleleIndex <= n) {
                    printf "%s", alleles[alleleIndex];
                } else {
                    printf "?";
                }
            }
            if (k == 1) printf "/";
        }
        printf " ";  # Space between genotypes
    }
    print "";  # Newline at the end of each record
}

