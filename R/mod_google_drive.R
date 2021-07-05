#' google_drive UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_google_drive_ui <- function(id){
  ns <- NS(id)
  tagList(
    fileInput(ns("file"), "Load the file"),
    actionButton(ns("load_sub_info"), "Fill in substance info"),
    verbatimTextOutput(ns("file_info")),
    verbatimTextOutput(ns("info")),
    fluidRow(
      selectInput(ns("user"), "User", choices = c("lefkios", "dimitris"), selected = "lefkios"),
      selectInput(ns("type"), "Type", choices = c("Occurrence", "Consumption", "Raw occurrence"), selected = "Occurrence")
      ,shinyFeedback::loadingButton(ns("add"), "Add to DB", loadingLabel = "Adding to DB")
    ),
    fluidRow(
      col_8(DT::DTOutput(ns("dta"))),
      col_4(mod_user_data_ui(ns("user_data_ui_1")))
      
    )
  )
}

#' google_drive Server Functions
#'
#' @noRd 
mod_google_drive_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    res <- mod_substance_info_server("substance_info_ui_1")
    
    rv <- reactiveValues(
      name = NULL,
      path = NULL,
      user = NULL,
      type = NULL,
      db_updated = 0
    )
    
    out_dribble <- mod_user_data_server("user_data_ui_1", reactive(rv$user), reactive(rv$db_updated))
    
    
    dta <- reactive({
      
      req(input$file)
      
      
      ext <- tools::file_ext(input$file$name)
      
      switch(ext,
             xls = ,
             xlsx = readxl::read_excel(input$file$datapath),
             csv = vroom::vroom(input$file$datapath, delim = ","),
             tsv = vroom::vroom(input$file$datapath, delim = "\t"),
             validate("Invalid file; Please upload a .csv or .tsv file")
      )
      
    })
    
    observeEvent(input$file, {
      
      rv$name <- input$file$name
      
    })
    
    observeEvent(input$user,{
      rv$user = input$user
    })
    observeEvent(input$type,{
      rv$type = input$type
    })
    
    
    output$dta <- DT::renderDT({
      
      dta() %>% 
        datatable(
          options = list(
            scrollX = TRUE
          )
        )
    })
    
    output$file_info <- renderPrint({
      
      rv$name
    })
    
    
    
    observeEvent(input$add, {
      
      req(dta())
      
      add_to_db(dta(), rv$name,  rv$type, rv$user)
      
      rv$db_updated <- isolate(rv$db_updated + 1)
      
      shinyFeedback::resetLoadingButton("add")
    })
    
    
    
    # Fill in the substance details ----
    observeEvent(input$load_sub_info, {
      
      load_modal <- function(){
        ns <- session$ns
        
        modalDialog(
          title = "Fill in the substance info",
          mod_substance_info_ui(ns("substance_info_ui_1")),
          # footer = tagList(
          #   actionButton(ns("done"), label = "Done", class = "btn btn-success"), 
          #   modalButton("Cancel", icon("window-close"))
          # )
        )
        
      }
      
      showModal(load_modal())
    })
    
    observeEvent(res$trigger, {
      
      removeModal()
    })
    
    # this is temporary
    output$info <- renderPrint({
      
      reactiveValuesToList(res)
    })
    
    
    # End of  module Server ---
  })
}

## To be copied in the UI
# mod_google_drive_ui("google_drive_ui_1")

## To be copied in the server
# mod_google_drive_server("google_drive_ui_1")
