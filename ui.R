library(shiny)

inputTextarea <- function(inputId, value="", nrows, ncols) {
  tagList(
    singleton(tags$head(tags$script(src = "textarea.js"))),
    tags$textarea(id = inputId,
                  class = "inputtextarea",
                  rows = nrows,
                  cols = ncols,
                  as.character(value))
  )
}

shinyUI(pageWithSidebar(  
  headerPanel("",
              tags$head(
                tags$link(rel="shortcut icon", href="http://dl.dropboxusercontent.com/u/14343406/favicon.ico"),
                tags$link(rel="stylesheet", type="text/css", href="userContent.css"),
                tags$link(rel="stylesheet", type="text/css", href="http://fonts.googleapis.com/css?family=Mouse+Memoirs"),
                tags$link(rel="stylesheet", href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"),
                HTML('
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script src="textArea.js"></script>
                     '),
                
                tags$link(rel="stylesheet", href="http://jqueryui.com/jquery-wp-content/themes/jqueryui.com/style.css"),
                HTML(
                  '<div style="padding: 10px 0px;">
                    <h1>Shiny Sandbox</h1>
                    </div>'
                )          
              )
  ),
  
  sidebarPanel(
    htmlOutput("ui_title"),
    htmlOutput("ui_comptitle"),
    tags$textarea(id="foo","some text &in"),
    inputTextarea('exampleTextarea', '',20,35 ),
    
    HTML('
<script>
$(document).ready(function(){
    var left = 60
    $("#text_counter").text("Characters left: " + left);
 
        $("#data_entry_text_area").keyup(function () {
 
        left = 60 - $(this).val().length;
 
        if(left < 2){
            $("#text_counter").addClass("overlimit");
        }
        if(left >= 2){
            $("#text_counter").removeClass("overlimit");
        }
 
        $("#text_counter").text("Characters left: " + left);
    });
});
</script>
'),
    numericInput("start.val","Start Val",1),
    htmlOutput("number_ui")
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel(
        "tab1",
        h3("section1"),
        HTML('<div><p id="objects_table_for_OneCT" class="shiny-html-output"></p></div>'),
        h3("section2"),
        HTML('<div id="new.text2"><p id="new.text" class="shiny-html-output"></p></div>')
      ),
      tabPanel(
        "tab2",
        HTML('
          <script>
            function go() {
              var c1 = document.getElementById("new.text2").value;
              var d1 = document.getElementById("as");
              d1.innerHTML = c1;
            }
          </script>
          <input type="button" value="get txt" onclick="go()"/>
          <p id="as">Now what</p>
               ')
      ),
      tabPanel(
        "tab3",
        textOutput("out_exText")
      ),
      tabPanel(
        "tab4",
        HTML('<button id="clicked" onclick="myFunction()">Try it</button>

<p id="demo"></p>

<script>
function myFunction()
{
var r=confirm("Press a button!");
}
</script>'),
        textOutput("clicked_update")
      )
    )
  )
))



