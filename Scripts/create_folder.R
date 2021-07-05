
# script to create a new folder in theDB and add the sample datasets


library(tidyverse)
library(googledrive)


devtools::load_all()


path <- "C:/Users/User/OneDrive/IMPROVAST/SGL/foodex2.shiny/Data/"


drive_auth(path = "shinyappimprorisk-c4f5cf2ec6c2.json")


drive_find(n_max = 30)

vars_needed_RawOccurrence <- c("foodex2", "res_num", "lod", "t_uom")
vars_needed_occurrenceFdx2 <- c("termCode","N", "LB_mean", "MB_mean", "UB_mean")
fdx2_chain_code        <- readRDS(paste0(path, "fdx2_chain_code.rds"))
mtx_levels             <- fdx2_chain_code[c("termCode", "termExtendedName" ,"depth")]


# Sample files
occurrence_raw <- 
  readxl::read_xlsx(
    paste0(path,"FC_IMPRORISK_LEAD_2016_2017.xlsx")
  ) %>%
   select(all_of(vars_needed_RawOccurrence)) %>% 
  # mutate(
  #   termCode = stringr::str_extract(foodex2, "^.{5}"),
  #   across(c(res_num, lod), ~ ifelse(t_uom == "\U03BCg/kg", ./1000, .))
  # ) %>% 
  # left_join(mtx_levels, by = "termCode") %>%
  # filter(!is.na(termCode)) %>% 
  {.}

occurrence_raw_name <- "sample-Lead (Pb) raw.xlsx"

# Shiny Ready. Fewer variables and renamed.
consumption_sample <- readRDS(paste0(path,"sample-Consumption_EUMENU-FDX2-LOT1.rds"))

consumption_name <- "sample-EUMENU-FDX2-LOT1.xlsx"

# As exported from this app. Aggregated
path_occur <- paste0(path, "ex3.Lead (Pb)-2016_2017 with ProcessFacets.xlsx")

occurrence_sample <- readxl::read_xlsx(path_occur) %>% 
  select(all_of(vars_needed_occurrenceFdx2))

occurrence_name <- "sample-Lead (Pb).xlsx"


# Make a new directory ----

user <- "lefkios"

#drive_mkdir(user)

add_to_db(consumption_sample, name = consumption_name, type = "Consumption", user = user  )
add_to_db(occurrence_sample, name = occurrence_name, type = "Occurrence", user = user  )
add_to_db(occurrence_raw, name = occurrence_raw_name, type = "Raw occurrence", user = user  )

googledrive::drive_ls(paste0(user, "/")) 

get_file_list(user)


