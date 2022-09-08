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
	application_id: number?
}

export type ExecuteParams = {
	content: string?,
	username: string?,
	avater_url: string?,
	tts: boolean?,
	embeds: {Embed.Embed}?,
	allowed_mentions: {
		parse: {string}?,
		users: {string}?
	}
}

--[[
Handles webhooks object

@class Webhook
--]]
local Webhook = {}
Webhook.__index = Webhook


--[[
Enforces the rules on given params

@param params ExecuteParams -- The param to enforce rules on
]]
local function CheckParams(params: ExecuteParams)
	-- Prevents content and embeds being empty
	if typeof(params.content) == "nil" and typeof(params.embeds) == "nil" then
		error("You can't execute a webhook without content or embeds.")
	end
	
	if typeof(params.content) == "string" and params.content:len() > 2000 then
		error("Too many characters in content, limit is up to 2000 characters.")
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
				warn("[DAPI.Embed]: Title has", embed.title:len(), "characters")
				error("Embed title has too many characters, limit is up to 256 characters.")
			end
			stringCount += embed.title:len()
			
			if embed.description:len() > 1024 then
				warn("[DAPI.Embed]: Description has", embed.description:len(), "characters")
				error("Embed description has too many characters, limit is up to 1024 characters")
			end
			stringCount += embed.description:len()

			if typeof(embed.fields) == "table" then
				local countFields = 0
				
				for _, field in embed.fields do
					countFields += 1
					
					if countFields > 25 then
						error("Embed has too many fields, limit is up to 25 fields.")
					end
					
					if field.name and field.name:len() > 256 then
						warn("[DAPI.Embed.Field]: Field name has", field.name:len(), "characters")
						error("Field name has too many characters, limit is up to 256.")
					elseif field.value and field.value:len() > 1024 then
						warn("[DAPI.Embed.Field]: Field value has", field.value:len(), "characters")
						error("Field value has too many characters, limit is up to 1024 characters.")
					end
					stringCount += field.name:len()
					stringCount += field.value:len()
				end
			end
			
			if embed.footer and embed.footer.text:len() > 2048 then
				warn("[DAPI.Embed]: Footer has", embed.footer.text:len(), "characters")
				error("Embed footer text has too many characters, limit is up to 2048 characters.")
			end
			stringCount += embed.footer.text:len()
			
			if embed.author and embed.author.name:len() > 256 then
				warn("[DAPI.Embed]: Author name has", embed.author.name:len(), "characters")
				error("Embed author name has too many characters, limit is up to 256 characters")
			end
			stringCount += embed.author.name:len()
			
			if stringCount > 6000 then
				warn("[DAPI.Embed]: Embed has", stringCount, "characters")
				error("Embed has too many characters, the sum of title, description, field.name, field.value, footer.text, and author.name is above the limit. The limit is up to 6000")
			end
		end
		
		if countEmbeds > 10 then
			error("Too many embeds, limit is up to 10 embeds.")
		end
	end
end


--[[
Updates the webhook object and allows you to change it to a different one

@param url -- The url to get information and execute from. (Needs Post and Get methods)

@return boolean -- succesfully got information
]]
function Webhook:Update(url: string)
	local gotResponse, response = pcall(
		HttpService.GetAsync,
		HttpService,
		url
	)
	if gotResponse == false then
		error("Failed to get webhook information from url, are you sure that you have turned on http requests?\nError message from url: " .. response)
	end
	
	local success, decoded = HttpService:JSONDecode(response)
	if success == false then
		error("Failed to decode url response,  url response was: " .. response .. "\nError message from decode: " .. decoded)
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

	return true
end

--[[
Executes the webhook with given params
]]
function Webhook:Execute(params: ExecuteParams, override: boolean?)
	if override == true then
		warn("[DAPI]: Executing webhook with override true, this may lead to errors.")
		
		local success, encoded = pcall(
			HttpService.JSONEncode,
			HttpService,
			params
		)
		if success == false then
			error("Failed to encode params, are you sure that your table only has string and numbers?\nError message: " .. encoded)
		end
		
		local posted, response = pcall(
			HttpService.PostAsync,
			HttpService,
			self.url,
			encoded,
			Enum.HttpContentType.ApplicationJson
		)
		if posted == false then
			error("Failed to execute webhook, http service might be down.\nError message: " .. response)
		end
		
		return
	end
	
	local passed, reason = pcall(
		CheckParams,
		params
	)
	if passed == false then
		error("Params don't meet requirements.\nError message: " .. reason)
	end
	
	local success, encoded = pcall(
		HttpService.JSONEncode,
		HttpService,
		params
	)
	if success == false then
		error("Failed to encode params, are you sure that your table only has string and numbers?\nError message: " .. encoded)
	end

	local posted, response = pcall(
		HttpService.PostAsync,
		HttpService,
		self.url,
		encoded,
		Enum.HttpContentType.ApplicationJson
	)
	if posted == false then
		error("Failed to execute webhook, http service might be down.\nError message: " .. response)
	end

	return
end


--[[
Creates a new webhook object

@param webhookURL string -- The url that redirects to your webhook.

@return Webhook -- The created webhook class
]]
function Webhook.new(webhookURL: string)
	local self = setmetatable({}, Webhook)

	local succes, response = pcall(self.Update, self, webhookURL)

	if succes == false then
		error("Failed to create new webhook, \nError message: " .. response)
	end

	return self
end

return Webhook
