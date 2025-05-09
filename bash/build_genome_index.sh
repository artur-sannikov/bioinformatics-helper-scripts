#!/bin/bash
###############################################################################
# build_genome_index.sh - Build index of the input index
# Description: Build index with Bowtie 2
# Dependencies: bowtie2 2.5.3
#
# Usage: ./build_genome_index.sh [INPUT_GENOME_GZ] [OUTPUT_DIR]

# Optional Bowtie2-build binary
BOWTIE2_BUILD="${BOWTIE2_BUILD:-bowtie2-build}"

# Unpack fa genome
FILE_PATH="${1}"
GENOME="${FILE_PATH%.*}"
echo "${GENOME}"
if [ ! -f "${GENOME}" ]; then
    gzip -kd "$1"
else
    echo "File $GENOME exists, skipping"
fi

# Build bowtie index
mkdir -p "${2}"
OUTPUT_DIR="$2/$(basename "${GENOME}" .fa)"
echo "Output index directory is $OUTPUT_DIR"
"$BOWTIE2_BUILD" "${GENOME}" "${OUTPUT_DIR}"
