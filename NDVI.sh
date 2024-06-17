#!/bin/bash

# Set the working directory to the Landsat folder
setwd="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat"
cd "$setwd"

# Run the NDVI calculation script
echo "Starting NDVI calculation for Landsat data"
Rscript "$setwd/NDVI.R"
