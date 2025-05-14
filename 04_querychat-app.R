
# ~~~~~~~~ ✦ querychat ✦ ~~~~~~~~

# ===[ https://github.com/posit-dev/querychat ]===

#  Imagine typing questions like these directly into your dashboard, and seeing
#  the results in realtime:
#
# - "Show only penguins that are not species Gentoo and have a bill length
#   greater than 50mm."
# - "Show only blue states with an incidence rate greater than 100 per 100,000
#   people."
# - "What is the average mpg of cars with 6 cylinders?"
#
# querychat is a drop-in component for Shiny that allows users to query a data
# frame using natural language. The results are available as a reactive data
# frame, so they can be easily used from > Shiny outputs, reactive expressions,
# downloads, etc. This is not as terrible an idea as you might think!




## Joe Cheng - Shiny x AI - posit::conf(2025)
#
#  _______________
# |,----------.  |\
# ||           |=| |
# ||          || | |
# ||       . _o| | | __
# |`-----------' |/ /~/
#  ~~~~~~~~~~~~~~~ / /
#                  ~~
#
# https://www.youtube.com/watch?v=AP8BWGhCRZc

















#                                     __          __
#   ____ ___  _____  _______  _______/ /_  ____ _/ /_
#  / __ `/ / / / _ \/ ___/ / / / ___/ __ \/ __ `/ __/
# / /_/ / /_/ /  __/ /  / /_/ / /__/ / / / /_/ / /_
# \__, /\__,_/\___/_/   \__, /\___/_/ /_/\__,_/\__/
#   /_/_               /____/
#    / /_  ____ ______(_)_________
#   / __ \/ __ `/ ___/ / ___/ ___/
#  / /_/ / /_/ (__  ) / /__(__  )
# /_.___/\__,_/____/_/\___/____/

library(shiny)
library(bslib)
library(querychat)

# Step 1: Setup and querychat config
querychat_config <- querychat_init(mtcars)

ui <- page_sidebar(
  # Step 2: Drop the querychat UI into your app
  sidebar = querychat_sidebar("chat"),
  DT::DTOutput("dt")
)

server <- function(input, output, session) {

  # Step 3. Wire up querychat server-side
  querychat <- querychat_server("chat", querychat_config)

  output$dt <- DT::renderDT({
    # Step 4: Use the querychat-filtered data!
    DT::datatable(querychat$df())
  })
}

shinyApp(ui, server)
