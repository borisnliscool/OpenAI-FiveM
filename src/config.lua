API_KEY = GetConvar("openai_api_key", "")
if (API_KEY == "") then error("Invalid OpenAI API key.") end

local origin = "https://api.openai.com"
local api_version = "v1"
local open_ai_url = ("%s/%s"):format(origin, api_version)

ENGINES = {
    DAVINCI = "text-davinci-003",
    CURIE = "text-curie-001",
    BABBAGE = "text-babbage-001",
    ADA = "text-ada-001",
    CODE_DAVINCI = "code-davinci-002",
    CODE_CUSHMAN = "code-cushman-001",
}

DEFAULT_ENGINE = "DAVINCI"

ENDPOINTS = {
    completions = open_ai_url .. "/engines/%s/completions",
}

exports("ENGINES", ENGINES)
exports("DEFAULT_ENGINE", DEFAULT_ENGINE)
