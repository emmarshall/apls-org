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



## ──────────────────────────────────────────────────────────────────────────
## Awards "Past Recipients" tables
##
## Data come from awards/data/*.csv (generated by awards/_update-awards.R from
## the AP-LS Award Winners Google Sheet). These helpers render the reactable
## tables used on the awards/awards/ pages in one shared house style.
## ──────────────────────────────────────────────────────────────────────────

library(reactablefmtr)

# Shared house style for all award tables: brand-navy header rule, subtle row
# striping + hover, roomy padding, inherited site font.
apls_table_theme <- function() {
  reactable::reactableTheme(
    style           = list(fontFamily = "inherit"),
    backgroundColor = "transparent",          # inherit the page background
    headerStyle     = list(
      color         = "#1B3264",
      fontWeight    = 600,
      borderBottom  = "2px solid #1B3264",
      paddingBottom = "6px"
    ),
    borderColor     = "rgba(0,0,0,0.08)",     # thin neutral row separators
    highlightColor  = "rgba(27,50,100,0.06)", # subtle navy hover, blends anywhere
    cellPadding     = "10px 14px"
  )
}

# Generic year-grouped recipients table (Saleem Shah, Teaching, Undergraduate,
# Distinguished). Shows the year large with the recipient name beneath it; an
# optional `detail` column adds a muted second line (e.g. award type,
# affiliation, advisor). Newest year first.
awards_table <- function(data,
                         name = "name",
                         detail = NULL,
                         group = "year",
                         page_size = 60) {
  data <- as.data.frame(data)

  cols <- list()
  cols[[group]] <- reactable::colDef(
    name = "Year", maxWidth = 110, align = "left",
    style = list(fontWeight = 700, color = "#1B3264", fontSize = "1.05rem")
  )
  cols[[name]] <- reactable::colDef(
    name = "Recipient",
    style = list(fontWeight = 600, color = "#1f2937")
  )

  if (!is.null(detail)) {
    cols[[detail]] <- reactable::colDef(
      name = "", vAlign = "center", align = "left",
      style = list(color = "#6c757d")
    )
  }

  # hide any other columns present in the CSV
  for (cn in setdiff(names(data), c(group, name, detail))) {
    cols[[cn]] <- reactable::colDef(show = FALSE)
  }

  tbl <- reactable::reactable(
    data,
    defaultPageSize = page_size,
    defaultSorted   = stats::setNames(list("desc"), group),
    static          = TRUE,
    sortable        = FALSE,
    striped         = FALSE,
    highlight       = TRUE,
    theme           = apls_table_theme(),
    defaultColDef   = reactable::colDef(vAlign = "center", align = "left"),
    columns         = cols
  )
  htmltools::div(tbl, style = "max-width: 620px;")
}

# Book award table: year + author stacked, with a linked title column. Hidden
# cover-image column is retained in the CSV for future use.
book_awards_table <- function(data, page_size = 20) {
  data <- as.data.frame(data)

  tbl <- reactable::reactable(
    data,
    defaultPageSize = page_size,
    defaultSorted   = list(year = "desc"),
    static          = TRUE,
    sortable        = FALSE,
    striped         = FALSE,
    highlight       = TRUE,
    theme           = apls_table_theme(),
    defaultColDef   = reactable::colDef(vAlign = "center", align = "left"),
    columns = list(
      year = reactable::colDef(
        name = "Year", maxWidth = 90,
        style = list(fontWeight = 700, color = "#1B3264")
      ),
      author = reactable::colDef(
        name = "Author", maxWidth = 230,
        style = list(fontWeight = 600, color = "#1f2937")
      ),
      title = reactable::colDef(
        name = "Title", html = TRUE, align = "left",
        cell = function(value, index) {
          url <- data$url[index]
          if (!is.na(url) && nzchar(url)) {
            sprintf('<a href="%s" target="_blank">%s</a>', url, value)
          } else {
            value
          }
        }
      ),
      url = reactable::colDef(show = FALSE),
      img = reactable::colDef(show = FALSE)
    )
  )
  htmltools::div(tbl, style = "max-width: 860px;")
}

# Dissertation table: Year / 1st / 2nd / 3rd place columns. Newest year first.
dissertation_table <- function(data, page_size = 60) {
  data <- as.data.frame(data)

  place <- function(label) {
    reactable::colDef(name = label, vAlign = "center", align = "left", html = TRUE)
  }

  tbl <- reactable::reactable(
    data,
    defaultPageSize = page_size,
    defaultSorted   = list(year = "desc"),
    static          = TRUE,
    sortable        = FALSE,
    striped         = FALSE,
    highlight       = TRUE,
    theme           = apls_table_theme(),
    defaultColDef   = reactable::colDef(vAlign = "center", align = "left"),
    columns = list(
      year   = reactable::colDef(
        name = "Year", minWidth = 80, maxWidth = 110,
        style = list(fontWeight = 700, color = "#1B3264")
      ),
      first  = place("1st place"),
      second = place("2nd place"),
      third  = place("3rd place")
    )
  )
  htmltools::div(tbl, style = "max-width: 960px;")
}

# Emit a quarto-timeline (https://emilhvitfeldt.github.io/quarto-timeline/) from
# award data. MUST be called inside a chunk with `#| output: asis`.
# Requires the extension + filter:
#   quarto add EmilHvitfeldt/quarto-timeline      # run once in the repo
#   filters: [timeline]                           # in the page YAML
# `content` is the name of a column holding the markdown shown for each entry;
# rows sharing a `label` (year) are grouped under one marker by the extension.
awards_timeline <- function(data, label = "year", content = "content",
                            classes = c("timeline", "vertical-alt", "tl-card"),
                            style = NULL) {
  data <- as.data.frame(data)
  ord  <- order(suppressWarnings(as.numeric(data[[label]])), decreasing = TRUE)
  data <- data[ord, , drop = FALSE]

  cls <- paste(paste0(".", classes), collapse = " ")
  style_attr <- if (!is.null(style)) paste0(" style=\"", style, "\"") else ""
  cat("::: {", cls, style_attr, "}\n\n", sep = "")
  for (i in seq_len(nrow(data))) {
    cat("::: {.event data-label=\"", as.character(data[[label]][i]), "\"}\n", sep = "")
    cat(data[[content]][i], "\n", sep = "")
    cat(":::\n\n")
  }
  cat(":::\n")
  invisible(NULL)
}




