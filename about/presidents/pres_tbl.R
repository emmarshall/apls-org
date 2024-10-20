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
                 font_size = c("30px", "15px")) |> 
  cols_width(name ~ px(100),
             image ~px(120)) |> 
  cols_label(
    name = img_header(
      "AP-LS Presidents",
      "https://emmarshall.github.io/runza/img/apls-presidents/logo.png",
      height = 60,
      font_size = 24
    ),
    image = ""
  ) 

gtExtras::gtsave_extra(tbl, here(base_path, "img", "tbl.png"))   

tbl