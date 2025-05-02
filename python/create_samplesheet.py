# Based on the original script by Pande Erawijantari
import argparse
import csv
import itertools
import os

# Add parser arguments
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input_dir", help="Input directory with FASTQ files")
parser.add_argument("-o", "--output_file", help="Path to output file")
args = parser.parse_args()


def create_fastq_cols(files):
    """
    Create fastq_1 and fastq_2 columns, which contain absolute paths to
    fastq.gz files.

    Parameters
    ----------
    files : list
        List of fastq.gz files.
    Returns
    -------
        List of lists of absolute paths to fastq files.
    """
    fastq_1 = []
    fastq_2 = []
    for file in files:
        if "_R1_" in file:
            fastq_1.append(file)
        if "_R2_" in file:
            fastq_2.append(file)
    #  Add absolute paths to files
    fastq_dir = args.input_dir
    fastq_1 = list(map(lambda fastq_file: os.path.join(fastq_dir, fastq_file), fastq_1))
    fastq_2 = list(map(lambda fastq_file: os.path.join(fastq_dir, fastq_file), fastq_2))
    return (fastq_1, fastq_2)


def create_samplesheet(input_dir, output_file):
    """
    Create samplesheet.csv for Nextflow taxprofiler pipeline (see specifications here: https://nf-co.re/taxprofiler/usage#samplesheet-inputs)

    Parameters
    ----------
    input_dir : str
        Directory containing fastq.gz files
    output_file : str
        Path to samplesheet.csv save location.
    """

    # List to hold sample ids
    sample = []

    for root, _, files in os.walk(args.input_dir):
        # Sort files
        files = sorted(files)
        for file in files:
            sample_id = file.split("_")[0]
            if sample_id not in sample:
                sample.append(sample_id)
    fastq_rows = create_fastq_cols(files)

    # Sort samples
    sample = sorted(sample)

    # Other columns
    run_accession_sequence = ["L001", "L002"]
    run_accession_cycle = itertools.cycle(run_accession_sequence)
    run_accession = [next(run_accession_cycle) for _ in sample]
    instrument_platform = ["ILLUMINA" for _ in sample]
    fasta = ["" for _ in sample]

    # Write into a csv file
    with open(args.output_file, mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(
            [
                "sample",
                "run_accession",
                "instrument_platform",
                "fastq_1",
                "fastq_2",
                "fasta",
            ]
        )
        rows = zip(
            sample,
            run_accession,
            instrument_platform,
            fastq_rows[0],
            fastq_rows[1],
            fasta,
        )
        for row in rows:
            writer.writerow(row)


def check_rows(input):
    """
    Check if the sample id in the 'sample' column is identical to sample id in the filenames of fastq columns.

    Parameter
    ---------
    input : str
        Input samplesheet.csv.
    """

    with open(args.output_file, mode="r") as file:
        csv_file = csv.reader(file)
        # Skip header
        next(csv_file, None)

        for lines in csv_file:
            sample = lines[0]
            fastq_1 = os.path.basename(lines[3])
            fastq_2 = os.path.basename(lines[4])
            fastq_1 = fastq_1.split("_")[0]
            fastq_2 = fastq_2.split("_")[0]
            if sample != fastq_1 and fastq_1 != fastq_2 and sample != fastq_2:
                print(f"Check {sample}, its fastq files are incorrect.")


if __name__ == "__main__":
    create_samplesheet(args.input_dir, args.output_file)
    check_rows(args.output_file)
