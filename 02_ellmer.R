# pak::pak("tidyverse/ellmer") -- release coming soon!
library(ellmer)




# ========[ ellmer basics ]========

chat <- chat_openai()
chat$chat("Pick a random word.")

# Same for Anthropic





# ~~~~~~~~ ✦ Getting Set Up ✦ ~~~~~~~~

# You need API keys to interact with an LLM
#
# OpenAI:
#   1. https://platform.openai.com/
#   2. => OPENAI_API_KEY
#
# Anthropic:
#   1. https://console.anthropic.com/
#   2. => ANTHROPIC_API_KEY


# usethis::edit_r_environ()








#           ┬  ┌─┐┌─┐┌─┐┬    ┌┬┐┌─┐┌┬┐┌─┐┬  ┌─┐
#           │  │ ││  ├─┤│    ││││ │ ││├┤ │  └─┐
#           ┴─┘└─┘└─┘┴ ┴┴─┘  ┴ ┴└─┘─┴┘└─┘┴─┘└─┘
#
#           @@@@@@                         @@@@@@
#          @@@@@@@@@                     @@@@@@@@@@
#        @@@@@@@@@@@@                   @@@@@@@@@@@@
#        @@@@@  @@@@@@                 @@@@@@  @@@@@
#       @@@@@@   @@@@@                 @@@@@   @@@@@@
#       @@@@@    @@@@@   @@@@@@@@@@@   @@@@@    @@@@@
#       @@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@
#       @@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@
#       @@@@@     @@@@@@@          @@@@@@@@     @@@@@
#       @@@@@@@@@@@@@@@               @@@@@@@@@@@@@@@
#       @@@@@@@@@@@@@@                 @@@@@@@@@@@@@@
#      @@@@@@@@@@@@@                    @@@@@@@@@@@@@@
#    @@@@@@@@                                   @@@@@@@@
#   @@@@@@                                         @@@@@@
#  @@@@@@                                           @@@@@@
# @@@@@@                                             @@@@@@
# @@@@@                                               @@@@@
# @@@@@        @@@       @@@@@@@@@@@       @@@        @@@@@
# @@@@@      @@@@@@   @@@@@@@@@@@@@@@@@   @@@@@@      @@@@@
# @@@@@      @@@@@@  @@@@@@       @@@@@@  @@@@@@      @@@@@
# @@@@@@      @@@@ @@@@@             @@@@@ @@@@      @@@@@@
#  @@@@@@          @@@@    @@@@@@@    @@@@          @@@@@@
#   @@@@@@         @@@      @@@@@      @@@         @@@@@@
#   @@@@@@         @@@@      @@@      @@@@         @@@@@@
#  @@@@@@          @@@@@             @@@@@          @@@@@@
# @@@@@@             @@@@@@@@@@@@@@@@@@@             @@@@@@
# @@@@@@               @@@@@@@@@@@@@@@               @@@@@@
# @@@@@                                               @@@@@
# @@@@@                                               @@@@@
# @@@@@                                               @@@@@
# @@@@@@                                             @@@@@@
#  @@@@@@                                            @@@@@
#   @@@@@@                                         @@@@@@
#    @@@@@                                         @@@@@@
#   @@@@@@                                         @@@@@@
#  @@@@@@                                           @@@@@@
#  @@@@@                                             @@@@@
#  @@@@@                                             @@@@@
#  @@@@@                                             @@@@@@
#  @@@@@                                             @@@@@
#  @@@@@@                                            @@@@@


# https://ollama.com
#
# ollama pull qwen3:4b

# chat <- chat_






# ~~~~~~~~ ✨ ellmer in easy mode ✨ ~~~~~~~~

chat <- chat_openai(model = "gpt-4.1-nano")

live_console(chat)
live_browser(chat)

chat










# ~~~~~~~~ ✨ advanced ellmer ✨ ~~~~~~~~

chat <- chat_openai(
  system_prompt = c(
    "You are a trickster who turns what the user says",
    "into an silly riddle."
  ),
  model = "gpt-4.1-nano",
  params = params(
    temperature = 1
  )
)

chat$chat("I like waffles for breakfast.")


















chat <- chat_openai(
  system_prompt = c(
    "You are an expert R programmer and statistician.",
    "You explain things clearly and concisely and you show your code.",
    "You break down complex problems into simple steps.",
    "You always use the latest features of R,",
    "including the `|>` pipe operator,",
    "and you prefer the tidyverse style and set of packages when possible.",
    "You write nicely formatted code, in a functional style,",
    "and you prefer R-native conventions, like vectorization."
  ),
  model = "gpt-4.1-nano",
  params = params(
    temperature = 0.2
  )
)

chat$chat(
  "Write R code to analyze the `mtcars` dataset",
  "to determine the relationship between `mpg` and `wt`."
)
