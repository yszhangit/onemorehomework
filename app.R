library(openintro)
library(shiny)
library(DT)

data("countyComplete")
dat <- countyComplete[,c("state","name","pop2010","pop2000",
                         "foreign_born","foreign_spoken_at_home",
                         "home_ownership","median_household_income",
                         "poverty","mean_work_travel","median_val_owner_occupied")]
states <- c("ALL",as.character(unique(dat$state)))
dat$popchgpct <- round((dat$pop2010-dat$pop2000)/dat$pop2000*100,2)
dat$income_housevalue_pct <- round(dat$median_household_income/dat$median_val_owner_occupied*100,2)

ui <- fluidPage(
  title="US Census By Counties 2010",
  
  sidebarLayout(
    sidebarPanel(
      selectInput("state","state",states),
      checkboxGroupInput("show_vars", "column toggle",
                           names(dat), 
                           selected = names(dat)
                           ),
      selectInput("hist_var","histogram",names(dat)[3:length(names(dat))]),
      plotOutput(outputId="hist_plot")
      ),
    mainPanel(
      DT::dataTableOutput("tab_out")
    )
  )
)

server <- function(input,output) {
  output$tab_out <- DT::renderDataTable(DT::datatable({
    if (input$state == "ALL") {
      data <- dat[,input$show_vars]
    }else{
      data <- dat[dat$state == input$state,input$show_vars]
    }
  }, rownames = F)
  )
  

  output$hist_plot <- renderPlot({
    if (input$state == "ALL") {
      hist_dat <- dat[, input$hist_var]
    }else{
      hist_dat <- dat[dat$state == input$state,input$hist_var]
    }   
    hist(hist_dat, breaks = 15, main = input$hist_var)
  })
}

shinyApp(ui,server)
