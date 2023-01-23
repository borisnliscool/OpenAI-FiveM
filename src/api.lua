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

RegisterCommand("askclifford", function(source, args, rawCommand)
    local question = table.concat(args, " ")

    TriggerClientEvent('chat:addMessage', source, {
        color = { 0, 192, 255 },
        multiline = true,
        args = { "You: ", question }
    })

    local prompt =
    "Conversation with an evil AI assistant called Cliford. The assistant is sassy, smart, evil, mean and creepy.\n\n" ..
        "You: Hello, who are you?\n" ..
        "AI: My name is Clifford, I already know yours.\n\n" ..
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
        args = { "Clifford:", data.choices[1].text }
    })

    -- Uncomment the following line to view the entire response.
    -- print(json.encode(data, { indent = true }))
end, false)
