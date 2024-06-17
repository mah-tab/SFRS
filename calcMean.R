# Load required packages
library(tools)
library(terra)

# Get command line arguments
args <- commandArgs(TRUE)
study_reg_dir <- args[1]

# Set working directory
setwd(study_reg_dir)
wd <- getwd()

# Create output directory if it does not exist
out_dir <- paste(dirname(dirname(wd)), "/extrRas", sep="")
if(!file.exists(out_dir)) {
  dir.create(out_dir)
}

# List .txt files with extracted raster values
LS_vals <- list.files(path=wd, pattern=".txt$", full.names=TRUE, recursive=FALSE)

# Print list of .txt files
print(LS_vals)

# Create empty vectors to store dates and mean NDVI values
LS_name <- c()
LS_mean <- c()

# Loop through each .txt file, calculate mean NDVI, and store the results
for (i in 1:length(LS_vals)) {
  # Read date of table from filename
  tb_name <- file_path_sans_ext(basename(LS_vals[i]))
  tb_name <- substr(tb_name, 1, 10)
  LS_name <- append(LS_name, tb_name)
  
  # Read table and calculate mean NDVI
  tb <- read.table(LS_vals[i], header=FALSE, stringsAsFactors=FALSE)
  tb_mean <- mean(tb[,1], na.rm=TRUE)
  LS_mean <- append(LS_mean, tb_mean)
  
  rm(tb_name, tb, tb_mean)
}

# Create summary table
LS_table <- as.data.frame(cbind(LS_name, LS_mean), stringsAsFactors=FALSE)
colnames(LS_table) <- c("date", "mean")
LS_table[,2] <- as.numeric(LS_table[,2])

# Save the summary table as .csv file
outname <- paste("/table_", basename(wd), ".csv", sep="")
write.csv(LS_table, paste(dirname(wd), outname, sep="/"), row.names=FALSE)

# Create and save a quicklook plot of the NDVI mean timeseries
pngname <- paste("/plot_", basename(wd), ".png", sep="")
png(paste(dirname(wd), pngname, sep="/"))
plot(seq(1, nrow(LS_table), 1), LS_table[,2], type="o", xaxt="n", xlab="date", ylab="mean NDVI")
axis(side=1, at=seq(1, nrow(LS_table), 1), labels=LS_table[,1]) # Add pretty x-axis
dev.off()
