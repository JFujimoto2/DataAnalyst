library(shiny)
library(ggplot2)
library(tidyverse)
bcl <- read.csv("bcl-data.csv")
#bcl
ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("price", 
                  label = "price", pre = ("$"),
                  min =0, max = 100, value = c(25, 40)),
      radioButtons("product", h3("Product type"),
                   choices = list("BEER", "REFRESHMENT",
                                  "SPIRITS", "WINE")),
      selectInput("var", 
                  label = "Country",
                  choices = bcl$Country,
                  selected = 1
      )
    ),
    mainPanel(
      plotOutput("bar_plot"),
      tableOutput("chart")
    )
  )
)

server <- function(input, output) {
  
  output$bar_plot <- renderPlot({
    temp <- subset(bcl, Country == input$var 
                   & Type == input$product
                   & Price >= input$price[1]
                   & Price <= input$price[2]
    )
    
    ggplot(temp, aes(x = Alcohol_Content)) + geom_histogram()
  })
  output$chart <- renderTable({
    subset(bcl, Country == input$var 
           & Type == input$product
           & Price >= input$price[1]
           & Price <= input$price[2]
    )
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)