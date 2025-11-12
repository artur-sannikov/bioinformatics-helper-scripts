#!/usr/bin/env bash
# =============================================================================
# Description: concatenate Illumina fastq files of the same direction (R1 or R2)
# into one file per each sample
# Author: Artur Sannikov
# Usage: concatenate_fastq.sh <input_dir> <output_dir>
# =============================================================================

INPUT_DIR="${1}"
OUTPUT_DIR="${2}"
mkdir -p "${OUTPUT_DIR}"

for sample in $(find "${INPUT_DIR}" -type f -regex '.*_L[0-9]+_R[12]_001.fastq.gz' | sed -E 's/(.*)_L[0-9]+_R[12]_001.fastq.gz/\1/' | sort -u); do
    # If conditions to avoid creating duplicates
    if [[ ! -e "${OUTPUT_DIR}"/"${sample}"_R1_001.fastq.gz ]]; then
        cat "${sample}"_L*_R1_001.fastq.gz >"${OUTPUT_DIR}"/"${sample}"_R1_001.fastq.gz
        echo "Merged R1 files for ${sample} into ${OUTPUT_DIR}/${sample#./}_R1_001.fastq.gz"
    fi

    if [[ ! -e "${OUTPUT_DIR}"/"${sample}"_R2_001.fastq.gz ]]; then
        cat "${sample}"_L*_R2_001.fastq.gz >"${OUTPUT_DIR}"/"${sample}"_R2_001.fastq.gz
        echo "Merged R2 files for ${sample} into ${OUTPUT_DIR}/${sample#./}_R2_001.fastq.gz"
    fi
done
