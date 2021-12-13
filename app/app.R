## Shiny Server Config Section ## ------------

# .libPaths(new = c("/mnt/home/niranjan.ilawe/R/x86_64-conda_cos6-linux-gnu-library/3.6",
#                   "/mnt/opt/R/R-3.6.1-conda-openblas/R-library",
#                   "/mnt/opt/R/R-3.6.1-conda-openblas/env/lib/R/library"))
#
# options(shiny.usecairo = FALSE)
#
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/clean_plate_df.R")
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/join_sequence_files.R")
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/pass_by_matches.R")
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/read_csv_file.R")
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/pass_by_volume.R")
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/pass_by_conc.R")
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/clean_idt_coa_file.R")
# source("/mnt/home/niranjan.ilawe/ShinyApps/IDT.CoA.Checker/R/clean_idt_order_file.R")

## End of Shiny Server Config ----------

## Package Dev Path for Personal Development ## -------

source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/clean_plate_df.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/join_sequence_files.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/pass_by_matches.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/read_csv_file.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/pass_by_volume.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/pass_by_conc.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/clean_idt_coa_file.R")
source("/Users/niranjan.ilawe/Documents/GitHub/IDT.CoA.Checker/R/clean_idt_order_file.R")

## End of Package Dev Config ------------

library(shinydashboard)
library(shiny)
library(shinyalert)
library(DT)


ui <- dashboardPage(
  dashboardHeader(title = "IDT CoA Checker"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Checker", tabName = "checker", icon = icon("dashboard")),
      menuItem("Clean CoA File", tabName = "coa_creator", icon = icon("th")),
      menuItem("Clean Order File", tabName = "order_creator", icon = icon("th"),badgeLabel = "new", badgeColor = "green")
    )
  ),
  dashboardBody(
    tabItems(

      # First tab content
      tabItem(tabName = "checker",
              fluidRow(
                box(width = 3,
                  fileInput("coa_file", "Upload CoA File (csv)",
                            multiple = FALSE,
                            accept = c(".csv")),
                  fileInput("order_file", "Upload Order File (csv)",
                            multiple = FALSE,
                            accept = c(".csv")),
                  actionButton("check_coa", "Check")
                ),
                box(width = 9,
                  infoBoxOutput("coa_cnt_box"),
                  infoBoxOutput("order_cnt_box"),
                  infoBoxOutput("no_of_matches"),
                  infoBoxOutput("seq_fail_box"),
                  infoBoxOutput("vol_fail_box"),
                  infoBoxOutput("conc_fail_box")
                )
              ),
              fluidRow(
                box(width = NULL,
                    collapsible = TRUE,
                    div(style = 'overflow-y: scroll', DT::dataTableOutput('summary_tbl'))
                )
              )
      ),

      # Second tab content
      tabItem(tabName = "coa_creator",
              fluidRow(
                box(width = 3,
                    fileInput("raw_coa_file", "Upload Raw CoA File (csv or xlsx)",
                              multiple = FALSE,
                              accept = c(".csv", ".xlsx"))
                ),
                box(width = 6,
                    h5("Filters Applied"),
                    verbatimTextOutput('filter_list')
                )
              ),
              fluidRow(
                box(width = 3,
                  selectInput("file_col",
                              label = "Choose columns to Filter By",
                              choices = c()),
                    selectInput("filter_value",
                                label = "Choose values to Filter",
                                choices = c()),
                    actionButton("add_to_filter", "Add to Filter"),
                    actionButton("create_coa_file", "View Filtered Data"),
                    h4(""),
                    downloadButton("dl_clean_coa", "Download Filtered File")
                    #h6("Only columns 'plate_name', 'well_position', 'sequence', and 'sequence_name' will be downloaded")
                ),
                box(width = 9,
                    useShinyalert(),
                    h5("Filtered Data"),
                    div(style = 'overflow-y: scroll', DT::dataTableOutput('clean_coa_file'))
                )
              )
      ),

      # Third tab
      tabItem(tabName = "order_creator",
        fluidRow(
          box(width = 3,
            fileInput("raw_order_file", "Upload Raw Order File (xlsx)",
                      multiple = FALSE,
                      accept = c(".xlsx")),
            selectInput("sheet_name",
                        label = "Choose Sheet Name",
                        choices = c()),
            actionButton("create_order_file", "View Order Data"),
            h4(""),
            downloadButton("dl_clean_order", "Download Clean File")
          ),
          box(width = 9,
            collapsible = TRUE,
            div(style = 'overflow-y: scroll', DT::dataTableOutput('clean_order_file'))
          )
        )
      )
    )
  )
)

server <- function(input, output) {

  ### PAGE 1 START ----------- CHECKER -------------------

  #Filter List
  filterList <- reactiveValues()

  # read CoA File and Order File
  file_data <- eventReactive(input$check_coa, {

    coa_df <- read_csv_file(input$coa_file$datapath)
    if(is.null(coa_df)){
      shinyalert("Oops!", "Could not find columns named 'plate_name', 'sequence_name', 'well_position', 'sequence' in the CoA file", type = "error")
    }
    order_df <- read_csv_file(input$order_file$datapath)
    if(is.null(order_df)){
      shinyalert("Oops!", "Could not find columns named 'plate_name', 'sequence_name', 'well_position', 'sequence' in the Order file", type = "error")
    }

    list(coa_df = coa_df, order_df = order_df)
  })

  # create join from CoA and Order DFs
  joined_df <- reactive(
    df <- join_sequence_files(coa_df = file_data()[['coa_df']],
                              order_df = file_data()[['order_df']])
  )

  output$coa_cnt_box <- renderInfoBox({
    infoBox(
      "# CoA Sequences", paste0(nrow(file_data()[['coa_df']])), icon = icon("list"),
      color = "light-blue", fill = TRUE
    )
  })
  output$order_cnt_box <- renderInfoBox({
    infoBox(
      "# Order Sequences", paste0(nrow(file_data()[['order_df']])), icon = icon("list"),
      color = "light-blue", fill = TRUE
    )
  })
  output$no_of_matches <- renderInfoBox({
    infoBox(
      "# Matches", paste0(sum(joined_df()[['seq_match']], na.rm = TRUE)), icon = icon("list"),
      color = "navy", fill = TRUE
    )
  })
  output$seq_fail_box <- renderInfoBox({
    if(pass_by_matches(joined_df())){
      infoBox(
        "Sequences Pass", color = "green", fill = TRUE, icon = icon("thumbs-up", lib = "glyphicon"),
      )
    } else {
      infoBox(
        "Sequences Fail", color = "red", fill = TRUE, icon = icon("thumbs-down", lib = "glyphicon"),
      )
    }
  })
  output$vol_fail_box <- renderInfoBox({
    if(pass_by_volume(joined_df())){
      infoBox(
        "Volumes Pass", color = "green", fill = TRUE, icon = icon("thumbs-up", lib = "glyphicon"),
      )
    } else {
      infoBox(
        "Volumes Fail", color = "red", fill = TRUE, icon = icon("thumbs-down", lib = "glyphicon"),
      )
    }
  })
  output$conc_fail_box <- renderInfoBox({
    if(pass_by_conc(joined_df())){
      infoBox(
        "Concentrations Pass", color = "green", fill = TRUE, icon = icon("thumbs-up", lib = "glyphicon"),
      )
    } else {
      infoBox(
        "Concentrations Fail", color = "red", fill = TRUE, icon = icon("thumbs-down", lib = "glyphicon"),
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

  ### PAGE 2 START ----------- COA CLEANER -------------------


  #clean CoA dataframe
  coa <- reactiveValues(df_data = NULL)

  # Create Clean CoA File
  observeEvent(input$create_coa_file, {
    tmp_df <- data()
    for (i in 1:length(filterList$col)) {
      tmp_df <- tmp_df %>% dplyr::filter(!!as.name(filterList$col[i]) == filterList$val[i])
    }
    coa$df_data <- tmp_df
  })

  # Read Raw CoA File
  data <- reactive({
    req(input$raw_coa_file)

    file_contents <- clean_idt_coa_file(input$raw_coa_file$datapath)

    if(is.null(file_contents)){
      shinyalert("Oops!", "Could not find columns named 'plate_name', 'sequence_name', 'well_position', 'sequence'", type = "error")
    }

    file_contents
  })

  # Get Column list to populate selection Box
  observe({
    col_names <- colnames(data())
    updateSelectInput(inputId = "file_col",
                      choices = col_names)
  })

  # Populate filter values selection box
  observe({
    req(input$file_col)

    values <- data() %>%
      dplyr::select(!!as.name(input$file_col)) %>%
      dplyr::distinct() %>%
      dplyr::pull()

    updateSelectInput(inputId = "filter_value",
                      choices = values)
  })

  # Add filters to filter list
  observeEvent(input$add_to_filter, {
    #filter <- glue::glue("{input$file_col} == '{input$filter_value}'")
    #filter <- glue::glue("tmp_df <- dplyr::filter(tmp_df, {input$file_col} == '{input$filter_value}')")
    filterList$col <- c(isolate(filterList$col), isolate(input$file_col))
    filterList$val <- c(isolate(filterList$val), isolate(input$filter_value))
  })

  # Output filters to text Output
  output$filter_list<-renderPrint({
    for (i in 1:length(filterList$col)) {
     print(glue::glue("{filterList$col[i]} == {filterList$val[i]}"))
    }
  })

  # Output clean CoA file to table
  output$clean_coa_file <- renderDT(coa$df_data, extensions = 'Buttons', selection = 'single', options = list(
    autoWidth = TRUE,
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))

  # Download Clean COA file
  output$dl_clean_coa <- downloadHandler(
    filename = function() {
      paste("clean_coa_", Sys.time(), '.csv', sep='')
    },
    content = function(con) {
      readr::write_csv(coa$df_data, con)
    }
  )

  ### PAGE 3 START ----------- ORDER CLEANER -------------------

  #clean Order dataframe
  order <- reactiveValues(df_data = NULL)

  # Get sheet name list to populate selection Box
  observe({
    req(input$raw_order_file)

    sheet_names <- readxl::excel_sheets(input$raw_order_file$datapath)
    updateSelectInput(inputId = "sheet_name",
                      choices = sheet_names)
  })

  # Create Clean Order File
  observeEvent(input$create_order_file, {
    req(input$raw_order_file)

    order$df_data <- clean_idt_order_file(input$raw_order_file$datapath, input$sheet_name)

  })

  # Populate clean order data in table
  output$clean_order_file <- renderDT(order$df_data, extensions = 'Buttons', selection = 'single', options = list(
    autoWidth = TRUE,
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))

  # Download Clean Order file
  output$dl_clean_order <- downloadHandler(
    filename = function() {
      paste("clean_order_", Sys.time(), '.csv', sep='')
    },
    content = function(con) {
      readr::write_csv(order$df_data, con)
    }
  )

}

shinyApp(ui, server)
