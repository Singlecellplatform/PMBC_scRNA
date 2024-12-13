#!/bin/bash

# Set the working directory to the current directory
Path=$(pwd)
echo "Working Directory: $Path"

# Define paths
RMD_file="$Path/7_SF_Immune.Rmd"

# Extract the base name of the Rmd file for the output file title
pSubTitle=$(basename "$RMD_file" .Rmd).pdf

# Extract base_output_dir from the YAML configuration using R
base_output_dir=$(Rscript -e "cat(config::get(file = 'Config.yml')\$base_output_dir)")

# Check if the R script was successful in fetching base_output_dir
if [ -z "$base_output_dir" ]; then
  echo "Error: Failed to fetch base_output_dir from Config.yml"
  exit 1
fi

# Print paths for debugging
echo "RMD File: $RMD_file"
echo "Output File: $pSubTitle"
echo "Base Output Directory: $base_output_dir"

# Create the output directory if it doesn't exist
mkdir -p "$base_output_dir" || {
  echo "Error: Failed to create directory $base_output_dir"
  exit 1
}

# Render the RMarkdown file
Rscript -e "rmarkdown::render('$RMD_file', output_file='$pSubTitle', output_dir='$base_output_dir')" || {
  echo "Error: Failed to render RMarkdown file"
  exit 1
}

echo "Rendering completed successfully. Output saved to $base_output_dir/$pSubTitle"

