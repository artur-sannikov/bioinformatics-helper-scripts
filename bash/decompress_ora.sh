#!/bin/bash
###############################################################################
# decompress_ora.sh - Decompress DRAGEN Original Read Archive archives from
# Illumina into fastq files.
# Description:
#   To use this script you need to download DRAGEN ORA Decompression
#   Software: https://s3.amazonaws.com/webdata.illumina.com/downloads/software/dragen-decompression/orad.2.7.0.linux.tar.gz
#   It should contain ORA reference files for humans. I was told to use them
#   even for other species. If you know that you need to use other reference
#   files, you can find them here: https://support.illumina.com/sequencing/sequencing_software/DRAGENORA.html
#
#   Set the following environment variables:
#     1. ORA_DATA_DIR - Path to directory containing .ora files.
#     2. FASTQ_OUTPUT_DIR - Path to output directory for decompressed .fastq
#     files.
#     3. ORA_REFERENCE - Path to directory with ORA reference files. It should
#     be included in the ORA download.
#     4. ORAD_BIN - Path to `orad` binary in the directory of the ORA Decompression
#     Software

# Decompress files with orad
for file in "$ORA_DATA_DIR"/*.ora; do
    echo "Decompressing $file..."

    $ORAD_BIN --raw \
        --ora-reference "$ORA_REFERENCE" \
        --path "$FASTQ_OUTPUT_DIR" \
        "$file"
done

echo "Decompression successful!"
