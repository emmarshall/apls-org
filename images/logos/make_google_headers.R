library(magick)
setwd("~/Documents/R /apls/APLS_logos")

# Example image
ECP <- image_read("APLS_ECP_clear.png")

print(ECP)

# get original dimensions
orig_width <- image_info(ECP)$width
orig_height <- image_info(ECP)$height

# calculate the new dimensions based on aspect ratio
new_width <- round((400/1600)*orig_height)
new_height <- orig_height

# resize the image while maintaining aspect ratio
image_resized <- image_resize(image, paste0(new_width, "x", new_height))

image_resize(ECP, )

resize_images <- function(){
  # set path to original directory containing images
  path <- "APLS_logos/"
  
  # get list of files with .png extension
  files <- list.files(path, pattern = ".png$")
  
  # create new directory to store resized images
  new_dir <- "google_headers/"
  dir.create(new_dir, recursive = TRUE, showWarnings = FALSE)
  
  # loop through each image in the directory
  for (file in files) {
    # read in the image
    image <- image_read(paste0(path, file))
    
    # get original dimensions
    orig_width <- image_info(image)$width
    orig_height <- image_info(image)$height
    
    # calculate the new dimensions based on aspect ratio
    new_width <- round((400/1600)*orig_height)
    new_height <- orig_height
    
    # resize the image while maintaining aspect ratio
    image_resized <- image_resize(image, paste0(new_width, "x", new_height))
    
    # write the resized image to the new directory
    new_file <- paste0(new_dir, file)
    image_write(image_resized, new_file)
    
    # check if the new file exists
    if (file.exists(new_file)) {
      message(paste("Resized", file, "saved to", new_file))
    } else {
      message(paste("Error: could not save", file, "to", new_file))
    }
  }
  
  # check if the new directory exists
  if (dir.exists(new_dir)) {
    message(paste("Resized images saved to", new_dir))
  } else {
    message(paste("Error: could not create directory", new_dir))
  }
}


resize_images()
