#!/bin/bash
###############################################################################
# download_databases.sh - Download necessary databases for taxonomic profiling
# of metagenomic data
#
# Description:
#   Download database required for Taxprofiler Nextflow pipeline.
#   This is more of a template script because it might require modification of
#   URLs to download specific databases.
# Usage:
#   ./download_databases.sh [OUTPUT_DIR]
#
#   OUTPUT_DIR - Path to save directory for databases.
OUTPUT_DIR="$1"

# Color codes
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

download_file() {
    local url="$1"
    local download_desc="$2"

    echo -e "Downloading ${GREEN}$download_desc${NC} from $url to $OUTPUT_DIR..."
    wget -N -P "$OUTPUT_DIR" "$url" || echo -e "Download ${RED}failed${NC}!"
    echo -e "Download ${GREEN}successful${NC}!"
}

check_md5() {
    local file="$1"
    local expected_md5="$2"

    local computed_md5
    computed_md5=$(md5sum "$file" | awk '{print $1}')

    if [[ "$computed_md5" != "$expected_md5" ]]; then
        echo "MD5 mismatch for '{$file}'"
        echo "Expected: '${expected_md5}'"
        echo "Got: '${computed_md5}'"
        exit 1
    else
        echo "MD5 checksum passed for '${file}'"
    fi
}

# Download Mus musculus genome
URL="https://ftp.ensembl.org/pub/release-113/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.toplevel.fa.gz"
download_file "$URL" "Mus musculus genome"

# Download MetaPhAn database
URL="http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_vOct22_CHOCOPhlAnSGB_202403.tar"
download_file "$URL" "MetaPhlAn database"

# Extract filename from URL
FILENAME=${URL##*/}

# Untar MetaPhlAn database
METAPHLAN_DB_DIR="$OUTPUT_DIR/${FILENAME%.tar}"
echo $METAPHLAN_DB_DIR
mkdir -p "$METAPHLAN_DB_DIR"
tar xf "$OUTPUT_DIR/$FILENAME" -C "$METAPHLAN_DB_DIR"

# Check MetaPhlAn md5 checksum
check_md5 "$OUTPUT_DIR/$FILENAME" "90277ac04de6c72d6542f75bdb1b5104"
