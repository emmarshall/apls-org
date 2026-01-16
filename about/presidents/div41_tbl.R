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
library(readxl)

base_path <- here::here("about", "presidents")
#pres <- readr::read_csv(here(base_path, "pres_data.csv"))
#pres <- read_excel("pres_data.xlsx", sheet = "pres_data")
div41 <- read_excel(here(base_path, "pres_data.xlsx"), sheet = "div41_data")

tbl <- div41 |> 
  select(name, date) |> 
  gt() |> 
  gt_merge_stack(col1 = name, col2 = date, palette = c("#343A40", "#737475"),
                 font_size = c("16px", "11px")) |> 
  cols_width(name ~ px(500)) |> 
  tab_header(
    title = html("APLS Presidents Prior to Merger with APA Division 41<br><span style='color:#1B3264;'>(1969-1983)</span>"),
    subtitle = html("The American Psychology-Law Society (APLS) operated independently from 1969-1983.<br>APA Division 41 was established in 1981, and APLS merged with it in 1984.")
  ) |> 
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
      cells_title(groups = "title")
    )
  ) |>
  tab_style(
    style = list(
      cell_text(
        size = "11px",
        color = "#737475",
        weight = "normal",
        style = "italic"
      )
    ),
    locations = list(
      cells_title(groups = "subtitle")
    )
  ) |>
  cols_label(
    #name = img_header("AP-LS Presidents", "https://emmarshall.github.io/runza/img/apls-presidents/logo.png", height = 60,font_size = 24),
    name = ""
  ) 

tbl |> 
  gtsave(here(base_path, "tbl_2.html"))