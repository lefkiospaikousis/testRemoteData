

#' Add the dataset to the database as an .rds file
#' 
#' The dataset is the one the user either uploaded and improrisk processed, or the user created in ImproRisk
#' such as an aggregated occurrence dataset 
#' @details 
#' The `type` of the dataset willbe passed as the name of the dataset and the `name` will be passed
#' onto the `description` in the dribble. This is because the user will be allowed only one of each
#' type to upload (occurrence, concumption, raw_occurrence). When a new dataset is uploaded, the dribble 
#' name (i.e. the type) will be the one that will determine whether the dataset will be updated, or it is 
#' a new type of data. So eventually,the `description` column in the resulting driblle will hold the dataset's
#' raw name. Confusing it is I know :)
#' @param dta A tibble. The dataset to add.
#' @param name String length 1. The name to give to the dataset. Usually this will be what the user uploaded
#' @param type String length 1. The type of dataset. One of `Consumption`, `Occurrence`, `Raw occurrence`
#' @param user String length 1. The user id
#' 
#' @return A googledrive dribble for further manipulation if needed
#' @noRd
add_to_db <- function(dta, name, type, user){
  
  if(!inherits(dta, "data.frame")){
    stop("Data is not a dataframe")
  }
  
  type = match.arg(type, choices = c("Consumption", "Occurrence", "Raw occurrence"))
  
  # dta needs to be save locally first and then uploaded
  file_path <- file.path(tempdir(), type)
  
  saveRDS(dta, file_path)
  
  # Now upload. 
  
  if(has_token()){
    
    file <- googledrive::drive_put(
      media = file_path, 
      path = paste0(user, "/"), 
      description = name
      )
    
  } else {
    
    stop("There is no authorisation on the google drive", call. = FALSE)
    
  }
  
  # TODO final checks? Not sure if it needed
  if(googledrive::is_dribble(file)){
    
    usethis::ui_done("Successfully added the file")
    
  } else {
    
    stop("Not a dribble", call. = FALSE)
  }
  
  return(file)
  
}

#' Delete a file from the database
#' 
#' This function deletes the file from theusers DB
#' @param name String length 1. The name of the file to delete. This is the name that appears in the dribble
#' @param user String length 1. The user id
#' @return logical. If it is succesfull.  see ?googledrive::drive_rm
#' @noRd
delete_from_db <- function(name, user){
  
  name <- paste0(user, "/", name)
  
  if(has_token()){
    
    removed <- googledrive::drive_rm(name)
    
  } else {
    
    stop("There is no authorisation on the google drive", call. = FALSE)
    
  }
  
  removed
}

#' Load the data into ImproRisk
#' 
#' This function first downloads locally the .rds file from gdrive and then readsit in to ImproRisk
#' @param name String length 1. The name of the file to delete. This is the name that appears in the dribble
#' @param user String length 1. The user id
#' @noRd
load_data <- function(name, user){
  
  # remember that all files are saved as .rds
  
  temp_file <- tempfile(fileext = ".rds")
  
  full_name <- paste0(user, "/", name)
  
  file <- googledrive::drive_download(file= full_name, path = temp_file, overwrite = TRUE)
  
  readRDS(file$local_path)
  
}


#' Check if the user exceeds the storage limit
#' @param user String length 1. The user id
#' @return logical. TRUE if the user has enough storage
#' @noRd
has_storage <- function(user){
  
  size = get_storage_size(user)
  
  if(size <1024^3){
    TRUE
  } else {
    FALSE
  }
}


#' Get the total storage size of a user 
#' @param user String length 1. The user id
#' @noRd
get_storage_size <- function(user){
  
  
  dribble <- get_file_list(user)
  
  sum(dribble$size)
  
  
}


#' List of files in a user's folder in the google drive
#' 
#' @param user String length 1. The user id
#' @return A dribble with contents of the user's folder metadata
#' @noRd
get_file_list <- function(user){
  
  file_list <- googledrive::drive_ls(paste0(user, "/")) 
  
  file_list %>% 
    dplyr::rowwise() %>% 
    dplyr::mutate(
      size = drive_resource[["size"]] %>% as.numeric(),
      description = drive_resource[["description"]]
    ) %>% 
    dplyr::ungroup()
  
}



has_token <- function(){
  
  if(googledrive::drive_has_token()){
    
    TRUE
    
  } else {
    
    FALSE
    
  }
}

