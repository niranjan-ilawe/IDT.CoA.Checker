## app.R ##
library(shinydashboard)
library(shiny)
library(DT)

## Package Dev Paths
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/clean_plate_df.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/join_sequence_files.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/pass_by_matches.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/read_coa_file.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/read_order_file.R")

## Shiny Server Paths

ui <- dashboardPage(
  dashboardHeader(title = "IDT CoA Checked"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Checker", tabName = "checker", icon = icon("dashboard")),
      menuItem("Create CoA File", tabName = "coa_creator", icon = icon("th")),
      menuItem("Create Order File", tabName = "order_creator", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "checker",
              fluidRow(
                box(width = 4,
                  fileInput("coa_file", "Upload CoA File",
                            multiple = FALSE,
                            accept = c(".csv"))
                ),

                box(width = 4,
                  fileInput("order_file", "Upload Order File",
                            multiple = FALSE,
                            accept = c(".xlsx"))
                ),

                box(width = 4,
                  actionButton("check_coa", "Check")
                )
              ),
              fluidRow(
                infoBoxOutput("coa_cnt_box"),
                infoBoxOutput("order_cnt_box"),
                infoBoxOutput("pass_fail_box")
              ),
              fluidRow(
                box(width = NULL,
                    collapsible = TRUE,
                    div(style = 'overflow-y: scroll', DT::dataTableOutput('summary_tbl'))
                )
              )
      ),

      # Second tab content
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )
  )
)

server <- function(input, output) {

  # read CoA File and Order File
  file_data <- eventReactive(input$check_coa, {

    coa_df <- read_coa_file(input$coa_file$datapath)
    order_df <- read_order_file(input$order_file$datapath)

    list(coa_df = coa_df, order_df = order_df)
  })

  # create join
  joined_df <- reactive(
    df <- join_sequence_files(coa_df = file_data()[['coa_df']],
                              order_df = file_data()[['order_df']])
  )

  output$coa_cnt_box <- renderInfoBox({
    infoBox(
      "# CoA Sequences", paste0(nrow(file_data()[['coa_df']])), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  output$order_cnt_box <- renderInfoBox({
    infoBox(
      "# Order Sequences", paste0(nrow(file_data()[['order_df']])), icon = icon("list"),
      color = "yellow", fill = TRUE
    )
  })
  output$pass_fail_box <- renderInfoBox({
    if(pass_by_matches(joined_df())){
      infoBox(
        "Pass", color = "green", fill = TRUE, icon = icon("thumbs-up", lib = "glyphicon"),
      )
    } else {
      infoBox(
        "Fail", color = "red", fill = TRUE, icon = icon("thumbs-down", lib = "glyphicon"),
      )
    }

  })

  output$summary_tbl <- DT::renderDT(server = FALSE, {
    DT::datatable(
      joined_df(),
      extensions = c("Buttons"),
      options = list(
        dom = 'Bfrtip',
        buttons = list(
          list(extend = "csv", text = "Download Data", filename = glue::glue(Sys.Date(),"-data"),
               exportOptions = list(
                 modifier = list(page = "all")
               )
          )
        )
      )
    )
  })

}

shinyApp(ui, server)
