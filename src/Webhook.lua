--[[
Description: Webhook class, handles execution and information of webhook.
Author: GGshor
Date: 04 September, 2022
]]

local HttpService = game:GetService("HttpService")

local Embed = require(script.Parent.Embed)

export type WebhookData = {
	id: number,
	type: number,
	guild_id: number,
	channel_id: number,
	name: string,
	avatar: string,
	token: string,
	application_id: number?,
}
export type ExecuteParams = {
	content: string?,
	username: string?,
	avater_url: string?,
	tts: boolean?,
	embeds: { Embed.Embed }?,
	allowed_mentions: {
		parse: { string }?,
		users: { string }?,
	},
}

--[[
Handles webhook object

@class Webhook
]]
local Webhook = {}
Webhook.__index = Webhook

--[=[
	Enforces the rules on given params.

	@param params ExecuteParams -- The parameters to enforce rules on

	@error "EmptyBody" -- You need at least content or embeds
	@error "TooMany" -- Object has too many characters or too many embeds/fields
]=]
local function CheckParams(params: ExecuteParams)
	-- Prevents content and embeds being empty
	if typeof(params.content) == "nil" and typeof(params.embeds) == "nil" then
		error("You can't execute a webhook without content or embeds.")
	end

	if typeof(params.content) == "string" and params.content:len() > 2000 then
		error("Content has " .. tostring(params.content:len()) .. ", limit is up to 2000 characters.")
	end

	if type(params.embeds) == "table" then
		local countEmbeds = 0

		for _, embed in params.embeds do
			countEmbeds += 1

			local stringCount = 0

			if countEmbeds > 10 then
				error("Too many embeds, limit is up to 10 embeds.")
			end

			if embed.title:len() > 256 then
				error(
					"Embed title has "
						.. tostring(embed.title:len())
						.. " characters, but the limit is up to 256 characters."
				)
			end
			stringCount += embed.title:len()

			if embed.description:len() > 1024 then
				error(
					"Embed description has "
						.. tostring(embed.description:len())
						.. " characters, but the limit is up to 1024 characters"
				)
			else
				stringCount += embed.description:len()
			end

			if typeof(embed.fields) == "table" then
				local countFields = 0

				for _, field in embed.fields do
					countFields += 1

					if countFields > 25 then
						error("Embed has too many fields, limit is up to 25 fields.")
					end

					if field.name:len() > 256 then
						error(
							"A field name has "
								.. tostring(field.name:len())
								.. " characters, but the limit is up to 256.\nName: "
								.. field.name
						)
					elseif field.value:len() > 1024 then
						error(
							"Field value has "
								.. tostring(field.value:len())
								.. " characters, but the limit is up to 1024 characters.\nName: "
								.. field.name
						)
					end
					stringCount += field.name:len()
					stringCount += field.value:len()
				end
			end

			if embed.footer and embed.footer.text:len() > 2048 then
				error(
					"Embed footer text has "
						.. tostring(embed.footer.text:len())
						.. " characters, but the limit is up to 2048 characters."
				)
			else
				stringCount += embed.footer.text:len()
			end

			if embed.author and embed.author.name:len() > 256 then
				error(
					"Embed author name has "
						.. tostring(embed.author.name:len())
						.. " characters, limit is up to 256 characters"
				)
			else
				stringCount += embed.author.name:len()
			end

			if stringCount > 6000 then
				error(
					"Embed has "
						.. tostring(stringCount)
						.. " characters, the sum of title, description, field.name, field.value, footer.text, and author.name"
						.. "is above the limit. The limit is up to 6000"
				)
			end
		end

		if countEmbeds > 10 then
			error("Too many embeds, limit is up to 10 embeds.")
		end
	end
end

--[=[
	Updates the webhook object and allows you to change it to a different one

	@param url -- The url to get information and execute from. (Needs Post and Get methods)

	@error "ResponseFailure" -- Http service might be turned off
	@error "DecodeError" -- Was unable to run json decode from response
]=]
function Webhook:Update(url: string)
	local gotResponse, response = pcall(HttpService.GetAsync, HttpService, url)
	if gotResponse == false then
		error(
			"Failed to get webhook information from url, are you sure that you have turned on http requests?"
				.. "\nError message from url: "
				.. response
		)
	end

	local success, decoded = HttpService:JSONDecode(response)
	if success == false then
		error(
			"Failed to decode url response,  url response was: "
				.. response
				.. "\nError message from decode: "
				.. decoded
		)
	end

	self.url = url

	self.id = decoded.id
	self.name = decoded.name
	self.avatar = decoded.avatar
	self.guild_id = decoded.guild_id
	self.channel_id = decoded.channel_id
	self.token = decoded.token

	if decoded.application_id then
		self.application_id = decoded.application_id
	end

	return
end

--[=[
	Executes the webhook with given params.

	@param params ExecuteParams -- The table with all the parameters
	@param override boolean? -- If you wish to override the checks

	@error "EncodeError" -- Unable to json encode the params, try running it without override
	@error "ExecuteError" -- If the post pcall failed for some reason, most likely http service
	@error "ParamsCheckError" -- Check parameters failed
]=]
function Webhook:Execute(params: ExecuteParams, override: boolean?)
	if override == true then
		warn("[DAPI]: Executing webhook with override true, this may lead to the webhook not executing correctly.")

		local success, encoded = pcall(HttpService.JSONEncode, HttpService, params)
		if success == false then
			error(
				"Failed to encode params, are you sure that your table only has string and numbers?"
					.. "\nError message: "
					.. encoded
			)
		end

		local posted, response =
			pcall(HttpService.PostAsync, HttpService, self.url, encoded, Enum.HttpContentType.ApplicationJson)
		if posted == false then
			error("Failed to execute webhook, http service might be down." .. "\nError message: " .. response)
		end

		return
	end

	local passed, reason = pcall(CheckParams, params)
	if passed == false then
		error("Params don't meet requirements." .. "\nError message: " .. reason)
	end

	local success, encoded = pcall(HttpService.JSONEncode, HttpService, params)
	if success == false then
		error(
			"Failed to encode params, are you sure that your table only has string and numbers?"
				.. "\nError message: "
				.. encoded
		)
	end

	local posted, response =
		pcall(HttpService.PostAsync, HttpService, self.url, encoded, Enum.HttpContentType.ApplicationJson)
	if posted == false then
		error("Failed to execute webhook, http service might be down." .. "\nError message: " .. response)
	end

	return
end

--[=[
	Creates a new webhook object

	@param webhookURL string -- The url that redirects to your webhook.

	@return Webhook -- The created webhook class

	@error "WebhookError" -- Something went wrong while making a new webhook
]=]
function Webhook.new(webhookURL: string)
	local self = setmetatable({}, Webhook)

	local succes, response = pcall(self.Update, self, webhookURL)

	if succes == false then
		error("Failed to create new webhook," .. "\nError message: " .. response)
	end

	return self
end

return Webhook
