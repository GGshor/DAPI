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

local Embed = {type="rich"}
Embed.__index = Embed


function Embed:AddField(name: string, value: string, inline: boolean?)
	Utils.CheckArgumentTypes({"string", "string", "boolean?"}, name, value, inline)
	Utils.CheckArgumentCharacters({256, 1024}, name, value)

	table.insert(self.fields, {
		name = name,
		value = value,
		inline = inline or false
	})
end

function Embed:AppendField(field: EmbedField)
	table.insert(self.fields, field)
end

function Embed:InsertFieldAt(index: number, name: string, value: string, inline: boolean?)
	Utils.CheckArgumentTypes({"number", "string", "string", "boolean?"})
	Utils.CheckArgumentCharacters({256, 1024}, name, value)

	table.insert(self.fields, index, {
		name = name,
		value = value,
		inline = inline or false
	})
end

function Embed:RemoveAuthor()
	table.clear(self.author)
end

function Embed:RemoveFooter()
	table.clear(self.footer)
end

function Embed:RemoveImage()
	table.clear(self.image)
end

function Embed:RemoveThumbnail()
	table.clear(self.thumbnail)
end

function Embed:SetAuthor(name: string, url: string?, icon_url: string?)
	-- NOTE: For url check with string.find, example: string.find(url, "https", 1) -- Starts at characters  1 of the url
	-- TODO: Work further on this
end

function Embed:ClearFields()
	table.clear(self.fields)
end

function Embed:RemoveField(index: number)
	Utils.CheckArgumentTypes({"number"}, index)

	table.remove(self.fields, index)
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

function Embed.new(title: string?, description: string?, color: Color3?, url: string?, timestamp: number?, fields: {EmbedField}?)
	local self = setmetatable({}, Embed)

	if Utils.CheckArgumentTypes({"string"}, title) and Utils.CheckArgumentCharacters({256}, title) then
		self.title = title
	end

	if Utils.CheckArgumentTypes({"string"}, description) and Utils.CheckArgumentCharacters({1024}, description) then
		self.description = description
	end
	return
end

return Embed
