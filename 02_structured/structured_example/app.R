library(shiny)

ui <- fluidPage(
  counterButton("counter1", "Counter #1"),
  counterButton("counter2", "Counter #2")
)

server <- function(input, output, session) {
  callModule(counter, "counter1")
  callModule(counter, "counter2")
}

shinyApp(ui, server)