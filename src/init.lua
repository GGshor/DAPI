--[[
Description: API wrapper for Discord
Author: GGshor
Date: 27 October, 2022
]]

local Embed = require(script.Embed)
local Utils = require(script.Utils)
local Webhook = require(script.Webhook)

--[[
    Service for all classes

    @class RoCord
]]
local RoCord = {}

function RoCord:CreateEmbed(title: string?, description: string?, color: Color3?, url: string?, timestamp: number?)
	return Embed.new(title, description, color, url, timestamp)
end

function RoCord:SendMessage(content: string, username: string?)
	-- do something
end

function RoCord:Init(webhookURL: string)
	self.webhook = Webhook.new(webhookURL)

	self.body = {
		content = "",
		username = self.webhook.name,
	}
end

return RoCord
