library(shiny)
library(bslib)
library(ellmer)
library(promises)
library(shinychat)

ui <- page_sidebar(
  title = "Interactive markdown streaming",
  sidebar = sidebar(
    textAreaInput("user_query", "Tell me a story about..."),
    input_task_button("ask_chat", label = "Generate a story")
  ),
  card(
    card_header(textOutput("story_title")),
    shinychat::output_markdown_stream("response"),
  )
)

server <- function(input, output) {
  observeEvent(input$ask_chat, {
    chat <- chat_openai(
      system_prompt = "You are a rambling chatbot who likes to tell stories but gets distracted easily.",
      model = "gpt-4.1-nano"
    )

    # Stream the chat completion into the markdown stream. `markdown_stream()`
    # returns a promise onto which we'll chain the follow-up task of providing
    # a story title.
    stream <- chat$stream_async(input$user_query)
    stream_res <- shinychat::markdown_stream("response", stream)

    # Follow up by asking the LLM to provide a title for the story that we
    # return from the task.
    stream_res$then(function(value) {
      story_title(
        chat$chat(
          "What is the title of the story? Reply with only the title and nothing else."
        )
      )
    })
  })

  story_title <- reactiveVal("Your story will appear here!")
  output$story_title <- renderText(story_title())
}

shinyApp(ui = ui, server = server)
