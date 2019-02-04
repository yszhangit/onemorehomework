library(shiny)
library(DT)

dat <- readRDS('us_counties.rds')

# FIPS not needed in this app, will be used in maps
dat <- subset(dat, select= -c(FIPS))
# get list of stats and add "all" at beginning
states <- c("ALL",as.character(unique(dat$state)))

ui <- fluidPage(
  title="US Census By Counties 2010",
 
  h1("US census by counties", align = "center"), 
  p("Developing Data Products peer-graded assignment", align = "right"),
  p("Yinshu Zhang, Feb. 2nd, 2019",align = "right"),
  hr(),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("state","state",states),
      checkboxGroupInput("show_vars", "column selection",
                           names(dat), 
                           selected = names(dat)[1:5]
                           ),
      numericInput("pop_limit", label=h4("hide counties with populition(2010) less than"), value=100),
      selectInput("hist_var","column histogram",names(dat)[3:length(names(dat))]),
      plotOutput(outputId="hist_plot")
      ),
    mainPanel(
      DT::dataTableOutput("tab_out"),
      includeHTML("doc.html")
    )
  )
)

server <- function(input,output) {
  output$tab_out <- DT::renderDataTable(DT::datatable({
    if (input$state == "ALL") {
      data <- dat[dat$population_2010>input$pop_limit,input$show_vars]
    }else{
      data <- dat[dat$population_2010>input$pop_limit & dat$state == input$state,input$show_vars]
    }
  }, rownames = F)
  )
  

  output$hist_plot <- renderPlot({
    if (input$state == "ALL") {
      hist_dat <- dat[, input$hist_var] 
      title <- "Country"
    }else{
      hist_dat <- dat[dat$state == input$state,input$hist_var]
      title <- input$state
    }   
    hist(hist_dat, breaks = 15, main = title , xlab = "", col = "#7099DB", border = "white")
  })
}

shinyApp(ui,server)
