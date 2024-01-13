Discord = {}


Discord.Webhook = "ENTER_YOUR_WEBHOOK"
Discord.WebhookDebug = "ENTER_YOUR_DEBUG_WEBHOOK_HERE (OPTIONAL)"
Discord.botName = "K3-TIKTOK"

Discord.Settings = { -- identifiers to log (true = enabled, false = disabled)
    xbl = true,
    discord = true,
    steam = true,
    ip = true,
    license = true,
    fivem = true,
}

-- Function for discord logging (dont touch if you dont know what you are doing)
local DiscordColors = {
    red = 16711680,
    green = 65280,
    blue = 255,
    yellow = 16776960,
    purple = 8388736,
}

function getPlayerIdentifiers(xPlayer)
    local identifiers = {}
    for _, id in ipairs(GetPlayerIdentifiers(xPlayer.source)) do
        if string.match(id, "xbl:") and Discord.Settings.xbl then
            identifiers.xbox = id
        elseif string.match(id, "discord:") and Discord.Settings.discord then
            identifiers.discord = id
        elseif string.match(id, "steam:") and Discord.Settings.steam then
            identifiers.steam = id
        elseif string.match(id, "ip:") and Discord.Settings.ip then
            identifiers.ip = id
        elseif string.match(id, "license:") and Discord.Settings.license then
            identifiers.license = id
        elseif string.match(id, "fivem:") and Discord.Settings.fivem then
            identifiers.fivem = id
        end
    end
    return identifiers
end

function logToDiscord(title, message, color, channel, xPlayer)
    local webhook = channel == 'debug' and Discord.WebhookDebug or Discord.Webhook
    local embedColor = DiscordColors[color] or DiscordColors["green"] -- Default color is green for success messages

    local identifiers = xPlayer and getPlayerIdentifiers(xPlayer) or {}

    local function extractID(id)
        return id and string.match(id, ":(.+)") or "N/A"
    end

    local function createCodeBlock(id)
        return string.format('`%s`', extractID(id)) or "`N/A`"
    end

    local function createField(name, value, inline)
        return {name = name, value = value or "`N/A`", inline = inline or true}
    end

    local fields = {
        createField("Name", xPlayer and K3.Functions.PlayerName(xPlayer.source) or "N/A"),
        createField("Rockstar ID", createCodeBlock(xPlayer and K3.Functions.GetIdentifier(xPlayer.source) or "N/A")),
        createField("Xbox License", createCodeBlock(identifiers.xbox)),
        createField("Discord ID", createCodeBlock(identifiers.discord)),
        createField("Steam", createCodeBlock(identifiers.steam)),
        createField("IP", createCodeBlock(identifiers.ip)),
        createField("License", createCodeBlock(identifiers.license)),
        createField("FiveM", createCodeBlock(identifiers.fivem)),
        createField("Discord Mention", identifiers.discord and "<@" .. extractID(identifiers.discord) .. ">", false),
    }

    local embeds = {{
        title = "**"..title.."**",
        description = message,
        type = "rich",
        color = embedColor,
        footer = { text = os.date("%Y.%m.%d ||| %X") },
        fields = fields,
    }}

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = Discord.botName, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
