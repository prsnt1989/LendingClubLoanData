#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(gmodels)
library(DT)
library(shinythemes)
library(rsconnect)
library(dplyr)




source("loading_data.R")



# Define UI for application that plots features of movies 
ui <- fluidPage(
 # theme=shinytheme("cerulean"),
  # Application title
  titlePanel("Loan Data Exploration"),
  h3(tags$i("Prashant Mishra")),
  h3(tags$i(Sys.Date())),
  
  # Sidebar layout with a input and output definitions 
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
     wellPanel(
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("term","grade","sub_grade","emp_title","emp_length","home_ownership","verification_status","issue_d","loan_status","purpose","title","zip_code","addr_state","earliest_cr_line","initial_list_status","last_payment_d","last_credit_pull_d","application_type"), 
                  selected = "grade"),
      selectInput(inputId = "fill", 
                  label = "Fill color by:",
                  choices = c("term","grade","sub_grade","emp_title","emp_length","home_ownership","verification_status","issue_d","loan_status","purpose","title","zip_code","addr_state","earliest_cr_line","initial_list_status","last_payment_d","last_credit_pull_d","application_type"), 
                  selected = "loan_status"),
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("loan_amnt","int_rate","funded_amnt","funded_amnt_inv","installment","annual_inc","dti","delinq_2yrs","inq_last_6mths","open_acc","pub_rec","revol_bal","total_acc","out_prncp","out_prncp_inv","total_pymnt","total_pymnt_inv","total_rec_prncp","total_rec_int","total_rec_late_fee","recoveries","collection_recovery_fee","last_payment_amnt"), 
                  selected = "loan_amnt")
              )
    ),
       
      
  
    
    
    
    # Outputs
    mainPanel(
      
        
        #actionButton(inputId = "button", 
        #             label = "Show",value=TRUE)
      tabsetPanel(type="tabs",
                  tabPanel("barplot_data",
                           h3("Barplot of X-axis variable, color filled by variable chosen in the side panel"),
                           br(),
                           plotOutput(outputId = "barplot",click = "barplot_click")),
                           
                  tabPanel("scaled_barplot",
                           h3("Scaled Bar plot of X-axis variable, color filled by variable chosen in the side panel"),
                           br(),
                           plotOutput(outputId = "scaledbarplot",click = "scaledbarplot_click")),
                  tabPanel("boxplot",
                           h3("Box plot between X-axis and Y-axis variables, color filled with the variable chosen in the side bar panel."),
                           br(),
                           plotOutput(outputId = "boxplot",click = "boxplot_click")),
                  tabPanel("crosstab",
                           h3("CrossTab values of X-axis data with Class variable."),
                           br(),
                           verbatimTextOutput(outputId = "crosstab")),
                  tabPanel("fulldata",
                           h3("Full Data"),
                           br(),
                           DT::dataTableOutput(outputId="showfulldata"))
))))

# Define server function required to create the scatterplot
server <- function(input, output) {
  # Create scatterplot object the plotOutput function is expecting
  output$barplot <- renderPlot({
   # if(input$show_barplot){
      ggplot(data = loan_data, aes_string(x = input$x, fill = input$fill)) +
        geom_bar()+labs(title = paste0("Counts of each category of ",input$x," color coded by ",input$fill," for each grade."))+theme(axis.text.x = element_text(angle = 90, hjust = 1))
  #  }
    })
  output$scaledbarplot <- renderPlot({
  #  if(input$show_scaledbarplot){
    ggplot(data = loan_data, aes_string(x = input$x, fill = input$fill)) +
      geom_bar(position = "fill") + ylab("proportion")+labs(title = paste0("Proportional count of each category of ",input$x," color coded by ",input$fill," for each grade"))+theme(axis.text.x = element_text(angle = 90, hjust = 1))
  #  }
  })
  output$boxplot <- renderPlot({
  #  if(input$show_boxplot){
    ggplot(data = loan_data, aes_string(x = input$x, y = input$y, color=input$fill)) +
      geom_boxplot() +labs(title = paste0("Distribution of ",input$y," in each category of ",input$x," for each grade, color coded with ",input$fill))+theme(axis.text.x = element_text(angle = 90, hjust = 1))
  #  }
  })
  

  
  output$showfulldata <- DT::renderDataTable({
    
    DT::datatable(data = loan_data, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
  output$crosstab <- renderPrint({
  #  if(input$show_crosstab){
      x <- loan_data[[input$x]]
      y <- loan_data[["grade"]]
      ct <- CrossTable(x,y)
      print(ct, digits = 3, signif.stars = FALSE)
   # }
  })
}


# Create a Shiny app object
shinyApp(ui = ui, server = server)
