#!/bin/bash

# Define the directory containing the zip files
zip_dir="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/zip"
unzip_dir="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/unzip"

# Create the unzip directory if it doesn't exist
mkdir -p "$unzip_dir"

# Unpack each zip file
for file in "$zip_dir"/*.tar.gz; do
    Rscript "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/unpack.R" "$file"
done

# Move all unpacked files to the unzipped directory
mv "$zip_dir"/*/ "$unzip_dir"
