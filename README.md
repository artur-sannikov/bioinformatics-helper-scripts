# Bioinformatics helper scripts

This repo contains some bioinformatics helper scripts I use in my research.
You are free to use them but beware that you mind need to modify them to suit
your needs (i.e., modify URLs, etc).

## Notes

### `create_samplesheet.py`

Python script `create_samplesheet.py` creates a `samplesheet.csv` file for
Nextflow taxprofiler pipeline. One of the columns is `run_accession`, which has
hard-coded values of L001 or L002. It is possible that your fastq files have
different values for this variable, such as L003/L004. It should not matter,
because as long as you have paired data, each pair element should have unique
`run_accession`. For example, if the sample name is `D42`, the first pair
element might have L001, and the second pair element might have L002. If they
have L003 and L004, the final result should not change.

