#!/bin/bash

# Set the working directory
setwd="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat"
cd "$setwd/NDVI"

# Specify the location of the study areas shapefile
shp_path="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/study_regions.shp"

# Flag to control extraction
extract=1 # 0/1: extraction of NDVI values

if [ $extract -eq 1 ]; then
  echo "Starting extraction of NDVI values"

  # Loop through each NDVI raster file
  for ndvi_file in *.tif; do
    Rscript ../extrRas.R "$ndvi_file" "$shp_path"
  done
fi
