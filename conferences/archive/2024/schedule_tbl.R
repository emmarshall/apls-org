
library(readxl)
library(stringr)
library(htmltools)
library(crosstalk)
library(dplyr)
library(tidyr)
library(reactablefmtr)
library(tippy)
library(htmlwidgets)

grid <- read_excel("AP-LS_2024_Program.xlsx", sheet = "schedule")

# Make day an ordered factor to use as filter 
grid$day <- factor(grid$day, levels = c("Thursday", "Friday", "Saturday"))


grid <- grid |> 
  mutate(time = paste(format(start, "%I:%M %p"), " - ", format(end, "%I:%M %p"))) |> 
  mutate(type = str_to_title(type)) 



# See the ?tippy documentation to learn how to customize tooltips
with_tooltip <- function(value, tooltip, ...) {
  div(style = "cursor: help",
      #using tippy allows for accessible tooltip
      tippy(value, tooltip, ...))
}



# Function to Generate a table for each day of the conference

daily_overview <- function(day) {

  grid_day <- grid |>  
    mutate(sess = case_when(
      type == "Session" ~ "2",
      TRUE ~ "1")) |>      
  # Filter grid for the specified day
  filter(day == !!day) 

  
  
  row_details <- function(index) {
    dets <- grid_day[index, ]
    
    dets_field <- function(name, ...) {
      if (any(is.na(...))) NULL
      else tagList(div(class = "detail-label", name), ...)
    }
    
    
    speakers <- lapply(paste0("people_", 1:10), function(who_col) {
      if (is.na(dets[[who_col]])) {
        NULL
      } else {
        div(dets[[who_col]])
      }
    })
    
    speakers <- Filter(Negate(is.null), speakers)
    
    if (length(speakers) == 0) {
      detail <- div(
        class = "schedule-detail",
        dets_field("Location", dets$location),
        dets_field("Chair", dets$chair),
        dets_field("CE Credits", dets$CE),
        dets_field("Description", dets$details)
      )
    } else {
      if (!is.na(dets$chair)) {
        detail <- div(
          class = "schedule-detail",
          div(class = "detail-header", dets$type),
          dets_field("Location", dets$location),
          dets_field("CE Credits", dets$CE),
          dets_field("Chair", dets$chair),
          dets_field("Speakers", div(class = "people", speakers))
        )
      } 
      else {
        detail <- div(
          class = "schedule-detail",
          dets_field("Event Type", dets$type),
          dets_field("Location", dets$location),
          dets_field("CE Credits", dets$CE),
          dets_field("Speakers", div(class = "people", speakers))
        )
      }
    }
    
    detail
  }
  
  

  # select only what we want for table
  grid_day <- grid_day |>
    select(day, month, number, type, sess, title, start, end, time, location, CE, details, chair, subtitle, contains("people_"))
  
  # Create the table using reactable with the filtered data
  reactable_table <- reactable(grid_day, 
                               defaultSorted = c("number", "start"),
                               sortable = FALSE,                     
                               showPageSizeOptions = FALSE,
                               showPageInfo = FALSE,
                               defaultPageSize = 70,
                               searchable = TRUE,
                               onClick = "expand",
                               rowStyle = function(index) {
                                 if (grid_day[index, "sess"] > 1) {
                                   list(background = "#ecf0f1")
                                 }
                               },
                              
                               defaultColDef = colDef(
                                 headerVAlign = "bottom"
                               ),
                               
                               columns = list(
                                 time = colDef(minWidth = 200, 
                                               header = with_tooltip("Details", "Session Details about Location & Time"),
                                               cell = function(value, index) { 
                                                 location <- grid_day$location[index]
                                                 location <- if (!is.na(location)) location else ""
                                                 div(
                                                   div(style = "font-weight: 700; font-size: .775rem; color: #343a40;", value),
                                                   div(style = "font-weight: 600; font-size: 0.675rem; text-transform: uppercase; color: #1B3264; letter-spacing: 0.8;", location)
                                                 )
                                               }
                                 ),
                                 
                                 type = colDef(name = "",
                                               minWidth = 60,
                                               align = "center",
                                               # style =  list(borderRight = "1px solid rgba(0, 0, 0, 0.1)"),
                                               cell = function(value) {
                                                 image <- img(src = 
                                                                sprintf("https://github.com/emmarshall/apls-org/raw/main/images/tbl/%s.png"
                                                                        , value), style = "height: 45px;", alt = value)
                                                 tagList(
                                                   div(style = "display: inline-block; width: 45px;", image)
                                                 )
                                               }
                                 ),
                                 title = colDef(
                                   header = with_tooltip("Session", "Event title & details"),
                                   minWidth = 400,
                                   align = "center", 
                                   cell = function(value, index) { 
                                     subtitle <- grid_day$subtitle[index]
                                     subtitle <- if (!is.na(subtitle)) subtitle else ""
                                     div(
                                       div(style = "font-weight: 900; line-height: 1.3; font-size: .875rem; color: #343a40;
", value),
                                       div(style = "font-size: .775rem; color: #737475", subtitle)
                                     )
                                   }
                                 ),
                                 location = colDef(show = FALSE),
                                 subtitle = colDef(show = FALSE),
                                 sess = colDef(show = FALSE),
                                 day = colDef(show = FALSE),
                                 time = colDef(show = FALSE),
                                 month = colDef(show = FALSE),
                                 number = colDef(show = FALSE),
                                 start = colDef(show = FALSE),
                                 end = colDef(show = FALSE),
                                 CE = colDef(show = FALSE),
                                 type = colDef(show = FALSE),
                                 details = colDef(show = FALSE),
                                 chair = colDef(show = FALSE),
                                 people = colDef(show = FALSE),
                                 people_1 = colDef(show = FALSE),
                                 people_2 = colDef(show = FALSE),
                                 people_3 = colDef(show = FALSE),
                                 people_4 = colDef(show = FALSE),
                                 people_5 = colDef(show = FALSE),
                                 people_6 = colDef(show = FALSE),
                                 people_7 = colDef(show = FALSE),
                                 people_8 = colDef(show = FALSE),
                                 people_9 = colDef(show = FALSE),
                                 people_10 = colDef(show = FALSE),
                                 people_11 = colDef(show = FALSE)
                               ),
                               details = row_details,
                               wrap = TRUE,
                               class = "schedule-tbl",
                               theme = reactableTheme(
                                 cellPadding = "8px 12px",
                                 headerStyle = list(
                                   borderWidth = "3px",
                                   paddingTop = "12px",
                                   verticalAlign = "bottom",
                                   textAlign = "bottom",
                                   background = "#1B3264",
                                   textTransform = "uppercase",
                                   borderColor = "#FBF9F4",
                                   color = "#FBF9F4",
                                   "&:hover" = list(background = "#333"),
                                   "&[aria-sort='ascending'], &[aria-sort='descending']" = list(background = "#5b5e5f"),
                                   borderColor = "#333",
                                   fontSize = "1.3rem"
                                 ),
                                 searchInputStyle = list(width = "100%"),
                                 paginationStyle = list(color = "#1B3264"),
                                 pageButtonHoverStyle = list(backgroundColor = "#4271B3"),
                                 pageButtonActiveStyle = list(backgroundColor = "#FBF9F4"))
  )                    
                               return(reactable_table)
                               }

# Create a table for each day
tbl_thurs <- daily_overview("Thursday")
tbl_fri <- daily_overview("Friday")
tbl_sat <- daily_overview("Saturday")


