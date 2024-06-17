# plot_NDVI.R
# This script plots the NDVI raster with a color scale.

# Load the required libraries
library(terra)
library(rasterVis)

# Set the path to the NDVI image
ndvi_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/NDVI/2000-08-13_LT05_194_025_cropped_TOA_NDVI.tif" # Replace with your NDVI image path

# Load the NDVI raster
ndvi_raster <- rast(ndvi_path)

# Display the NDVI raster in R
plot(ndvi_raster, main = basename(ndvi_path), col = colorRampPalette(c("brown", "yellow", "green"))(100))

# Function to apply a color scale to NDVI values and display the plot
apply_color_scale <- function(ndvi_raster) {
  levelplot(ndvi_raster, col.regions = colorRampPalette(c("brown", "yellow", "green"))(100),
            main = basename(ndvi_path),
            par.settings = list(layout.widths = list(axis.key.padding = 1, ylab.right = 2)))
}

# Apply color scale and display the plot
apply_color_scale(ndvi_raster)

# Print a message indicating successful completion
cat("NDVI plot displayed successfully.\n")

#################################################################################
# plot study regions NDVI
# Load necessary libraries
library(ggplot2)

# Define the file paths for the CSV files
file1 <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extrRas/table_study_reg_1.csv"
file2 <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extrRas/table_study_reg_2.csv"
file3 <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extrRas/table_study_reg_3.csv"

# Read the CSV files
data1 <- read.csv(file1)
data2 <- read.csv(file2)
data3 <- read.csv(file3)

# Add a column to each dataset to identify the study region
data1$region <- "Study Region 1"
data2$region <- "Study Region 2"
data3$region <- "Study Region 3"

# Combine the datasets into one
combined_data <- rbind(data1, data2, data3)

# Convert the date column to Date type for better plotting
combined_data$date <- as.Date(combined_data$date, format = "%Y-%m-%d")

# Create the plot
p <- ggplot(combined_data, aes(x = date, y = mean, color = region, group = region)) +
  geom_line() +
  geom_point() +
  labs(title = "Mean NDVI Values Over Time for Different Study Regions",
       x = "Year",
       y = "Mean NDVI",
       color = "Study Region") +
  theme_minimal() +
  scale_x_date(date_labels = "%Y", date_breaks = "1 years") +
  scale_y_continuous(limits = c(-1, 1))

# Display the plot
print(p)
##########################################################################

# plot NDVI correlation with precipitation and temprature (ugly)

# Load necessary libraries
library(readxl)
library(dplyr)

# Define file paths
ndvi_csv_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extrRas/table_study_reg_1.csv"
weather_data_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session03/Aug_MonatsKlimaMittelMöhrendorf_2000to2023.xlsx"

# Load the NDVI data
ndvi_data <- read.csv(ndvi_csv_path)
ndvi_data$date <- as.Date(ndvi_data$date, format = "%Y-%m-%d")
ndvi_data$year <- as.numeric(format(ndvi_data$date, "%Y"))

# Check NDVI data
print("NDVI Data:")
print(head(ndvi_data))

# Load the weather data
weather_data <- read_excel(weather_data_path, sheet = 1)

# Extract the year from the MESS_DATUM_BEGINN column
weather_data <- weather_data %>%
  mutate(year = as.numeric(substr(as.character(MESS_DATUM_BEGINN), 1, 4)))

# Select only the required columns
weather_data <- weather_data %>%
  select(year, MO_TT, MO_RR)

# Replace negative or NaN precipitation values with zero
weather_data$MO_RR[weather_data$MO_RR < 0 | is.na(weather_data$MO_RR)] <- 0

# Check Weather data
print("Weather Data:")
print(head(weather_data))

# Merge NDVI data with weather data
merged_data <- merge(ndvi_data, weather_data, by = "year")

# Check merged data
print("Merged Data:")
print(head(merged_data))

# Plot NDVI and Temperature on the same plot with dual y-axes
par(mar = c(5, 4, 4, 4) + 0.3)
plot(merged_data$year, merged_data$mean, type = "o", col = "blue", ylim = c(-1, 1), ylab = "Mean NDVI", xlab = "Years", main = "Correlation between NDVI and Temperature (study region 1)")
par(new = TRUE)
plot(merged_data$year, merged_data$MO_TT, type = "o", col = "red", ylim = range(merged_data$MO_TT), axes = FALSE, xlab = "", ylab = "")
axis(side = 4)
mtext("Temperature (°C)", side = 4, line = 3)
legend("bottomright", legend = c("NDVI", "Temperature"), col = c("blue", "red"), lty = 1, bty = "n", xpd = TRUE, inset = c(0, -0.3))

# Calculate correlation and p-value for Temperature
cor_temp <- cor.test(merged_data$mean, merged_data$MO_TT)
text(x = max(merged_data$year) - 5, y = -0.9, labels = paste("p-value =", sprintf("%.5f", cor_temp$p.value)), col = "red")
text(x = max(merged_data$year) - 5, y = -0.95, labels = paste("r =", round(cor_temp$estimate, 2)), col = "red")

# Plot NDVI and Precipitation on the same plot with dual y-axes
par(mar = c(5, 4, 4, 4) + 0.3)
plot(merged_data$year, merged_data$mean, type = "o", col = "blue", ylim = c(-1, 1), ylab = "Mean NDVI", xlab = "Years", main = "Correlation between NDVI and Precipitation (study region 1)")
par(new = TRUE)
plot(merged_data$year, merged_data$MO_RR, type = "o", col = "green", ylim = range(merged_data$MO_RR), axes = FALSE, xlab = "", ylab = "")
axis(side = 4)
mtext("Precipitation (mm)", side = 4, line = 3)
legend("bottomright", legend = c("NDVI", "Precipitation"), col = c("blue", "green"), lty = 1, bty = "n", xpd = TRUE, inset = c(0, -0.3))

# Calculate correlation and p-value for Precipitation
cor_prec <- cor.test(merged_data$mean, merged_data$MO_RR)
text(x = max(merged_data$year) - 5, y = -0.9, labels = paste("p-value =", sprintf("%.5f", cor_prec$p.value)), col = "green")
text(x = max(merged_data$year) - 5, y = -0.95, labels = paste("r =", round(cor_prec$estimate, 2)), col = "green")
###########################################################
# Pretty but wrong
# Load necessary libraries
library(ggplot2)
library(readxl)
library(grid)
library(dplyr)

# Define the file paths
ndvi_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extrRas/table_study_reg_1.csv"
weather_data_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session03/Aug_MonatsKlimaMittelMöhrendorf_2000to2023.xlsx"

# Load the NDVI data
ndvi_data <- read.csv(ndvi_path)
ndvi_data$date <- as.numeric(substr(ndvi_data$date, 1, 4))

# Load the weather data
weather_data <- read_excel(weather_data_path)
weather_data <- weather_data %>%
  mutate(
    year = as.numeric(substr(as.character(MESS_DATUM_BEGINN), 1, 4)),
    MO_RR = ifelse(is.na(MO_RR) | MO_RR < 0, 0, MO_RR)
  )

# Merge the data on the year
merged_data <- merge(ndvi_data, weather_data, by.x = "date", by.y = "year")

# Calculate correlation and p-value for NDVI and temperature
cor_temp <- cor.test(merged_data$mean, merged_data$MO_TT)
cor_temp_text <- paste("p-value =", format.pval(cor_temp$p.value), "r =", round(cor_temp$estimate, 5))

# Calculate correlation and p-value for NDVI and precipitation
cor_prec <- cor.test(merged_data$mean, merged_data$MO_RR)
cor_prec_text <- paste("p-value =", format.pval(cor_prec$p.value), "r =", round(cor_prec$estimate, 5))

# Plot NDVI and temperature
plot_temp <- ggplot(merged_data, aes(x = date)) +
  geom_line(aes(y = mean, color = "NDVI"), size = 1.2) +
  geom_point(aes(y = mean, color = "NDVI"), size = 2) +
  geom_line(aes(y = MO_TT, color = "Temperature"), size = 1.2) +
  geom_point(aes(y = MO_TT, color = "Temperature"), size = 2) +
  scale_y_continuous(
    name = "Mean NDVI",
    limits = c(-1, 1),
    sec.axis = sec_axis(~., name = "Mean Monthly Temperature in August (°C)")
  ) +
  labs(
    title = "Correlation between NDVI and Temperature (Study Region 1)",
    x = "Years"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.margin = unit(c(1, 1, 2, 1), "lines")
  ) +
  guides(color = guide_legend(title = NULL)) +
  annotation_custom(grobTree(textGrob(cor_temp_text, x = 0.1, y = 0.05, just = "left", gp = gpar(col = "black", fontsize = 10))))

# Plot NDVI and precipitation
plot_prec <- ggplot(merged_data, aes(x = date)) +
  geom_line(aes(y = mean, color = "NDVI"), size = 1.2) +
  geom_point(aes(y = mean, color = "NDVI"), size = 2) +
  geom_line(aes(y = MO_RR, color = "Precipitation"), size = 1.2) +
  geom_point(aes(y = MO_RR, color = "Precipitation"), size = 2) +
  scale_y_continuous(
    name = "Mean NDVI",
    limits = c(-1, 1),
    sec.axis = sec_axis(~., name = "Precipitation in August (mm)")
  ) +
  labs(
    title = "Correlation between NDVI and Precipitation (Study Region 1)",
    x = "Years"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.margin = unit(c(1, 1, 2, 1), "lines")
  ) +
  guides(color = guide_legend(title = NULL)) +
  annotation_custom(grobTree(textGrob(cor_prec_text, x = 0.1, y = 0.05, just = "left", gp = gpar(col = "black", fontsize = 10))))

# Display the plots
print(plot_temp)
print(plot_prec)

#####################################
# Plot correlations of NDVI mean with percipitation and temp
# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)

# Define file paths
ndvi_csv_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/extrRas/table_study_reg_1.csv"
weather_data_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session03/Aug_MonatsKlimaMittelMöhrendorf_2000to2023.xlsx"

# Load the NDVI data
ndvi_data <- read.csv(ndvi_csv_path)
ndvi_data$date <- as.Date(ndvi_data$date, format = "%Y-%m-%d")
ndvi_data$year <- as.numeric(format(ndvi_data$date, "%Y"))

# Check NDVI data
print("NDVI Data:")
print(head(ndvi_data))

# Load the weather data
weather_data <- read_excel(weather_data_path, sheet = 1)

# Extract the year from the MESS_DATUM_BEGINN column
weather_data <- weather_data %>%
  mutate(year = as.numeric(substr(as.character(MESS_DATUM_BEGINN), 1, 4)))

# Select only the required columns
weather_data <- weather_data %>%
  select(year, MO_TT, MO_RR)

# Replace negative or NaN precipitation values with zero
weather_data$MO_RR[weather_data$MO_RR < 0 | is.na(weather_data$MO_RR)] <- 0

# Check Weather data
print("Weather Data:")
print(head(weather_data))

# Merge NDVI data with weather data
merged_data <- merge(ndvi_data, weather_data, by = "year")

# Check merged data
print("Merged Data:")
print(head(merged_data))

# Calculate correlation and p-value for Temperature
cor_temp <- cor.test(merged_data$mean, merged_data$MO_TT)
cor_temp_text <- paste("p-value =", sprintf("%.5f", cor_temp$p.value), "\nr =", round(cor_temp$estimate, 5))

# Plot NDVI and Temperature on the same plot with dual y-axes using ggplot2
ggplot(merged_data, aes(x = year)) +
  geom_line(aes(y = mean, color = "NDVI")) +
  geom_point(aes(y = mean, color = "NDVI")) +
  geom_line(aes(y = MO_TT / 10, color = "Temperature")) +  # Adjust scale for visualization
  geom_point(aes(y = MO_TT / 10, color = "Temperature")) +
  scale_y_continuous(name = "Mean NDVI", sec.axis = sec_axis(~ . * 10, name = "Temperature (°C)")) +  # Adjust scale back
  labs(title = "Correlation between NDVI and Temperature (study region 1)", x = "Years") +
  theme_minimal() +
  theme(legend.position = "bottom", legend.direction = "horizontal", legend.box = "horizontal") +
  theme(legend.justification = c("right", "bottom"), legend.margin = margin(6, 6, 6, 6)) +
  annotate("text", x = min(merged_data$year), y = -0.9, label = cor_temp_text, hjust = 0, vjust = 0) +
  scale_color_manual(values = c("NDVI" = "blue", "Temperature" = "red"))

# Calculate correlation and p-value for Precipitation
cor_prec <- cor.test(merged_data$mean, merged_data$MO_RR)
cor_prec_text <- paste("p-value =", sprintf("%.5f", cor_prec$p.value), "\nr =", round(cor_prec$estimate, 5))

# Plot NDVI and Precipitation on the same plot with dual y-axes using ggplot2
ggplot(merged_data, aes(x = year)) +
  geom_line(aes(y = mean, color = "NDVI")) +
  geom_point(aes(y = mean, color = "NDVI")) +
  geom_line(aes(y = MO_RR / 100, color = "Precipitation")) +  # Adjust scale for visualization
  geom_point(aes(y = MO_RR / 100, color = "Precipitation")) +
  scale_y_continuous(name = "Mean NDVI", sec.axis = sec_axis(~ . * 100, name = "Precipitation (mm)")) +  # Adjust scale back
  labs(title = "Correlation between NDVI and Precipitation (study region 1)", x = "Years") +
  theme_minimal() +
  theme(legend.position = "bottom", legend.direction = "horizontal", legend.box = "horizontal") +
  theme(legend.justification = c("right", "bottom"), legend.margin = margin(6, 6, 6, 6)) +
  annotate("text", x = min(merged_data$year), y = -0.9, label = cor_prec_text, hjust = 0, vjust = 0) +
  scale_color_manual(values = c("NDVI" = "blue", "Precipitation" = "green"))
################################################################################
# NDVI difference plot

# Load the required libraries
library(terra)
library(rasterVis)

# Function to calculate the mean NDVI value of a raster
calculate_mean_ndvi <- function(ndvi_raster) {
  return(mean(values(ndvi_raster), na.rm = TRUE))
}

# Function to apply a color scale to NDVI values and display the plot
apply_color_scale <- function(ndvi_raster, title) {
  levelplot(ndvi_raster, col.regions = colorRampPalette(c("brown", "yellow", "green"))(100),
            main = title,
            par.settings = list(layout.widths = list(axis.key.padding = 1, ylab.right = 2)))
}

# Set the directory path to the NDVI images
ndvi_dir <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/NDVI"

# Get a list of all NDVI Geotiff files in the directory
ndvi_files <- list.files(ndvi_dir, pattern = "*.tif$", full.names = TRUE)

# Initialize variables to store the highest and lowest NDVI images
highest_ndvi <- -Inf
lowest_ndvi <- Inf
highest_ndvi_raster <- NULL
lowest_ndvi_raster <- NULL
highest_ndvi_path <- NULL
lowest_ndvi_path <- NULL

# Loop through each file and calculate the mean NDVI to determine the highest and lowest NDVI images
for (ndvi_path in ndvi_files) {
  ndvi_raster <- rast(ndvi_path)
  mean_ndvi <- calculate_mean_ndvi(ndvi_raster)
  
  if (mean_ndvi > highest_ndvi) {
    highest_ndvi <- mean_ndvi
    highest_ndvi_raster <- ndvi_raster
    highest_ndvi_path <- ndvi_path
  }
  
  if (mean_ndvi < lowest_ndvi) {
    lowest_ndvi <- mean_ndvi
    lowest_ndvi_raster <- ndvi_raster
    lowest_ndvi_path <- ndvi_path
  }
}

# Plot the highest NDVI image
cat("Plotting the highest NDVI image...\n")
plot(highest_ndvi_raster, main = paste("Highest NDVI:", basename(highest_ndvi_path)), col = colorRampPalette(c("brown", "yellow", "green"))(100))
apply_color_scale(highest_ndvi_raster, paste("Highest NDVI:", basename(highest_ndvi_path)))

# Plot the lowest NDVI image
cat("Plotting the lowest NDVI image...\n")
plot(lowest_ndvi_raster, main = paste("Lowest NDVI:", basename(lowest_ndvi_path)), col = colorRampPalette(c("brown", "yellow", "green"))(100))
apply_color_scale(lowest_ndvi_raster, paste("Lowest NDVI:", basename(lowest_ndvi_path)))

# Calculate the difference between the highest and lowest NDVI images
ndvi_difference <- highest_ndvi_raster - lowest_ndvi_raster

# Plot the NDVI difference map
cat("Plotting the NDVI difference map...\n")
levelplot(ndvi_difference, col.regions = colorRampPalette(c("red", "white", "blue"))(100),
          main = "NDVI Difference (Highest - Lowest)",
          par.settings = list(layout.widths = list(axis.key.padding = 1, ylab.right = 2)))

# Print a message indicating successful completion
cat("NDVI difference map displayed successfully.\n")
#############################################################################
# Load the required libraries
library(terra)
library(rasterVis)

# Set the directory containing NDVI images
ndvi_dir <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/NDVI"

# Get list of NDVI images
ndvi_files <- list.files(ndvi_dir, pattern = "*.tif$", full.names = TRUE)

# Initialize variables to store the max and min NDVI values and corresponding file names
max_ndvi <- -Inf
min_ndvi <- Inf
max_ndvi_file <- ""
min_ndvi_file <- ""

# Loop through each NDVI file to find the max and min NDVI values
for (file in ndvi_files) {
  ndvi_raster <- rast(file)
  mean_ndvi <- global(ndvi_raster, fun = mean, na.rm = TRUE)
  
  if (mean_ndvi > max_ndvi) {
    max_ndvi <- mean_ndvi
    max_ndvi_file <- file
  }
  
  if (mean_ndvi < min_ndvi) {
    min_ndvi <- mean_ndvi
    min_ndvi_file <- file
  }
}

# Print the files with max and min NDVI values
cat("File with max NDVI:", max_ndvi_file, "\n")
cat("File with min NDVI:", min_ndvi_file, "\n")

# Plot the NDVI raster with max NDVI
ndvi_raster_max <- rast(max_ndvi_file)
plot(ndvi_raster_max, main = paste("Max NDVI:", basename(max_ndvi_file)), col = colorRampPalette(c("brown", "yellow", "green"))(100))

# Plot the NDVI raster with min NDVI
ndvi_raster_min <- rast(min_ndvi_file)
plot(ndvi_raster_min, main = paste("Min NDVI:", basename(min_ndvi_file)), col = colorRampPalette(c("brown", "yellow", "green"))(100))

# Calculate the difference
ndvi_diff <- ndvi_raster_max - ndvi_raster_min

# Plot the difference
levelplot(ndvi_diff, col.regions = colorRampPalette(c("red", "white", "blue"))(100), main = "NDVI Difference")

##################################################################
# manually

# Load the required libraries
library(terra)
library(rasterVis)

# Set the paths to the low and high NDVI images
high_ndvi_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/NDVI/2001-08-25_LT05_193_026_cropped_TOA_NDVI.tif"
low_ndvi_path <- "E:/FAU master/LESSONS/Semester3/Scripting/SFRS/session02/Landsat/NDVI/2011-09-06_LT05_193_026_cropped_TOA_NDVI.tif"

# Load the NDVI rasters
low_ndvi_raster <- rast(low_ndvi_path)
high_ndvi_raster <- rast(high_ndvi_path)

# Plot the low NDVI raster
plot(low_ndvi_raster, main = "Low NDVI: 2011.09.06_LT05", col = colorRampPalette(c("brown", "yellow", "green"))(100))
# MAST MALI: read thing: Low NDVI: 2001.08.25_LT05

# Plot the high NDVI raster
plot(high_ndvi_raster, main = "High NDVI: 2019.08.27_LC08", col = colorRampPalette(c("brown", "yellow", "green"))(100))
# MAST MALI: real thing: High NDVI: 2011-09-06_LT05_193_026_cropped_TOA_NDVI

# Calculate the difference
ndvi_diff <- high_ndvi_raster - low_ndvi_raster

# Define the color scale for the difference plot
diff_colors <- colorRampPalette(c("red", "white", "blue"))(100)

# Adjust plot layout to make space for the legend
layout(matrix(c(1, 2), nrow = 1), widths = c(3, 1))

# Plot the NDVI difference
par(mar = c(5, 4, 4, 1) + 0.1)
plot(ndvi_diff, main = "NDVI Difference (High - Low)", col = diff_colors)

# Create an empty plot for the legend
par(mar = c(5, 0, 4, 1) + 0.1)
plot.new()
legend("center", legend = c("NDVI Decrease", "No Change", "NDVI Increase"),
       fill = c("red", "white", "blue"), title = "Legend", cex = 0.6)

##########################################################



