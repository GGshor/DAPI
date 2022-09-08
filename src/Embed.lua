export type Embed = {
	title: string,
	type: string, -- Always rich
	description: string,
	url: string?,
	timestamp: string?,
	color: number?,
	footer: EmbedFooter?,
	fields: {EmbedField}?,
	author: EmbedAuthor?
}

export type EmbedFooter = {
	text: string,
	icon_url: string?,
	proxy_icon_url: string?
}

export type EmbedImage = {
	url: string,
	proxy_url: string?,
	height: number?,
	width: number?
}

export type EmbedThumbnail = EmbedImage
export type EmbedVideo = EmbedImage

export type EmbedProvider = {
	name: string?,
	url: string?
}

export type EmbedAuthor = {
	name: string,
	url: string?,
	icon_url: string?,
	proxy_icon_url: string?
}

export type EmbedField = {
	name: string,
	value: string,
	inline: boolean
}

local Utils = require(script.Parent.Utils)

local Embed = {}
Embed.__index = Embed


function Embed:AddField(name: string, value: string, inline: boolean?)
	Utils.CheckArgument({"string", "value", "boolean?"}, name, value, inline)
end

function Embed:CountCharacters()
	local result = {total=0}

	if self.title then
		result.title = self.title:len()
		result.total += self.title:len()
	end

	if self.description then
		result.description = self.description:len()
		result.total += self.description:len()
	end

	for field: EmbedField in self.fields do
		result.fields[field.name] = field.value:len() + field.name:len()
		result.total += field.value:len() + field.name:len()
	end

	if self.footer then
		result.footer = self.footer:len()
		result.total += self.footer:len()
	end

	if self.author then
		result.author = self.author.name:len()
		result.total += self.author.name:len()
	end

	return result.total, result
end

function Embed.new()
	
end

return Embed
