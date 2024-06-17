# extrRas.R

# Load necessary libraries
library(terra)

# Read command line arguments
args <- commandArgs(trailingOnly = TRUE)
r_name <- args[1]
shp_path <- args[2]

# Load the NDVI raster
LS_ndvi <- rast(r_name)

# Load the study areas shapefile
ex_shp <- vect(shp_path)

# Create the output directory
wd <- getwd()
out_dir <- paste0(dirname(wd), "/extrRas/")
if(!file.exists(out_dir)) {
  dir.create(out_dir, showWarnings = FALSE)
}

# Loop through each study region polygon
for (i in 1:length(ex_shp)) {
  # Create specific output directory for each study area
  region_dir <- paste0(out_dir, "study_reg_", i, "/")
  if(!file.exists(region_dir)) {
    dir.create(region_dir, showWarnings = FALSE)
  }
  
  # Extract raster values at the location of the i-th polygon
  r_vals <- extract(LS_ndvi, ex_shp[i,], method = "simple")
  r_vals <- as.numeric(unlist(r_vals))
  
  # Save the extracted values as a text file
  outname <- paste0(substr(basename(r_name), 1, nchar(basename(r_name)) - 4), "_", i, "_vals.txt")
  write.table(r_vals, file.path(region_dir, outname), row.names = FALSE, col.names = FALSE)
}
