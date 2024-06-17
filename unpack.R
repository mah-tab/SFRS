# unpack.R
args <- commandArgs(trailingOnly = TRUE)
zip <- args[1]

library(tools)

# Set the working directory to the zip folder
setwd("E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/zip")

# Extract parts of the filename
filename <- file_path_sans_ext(basename(zip))
year <- substr(filename, 18, 21)
month <- substr(filename, 22, 23)
day <- substr(filename, 24, 25)
path <- substr(filename, 11, 13)
row <- substr(filename, 14, 16)
sat <- substr(filename, 1, 4)

# Create output directory name in the unzipped folder
outname <- paste0("E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/unzip/", year, "-", month, "-", day, "_", sat, "_", path, "_", row)

# Unpack the tar.gz file
untar(zip, exdir = outname)
