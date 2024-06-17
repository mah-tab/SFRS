# NDVI.R
# This script calculates the Normalized Difference Vegetation Index (NDVI) from preprocessed Landsat TOA reflectance data.

# Load the required library
library(terra)

# Set the working directory to the folder containing the TOA reflectance data
setwd("E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/TOA")

# Create the output folder if it doesn't exist
if (!file.exists(paste(dirname(getwd()), "/NDVI/", sep = ""))) {
  dir.create(paste(dirname(getwd()), "/NDVI/", sep = ""), showWarnings = FALSE)
}

# Get a list of all TOA Geotiff files in the folder
toa_files <- list.files(pattern = "*.tif$", full.names = TRUE)

# Loop through each file and calculate the NDVI
for (r_name in toa_files) {
  # Load the specified dataset
  LS_toa <- rast(r_name)
  
  # Determine the satellite type by checking the filename
  if (grepl("LT05", basename(r_name))) {
    # Landsat 5 TM bands: Select bands 1 to 5 and 7
    LS_toa <- LS_toa[[c(1, 2, 3, 4, 5, 7)]]
    red_band <- 3
    nir_band <- 4
  } else if (grepl("LC08", basename(r_name))) {
    # Landsat 8 OLI bands: Select bands 2 to 7
    LS_toa <- LS_toa[[c(2, 3, 4, 5, 6, 7)]]
    red_band <- 3
    nir_band <- 4
  } else {
    stop("Unexpected filename format.")
  }
  
  # Calculate NDVI
  LS_ndvi <- (LS_toa[[nir_band]] - LS_toa[[red_band]]) / (LS_toa[[nir_band]] + LS_toa[[red_band]])
  
  # Define the output path and write the NDVI raster to the hard disk
  outname <- paste0(dirname(getwd()), "/NDVI/", substr(basename(r_name), 1, nchar(basename(r_name)) - 4), "_NDVI.tif")
  writeRaster(LS_ndvi, outname, overwrite = TRUE)
  
  # Print a message indicating successful completion
  cat("NDVI calculation and saving completed for", r_name, "\n")
}
