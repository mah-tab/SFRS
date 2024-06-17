#!/bin/bash

setwd="E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat"
cd "$setwd"

unpack=1 # 0/1: unpacking of Landsat archives
crop=1 # 0/1: cropping of unpacked data to AOI
DN2TOA=1 # 0/1: conversion of DNs to TOA reflectances
ndvi=1 # 0/1: calculation of NDVI from TOA reflectances
extrRas=1 # 0/1: extraction of raster values from NDVI rasters
calcMean=1 # 0/1: calculation of mean NDVI values

if [ $unpack -eq 1 ]; then
    echo "Starting unpacking of Landsat data"
    bash "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/unpack.sh"
fi

if [ $crop -eq 1 ]; then
    echo "Starting cropping of Landsat data"
    bash "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/crop.sh"
fi

if [ $DN2TOA -eq 1 ]; then
    echo "Starting DN to TOA conversion of Landsat data"
    bash "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/DN2TOA.sh"
fi

if [ $ndvi -eq 1 ]; then
    echo "Starting NDVI calculation of Landsat data"
    bash "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/NDVI.sh"
fi

if [ $extrRas -eq 1 ]; then
    echo "Starting extraction of raster values from NDVI data"
    bash "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extract_all.sh"
fi

if [ $calcMean -eq 1 ]; then
    echo "Starting calculation of mean NDVI values"
    bash "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/calcMean.sh"
fi
