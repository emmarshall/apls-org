## Load packages
library(dplyr)
library(htmltools)
library(data.table)
library(reactable)
library(purrr)
library(tibble)
library(yaml)
library(tidyverse)
library(gt)

## Alternative option to add these to .Rprofile w/---
## if (file.exists('~/.Rprofile')) {
## sys.source('~/.Rprofile', envir = environment())
## }


# Function to make image carousel
# carousel displays a list of items w/ nav buttons
carousel <- function(id, duration, items) {
  index <- -1
  items <- lapply(items, function(item) {
    index <<- index + 1
    carouselItem(item$caption, item$image, item$link, index, duration)
  })
  
  indicators <- div(class = "carousel-indicators",
                    tagList(lapply(items, function(item) item$button))
  )
  items <- div(class = "carousel-inner",
               tagList(lapply(items, function(item) item$item))           
  )
  div(id = id, class="carousel carousel-dark slide", `data-bs-ride`="carousel",
      indicators,
      items,
      navButton(id, "prev", "Prevoius"),
      navButton(id, "next", "Next")
  )
}

# carousel item
carouselItem <- function(caption, image, link, index, interval) {
  id <- paste0("gallery-carousel-item-", index)
  button <- tags$button(type = "button", 
                        `data-bs-target` = "#gallery-carousel",
                        `data-bs-slide-to` = index,
                        `aria-label` = paste("Slide", index + 1)
  )
  if (index == 0) {
    button <- tagAppendAttributes(button,
                                  class = "active",
                                  `aria-current` = "true"                  
    )
  }
  item <- div(class = paste0("carousel-item", ifelse(index == 0, " active", "")),
              `data-bs-interval` = interval,
              a(href = link, img(src = image, class = "d-block  mx-auto border")),
              div(class = "carousel-caption d-none d-md-block",
                  tags$p(class = "fw-light", caption)
              )
  )
  list(
    button = button,
    item = item
  )                        
}

# Function to make nav button
navButton <- function(targetId, type, text) {
  tags$button(class = paste0("carousel-control-", type),
              type = "button",
              `data-bs-target` = paste0("#", targetId),
              `data-bs-slide` = type,
              span(class = paste0("carousel-control-", type, "-icon"),
                   `aria-hidden` = "true"),
              span(class = "visually-hidden", text)
  )
}

## Function to make inline lists of links
create_inline_object <- function(icon, text, url) {
  sprintf(
    '<span class="inline-object"><i class="fa fa-%s"></i><a href="%s">%s</a></span>',
    icon, url, text
  )
}

## Function to make info bars with icons
generate_info_bar <- function(info) {
  # Define CSS class names
  #info_bar_class <- "info-bar"
  inner_container_class <- "inner-container"
  info_bar_icon_class <- "info-bar__icon"
  info_bar_text_class <- "info-bar__text"
  info_bar_title_class <- "info-bar__title"
  info_bar_center_class <- "info-bar__center"
  
  # Generate HTML code
  html <- paste0(
    "<div class=info-bar container mt-3>",
    "<div class=class=d-flex justify-content-around mb-3'>",
    "<div class='", info_bar_icon_class, "' class=p-2'>",
    "<i class='", info$icon, "'></i>",
    "</div>",
    "<div class='", info_bar_text_class, "' class=p-2'>",
    "<h3 class='", info_bar_title_class, "'>", info$title, "</h3>",
    "<p class='lead'>", info$text, "</p>",
    "</div>",
    "<div class='", info_bar_center_class, "' class=p-2'>",
    "<a href='", info$link, "' class='btn btn-outline-primary'>", info$ctr, "</a>",
    "</div>",
    "</div>",
    "</div>"
  )
  
  return(html)
}


## Function to make accordion objects
make_accordion <- function(titles, contents) {
  # Create a list of accordion items
  items <- lapply(seq_along(titles), function(i) {
    item_header <- tags$h2(class = "accordion-header", 
                           tags$button(class = "accordion-button", 
                                       type = "button", 
                                       `data-bs-toggle` = "collapse", 
                                       `data-bs-target` = paste0("#collapse", i), 
                                       `aria-expanded` = ifelse(i == 1, "true", "false"), 
                                       `aria-controls` = paste0("collapse", i), 
                                       titles[i]))
    item_body <- tags$div(class = ifelse(i == 1, "accordion-collapse collapse show", "accordion-collapse collapse"), 
                          id = paste0("collapse", i), 
                          `aria-labelledby` = paste0("heading", i), 
                          `data-bs-parent` = "#accordionExample", 
                          tags$div(class = "accordion-body", contents[i]))
    tags$div(class = "accordion-item", item_header, item_body)
  })
  
  # Combine the list of items into a single tag object
  accordion <- tags$div(class = "accordion", id = "accordionExample", items)
  
  # Return the accordion tag object
  return(accordion)
}



#Function to make rowwise_tables for 'data.table' credit to mlr3misc pkg 

#' Similar to the \CRANpkg{tibble} function `tribble()`, this function
#' allows to construct tabular data in a row-wise fashion.
#'
#' The first arguments passed as formula will be interpreted as column names.
#' The remaining arguments will be put into the resulting table.
#'
#' @param ... (`any`)\cr
#'   Arguments: Column names in first rows as formulas (with empty left hand side),
#'   then the tabular data in the following rows.
#' @param .key (`character(1)`)\cr
#'   If not `NULL`, set the key via [data.table::setkeyv()] after constructing the
#'   table.
#'
#' @return [data.table::data.table()].
#' @export
#' @examples
#' rowwise_table(
#'   ~a, ~b,
#'   1, "a",
#'   2, "b"
#' )
rowwise_table = function(..., .key = NULL) {
  
  dots = list(...)
  
  for (i in seq_along(dots)) {
    if (!inherits(dots[[i]], "formula")) {
      ncol = i - 1L
      break
    }
  }
  
  if (ncol == 0L) {
    stop("No column names provided")
  }
  
  n = length(dots) - ncol
  if (n %% ncol != 0L) {
    stop("Data is not rectangular")
  }
  
  tab = lapply(seq_len(ncol), function(i) simplify2array(dots[seq(from = ncol + i, to = length(dots), by = ncol)]))
  tab = setnames(setDT(tab), map_chr(head(dots, ncol), function(x) attr(terms(x), "term.labels")))
  if (!is.null(.key)) {
    setkeyv(tab, .key)
  }
  tab
}
