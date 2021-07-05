#' substance_info UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_substance_info_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$table(
      tags$tr(width = "100%",
              tags$td(width = "60%", div(style = "font-size:14px;", "Chemical Substance")),
              tags$td(width = "40%", textInput(inputId = ns("substance_name"), value = "", label = NULL, 
                                               placeholder = "Write a name for the substance"))),
      tags$tr(width = "100%",
              tags$td(width = "60%", tags$div(style = "font-size:14pX;", "Substance Category")),
              tags$td(width = "40%", selectInput(inputId = ns("substance_category"), 
                                                 #selected = , 
                                                 choices = sub_categories,
                                                 label = NULL))),
      tags$tr(width = "100%",
              tags$td(width = "60%", tags$div(style = "font-size:14pX;", "Reference value (μg/Kg bw)")),
              tags$td(width = "40%", numericInput(inputId = ns("substance_refValue"), 
                                                  value = 0, #substance_info$ref_value, 
                                                  min  = 0,
                                                  label = NULL))),
      tags$tr(width = "100%",
              tags$td(width = "60%", tags$div(style = "font-size:14pX;", "Type of reference value")),
              tags$td(width = "40%", selectInput(inputId = ns("substance_type"), 
                                                 #selected = , 
                                                 choices = sub_ref_type,
                                                 label = NULL))),
      tags$tr(width = "100%",
              tags$td(width = "60%", tags$div(style = "font-size:14pX;", "Frequency")),
              tags$td(width = "40%", selectInput(inputId = ns("substance_frequency"), 
                                                 #selected =, 
                                                 choices = sub_frequency,
                                                 label = NULL)))
    ),
    actionButton(ns("done"), label = "Done", class = "btn btn-success",width = "100%")
  )
}
    
#' substance_info Server Functions
#'
#' @noRd 
mod_substance_info_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    to_return <- rv(
      substance_name = NULL,
      substance_category = NULL,
      substance_refValue = NULL,
      substance_type = NULL,
      substance_frequency = NULL,
      trigger = 0  
    )
    
    
    observeEvent(input$done, {

      to_return$substance_name <- input$substance_name
      to_return$substance_category <-input$substance_category
      to_return$substance_refValue <- input$substance_refValue
      to_return$substance_type <- input$substance_type
      to_return$substance_frequency <- input$substance_frequency
      to_return$trigger <- isolate(to_return$trigger + 1 )
    })
    
    
    return(to_return)
    
    
  })
}
    
## To be copied in the UI
# mod_substance_info_ui("substance_info_ui_1")
    
## To be copied in the server
# mod_substance_info_server("substance_info_ui_1")
