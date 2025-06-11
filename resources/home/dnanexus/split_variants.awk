#!/usr/bin/awk -f

BEGIN {
    FS = "\t";  # Field separator is tab
    OFS = "\t"; # Output field separator is also tab
}

{
    # Print variant for REF allele
    print $1 "_" $2;

    # Check if ALT allele is not just a '.'
    if ($3 != ".") {
        # Split the ALT field into an array of alleles (removing <STR and >)
        n = split($3, alleles, ",");
        for (i = 1; i <= n; i++) {
            gsub(/<STR|>/, "", alleles[i]);
            # Print variant for each ALT allele
            print $1 "_" alleles[i];
        }
    }
}