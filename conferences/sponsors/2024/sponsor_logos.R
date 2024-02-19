library(ggplot2)
library(ggimage)
library(ragg)
library(magick)
create_sponsor_canvas <- function(file_paths, image_size = 0.2) {
  # Resize and save the images
  resized_files <- file_paths
  for (file_path in file_paths) {
    image <- image_read(file_path)
    resized_image <- image_scale(image, "400x400")  # Adjust the dimensions as per your requirement
    new_file_path <- paste0(tools::file_path_sans_ext(file_path), "_resized", ".png")
    image_write(resized_image, path = new_file_path)
    # Update the file path in the data frame
    resized_files[resized_files == file_path] <- new_file_path
  }
  
  # Calculate the number of images
  num_images <- length(file_paths)
  
  # Set the spacing between the images
  spacing <- 3  # Adjust the spacing as needed
  
  # Calculate the x positions for arranging the images in a row with even spacing
  x_positions <- seq(from = 1, to = num_images * spacing, by = spacing)
  
  # Set the y position for all images
  y_position <- 6  # Adjust the y position as needed
  
  # Create a data frame with the positions and file paths
  photo_data <- data.frame(
    x = x_positions,
    y = rep(y_position, num_images),
    file_path = file_paths
  )
  
  # Calculate the dimensions for the canvas using the golden ratio
  width <- 8 # Initial width
  height <- width * 1.618 # Calculate height using the golden ratio
  
  # Create canvas with golden ratio aspect ratio
  sponsor_canvas <- ggplot(data.frame(x = c(0, width), y = c(0, height)), aes(x, y)) +
    geom_blank() # This creates an empty canvas
  
  # Add local images to the canvas
  sponsors <- sponsor_canvas +
    geom_image(data = photo_data, aes(x = x, y = y, image = file_path), size = 0.45) +
    theme_void() # This removes axis and background elements
  
  # Save the canvas as a PNG file With {ragg}
  ggsave("conferences/sponsors/2024/sponsors.png", sponsors,
         device = ragg::agg_png, res = 300,
         width = 11, height = 5, units = "in")
}

# Example usage:
file_path <- c(
  "conferences/sponsors/2024/ca_hosp.jpg",
  "conferences/sponsors/2024/OFMHS.png",
  "conferences/sponsors/2024/OUP_transparent.png"
)

create_sponsor_canvas(file_path)