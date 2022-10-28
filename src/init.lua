--[[
Description: API wrapper for Discord
Author: GGshor
Date: 27 October, 2022
]]

local Embed = require(script.Embed)
local Utils = require(script.Utils)
local Webhook = require(script.Webhook)

--[[
    Making it easier to send message through webhooks.

    @class RoCord
]]
local RoCord = {}

function RoCord:AddEmbed(title: string?, description: string?, color: Color3?)
	local embed = Embed.new(title, description, color)

	table.insert(self.body.embeds, embed)

	return embed
end

function RoCord:SendMessage(content: string, username: string?)
	Utils.CheckArgumentCharacters({ Utils.Limits.Content}, content)
	self.webhook:Execute()
end

function RoCord:ChangeWebhook(webhookUrl: string)
	self.webhook:Update(webhookUrl)
end

--[[
	Inits a new setup
]]
function RoCord.new(webhookURL: string)
	local self = setmetatable({}, RoCord)

	self.webhook = Webhook.new(webhookURL)

	self.body = {
		content = "",
		username = self.webhook.name,
		tts = false,
		embeds = {},
	}

	return self
end

return RoCord
