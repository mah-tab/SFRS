#!/bin/bash

# Define the directory containing the unzipped folders
unzipped_dir="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/unzip"
cropped_dir="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/cropped"

# Create the cropped directory if it doesn't exist
mkdir -p "$cropped_dir"

# Crop each unzipped folder
for folder in "$unzipped_dir"/*/; do
    Rscript "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/crop.R" "$folder"
done
