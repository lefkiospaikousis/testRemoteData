#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import dplyr
#' @importFrom shinycssloaders withSpinner
#' @importFrom DT datatable
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  
  # this needs to go to a separate file e.g. global.R and then
  #in run_app.R we can use
  # source(system.file("global.R",package = "testRemoteData"))
  # similar  to improreconcile.
  googledrive::drive_auth(path = "shinyappimprorisk-c4f5cf2ec6c2.json")
  
  mod_google_drive_server("google_drive_ui_1")
  
  
}
