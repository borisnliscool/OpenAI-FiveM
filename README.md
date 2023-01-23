# OpenAI-FiveM

A simple wrapper for the OpenAI API.

Showcase: [streamable.com/1bf31f](https://streamable.com/1bf3f1)

[My Discord](https://borisnl.nl/discord) for limited support.

### Setup

Add your OpenAI api key to your server configuration.

```lua
set openai_api_key "<key>";
```

### Usage

```lua
local OpenAI = exports["OpenAI-FiveM"]

local data = OpenAI:Complete({
    engine = "text-davinci-003",
    prompt = "this is a test",
    maxTokens = 100,
    temperature = 0.9,
    topP = 1,
    presencePenalty = 0,
    frequencyPenalty = 0,
    bestOf = 1,
    n = 1,
    stream = false,
    stop = { "\n" }
})

print(json.encode(data, { indent = true }))
```

For more information I recommend checking out [OpenAI's Website](https://beta.openai.com/docs/introduction) about this stuff.
