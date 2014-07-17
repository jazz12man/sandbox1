titles.data = data.frame(titles=c("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"),
                         vals1 = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16),
                         vals2 = c(10,12,34,23,12,35,34,86,34,56,23,54,12,45,76,12),stringsAsFactors=F)

input.vals = data.frame(titles=c("aa","bb","cc","dd"),
                        vals1=c(1,5,8,11),
                        vals2=c(23,56,23,65),stringsAsFactors=F)

shinyServer(function(input, output, session) {
  
  createObjectsTable = reactive({
    data.frame(a=1:10,b=input$start.val:(input$start.val+9))
    
  })
  
  output$ui_title = renderUI({selectInput("title","Select Title",input.vals$titles)})
  output$ui_comptitle = renderUI({
    if(!is.null(values)) {
      selectInput("comptitle","Select Title",titles.data$titles,dist()[as.numeric(values$PopRow),"titles"])
    }
  })
  
  
  output$drag_try = renderText({
    c(paste("<ul>",
            paste("<li>",titles.data$titles,"</li>"),
            "</ul>"),
      '<div id="cart">
       <h1 class="ui-widget-header">Shopping Cart</h1>
       <div class="ui-widget-content">
       <ol>
       <li class="placeholder">Add your items here</li>
       </ol>
       </div>
       </div>'
      )
    
    
  })
  
  dist = reactive({
    data.in = input.vals[input.vals$title==input$title,]
    dist = (data.in$vals1 - titles.data$vals1)^2 +
      (data.in$vals1 - titles.data$vals2)^2
    names(dist) = titles.data$titles
    dist = dist[order(dist)]
    data.out = titles.data[match(names(dist),titles.data$titles),][1:8,]
    return(data.out)
  })
  
  output$comp_table = renderGvis({
    gvisTable(dist(),list(width=300,height=300))
  })
  
  values = reactiveValues(PopRow=1)   ### To receive and hold the selected row number.
  
  f.objects_table_for_OneCT = function(){
    f.changeSelectedRow()        #### See definition below.
    df = dist()    #### Any data frame goes here; code not provided here.
    selectedRow = values$PopRow
    header_html <- function(table_cell) paste0('<th>', table_cell, '</th>')
    cell_html <- function(table_cell) paste0('<td>', table_cell, '</td>')
    radio_html <- function(radio_name, radio_value, is_checked, radio_text) {
      paste0('<input type="radio" name="', 
             radio_name, '" value=', radio_value, 
             ifelse(is_checked, " checked ", ""),
             '>', radio_text)
    }    
    row_html <- function(table_row_num) {
      table_row = df[table_row_num, ]
      cells <- sapply(table_row, cell_html)
      cells <- c(cell_html(radio_html(
        "whichRow", table_row_num, table_row_num == selectedRow, "")),
                 cells)
      collapse_cells <- paste0(cells, collapse='')
      selectedRowStyle = "style='color: #B38647; font-weight:bold'"
      collapse_cells <- paste0('<tr ', 
                               ifelse(table_row_num == selectedRow, selectedRowStyle, ""),
                               '>', collapse_cells, '</tr>')
      collapse_cells 
    }
    df_rows <- sapply(1:nrow(df), row_html) 
    df_header_row <- header_html(c("CHOICE", names(df)))
    collapse_cells <- paste0(c(df_header_row, df_rows), collapse='')    
    full_table <- paste0('<table class=\"data table table-bordered table-condensed\">', 
                         collapse_cells, '</table>')
    return(full_table)
  }
  
#   output$sas.text = renderText({
#     paste0("<textarea rows='25'>",
#            paste0(read.txt,collapse="\n"),
#            "<textarea>")
#   })
  
  output$objects_table_for_OneCT = renderText({
#     cat(values$PopRow,"\n")
#     cat(str(as.numeric(values$PopRow)),"\n")
#     cat(paste0(dist()[,"titles"],collapse=", "),"\n")
#     cat(paste0(dist()[as.numeric(values$PopRow),"titles"],collapse=", "),"\n")
#     cat(values$PopRow,"\n")
    f.objects_table_for_OneCT()
  })
  
  input.text = reactive({
    c(paste0(dist()[,"titles"],collapse=", "),
      paste0(dist()[,2],collapse=", "),
      paste0(dist()[,3],collapse=", "))
  })
  output$new.text = renderText({
    paste('<script>
                           function displayResult()
{
         document.getElementById("a").select();
         }
         </script>
         </head>
         <body>
         
         <textarea id="a" cols="20" >',
          paste0(input.text(),collapse="\n"),
    '</textarea>
      <br>
      
      <button type="button" onclick="displayResult()">Select contents of text area</button>')
     
    
    
  })
  
  output.try = reactive({
    if(!is.null(values)) {
      createObjectsTable()[values$PopRow,2]  
    }
  })
  
  output$number_ui = renderUI({
    numericInput("num_input","Input:",output.try())
  })
  
  f.changeSelectedRow = reactive({
    if(is.null(values$PopRow)) values$PopRow = 1
    if(!is.null(input$whichRow))   ### from the radio button set.
      if(input$whichRow != values$PopRow) values$PopRow = input$whichRow
  })
  
  output$out_exText = renderText({
    input$foo
  })
  
  output$clicked_update = renderText({
    input$clicked
    
  })
  
})
