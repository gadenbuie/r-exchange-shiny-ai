
```{art}
┌ R Exchange 2025 ─────────────────────────┐
│                                          │
│                                          │
│      Shiny + AI:                         │
│      Building LLM-Powered Apps in R      │
│                                          │
│                                          │
└──────────────────────── garrick@posit.co ┘
```





## 👋 Hi, I'm Garrick!

* 👨‍💻 https://github.com/gadenbuie

* 🦋 https://bsky.app/profile/grrrck.xyz

* 📧 garrick@posit.co

* 💾 https://github.com/gadenbuie/r-exchange-shiny-ai












```{art}
  .+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.
 (                                     )
  )                                   (
 (          $$$$$$\  $$$$$$\           )
  )        $$  __$$\ \_$$  _|         (
 (         $$ /  $$ |  $$ |            )
  )        $$$$$$$$ |  $$ |           (
 (         $$  __$$ |  $$ |            )
  )        $$ |  $$ |  $$ |           (
 (         $$ |  $$ |$$$$$$\           )
  )        \__|  \__|\______|         (
 (                                     )
  )                                   (
 (                                     )
  "+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"
```














```{art}
  ██╗     ██╗     ███╗   ███╗███████╗
  ██║     ██║     ████╗ ████║██╔════╝
  ██║     ██║     ██╔████╔██║███████╗
  ██║     ██║     ██║╚██╔╝██║╚════██║
  ███████╗███████╗██║ ╚═╝ ██║███████║
  ╚══════╝╚══════╝╚═╝     ╚═╝╚══════╝
```








## Things I've learned from Joe Cheng

```{art}
    _                   _
   (_)                 | |
    _  ___   ___    ___| |__   ___ _ __   __ _
   | |/ _ \ / _ \  / __| '_ \ / _ \ '_ \ / _` |
   | | (_) |  __/ | (__| | | |  __/ | | | (_| |
   | |\___/ \___|  \___|_| |_|\___|_| |_|\__, |
  _/ |                                    __/ |
 |__/                                    |___/
```


- Stay skeptical, but **let yourself be curious**

- Try programming with LLMs

- Be open to revising your mental models











### 🤖 AI: Are they machines that reason?











### 🦜 LLMs: Are they just stochastic parrots?








![](images/Joe_Cheng.jpg)

- The "stochastic parrot" mental model is true, reassuring, and **unhelpful**

- The "machines that reason" mental model is false, terrifying, and **helpful**

















## How do we interact with LLMs?


1. You write some text.

2. The LLM continues writing more text.

3. You think you're having a conversation.













### How does it write more text?


1. What else would someone who said what you said say?

2. Based on all written text and code that can be found.

3. Inherently biased toward things people have written about
   before the model was trained.














## Stochastic parrot is helpful, actually?


1. **You write** some text.

2. The LLM continues writing more text.

3. **You think** you're having a conversation.


```{r}
shiny::runApp("01_probs-app.R")
```
