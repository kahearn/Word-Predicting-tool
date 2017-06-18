#
# This is the user-interface for word prediction application
#

library(shiny)

# Define UI for application
shinyUI(fluidPage(
  # Application title
  titlePanel("Capstone Project: Word Prediction Tool"),
  # Instruction to use the application
  sidebarLayout(
    sidebarPanel(
      h1("Instruction"),
      h2(""),
      h5("1.Type a phrase or a sentence into the textbox provided"),
      h5("2.Click on Submit button"),
      h5("3.The application will predict up to 10 best next word")
    ),
    
    # Main panel of the applicaton
    # Provide text box for user input and output of the next word prediction
    mainPanel(
       textInput("textInput", "Input a sentence to predict the next word", width = '100%'),
       actionButton("submit", "submit"),
       textOutput('helpText'),
       verbatimTextOutput('distText')
       )
  )
))

