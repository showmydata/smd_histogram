# Histogram 
library(shiny)
library("rclipboard") # added for URL project 3/22/24

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  rclipboardSetup(), # added for URL project 3/22/24
  
  # Application title
  titlePanel("Histograms"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      

      # Data input
      textAreaInput("myData", "DATA", "", width = 200, height = 200, placeholder = "[Paste, from spreadsheet, data with non-number labels in top row]"),
      
      # Hacks
      tags$style("input[type='checkbox']:checked+span{font-weight:bold;}"), # hack to get checkboxes to show up bold when unchecked
      tags$style("input[type='checkbox']:not(:checked)+span{font-weight:bold;}"), # hack to get checkboxes to show up bold when unchecked
      tags$style(type = "text/css", ".irs-grid-pol.small {height: 0px;}"), # hack to remove minor ticks on sliders
      
      # Options to select from
      selectInput(inputId="options", label="OPTIONS:",
                  choices=c("*** select ***" = "select",
                            "Manage data point visibility" = "dotvisibility",
                            "Manage histograms" = "histograms",
                            "Manage axes & labels" = "axesdimslabels",
                            "Data import" = "dataimport"),
                  selected = NULL),
      
      
      # Manage plot contents
      #checkboxInput("contents", "Manage plot contents", FALSE),
      #conditionalPanel(condition="input.contents",
       #                hr(style = "margin: 0px 30px 10px 30px; border: .5px solid #a6a6a6"),
                       # Manage data point overlap
                       #checkboxInput("overlap", "Manage datapoint overlap", FALSE),
                       conditionalPanel(condition="input.options=='dotvisibility'",
                                        sliderInput(inputId = "dotsize",
                                                    label = "size",
                                                    min = 0,
                                                    max = 100,
                                                    value = 20),
                                        sliderInput(inputId = "jitter_perc",
                                                    label = "jitter",
                                                    min = 0,
                                                    max = 100,
                                                    value = 0),
                                        sliderInput(inputId = "dotopacity",
                                                    label = "opacity",
                                                    min = 0,
                                                    max = 100,
                                                    value = 100),
                                        radioButtons("dottype", label = "type", choiceNames = list("ring", "dot"), choiceValues = list("1","16"))
                       ),
      # Tweak axes
      conditionalPanel(condition="input.options=='axes'"
       ),
      
                       #hr(style = "margin: 0px 0 10px 0; border: .5px solid #000000"),
                       # Manage other plot contents
                       #checkboxInput("plotfeatures", "Manage histogram overlap", FALSE),
                       conditionalPanel(condition="input.options=='histograms'",
                                        checkboxInput("quantiles", "show quantiles", FALSE),
                                        conditionalPanel(condition="input.quantiles",
                                        checkboxInput("move", "embed quantiles in data", FALSE)
                                        ),
                                        hr(style = "margin: 0px 30px 10px 30px; border: .5px solid #a6a6a6"),
                                        sliderInput(inputId = "histheight",
                                                    label = "histogram height",
                                                    min = 0,
                                                    max = 100,
                                                    value = 50),
                                        sliderInput(inputId = "smoothness",
                                                    label = "histogram smoothness",
                                                    min = 0,
                                                    max = 100,
                                                    value = 50),
                                        sliderInput(inputId = "histopacity",
                                                    label = "histogram opacity",
                                                    min = 0,
                                                    max = 100,
                                                    value = 50),
                                        hr(style = "margin: 0px 30px 10px 30px; border: .5px solid #a6a6a6"),
                                        sliderInput(inputId = "plotheight",
                                                    label = "plot height",
                                                    min = 0,
                                                    max = 300,
                                                    value = 75),
                                        sliderInput(inputId = "plotwidth",
                                                    label = "plot width",
                                                    min = 0,
                                                    max = 300,
                                                    value = 75)
                                        # 
                                        # textInput("histheight", label = "histogram height", width = "75%", placeholder = "[type number]"),
                                        # textInput("smoothness", label = "histogram smoothness", width = "75%", placeholder = "[type number]")
                       ),
                        #hr(style = "margin: 0px 0 10px 0; border: .5px solid #000000"),
                        # Manage other plot contents
                        #checkboxInput("quantilelines", "Manage quantile lines", FALSE),
                        conditionalPanel(condition="input.options=='lines'",
                                         # # radioButtons("whichgraph", label = "type", choices = list("smooth","bars")),
                                         # # conditionalPanel(condition="input.whichgraph=='bars'",
                                         # #                  sliderInput(inputId = "bins",
                                         # #                              label = "number of bars",
                                         # #                              min = 0,
                                         # #                              max = 200,
                                         # #                              value = 30),
                                         # hr(style = "margin: 0px 30px 10px 30px; border: .5px solid #a6a6a6")
                                         # ),
                       ),
      #),
      #hr(style = "margin: 0px 0 10px 0; border: .5px solid #000000"),
      # Manage labels
      #checkboxInput("labels", "Edit labels", FALSE),
      conditionalPanel(condition="input.options=='axesdimslabels'",
                       textInput("xaxisrange", label = "x range", value = "", width = "50%", placeholder = "min,max"),
                       textAreaInput("graphtitle", label = "title", value = "", width = "100%", placeholder = "Use [return] to split title"),
                       # textInput("xlabel", label = "Enter x axis title", width = "75%", placeholder = "[x label]"),
                       # textInput("ylabel", label = "Enter y axis title", width = "75%", placeholder = "[y label]"),
                       textAreaInput("variablelabels", label = "variable labels", value = "", width = "100%", rows = "2", placeholder = "v1,v2,v3... (from bottom; use [return] to split a label"),
                       sliderInput(inputId = "ticklabelsize",
                                   label = "axis text size",
                                   min = 0,
                                   max = 100,
                                   value = 50)
                       ),
      
      # Data import
      conditionalPanel(condition="input.options=='dataimport'",
                       textInput("datalink", 
                                 label = HTML("paste shared google sheets link<h6><strong style='font-weight:normal'>
                                 Linked file must contain <i>only</i> the data you wish to plot, with a top row of column labels, and the rest numbers. Column labels must be text, not numbers.</strong></h6>"), 
                                 value = "", width = "85%", placeholder = "https://docs.google.com/spread...")
      )
      
      
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    uiOutput('ui_plot'),
    tags$h6(HTML(" ")),
    downloadButton(outputId = "down", label = "Download graph as..."),
    radioButtons("filetype", label = NULL, choices = list("png", "pdf")),
    
    # added for URL project 3/22/24
    uiOutput("clip"), 
    tags$h6(HTML(" ")),
    
    hr(style = "margin: 0px 30px 20px 30px; border: .5px solid #a6a6a6"),
    tags$h6("Notes..."),
    tags$h6("1. Quantile lines: drawn at 25th, 50th, and 75th percentiles."),
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }")
    )
  )
))

