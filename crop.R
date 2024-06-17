# crop.R
library(terra)

args <- commandArgs(trailingOnly = TRUE)
folder <- args[1]

setwd(folder)
AOI <- ext(638485, 650088, 5489475, 5498898)
tifs <- dir(pattern="*.TIF$", full.names = T)

# Define the output directory in the cropped folder
outdir <- paste0(dirname(dirname(getwd())), "/cropped/", basename(getwd()), "_cropped")
if(!dir.exists(outdir)) { dir.create(outdir, recursive = T) }

for (i in 1:length(tifs)) {
  tif <- rast(tifs[i])
  tif_c <- crop(tif, AOI)
  outname <- file.path(outdir, basename(tifs[i]))
  writeRaster(tif_c, outname, overwrite = TRUE)
}

# Copy non-TIF files to the output directory
files <- dir(full.names = TRUE)
notifs <- files[!files %in% tifs]
file.copy(notifs, outdir)
