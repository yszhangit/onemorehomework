library(openintro)
library(shiny)
data("countyComplete")

dat <- countyComplete[,c("state","name","pop2010","pop2000")]

ui <- fluidPage(
  title="US Counties",
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("show_vars", "column toggle",
                           names(dat), 
                           selected = names(dat)
                           )
      ),
    mainPanel(
      DT::dataTableOutput("tab_out")
    )
  )
)

server <- function(input,output) {
  output$tab_out <- DT::renderDataTable(DT::datatable({
    data <- dat
  })
  )
}

shinyApp(ui,server)
