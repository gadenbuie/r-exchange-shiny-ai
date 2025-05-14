# ╭──────────────────────────────────╮
# │                                  │
# │   +--------------------------+   │
# │   |                          |   │
# │   |         May 2025         |   │
# │   |   Mo Tu We Th Fr Sa Su   |   │
# │   |                      1   |   │
# │   |    2  3  4  5  6  7  8   |   │
# │   |    9 10 11 12 13 14 15   |   │
# │   |   16 17 18 19 20 21 22   |   │
# │   |   23 24 25 26 27 28 29   |   │
# │   |   30 31                  |   │
# │   |                          |   │
# │   +--------------------------+   │
# │                                  │
# ╰──────────────────────────────────╯

library(ellmer)

chat <- chat_openai(model = "gpt-4.1-nano")

chat$chat("what is today's date?")







#    _                        _
#   | |_     ___     ___     | |     ___
#   |  _|   / _ \   / _ \    | |    (_-<
#   _\__|   \___/   \___/   _|_|_   /__/_
# _|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
# "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'

todays_date <- function() {
  strftime(Sys.time(), format = "%Y-%m-%d")
}

chat$register_tool()




chat$chat("Check again, what is today's date?")









#   _     _
#  | |__ | |___      __
#  | '_ \| __\ \ /\ / /
#  | |_) | |_ \ V  V /
#  |_.__/ \__| \_/\_/
#
#
# pak::pak("posit-dev/btw")
library(btw)

?btw_tools



btw_app()














prompt <- "
I have a `.csv` file with grant terminations in my project.
Show me how to read it into an in-memory duckdb database.
"

client <- btw_client()
client$chat(prompt)























client$chat("Is there a more straightforward way to read the csv with the duckdb R package?")















client$chat(
  "Write dplyr code that finds the states with the most cancelled funding ",
  "using the `nsf_terminations` data frame."
)
