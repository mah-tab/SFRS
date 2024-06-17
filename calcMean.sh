#!/bin/bash

setwd="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extrRas"
cd "$setwd"

mean=1 # 0/1: calculation of mean NDVI values

if [ $mean -eq 1 ]; then
    echo "Starting calculation of mean NDVI values"

    # Loop through each study_reg folder
    for study_reg in study_reg_*; do
        Rscript "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/calcMean.R" "$setwd/$study_reg"
    done
fi
