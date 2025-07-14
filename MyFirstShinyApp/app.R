# Load Shiny library if not already loaded
library(shiny)

# Define the user interface (UI)

ui <- fluidPage(
  titlePanel("Descriptive Statistics on Uploaded Dataset"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload your dataset (CSV or XLSX)", 
                accept = c(".csv", ".xlsx")),
      
      uiOutput("num_var_ui"),  # Numeric variable
      uiOutput("cat_var_ui"),  # Categorical variable
      
      sliderInput("NbCla", "Number of bins:", min = 2, max = 30, value = 10),
      
      radioButtons("Coul", "Histogram color:",
                   choices = c("Dark Blue" = "blue", "Green" = "green", "Red" = "red"),
                   selected = "green")
    ),
    
    mainPanel(
      verbatimTextOutput("sortie1"),
      plotOutput("sortie2"),
      verbatimTextOutput("cat_table")
    )
  )
)

# Call shinyUI with the UI object
shinyUI(ui)

# Define server logic

library(readr)
library(readxl)

server <- function(input, output, session) {
  
  # Load dataset (.csv or .xlsx)
  dataset <- reactive({
    req(input$file)
    ext <- tools::file_ext(input$file$name)
    
    switch(ext,
           "csv" = read_csv(input$file$datapath),
           "xlsx" = read_excel(input$file$datapath),
           stop("Unsupported file type")
    )
  })
  
  # Detect numeric and categorical variables
  observeEvent(dataset(), {
    df <- dataset()
    
    num_vars <- names(df)[sapply(df, is.numeric)]
    cat_vars <- names(df)[sapply(df, function(x) is.character(x) || is.factor(x))]
    
    # Update numeric variable input
    output$num_var_ui <- renderUI({
      if (length(num_vars) > 0) {
        selectInput("VarName", "Choose a numeric variable:", 
                    choices = num_vars, selected = num_vars[1])
      } else {
        helpText("No numeric variable found.")
      }
    })
    
    # Update categorical variable input
    output$cat_var_ui <- renderUI({
      if (length(cat_vars) > 0) {
        selectInput("CatVar", "Choose a categorical variable:", 
                    choices = cat_vars, selected = cat_vars[1])
      } else {
        helpText("No categorical variable found.")
      }
    })
  })
  
  # Median display
  output$sortie1 <- renderPrint({
    req(input$VarName)
    paste("The median is", median(dataset()[[input$VarName]], na.rm = TRUE))
  })
  
  # Histogram
  output$sortie2 <- renderPlot({
    req(input$VarName)
    x <- dataset()[[input$VarName]]
    Classes <- seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = input$NbCla + 1)
    
    hist(x,
         breaks = Classes,
         freq = FALSE,
         col = input$Coul,
         main = paste("Histogram of", input$VarName),
         xlab = input$VarName)
  })
  
  # Table of frequencies for categorical variable
  output$cat_table <- renderPrint({
    req(input$CatVar)
    var <- dataset()[[input$CatVar]]
    freq <- prop.table(table(var)) * 100
    round(freq, 2)
  })
}

# Wrap the server function
shinyServer(server)

shinyApp(ui = ui, server = server)