# penguin plot in shiny app
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(patchwork)
library(glue)

pretty_penguin_axis <-
  c("Bill length [mm]" = "bill_length_mm",
    "Bill depth [mm]" = "bill_depth_mm",
    "Flipper length [mm]" = "flipper_length_mm",
    "Body mass [g]" = "body_mass_g")
pretty_penguin_colors <-
  c("Species" = "species",
    "Sex" = "sex",
    "Island" = "island")

ui <- fluidPage(
  titlePanel("Interactive Palmer Penguins size plot"),
  sidebarLayout(
    sidebarPanel(
      # select x axis
      selectInput(inputId = "xaxis",
                  label = "Choose x-axis:",
                  choices = pretty_penguin_axis,
                  selected = pretty_penguin_axis[1]),
      # select y axis
      selectInput(inputId = "yaxis",
                  label = "Choose a y-axis:",
                  choices = pretty_penguin_axis,
                  selected = pretty_penguin_axis[2]),
      # add color by?
      selectInput(inputId = "colorby",
                  label = "Color data points?",
                  choices = pretty_penguin_colors),
      # Select whether to overlay smooth trend line
      checkboxInput(inputId = "smooth",
                    label = strong("Add regression lines"),
                    value = FALSE),
    ),
    mainPanel(
      plotOutput("penguins_plot")
    )
  )
)
server <- function(input, output) {
  output$penguins_plot <- renderPlot({
    x_name <- names(pretty_penguin_axis[pretty_penguin_axis == input$xaxis])
    y_name <- names(pretty_penguin_axis[pretty_penguin_axis == input$yaxis])
    plt_all <-
      penguins %>%
      ggplot(aes_string(x = input$xaxis, y = input$yaxis)) +
      geom_point() +
      {if (input$smooth) geom_smooth(se = FALSE, method = "lm", formula = "y ~ x")} +
      labs(x = x_name,
           y = y_name) +
      theme_classic() +
      theme(legend.position = "bottom") +
      scale_color_viridis_d()
    plt <-
      penguins %>%
      ggplot(aes_string(x = input$xaxis, y = input$yaxis,
                        color = input$colorby)) +
      geom_point() +
      {if (input$smooth) geom_smooth(se = FALSE, method = "lm", formula = "y ~ x")} +
      labs(x = x_name,
           y = y_name,
           color = names(pretty_penguin_colors[pretty_penguin_colors == input$colorby]))+
      theme_classic() +
      theme(legend.position = "bottom") +
      scale_color_viridis_d()
    plt_all + plt +
      plot_annotation(title = "Palmer Penguins size",
                      subtitle = glue("{x_name} and {y_name} for {glue_collapse(sort(unique(penguins$species)), sep = ', ', last = ' and ')} Penguins."))
  })
}
shinyApp(ui, server)