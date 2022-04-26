distributions <-
  c("Normal" = "norm",
    "Uniform" = "unif",
    "Log-normal" = "lnorm",
    "Exponential" = "exp")


random_button_ui <- function(id, label = "Regenerate") {
  ns <- NS(id)
  tagList(
    actionButton(ns("button"), label = label),
    br(),
    textOutput(ns("out")),
    br(),
    # Input: Slider for the number of observations to generate ----
    sliderInput(ns("n"),
                "Number of observations:",
                value = 500,
                min = 1,
                max = 1000),
    
    # Input: Slider for the number of observations to generate ----
    sliderInput(ns("bins"),
                "Number of bins:",
                value = 30,
                min = 1,
                max = 100),
    
    tabsetPanel(type = "tabs",
                tabPanel("Plot", plotOutput(ns("plot"))),
                tabPanel("Summary", htmlOutput(ns("summary"))),
                tabPanel("Table", tableOutput(ns("table"))))
  )
}

random_dist_server <- function(input, output, session) {
  
  random_dist <- reactiveVal(distributions[1])
  
  observeEvent(input$button, {
    random_dist(sample(distributions, 1))
  })
  
  d <- reactive({
    dist <- switch(random_dist(),
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    dist(input$n)
    })
  
  output$out <- renderText({
    paste0("Chosen distribution: ", names(random_dist()))
  })
  
  output$plot <- renderPlot({
    dist <- names(random_dist())
    n <- input$n
    bins <- input$bins
    
    hist(d(), breaks = bins,
         main = paste(dist, " (", n, ")", sep = ""),
         col = "#75AADB", border = "white")
  })
  
  # Generate a summary of the data ----
  output$summary <- renderText({
    
    summary_vec <- round(summary(d()), 3)
    dist <- names(random_dist())
    
    glue::glue("<h3>The summary of the {dist} distribution.</h3> <br>",
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
  
  random_dist
}
