library(shiny)

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Structured and random"),
  
  random_button_ui(id = "rand_dist_button", label = "Select distribution")
)

server <- function(input, output, session) {
  callModule(random_dist_server, "rand_dist_button")
}

shinyApp(ui, server)