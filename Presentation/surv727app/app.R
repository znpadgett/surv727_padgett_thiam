

library(shiny)
library(rsconnect)
library(dplyr)
library(ggplot2)
library(repmis)


source_data("https://github.com/znpadgett/surv727_padgett_thiam/blob/master/Data/app_data.RData?raw=true")


# Define UI

ui <- fluidPage(
    
    # Application title
    titlePanel("2020 Democratic Primary Candidate Data"),
    
    # Sidebar with a dropdown
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "Candidate",                   
                        label = "Candidate",                  
                        choices = c("Joe Biden", "Pete Buttigieg", "Kamala Harris", 
                                    "Bernie Sanders", "Elizabeth Warren"),                   
                        selected = "Joe Biden"),
            selectInput(inputId = "Data",
                        label = "Data Type",
                        choices = c("Polling", "GTrends", "Twitter"),
                        selected = "Polling")
        ),
        
        # Show plot
        mainPanel(
            plotOutput(outputId = "graph")      
        )
    )
)

# Define server logic
server <- function(input, output) {
    
    output$graph <- renderPlot({
        all_data %>%
            filter(Candidate == input$Candidate, Data == input$Data) %>%
            ggplot() +
            geom_col(mapping = aes(x=Pre_post, y=Percentage, fill=input$Candidate)) +
            ylim(0,100) +
            xlab("Timeframe") + ylab("Percentage") +
            theme(legend.position = "none")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)