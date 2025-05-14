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
  chat_mod_ui("chat")
)

server <- function(input, output, session) {
  client <- chat_openai(model = "gpt-4.1-nano")
  chat_mod_server("chat", client)
}

shinyApp(ui, server)
