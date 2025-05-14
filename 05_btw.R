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

chat$register_tool(
  tool(
    todays_date,
    "Get today's date."
  )
)




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
#> I'll help you read your CSV file into an in-memory DuckDB database.
#> First, let's locate the CSV file in your project.
#> ◯ [tool call] btw_tool_files_list_files(regexp = "[.]csv$")
#> ● #> | path | type | size | modification_time |
#>   #> |------|------|------|-------------------|
#>   #> | 04_querychat-demo/nsf-terminations.csv | file | 5M |
#> 2025-05-14 12:28:31 |
#> I found a CSV file with grant terminations:
#> `04_querychat-demo/nsf-terminations.csv`. Now, let's check if the
#> DuckDB package is installed:
#> ◯ [tool call] btw_tool_session_package_info(packages = "duckdb")
#> ● #> ```
#>   #>  package * version date (UTC) lib source
#>   #>  duckdb 1.2.2 2025-04-29 [1] CRAN (R 4.5.0)
#>   #>
#>   #>  [1]
#> /Users/garrick/presentations/2025-05-14_shiny-ai-llm-powered-apps/renv/library/macos/R-4.5/aarch64-apple-darwin20
#>   #> …
#> Great! The DuckDB package is installed. Now I'll show you how to
#> read the CSV file into an in-memory DuckDB database:
#>
#> ```r
#> # Load the duckdb package
#> library(duckdb)
#>
#> # Create an in-memory DuckDB connection
#> con <- dbConnect(duckdb())
#>
#> # Import the CSV file directly into DuckDB
#> dbExecute(con, "CREATE TABLE grant_terminations AS SELECT * FROM
#> read_csv_auto('04_querychat-demo/nsf-terminations.csv')")
#>
#> # Alternatively, you can use dplyr syntax if you prefer:
#> # library(dplyr)
#> # tbl_grant_terminations <- tbl(con, "grant_terminations")
#>
#> # Verify that the data was imported correctly
#> dbGetQuery(con, "SELECT * FROM grant_terminations LIMIT 5")
#>
#> # When you're done, you can disconnect from the database
#> # dbDisconnect(con)
#> ```
#>
#> This code:
#>
#> 1. Loads the DuckDB package
#> 2. Creates an in-memory DuckDB database connection
#> 3. Uses DuckDB's `read_csv_auto()` function to import the CSV file
#> directly into a table called "grant_terminations"
#> 4. Verifies the import by showing the first 5 rows of data
#>
#> The advantage of this approach is that DuckDB can efficiently read
#> the CSV file directly without first loading it into R memory. DuckDB
#> will automatically infer column types from the data, though you can
#> specify them manually if needed.
#>
#> If you want to see what the data looks like before importing, or if
#> you need to specify particular column types, let me know and I can
#> show you how to examine the CSV file first.


client$chat("Is there a more straightforward way to read the csv with the duckdb R package?")
#> Yes, there is a more straightforward way to read a CSV file into DuckDB using the R
#> package. Let me show you the simplest approach:
#> ◯ [tool call] btw_tool_docs_help_page(package_name = "duckdb", topic =
#> "read_csv_duckdb")
#> ● #> ## `help(package = "duckdb", "read_csv_duckdb")`
#>   #>
#>   #> ### Deprecated functions
#>   #>
#>   #> #### Description
#>   #> …
#> Let's check the newer function:
#> ◯ [tool call] btw_tool_docs_help_page(package_name = "duckdb", topic =
#> "duckdb_read_csv")
#> ● #> ## `help(package = "duckdb", "duckdb_read_csv")`
#>   #>
#>   #> ### Reads a CSV file into DuckDB
#>   #>
#>   #> #### Description
#>   #> …
#> Here's a more straightforward way to read your CSV file into an in-memory DuckDB
#> database:
#>
#> ```r
#> # Load the duckdb package
#> library(duckdb)
#>
#> # Create an in-memory DuckDB connection
#> con <- dbConnect(duckdb())
#>
#> # Read the CSV file directly into a DuckDB table in one step
#> duckdb_read_csv(
#>   conn = con,
#>   name = "grant_terminations",
#>   files = "04_querychat-demo/nsf-terminations.csv"
#> )
#>
#> # Now you can query the table
#> result <- dbGetQuery(con, "SELECT * FROM grant_terminations LIMIT 5")
#> print(result)
#>
#> # When done
#> # dbDisconnect(con)
#> ```
#>
#> This approach:
#>
#> 1. Creates an in-memory DuckDB connection
#> 2. Uses `duckdb_read_csv()` to directly read the CSV file into a DuckDB table named
#> "grant_terminations"
#> 3. The function handles the table creation and data loading in a single step
#>
#> This is more straightforward than the previous approach because:
#> - It uses a dedicated function designed specifically for reading CSVs into DuckDB
#> - It requires less SQL code (no need to write a CREATE TABLE statement)
#> - It's more readable and idiomatic when using the R package
#>
#> The function has many optional parameters for customizing how the CSV is read, including
#> specifying column types, handling header rows, and dealing with NULL values, but the
#> default settings will work fine in most cases.


# ---- <code-from-chat> ----
library(duckdb)

# Create an in-memory DuckDB connection
con <- dbConnect(duckdb())

# Read the CSV file directly into a DuckDB table in one step
duckdb_read_csv(
  conn = con,
  name = "grant_terminations",
  files = "04_querychat-demo/nsf-terminations.csv"
)

library(dplyr)
nsf_terminations <- tbl(con, "grant_terminations")
# ---- </code-from-chat> ----

client$chat(
  "Write dplyr code that finds the states with the most cancelled funding ",
  "using the `nsf_terminations` data frame."
)
#> I'll help you write dplyr code to find the states with the most cancelled funding using
#> the `nsf_terminations` data frame. First, let's examine the structure of the data frame
#> to understand its columns.
#>
#> ◯ [tool call] btw_tool_env_describe_data_frame(data_frame = "nsf_terminations")
#> ● #> [...json snippet removed...]
#>
#> Now that I understand the structure of the data frame, I'll create dplyr code to find
#> the states with the most cancelled funding. I'm noticing that the funding amounts are
#> stored as character strings with dollar signs, so we'll need to clean that data to
#> perform calculations.
#>
#> Here's the dplyr code to find the states with the most cancelled funding:
#>
#> ```r
#> library(dplyr)
#> library(stringr)
#>
#> nsf_terminations %>%
#>   # Convert funding from string to numeric values by removing $ and commas
#>   mutate(funding_amount = as.numeric(str_remove_all(nsf_total_budget, "\\$|,"))) %>%
#>   # Group by state
#>   group_by(org_state) %>%
#>   # Calculate total cancelled funding per state
#>   summarize(
#>     total_cancelled_funding = sum(funding_amount, na.rm = TRUE),
#>     count_of_projects = n()
#>   ) %>%
#>   # Sort by total cancelled funding in descending order
#>   arrange(desc(total_cancelled_funding)) %>%
#>   # Show the top states with most cancelled funding
#>   head(10)
#> ```
#>
#> This code:
#>
#> 1. Loads the necessary libraries (dplyr for data manipulation and stringr for string
#> operations)
#> 2. Takes the nsf_terminations data frame
#> 3. Converts the funding amounts from character strings with dollar signs to numeric
#> values
#> 4. Groups the data by state (org_state)
#> 5. Calculates the total cancelled funding and count of cancelled projects for each state
#> 6. Sorts the results in descending order by total cancelled funding
#> 7. Shows the top 10 states with the most cancelled funding
#>
#> If you want to visualize this data, you could add the following code to create a bar
#> chart:
#>
#> ```r
#> library(ggplot2)
#>
#> nsf_terminations %>%
#>   mutate(funding_amount = as.numeric(str_remove_all(nsf_total_budget, "\\$|,"))) %>%
#>   group_by(org_state) %>%
#>   summarize(
#>     total_cancelled_funding = sum(funding_amount, na.rm = TRUE)
#>   ) %>%
#>   arrange(desc(total_cancelled_funding)) %>%
#>   head(10) %>%
#>   ggplot(aes(x = reorder(org_state, -total_cancelled_funding), y =
#> total_cancelled_funding / 1000000)) +
#>   geom_bar(stat = "identity", fill = "steelblue") +
#>   labs(
#>     title = "Top 10 States by Cancelled NSF Funding",
#>     x = "State",
#>     y = "Total Cancelled Funding (Millions $)"
#>   ) +
#>   theme_minimal() +
#>   theme(axis.text.x = element_text(angle = 45, hjust = 1))
#> ```
#>
#> This will create a bar chart of the top 10 states with the most cancelled funding, with
#> the amounts displayed in millions of dollars for better readability.
