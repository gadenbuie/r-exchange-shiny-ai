# Is the Shiny Extension installed?
# Start with the shinyapp snippet
# And make sure you have shinychat installed
# => pak::pak("posit-dev/shinychat")
# Use gpt-4.1-nano

library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_sidebar(
  title = "Demo shinychat app",
  chat_ui("chat")
)

server <- function(input, output, session) {
  client <- chat_openai(model = "gpt-4.1-nano")

  observeEvent(input$chat_user_input, {
    stream <- client$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
