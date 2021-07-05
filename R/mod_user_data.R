#' user_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_user_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    #fluidRow(
      DT::DTOutput(ns("user_dribble")) %>% withSpinner(),
      #br(),
      shinyFeedback::loadingButton(ns("delete"),"Delete from DB", loadingLabel = "Deleting file")
      
   # )
    
  )
}
    
#' user_data Server Functions
#'
#' @noRd 
mod_user_data_server <- function(id, user, db_trigger){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    
    user_dribble <- reactive({
      req(user())
      
      # to refresh when the DB is updated
      db_trigger()
      
      get_file_list(user())
      
    })
    
    output$user_dribble <- DT::renderDT({
      
      
      user_dribble() %>% 
        select( 'File name' = description, 'Type' = name, 'Size'= size) %>% 
        datatable(
          caption = "The available datasets",
          selection = "single",
          options = list(
            paging = FALSE, searching = FALSE
          )
        ) 
    })
    
    return(user_dribble)
  })
}
    
## To be copied in the UI
# mod_user_data_ui("user_data_ui_1")
    
## To be copied in the server
# mod_user_data_server("user_data_ui_1")
