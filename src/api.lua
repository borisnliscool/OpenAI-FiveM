local function camelToUnderscore(key)
    local result = string.gsub(key, "([A-Z])", " %1")
    return string.lower(string.gsub(result, "%s", "_"))
end

function SendRequest(url, method, options)
    local _body = {}
    for key, value in pairs(options or {}) do
        _body[camelToUnderscore(key)] = value
    end
    url = url:format(ENGINES[_body.engine] or ENGINES[DEFAULT_ENGINE])

    _body.engine = nil
    local body = json.encode(_body)

    local headers = {
        ["Authorization"] = "Bearer " .. API_KEY,
        ["Content-Type"] = "application/json",
    }

    local Promise = promise:new()
    PerformHttpRequest(url, function(status, rbody, rheaders, errorData)
        if (status == 200) then
            Promise:resolve(json.decode(rbody))
            return
        end

        Promise:reject({ status = status, errorData = errorData })
    end, method, body, headers)

    local data = Citizen.Await(Promise)
    return data
end

local function Complete(opts)
    local url = ENDPOINTS.completions
    return SendRequest(url, "POST", opts)
end

exports("Complete", Complete)


-- Basic usage example
RegisterCommand("askclifford", function(source, args, rawCommand)
    local question = table.concat(args, " ")

    TriggerClientEvent('chat:addMessage', source, {
        color = { 0, 192, 255 },
        multiline = true,
        args = { "\nYou: ", question }
    })

    -- Create the prompt with the user's question
    -- For more info about prompts check out:
    --  https://beta.openai.com/docs/guides/completion/prompt-design
    local prompt =
        "Clifford is an evil, sarcastic, sassy, creepy and unhelpful chatbot that reluctantly answers questions.\n\n" ..
        "You: What is FiveM?\n" ..
        "AI: Really? You're literally playing it right now.\n\n" ..
        "You: What's 9 + 10?\n" ..
        "AI: I don't awnser such boring questions, try something more interesting.\n\n" ..
        "You: What is the meaning of life?\n" ..
        "AI: I'm not sure. I'll ask my friend Google.\n\n" ..
        "You: " .. question .. "\n" ..
        "AI:"

    local data = Complete({
        engine = "text-davinci-003",
        prompt = prompt,
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

    TriggerClientEvent('chat:addMessage', source, {
        color = { 175, 2, 249 },
        multiline = true,
        args = { "\nClifford:", data.choices[1].text }
    })

    -- Uncomment the following line to view the entire response.
    -- print(json.encode(data, { indent = true }))
end, false)
