

library(tidyverse)
library(googledrive)


devtools::load_all()


path_consumption <- "C:/Users/User/OneDrive/IMPROVAST/SGL/moduleExposure/SampleData/Consumption_EUMENU-FDX2-LOT2.xlsx"
consumption <- readxl::read_excel(path_consumption)

path_occurrence <- "C:/Users/User/OneDrive/IMPROVAST/SGL/moduleExposure/SampleData/occurrence-correct.xlsx"

occurrence <- readxl::read_excel(path_occurrence)


# 
# saveRDS(consumption, "consumption.rds", compress = TRUE)
# 
# file.size("consumption.rds")



drive_find(n_max = 30)


drive_auth(path = "shinyappimprorisk-c4f5cf2ec6c2.json")

drive_user()

drive_get(id = "root")

drive_get(id = "root") %>% drive_reveal("path")


drive_get("lefkios/")

about <- drive_about()


about[["user"]]



user <- "lefkios"

#lefkios_folder <- drive_mkdir(user, overwrite = FALSE)

file_name <- "consumption.rds"
file_name <- "occurrence.rds"


file_path <- file.path(tempdir(), file_name)

saveRDS(consumption, file_path)

saveRDS(occurrence, file_path)

file.size(file_path)


# save to DB ----
out <- attempt::try_catch(
  
  add_to_db(
    dta  = occurrence, 
    name = "Lead (Pb).xlsx", 
    type = "occurrence", 
    user = "lefkios")
  
  , .e = ~ paste0("There was an error: ", .x)
  
)


# load data ----
attempt::try_catch(
  
  load_data(
    name = "Lead (Pb).xlsx", 
    user = "lefkios")
  
  , .e = ~ paste0("There was an error: ", .x)
  
)


# delete file ----

deleted <- delete_from_db("the name.xlsx", "lefkios")

isTRUE(deleted)




get_file_list("lefkios")




delete_from_db("LOT2.xlsx", "lefkios")

get_storage_size("lefkios")

load_data("Consumption", "lefkios")

load_data("occurrence", "lefkios")

delete_from_db("FC_IMPRORISK_METALS_2018.xlsx", "lefkios")


# file <- drive_upload(media = file_path, path = paste0(user, "/"), overwrite = TRUE,
#                      description = "a description"
#                      )


info <- drive_get("lefkios/occurrence.rds")

drive_get("lefkios/")

file_list <- drive_ls("lefkios/")

file_list %>% 
  rowwise() %>% 
  mutate(
    size = drive_resource[["size"]] %>% as.numeric(),
    description = drive_resource[["description"]]
  ) %>% 
  ungroup()


get_file_list("dimitris")



drive_download("lefkios/Lead_(Pb).xlsx", path = "lead.rds",overwrite = TRUE)


readRDS("lead.rds")



removed <- drive_rm("lefkios/consumsssption.rds")

success <- delete_from_db("the name.xlsx", "lefkios")

isTRUE(success)


info$drive_resource[[1]][["size"]] 


des <- info$drive_resource[[1]][["description"]]

purrr::pluck(info, "drive_resource", 1, "parents")

"1C3tudkP9lvhuESyGbJl3XregQdqFpFYT"

#file <- drive_update(file, name = "a new name")



# download it

temp_dir <- tempdir()





download_file <- drive_download(file, overwrite = TRUE)


readRDS(download_file$name)


file$drive_resource
list.files(pattern = ".rds")



