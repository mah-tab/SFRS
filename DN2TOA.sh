#!/bin/bash

# Define the directory containing the cropped folders
cropped_dir="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/cropped"
toa_dir="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/TOA"

# Create the TOA directory if it doesn't exist
mkdir -p "$toa_dir"

# Convert each cropped folder to TOA reflectances
for folder in "$cropped_dir"/*/; do
    Rscript "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/DN2TOA.R" "$folder"
done
