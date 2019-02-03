library(openintro)
library(shiny)
library(DT)

data("countyComplete")
dat <- countyComplete[,c("state","name","pop2000","pop20100",
                         "home_ownership","median_household_income","median_val_owner_occupied",
                         "white","black","asian","hispanic",
                         "foreign_born","foreign_spoken_at_home",
                         "poverty","mean_work_travel"
                         )]

# assuming NA response is zero
dat[is.na(dat)] <- 0

# get list of stats and add "all" at beginning
states <- c("ALL",as.character(unique(dat$state)))

# percentage of population change
dat$popchgpct <- round((dat$pop2010-dat$pop2000)/dat$pop2000*100,2)

# percentage of income over house value
dat$income_housevalue_pct <- round(dat$median_household_income/dat$median_val_owner_occupied*100,2)

# combain other races
dat$other_race <- round(100 - dat$white - dat$black - dat$hispanic - dat$asian, 2)
# census error
dat[dat$other_race < 0, "other_race"] <- 0

# re-order columns
dat <- dat[c(1,2,3,4,16,5,6,7,17,8,9,10,11,18,12,13,14,15)]
# rename columns
colnames(dat) <- c("state","county","population_2000","population_2010","population_change",
                   "home_ownership","median_household_income",
                   "median_house_value","income_to_house_value_percentage",
                   "white","black","asian","hispanic","other_race",
                   "foreign_born","foreign_language_spoken_at_home",
                   "mean_work_travel_distance","poverty"
                  )

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
