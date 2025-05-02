#!/bin/bash
#################################################################################
# compress_fastq.sh - Compress all fastq files into fastq.gz in a given
# directory
# Description:
#   Set the following environment variables:
#     1. FASTQ_GZ_DIR - path to output directory
#     2. FASTQ_DIR - path containing fastq files
#     3. PIGZ_BIN - path to pigz binary (parallel version of gzip).
#     If you cannot install software, you need to compile it from source.See
#     here: https://github.com/madler/pigz

# Create output directory
mkdir "$FASTQ_GZ_DIR"

# Compress fastq files
for file in "$FASTQ_DIR"/*.fastq; do
    echo "Compressing $file..."
    $PIGZ_BIN -p 8 -k "$file"
done

echo "All files compressed!"
