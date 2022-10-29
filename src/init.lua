--[[
Description: API wrapper for Discord
Author: GGshor
Date: 27 October, 2022
]]

local Embed = require(script.Embed)
local Utils = require(script.Utils)
local Webhook = require(script.Webhook)

--[=[
    Making it easier to send messages through webhooks.

    @class RoCord
]=]
local RoCord = {}

--[=[
	Adds an embed to the message and returns the embed so that you can change it.

	@param title string? -- Title of the embed
	@param description string? -- Description of the embed
	@param color Color3? -- Color of the embed

	@return Embed
]=]
function RoCord:AddEmbed(title: string?, description: string?, color: Color3?)
	local embed = Embed.new(title, description, color)

	table.insert(self.body.embeds, embed)

	return embed
end

--[=[
	Sends the message with added embeds.
	If the message was send succesfully then body is cleared back to default.

	@param content string? -- The text of the message
	@param username string? -- Override the username of webhook
]=]
function RoCord:SendMessage(content: string?, username: string?)
	if content then
		Utils.CheckArgumentTypes({ "string" }, content)
		Utils.CheckArgumentCharacters({ Utils.Limits.Content }, content)

		self.body.content = content
	end

	if username then
		Utils.CheckArgumentTypes({ "string" }, username)
		Utils.CheckArgumentCharacters({ Utils.Limits.UserName }, username)

		if username:len() < 2 then
			error("Expected username to have more than 2 characters, got " .. tostring(username:len()))
		end

		self.body.username = username
	end

	self.webhook:Execute(self.body)

	self.body = {
		content = "",
		username = self.webhook.name,
		tts = false,
		embeds = {},
	}
end

--[=[
	Updates the webhook url.

	@param webhookURL string -- The new webhook url
]=]
function RoCord:ChangeWebhook(webhookURL: string)
	self.webhook:Update(webhookURL)
end

--[=[
	Creates a new webhook setup.

	@param webhookURL string -- The webhook url, can be a proxy but needs to support get and post requests

	@return RoCord
]=]
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
