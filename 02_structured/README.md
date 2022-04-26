Structured app
================

Typical directory structure of an app.

``` bash
app_name
├── app.R
├── DESCRIPTION
├── R/
├── README
└── www/
```

# Directory

`app_name` is the name of the directory and app name. To run the app you
can run the following command in the console.

``` r
shiny::runApp("path/to/app_name")
```

# `app.R`

Inside that directory has to be the only required file - `app.R`. For
example it will have the following content.

``` r
library(shiny)

ui <- fluidPage(
  counterButton("counter1", "Counter #1")
)

server <- function(input, output, session) {
  callModule(counter, "counter1")
}

shinyApp(ui, server)
```

We are calling a `counter` module and `counterButton` that are not
specified in the `app.R` file. That’s because they are defined
`counter.R` file in the `R` sub directory. Note that we don’t have to
`source("R/counter.R")` file.

# `R/`

The `R` directory contains the files that will be sourced, without you
having to source them, when your app starts.

> As of Shiny version 1.3.2.9001, any .R files found in an R/ directory
> adjacent to your app will be automatically loaded when your app
> starts. Just like R packages, only the files at the top level of R/
> are considered; nested directories are ignored. Files in this
> directory are sourced in alphabetical order and any variables,
> functions, or modules they create are available to be used in your
> app.R, ui.R, or server.R files.

From [here](https://shiny.rstudio.com/articles/app-formats.html)

As mentioned above, in our example we have `counter.R` file in the `R`
sub directory in which we define `counter` module and `counterButton`.

``` r
counterButton <- function(id, label = "Counter") {
  ns <- NS(id)
  tagList(
    actionButton(ns("button"), label = label),
    verbatimTextOutput(ns("out"))
  )
}

counter <- function(input, output, session) {
  count <- reactiveVal(0)
  observeEvent(input$button, {
    count(count() + 1)
  })
  output$out <- renderText({
    count()
  })
  count
}
```

# `README` and `DESCRIPTION`

However it is a good practice to contain those, they are not required.

# `www`

This is an optional directory to share with a browser. Can contain
images, css and java script files to extend and customise the Shiny app.
