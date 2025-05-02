import argparse
import csv
from pathlib import Path

# Add arguments
parser = argparse.ArgumentParser()
parser.add_argument(
    "-o", "--output_file", help="Output file location", type=str, required=True
)
parser.add_argument("--kraken2", help="Kraken2 database location", type=str)
parser.add_argument("--metaphlan", help="MetaPhlAn database location", type=str)
args = parser.parse_args()


def create_database(output_file):
    """Creates database.csv for Nextflow taxprofiler pipeline
    Parameters
    ----------
    output_file : str
        The output filename and location
    """

    # List to hold rows for database csv file
    database_rows = []

    if args.kraken2:
        # Strip tar.gz from filename
        filename = Path(args.kraken).name
        kraken_db_basename = name.replace(".tar.gz", "")

        database_rows.append(
            ["kraken2", kraken_db_basename, "--memory-mapping", "short", args.kraken2]
        )

    if args.metaphlan:
        # MetaPlAn database is in directory
        metaphlan_dir_name = Path(args.metaphlan).name
        database_rows.append(
            ["metaphlan", metaphlan_dir_name, "", "short", args.metaphlan]
        )

    with open(output_file, mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["tool", "db_name", "db_params", "db_type", "db_path"])
        writer.writerows(database_rows)


if __name__ == "__main__":
    create_database(args.output_file)
