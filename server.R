#
# This is the server logic for word prediction application
#

# Defining the required library and loading required data

library(shiny)
library(tm)
library(RWeka)
library(stringr)
load('bigramDic.RData')
load('trigramDic.RData')



# Define server logic required to predict the next word
shinyServer(function(input, output, session) {
  observeEvent(input$submit,{

# Cleanning of the user input to match words library
  clean.text <- renderText({input$textInput})
  clean.text <- clean.text()
  clean.text < gsub("[^\x20-\x7E]", " ", clean.text) # clear non ASCII
  clean.text <- tolower(clean.text) # make lower case
  clean.text <- gsub("[[:punct:]]", " ", clean.text) # clean punctuation
  clean.text <- gsub("[0-9]", " ", clean.text) # remove numbers
  clean.text <- gsub("(\\w)\\1{2, }", " ", clean.text) # remove string repeated more than 3 times
  clean.text <- gsub("[[:space:]]*$","", clean.text, perl = TRUE) # remove space at the end
  input <- clean.text
  
# Word prediction algorithmn  
  twowords <- word(input, -2,-1)
  twowords <- paste("^",twowords,"\\>", sep = "")
    predict.word <- table(grep(twowords, tf.trigram, value = TRUE))
  n <- dim(predict.word)
  
  
  if(n == 1)
  {
    predict.word <- data.frame(predict.word)
    word <- word(predict.word$Var1[1],-1)
  }
  if (n > 1)
  {
    predict.word <- data.frame(predict.word)
    predict.word <- predict.word[order(-predict.word$Freq),]
    word <- word(predict.word$Var1[1:10],-1)
  }
  if (n == 0)
  {
    oneword <- word(input,-1)
    oneword <- paste("^",oneword,"\\>", sep = "")
    predict.word <- table(grep(oneword, tf.bigram, value = TRUE))
    i <- dim(predict.word)
    
    if(i == 1)
    { 
      predict.word <- data.frame(predict.word)
      word <- word(predict.word$Var1[1],-1)
    }
    if(i > 1)
    {
      predict.word <- data.frame(predict.word)
      predict.word <- predict.word[order(-predict.word$Freq),]
      word <- word(predict.word$Var1[1:10],-1)
    }
    if (i ==0 ){word <- c("the","and", "that","for", "you","with", "was", "this", "have", "are")}
  }

# Output of the prediction
  
  word <- na.omit(word)
  a <- length(word)
  output$helpText <- renderText({paste("The top 10 predicted words")})
  output$distText <- renderText({word[1:a]})
  })
  
})
