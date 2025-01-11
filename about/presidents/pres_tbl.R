library(janitor)
library(tidyverse)
library(gt)
library(stringr)
library(purrr)
library(htmltools)
library(gtExtras)
library(dplyr)
library(here)
library(webshot2)

base_path <- here::here("about", "presidents")

pres <- readr::read_csv(here(base_path, "pres_data.csv"))

tbl <- pres |> 
  select(image, name, date) |> 
  gt() |> 
  gtExtras::gt_img_rows(columns = "image", height = 100) |> 
  gt_merge_stack(col1 = name, col2 = date, palette = c("#343A40", "#737475"),
                 font_size = c("16px", "11px")) |> 
  cols_width(name ~ px(350),
             image ~px(150)) |> 
  tab_header(
    title = html("List of former <span style='color:#1B3264;'>American Psychology-Law Society</span> <br> & <span style='color:#1B3264;'>APA Div 41</span> Presidents"
  )) |> 
  opt_align_table_header(align = "left") |>
  opt_vertical_padding(scale = 0.5) |> 
  tab_style(
    style = list(
      cell_text(
        size = "18px",
        color = "#343A40",
        weight = "bold"
      )
    ),
    locations = list(
      cells_title()
    )
  ) |> 
  cols_label(
    #name = img_header("AP-LS Presidents", "https://emmarshall.github.io/runza/img/apls-presidents/logo.png", height = 60,font_size = 24),
    name = "",
    image = ""
  ) 

tbl |> 
  gtsave(here(base_path, "tbl_1.html"))   
