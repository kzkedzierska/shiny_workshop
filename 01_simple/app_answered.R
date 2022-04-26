library(shiny)
library(glue)
# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Tabsets"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      radioButtons("dist", "Distribution type:",
                   c("Normal" = "norm",
                     "Uniform" = "unif",
                     "Log-normal" = "lnorm",
                     "Exponential" = "exp")),
      
      # br() element to introduce extra vertical spacing ----
      br(),
      
      # Input: Slider for the number of observations to generate ----
      sliderInput("n",
                  "Number of observations:",
                  value = 500,
                  min = 1,
                  max = 1000),
      
      # Input: Slider for the number of observations to generate ----
      sliderInput("bins",
                  "Number of bins:",
                  value = 30,
                  min = 1,
                  max = 100)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Summary", htmlOutput("summary")),
                  tabPanel("Table", tableOutput("table"))
      )
      
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  d <- reactive({
    dist <- switch(input$dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    dist(input$n)
  })
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n
    bins <- input$bins
    
    hist(d(), breaks = bins,
         main = paste("r", dist, "(", n, ")", sep = ""),
         col = "#75AADB", border = "white")
  })
  
  # Generate a summary of the data ----
  output$summary <- renderText({
    
    summary_vec <- round(summary(d()), 3)
    dist <- input$dist
    
    glue("<h3>The summary of the {dist} distribution.</h3> <br>",
         "All observations fall within the ", 
         "<mark>{summary_vec['Min.']} - {summary_vec['Max.']} range</mark> ", 
         "with mean equal to {summary_vec['Mean']}. ", 
         "<b>Median is equal to {summary_vec['Median']}</b> ",
         "with 1st and 3rd quartiles at {summary_vec['1st Qu.']} ",
         "and {summary_vec['3rd Qu.']}, respectively.")
    
    
  })
  
  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    d()
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)