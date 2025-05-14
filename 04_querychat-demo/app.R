#####################################
# This file creates an interactive Shiny
# dashboard as part of the May 6 Tidy Tuesday challenge
# R version 4.4.2 (2024-10-31)
# Platform: aarch64-apple-darwin20
# Running under: macOS Sequoia 15.4.1
#####################################

# set seed because why not?
set.seed(562025)

# since we're mapping we want to avoid dealing with repeated shapefile downloads
# this is a little hack to make things run smoother
options(tigris_use_cache = TRUE, tigris_class = "sf")

# load libraries
library(shiny) # it's basically magic
library(bslib) # styling
library(querychat) # AI chatbot connection - pak::pak("posit-dev/querychat/r-package@r/feat/no-ns-needed")
library(leaflet) # pretty mapping
library(tidyverse) # for everything
library(DT) # table work
library(sf) # for the maps
library(tigris) # more mapping
library(htmltools) # to make the whole thing run via html
library(plotly) # for interactive plots
library(janitor) # to clean up
library(stringi) # to fix some strings

# load and clean data (code from Tidy Tuesday's github)
file_path <- "nsf-terminations.csv"
if (!file.exists(file_path)) {
  download.file(
    "https://drive.usercontent.google.com/download?id=1TFoyowiiMFZm73iU4YORniydEeHhrsVz&export=download",
    destfile = file_path
  )
}

# Read the CSV file
raw_nsf_terminations <- readr::read_csv(file_path)

nsf_terminations <- raw_nsf_terminations |>
  clean_names() |>
  mutate(
    usaspending_obligated = stri_replace_first_fixed(
      usaspending_obligated,
      "$",
      ""
    ) |>
      parse_number(),
    in_cruz_list = !is.na(in_cruz_list),
    grant_number = as.character(grant_number),
    org_city = str_to_title(str_to_lower(org_city))
  )

# querychat configuration with data dictionary
# this is mostly taken from the querychat github but
# instead of creating a separate data description file
# I'm just dumping everything here. It's not elegant but it works
querychat_config <- querychat_init(
  nsf_terminations,
  create_chat_func = purrr::partial(
    ellmer::chat_openai,
    model = "gpt-4.1-mini"
  ),
  data_description = "
This dataset includes information on cancelled NSF grants.

Variables:
- grant_number (character): The numeric ID of the grant.
- project_title (character): The title of the project the grant funds.
- termination_letter_date (date): The date a termination letter was received by the organization.
- org_name (character): The name of the organization or institution funded to do the project.
- org_city (character): The name of the organization's city.
- org_state (character): The organization's two-letter state abbreviation.
- org_district (character): The congressional district (state and number) where the organization is located.
- usaspending_obligated (double): The amount of money, via USAspending.gov, that NSF had committed to funding.
- award_type (character): The type of grant.
- directorate_abbrev (character): The three-letter abbreviation of the NSF directorate name.
- directorate (character): The NSF directorate (the highest level of organization), which administered the grant.
- division (character): The NSF division (housed within directorate) which administered the grant.
- nsf_program_name (character): The name of the funding program under which the grant was made.
- nsf_url (character): The URL pointing to the award information in the public NSF award database.
- usaspending_url (character): The URL pointing to budget and spending information at USAspending.gov.
- nsf_startdate (date): The start date of the project.
- nsf_expected_end_date (date): The date the project was expected to end.
- org_zip (character): The 5- or 9-digit ZIP code of the organization receiving the grant.
- org_uei (character): The unique entity identifier (UEI) of the organization.
- abstract (character): The text of the project abstract, describing the work to be done.
- in_cruz_list (logical): Whether the project was flagged by Senator Ted Cruz for promoting DEI or similar content.
",
  greeting = "Hello! I'm here to assist you with exploring and analyzing cancelled NSF grants.

  You can ask me questions about the data, and I'll do my best to provide you with insights and information.
  Here are some ideas to get started:

  * <span class='suggestion'>Which states lost the most funding?</span>
  * <span class='suggestion'>Show me all of the grants cancelled in California.</span>
  * <span class='suggestion'>Which grants were cancelled in the 5 states with the most cancelled funding?</span>",
  extra_instructions = "Only respond using the provided NSF data."
)

# the code below is augmented from the querychat example script here:
# https://github.com/posit-dev/querychat/blob/main/r-package/README.md

# UI
# This sets up our general layout
ui <- page_navbar(
  title = "Cancelled NSF Grants Dashboard",
  sidebar = querychat_sidebar("chat", width = "30%"),
  header = tagList(
    useBusyIndicators(),
    tags$style(
      "shiny-chat-messages ul, shiny-chat-messages ol { padding-left: 1rem; }"
    )
  ),
  nav_panel(
    "Stats",
    layout_columns(
      fill = FALSE,
      value_box(title = "Grants Cancelled", value = textOutput("n_Grants")),
      value_box(
        title = "Total Value Cancelled",
        value = textOutput("total_value")
      ),
      value_box(
        title = HTML("Flagged by Ted Cruz as<br>neo-Marxist propaganda"),
        value = textOutput("cruz_flagged")
      )
    ),
    layout_columns(
      min_height = 400,
      card(leafletOutput("map", height = 400)),
      card(plotlyOutput("barplot", height = 400))
    ),
  ),
  nav_panel(
    "Data",
    card(DTOutput("dt"), min_height = 500)
  )
)

# Server section to make the thing run
server <- function(input, output, session) {
  querychat <- querychat_server("chat", querychat_config)

  df <- reactive(querychat$df())

  # Value boxes
  output$n_Grants <- renderText({
    nrow(df())
  })
  output$total_value <- renderText({
    scales::dollar(sum(df()$usaspending_obligated, na.rm = TRUE))
  })
  output$cruz_flagged <- renderText({
    sum(df()$in_cruz_list, na.rm = TRUE)
  })

  # Leaflet map
  output$map <- renderLeaflet({
    req(nrow(df()) > 0)

    states_sf <- tigris::states(cb = TRUE) |>
      st_transform(4326) |>
      rename(org_state = STUSPS) |>
      filter(org_state %in% state.abb)

    tooltip_data <- df() |>
      group_by(org_state) |>
      summarise(
        count = n(),
        tooltip = paste0(org_state, ": ", count, " Grants"),
        .groups = "drop"
      )

    merged <- left_join(states_sf, tooltip_data, by = "org_state")
    pal <- colorNumeric("Blues", domain = merged$count, na.color = "#f0f0f0")

    leaflet(merged) |>
      addProviderTiles("CartoDB.Positron") |>
      addPolygons(
        fillColor = ~ pal(count),
        color = "white",
        weight = 1,
        fillOpacity = 0.7,
        label = ~ lapply(tooltip, HTML),
        highlightOptions = highlightOptions(
          weight = 2,
          color = "#666",
          fillOpacity = 0.9
        )
      ) |>
      fitBounds(-125, 25, -66, 50) |>
      setView(lng = -96, lat = 37.8, zoom = 2.5)
  })

  # bar chart
  output$barplot <- renderPlotly({
    req(nrow(df()) > 0)

    plot_data <- df() |>
      filter(!is.na(org_city)) |>
      group_by(org_city) |>
      summarise(
        total_value = sum(usaspending_obligated, na.rm = TRUE),
        .groups = "drop"
      ) |>
      slice_max(total_value, n = 10) |>
      mutate(
        tooltip = paste0(
          org_city,
          "<br>",
          scales::label_dollar(scale_cut = scales::cut_short_scale())(
            total_value
          )
        )
      )

    p <- ggplot(
      plot_data,
      aes(
        x = total_value,
        y = reorder(org_city, total_value),
        text = tooltip
      )
    ) +
      geom_bar(stat = "identity", fill = "#4682B4") +
      labs(
        x = "Total Canceled Value",
        y = "",
        title = "Top Cities by Lost Funding"
      ) +
      scale_x_continuous(labels = scales::label_dollar()) +
      theme_minimal() +
      theme(panel.grid.major.y = element_blank())

    ggplotly(p, tooltip = "text") |> layout(margin = list(l = 100))
  })

  # Data table just like in the querychat example
  output$dt <- renderDT({
    df() |>
      slice_head(n = 20) |>
      select(
        org_state,
        org_name,
        project_title,
        division,
        usaspending_obligated
      )
  })
}

# run it!!
shinyApp(ui, server)
