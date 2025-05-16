library(shiny) # pak::pak("rstudio/shiny")
library(bslib) # pak::pak("rstudio/bslib")
library(dplyr)
library(purrr)

chat_with_completion_log_probs <- function(input) {
  chat <- ellmer::chat_openai(
    model = "gpt-4.1-nano",
    system_prompt = "You are a concise and helpful sentence finisher.",
    params = ellmer::params(log_probs = TRUE, top_logprobs = 5)
  )

  chat$chat(input, echo = "none")

  chat$last_turn()@json$choices[[1]]$logprobs$content |>
    purrr::map_dfr(
      function(x) {
        res <- purrr::map_dfr(x$top_logprobs, \(x) x[c("token", "logprob")])
        if (!x$token %in% res$token) {
          res <- dplyr::bind_rows(res, x[c("token", "logprob")])
        }
        res$chosen <- res$token == x$token
        res
      },
      .id = "index"
    ) |>
    dplyr::mutate(
      index = as.integer(index),
      prob = exp(logprob),
      confidence = dplyr::case_when(
        logprob < -5 ~ "very-low",
        logprob < -2 ~ "low",
        logprob < -1 ~ "medium",
        logprob < -0.1 ~ "high",
        .default = "certain"
      )
    )
}

add_noWS_to_tags <- function(x) {
  # Base case: if x is not a list, return it unchanged
  if (!is.list(x)) {
    return(x)
  }

  # Check if the current element is a shiny.tag
  if (inherits(x, "shiny.tag")) {
    # Add .noWS = "outside" attribute if it doesn't already exist
    if (is.null(x$.noWS)) {
      x$.noWS <- "outside"
    }
  }

  # Recursively process all children/elements using lapply
  x[] <- lapply(x, add_noWS_to_tags)

  return(x)
}

token_tooltip_component <- function(tokens_data) {
  id <- paste0("prompt-", rlang::hash(tokens_data))

  token_elements <-
    tokens_data |>
    group_by(index) |>
    group_map(function(alternatives, .group) {
      alternatives <- alternatives |> arrange(desc(logprob))

      chosen_token <- alternatives$token[alternatives$chosen]
      chosen_token <- gsub("\n", "<br>", chosen_token, fixed = TRUE)
      chosen_confidence <- alternatives$confidence[alternatives$chosen]

      if (nrow(alternatives) == 0) {
        return(span(
          class = paste0("token confidence-", tolower(chosen_confidence)),
          chosen_token
        ))
      }

      # Create table rows for all alternatives
      table_rows <-
        alternatives |>
        pmap(function(token, logprob, chosen, ...) {
          tags$tr(
            tags$td(
              class = if (chosen) "fw-bold",
              token
            ),
            tags$td(
              scales::percent(exp(logprob), accuracy = 0.001),
              class = "text-end",
              class = if (chosen) "fw-bold"
            )
          )
        })

      # Create the alternatives table
      alt_table <- tags$table(
        class = "table table-sm token-table",
        `data-bs-theme` = "dark",
        tags$thead(
          tags$tr(
            tags$th("Token"),
            tags$th("Prob", class = "text-end")
          )
        ),
        tags$tbody(table_rows)
      )

      # Create token span
      token_span <- span(
        class = paste0("token confidence-", tolower(chosen_confidence)),
        HTML(chosen_token)
      )

      # Create and return popover
      tooltip(
        token_span,
        alt_table,
        options = list(
          trigger = "click"
        )
      )
    })

  # Add some basic styling for different confidence levels
  style_tag <- tags$style(HTML(
    "
    .token-tooltip-container {
      font-size: 1.2rem;
      font-family: 'Courier New', monospace;
      line-height: 1.66;
      word-break: break-word;
    }
    .token-table {
      --bs-table-bg: transparent;
    }
    .token {
      padding: 2px;
      border-radius: 6px;
      cursor: pointer;
      white-space: pre;
      border: 1px solid var(--bs-body-bg);
    }
    .confidence-certain {
      background-color: rgba(76, 175, 80, 0.2);
      border-bottom: 2px solid #4CAF50; /* Green */
    }
    .confidence-high {
      background-color: rgba(0, 150, 136, 0.2);
      border-bottom: 2px solid #009688; /* Teal */
    }
    .confidence-medium {
      background-color: rgba(255, 193, 7, 0.2);
      border-bottom: 2px solid #FFC107; /* Amber */
    }
    .confidence-low {
      background-color: rgba(255, 152, 0, 0.2);
      border-bottom: 2px solid #FF9800; /* Orange */
    }
    .confidence-very-low {
      background-color: rgba(244, 67, 54, 0.2);
      border-bottom: 2px solid #F44336; /* Red */
    }
    .bs-popover-auto {
      max-width: 300px;
    }
    .table th, .table td {
      padding: 0.25rem 0.5rem;
    }
  "
  ))

  reveal_sequentially <- tags$script(
    HTML(sprintf(
      "revealSequentially('#%s .token');",
      id
    ))
  )

  tagList(
    div(
      id = id,
      class = "token-tooltip-container",
      !!!add_noWS_to_tags(token_elements),
      style_tag
    ),
    reveal_sequentially
  )
}

ui <- page_navbar(
  title = "Token Possibilities",
  sidebar = sidebar(
    width = "33%",
    textAreaInput(
      "prompt",
      tagList(icon("pencil"), "Prompt"),
      value = "Write a funny limerick about a cat.",
      rows = 4,
      autoresize = TRUE,
    ),
    input_task_button(
      "submit",
      "Submit",
      icon = icon("paper-plane"),
      class = "btn-primary"
    )
  ),
  header = useBusyIndicators(),
  id = "tab",
  nav_panel(
    "Response",
    value = "response",
    icon = icon("robot", class = "me-1"),
    uiOutput("completion"),
  ),
  nav_panel(
    "Ideas",
    value = "ideas",
    icon = icon("lightbulb", class = "me-1"),
    shinychat::output_markdown_stream(
      id = "ideas-markdown",
      content = r"(
Here are some short, presentation-friendly phrases that illustrate how LLMs select words based on context and probability.

As a first step, try replacing `cat` with `animal`.

```markdown
Write a funny limerick about a cat.
```
```markdown
Write a funny limerick about an animal.
```

How does that change the LLM's response?

## High Ambiguity Examples

- "The bank..." (financial institution or riverside?)
- "She saw a bat..." (animal or sports equipment?)
- "I need to get a prescription for my..." (many medical possibilities)
- "Please pass the..." (countless objects could follow)
- "The doctor examined the patient's..." (multiple body parts possible)

## Context Shifts Probability

- "I'm going to the bank to..." (now likely financial)
- "I'm going to the bank to fish..." (now likely riverside)
- "The pitcher threw the bat..." (sports context established)
- "The cave was full of sleeping bat..." (animal context established)
- "Time flies like an..." (arrow? airplane? hour?)
- "Time flies like an arrow; fruit flies like a..." (banana becomes highly probable)

## Probability Steered by Specificity

- "The capital of France is..." (very high certainty for "Paris")
- "The chemical symbol for gold is..." (very high certainty for "Au")
- "To be or not to be, that is the..." (extremely high certainty for "question")
- "I woke up this morning feeling..." (many plausible completions)
- "In a world where..." (extremely open-ended)

## Contextual Collocations

- "Strong..." (coffee? winds? opinions? person?)
- "Strong tea and..." (likely food-related completions)
- "The heavy..." (weight? rain? traffic? burden?)
- "She couldn't bear the heavy..." (psychological interpretation more likely)

These examples demonstrate how LLMs navigate between certainty and ambiguity based on available context.
    )"
    )
  ),
  footer = tags$head(
    tags$script(
      HTML(
        r"(
function revealSequentially(selector, options = {}) {
  const elements = document.querySelectorAll(selector);
  const delay = options.delay || 100;
  const duration = options.duration || 500;

  elements.forEach((el, index) => {
    // Set initial state
    el.style.opacity = '0';
    el.style.transition = `opacity ${duration}ms`;

    // Trigger animation after staggered delay
    setTimeout(() => {
      el.style.opacity = '1';
      el.style.transform = 'translateY(0)';
    }, index * delay);
  });
}
      )"
      )
    )
  )
)

server <- function(input, output, session) {
  completion <- eventReactive(input$submit, {
    updateTabsetPanel(session, "tab", selected = "response")
    chat_with_completion_log_probs(input$prompt)
  })

  output$completion <- renderUI({
    token_tooltip_component(completion())
  })

  outputOptions(output, "completion", suspendWhenHidden = FALSE)
}

shinyApp(ui, server)
