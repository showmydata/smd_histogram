# Histogram
library(shiny)
library(tidyverse)
library(ggridges)
library(ggthemes)
library(gsheet)

source("functions/process_pasted_data.R")
source("functions/isolate_complete_pairs.R")
source("functions/jitter_by_percent_min_wn.R")
source("functions/make_url.R") 
source("functions/parse_url.R") 
source("functions/add_data_link_to_url.R")
source("functions/get_data_from_url.R")


shinyServer( # Initiate the shiny server
  function(input, output, session) { # Create the function -- added 'session' for URL project 3/22/24
    
# Re-render UI with user-specified height and width
  output$ui_plot <- renderUI({plotOutput("contents", width = input$plotwidth*8, height = input$plotheight*8)})
  
# Run function that makes the plot
  output$contents <- renderPlot( {
    
# Process any pasted data
    if(input$myData>"") {
      # Next 3 lines added 8/15/23
      v=unlist(strsplit(input$myData,"\n")); v=unlist(strsplit(v[1],"\t")); # Read 'header' exactly, regardless of characters
      if(!all(is.na(as.numeric(v)))) for (i in 1:length(v)) v[i]=paste("column ",i); # If 'header' has any numbers (is not all words), replace with "column i"
      d0=gsub(",","",input$myData); d0=gsub("'","",d0); d0=gsub("‘","",d0); d0=gsub("’","",d0); d0=gsub('"',"",d0); d0=gsub("“","",d0); d0=gsub("”","",d0) # Replace various characters that produce errors
      for (i in 1:length(v)) { vv=v[i]; # For each variable label
      if (nchar(vv)>20) { # If the variable label is >20 length, add a carriage return at the last space before the 20th character
        b=unlist(gregexpr(' ', vv)); c=max(b[b<20]); vv=paste(substr(vv,1,c-1), "\n", substr(vv,c+1,nchar(vv)), sep=""); v[i]=vv
      }}
      
      t <- read.table(text = d0, sep = '\t', header = TRUE)
    } else {
      t=iris[, 1:4]; v=colnames(t); v=gsub("\\.", " ", as.character(v))
      t=get_data_from_url(t,session,input$datalink); v=colnames(t)
    }
    t=as.data.frame(t); 
# Get variable labels input by user
    if(input$variablelabels=="") colnames(t)=v 
    else {
      rng=input$variablelabels
      rng=unlist(strsplit(rng,","))
      if (length(rng) < length(v)) {
        rng2=rng
        rng2[(length(rng)+1):length(v)]=v[(length(rng)+1):length(v)]
      } 
      else {
        rng2=rng[1:length(v)]
      }
      if (length(unique(rng))<length(rng)) rng2=colnames(t)
      v=rng2
      colnames(t)=v 
    }
# Deal with reshaping and specifying factors for one (vector) vs. multiple (matrix) columns
    if (length(t)==1) { # If there is only one column of data
      t1=cbind(v[1],t) # Take the name of that column and make the first column contain only that name
      t1[,1]=as.factor(t1[,1]); # Make the first column a "factor"
      t1[,2]=as.numeric(t1[,2]); # Make sure the column of data is numeric
      t3=as.data.frame(t1) # Convert what we have now into a data frame
    } else {
      t3=gather(t) # Takes multiple columns and stacks them into a single column with a new variable that lists variable names next to each data value
      t3[,1]=as.factor(t3[,1]) # Makes the first column a "factor"
    }
    colnames(t3)=c("y","x") # Label new columns as y for factor and x for numeric data
    t3$y <- factor(t3$y, levels = v) # Reorders factors to their original orders
    t3$y = fct_rev(t3$y)
# Jitter the data
    t3[,2]=jitter_by_percent_min_wn(data=t3[,2],perc_jitter=input$jitter_perc)
# Fix bandwidth & hist height
    if (length(t)==1) scale=input$histheight*sd(t3[,2],na.rm=TRUE)/50 else scale=input$histheight*.75/50
    if (length(t)==1) {smoothness=input$smoothness*sd(t3[,2],na.rm=TRUE)/50} else smoothness=input$smoothness*sd(t3[,2],na.rm=TRUE)/250
    #if (is.na(as.numeric(input$histheight))) {scale=.75; if (length(t)==1) scale=sd(t3[,2])} else scale=as.numeric(input$histheight)
    #if (is.na(as.numeric(input$smoothness))) smoothness=NULL else smoothness=as.numeric(input$smoothness)
# Plot after grabbing histogram density and dot type from ui
#    if (length(t)==1) scale=input$histheight else scale=input$histheight/100
    dottype=as.numeric(input$dottype)
      pl = ggplot(t3, aes(x=x, y=y, height=..density..)) +
        # geom_dotplot(binwidth = 1, dotsize = input$histdensity/nrow(t), method = 'histodot') +
        geom_density_ridges(jittered_points = TRUE,
                            alpha = input$histopacity/100, 
                            point_shape = dottype, point_size=input$dotsize/10, point_alpha=input$dotopacity/100,
                            quantile_lines = input$quantiles, linewidth = 1, vline_color = "blue",
                            position = position_raincloud(adjust_vlines = input$move), scale=scale, bandwidth = smoothness) +
        theme_base() + 
        theme_ridges(font_size=(input$ticklabelsize+30)/3) +
        theme(axis.title.x=element_blank(), axis.title.y=element_blank(),
              plot.title = element_text(size=35,hjust=.5),
              text = element_text(size=1)) +
        ggtitle(input$graphtitle)
    if(input$xaxisrange=="") {} else {rng=input$xaxisrange; rng=unlist(strsplit(rng,",")); rng=as.numeric(rng); cat(rng); pl = pl + xlim(rng[1],rng[2])}
      pl = pl + theme(text = element_text(family = "Helvetica"))
    print(pl)

# Old version
#    hist(t, breaks=input$bins, main=input$graphtitle, xlab=input$xlabel, ylab=input$ylabel)
    
# Ultimately want to use something like stroke = 0 to allow dots to be as small as one wants
    # df <- data.frame(x=1:10000, y=runif(n))
    # pl <- ggplot(df) + geom_point(aes(x,y), size=2, shape=16, stroke = 0); pl
    # print(pl)
    # ...e.g. consider using "layer" to create the dots

# Save as 'filename' the 'content'
    output$down <- downloadHandler(
      filename =  function() {
        paste("myplot", input$filetype, sep=".")
      },
      # content is a function with argument file. content writes the plot to the device
      content = function(file) {
        if(input$filetype == "png")
          png(file, units="in", width=input$plotwidth/10, height=input$plotheight/10, res=500) # make png file
        else
          pdf(file, width=input$plotwidth/10, height=input$plotheight/10) # open the pdf device
        print(pl)
        dev.off()  # turn the device off
      })
  })
  
  # Get link, Make link, Add URL
  observe({ urlstring=session$clientData$url_search; if (urlstring!="") session <- parse_url(urlstring, session) }) # updates session
  
  observe({
    settings=reactiveValuesToList(input);
    theurl=make_url(settings, get_all=FALSE, 
                    datalink=input$datalink, 
                    appurl="https://showmydata.shinyapps.io/histogram"); 
    theurl=gsub("\\n","\n",theurl,fixed=TRUE); theurl=gsub("\n","newline",theurl,fixed=TRUE); 
    output$clip <- renderUI({ rclipButton(inputId = "clipbtn", icon = icon("clipboard"), 
                                          label = "Copy link with current settings", 
                                          clipText = theurl)}) 
  })
  
  
  })
  