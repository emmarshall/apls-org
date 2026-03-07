library(googlesheets4)
library(dplyr)
library(yaml)
library(here)
library(glue)
library(stringr)

gs4_deauth()

SHEET_ID <- "16RGHgDI7snPwaHfvF1gxTLAMet1V5_kM_4iHog2h7m8"

ec_data <- read_sheet(SHEET_ID, sheet = "EC")

ec_list <- ec_data |>
  mutate(
    url = paste0("mailto:", Email),
    first = tolower(str_extract(Name, "^\\S+")),
    last = tolower(str_replace(str_extract(Name, "(?<=\\s).*$"), " ", "-")),
    base_path = paste0("presidents/imgs/", first, "_", last),
    image = case_when(
      Position %in% c("President", "Past President", "President Elect") &
        file.exists(here("about", paste0(base_path, ".png")))  ~ paste0(base_path, ".png"),
      Position %in% c("President", "Past President", "President Elect") &
        file.exists(here("about", paste0(base_path, ".jpg")))  ~ paste0(base_path, ".jpg"),
      Position %in% c("President", "Past President", "President Elect") &
        file.exists(here("about", paste0(base_path, ".jpeg"))) ~ paste0(base_path, ".jpeg"),
      .default = NA_character_
    )
  ) |>
  rename(text = Position, name = Name) |>
  select(name, text, url, image)

# Convert to list, dropping NA image fields
ec_list <- lapply(seq_len(nrow(ec_list)), function(i) {
  row <- as.list(ec_list[i, ])
  if (is.na(row$image)) row$image <- NULL
  row
})

write_yaml(ec_list, here("about", "executive-committee.yml"))



#### Update conference chairs

conf_data <- read_sheet(SHEET_ID, sheet = "Conf_Chairs")

conf_list <- conf_data |>
  mutate(
    text = paste0(Term, " Conference ", Position)
  ) |>
  rename(name = Name) |>
  select(name, text)

conf_list <- lapply(seq_len(nrow(conf_list)), function(i) {
  as.list(conf_list[i, ])
})

write_yaml(conf_list, here("about", "conf-chairs.yml"))