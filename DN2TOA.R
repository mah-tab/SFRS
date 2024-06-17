# DN2TOA.R
library(terra)

args <- commandArgs(trailingOnly = TRUE)
folder <- args[1]

setwd(folder)
metafile_name <- dir(pattern = "MTL.txt$")

if (length(metafile_name) == 0) {
  stop("No MTL file found in the directory.")
}

metafile <- read.table(metafile_name, fill = TRUE, stringsAsFactors = FALSE)

# Debug: Print the first few lines of the metadata file
print("First few lines of the MTL file:")
print(head(metafile, 20))

# Extract the SPACECRAFT_ID
spacecraft_id <- metafile[which(metafile[, 1] == "SPACECRAFT_ID"), 3]
spacecraft_id <- gsub("\"", "", spacecraft_id)
print(paste("Extracted spacecraft_id:", spacecraft_id)) # Debugging line

LS_n <- substr(spacecraft_id, 9, 9)
print(paste("Extracted LS_n:", LS_n))

if (LS_n == "5") {
  REFLECTANCE_MULT_BAND <- c()
  REFLECTANCE_ADD_BAND <- c()
  for (b in c(1, 2, 3, 4, 5, 7)) {
    REFLECTANCE_MULT_BAND[b] <- as.numeric(metafile[which(metafile[, 1] == paste0("REFLECTANCE_MULT_BAND_", b)), 3])
    REFLECTANCE_ADD_BAND[b] <- as.numeric(metafile[which(metafile[, 1] == paste0("REFLECTANCE_ADD_BAND_", b)), 3])
  }
  REFLECTANCE_ADD_BAND <- na.omit(REFLECTANCE_ADD_BAND)
  REFLECTANCE_MULT_BAND <- na.omit(REFLECTANCE_MULT_BAND)
  LS <- dir(pattern = ".TIF$", full.names = TRUE)
  LS <- LS[c(1, 2, 3, 4, 5, 7)]
} else if (LS_n == "8") {
  REFLECTANCE_MULT_BAND <- as.numeric(metafile[which(metafile[, 1] == "REFLECTANCE_MULT_BAND_1"), 3])
  REFLECTANCE_ADD_BAND <- as.numeric(metafile[which(metafile[, 1] == "REFLECTANCE_ADD_BAND_1"), 3])
  LS <- dir(pattern = ".TIF$", full.names = TRUE)
  LS <- LS[c(2, 3, 4, 5, 6, 7)]  # Select bands 2 to 7
  # Repeat the same REFLECTANCE_MULT_BAND and REFLECTANCE_ADD_BAND for all selected bands
  REFLECTANCE_MULT_BAND <- rep(REFLECTANCE_MULT_BAND, length(LS))
  REFLECTANCE_ADD_BAND <- rep(REFLECTANCE_ADD_BAND, length(LS))
} else {
  stop("Unknown satellite type: ", LS_n)
}

# Debug: Print the bands selected for processing
print(LS)

# Check the number of images
print(paste("Number of images to process:", length(LS)))

LS <- rast(LS)
LS <- classify(LS, rcl = matrix(c(-Inf, -1, NA), 1, 3))
sun_ele <- as.numeric(metafile[which(metafile[, 1] == "SUN_ELEVATION"), 3])
LS_toa <- (LS * REFLECTANCE_MULT_BAND + REFLECTANCE_ADD_BAND) / sin(sun_ele / 180 * pi)

outdir <- paste0(dirname(dirname(getwd())), "/TOA")
if (!dir.exists(outdir)) {
  dir.create(outdir, recursive = TRUE)
}

outname <- paste0(outdir, "/", basename(getwd()), "_TOA.tif")
writeRaster(LS_toa, outname, overwrite = TRUE)

# Debug: Confirm successful writing
print(paste("Written TOA image to:", outname))
