--[[
	Description: Embed class, making sure that does not go over any limits
	Author: GGshor
	Date: 28 October, 2022
]]

local Utils = require(script.Parent.Utils)

export type Embed = {
	title: string,
	type: string, -- Always rich
	description: string,
	url: string?,
	timestamp: string?,
	color: number?,
	footer: EmbedFooter?,
	image: EmbedImage,
	thumbnail: EmbedThumbnail,
	video: EmbedVideo,
	provider: EmbedProvider,
	author: EmbedAuthor?,
	fields: { EmbedField }?,
}

export type EmbedFooter = {
	text: string,
	icon_url: string?,
	proxy_icon_url: string?,
}

export type EmbedImage = {
	url: string,
	proxy_url: string?,
	height: number?,
	width: number?,
}

export type EmbedThumbnail = EmbedImage
export type EmbedVideo = EmbedImage

export type EmbedProvider = {
	name: string?,
	url: string?,
}

export type EmbedAuthor = {
	name: string,
	url: string?,
	icon_url: string?,
	proxy_icon_url: string?,
}

export type EmbedField = {
	name: string,
	value: string,
	inline: boolean,
}

--[=[
	Embeds class, allows you to easily change the embed.
]=]
local Embed = {}
Embed.__index = Embed

--[=[
	Sets the title of the embed.

	@param title string -- The new title
]=]
function Embed:SetTitle(title: string)
	Utils.CheckArgumentTypes({ "string" }, title)
	Utils.CheckArgumentCharacters({ Utils.Limits.Title }, title)

	self.title = title
end

--[=[
	Sets description of the embed.

	@param description string -- The new description
]=]
function Embed:SetDescription(description: string)
	Utils.CheckArgumentTypes({ "string" }, description)
	Utils.CheckArgumentCharacters({ Utils.Limits.Description }, description)

	self.description = description
end

--[=[
	Sets the url of the embed.

	@param url string -- The new url
]=]
function Embed:SetURL(url: string)
	Utils.CheckArgumentTypes({ "string" }, url)
	Utils.CheckUrl(url)

	self.url = url
end

--[=[
	Removes the url of the embed.
]=]
function Embed:RemoveURL()
	self.url = nil
end

--[=[
	Sets the timestamp of the embed.

	@param timestamp DateTime -- The new timestamp
]=]
function Embed:SetTimestamp(timestamp: DateTime)
	Utils.CheckArgumentTypes({ "DateTime" }, timestamp)

	self.timestamp = timestamp:ToIsoDate()
end

--[=[
	Removes the timestamp of the embed.
]=]
function Embed:RemoveTimestamp()
	self.timestamp = nil
end

--[=[
	Sets the color of the embed.

	@param color Color3 -- The new color
]=]
function Embed:SetColor(color: Color3)
	Utils.CheckArgumentTypes({ "Color3" }, color)

	self.color = Utils.RGBtoHex(color)
end

--[=[
	Sets the footer of the embed.

	@param text string -- The text of the footer
	@param icon_url string? -- Adds an icon to the footer
	@param proxy_icon_url string? -- Proxy version of icon_url
]=]
function Embed:SetFooter(text: string, icon_url: string?, proxy_icon_url: string?)
	Utils.CheckArgumentTypes({ "string", "string?", "string?" }, text, icon_url, proxy_icon_url)
	Utils.CheckArgumentCharacters({ Utils.Limits.Footer.Text }, text)

	if icon_url then
		Utils.CheckUrl(icon_url)
	end

	if proxy_icon_url then
		Utils.CheckUrl(proxy_icon_url)
	end

	self.footer = {
		text = text,
		icon_url = icon_url,
		proxy_icon_url = proxy_icon_url,
	}
end

--[=[
	Removes the footer of the embed.
]=]
function Embed:RemoveFooter()
	self.footer = nil
end

--[=[
	Adds an image to the embed.

	@param url string -- The url of the image
	@param proxy_url string? -- Proxy version of the url
	@param height number? -- The height of the image
	@param width number? -- The width of the image
]=]
function Embed:SetImage(url: string, proxy_url: string?, height: number?, width: number?)
	Utils.CheckArgumentTypes({ "string", "string?", "number?", "number?" }, url, proxy_url, height, width)
	Utils.CheckUrl(url)

	if proxy_url then
		Utils.CheckUrl(proxy_url)
	end

	self.image = {
		url = url,
		proxy_url = proxy_url,
		height = height,
		width = width,
	}
end

--[=[
	Removes the image
]=]
function Embed:RemoveImage()
	self.image = nil
end

--[=[
	Adds a thumbnail to the embed.

	@param url string -- The url of the thumbnail
	@param proxy_url string? -- Proxy version of the url
	@param height number? -- The height of the thumbnail
	@param width number? -- The width of the thumbnail
]=]
function Embed:SetThumbnail(url: string, proxy_url: string?, height: number?, width: number?)
	Utils.CheckArgumentTypes({ "string", "string?", "number?", "number?" }, url, proxy_url, height, width)
	Utils.CheckUrl(url)

	if proxy_url then
		Utils.CheckUrl(proxy_url)
	end

	self.thumbnail = {
		url = url,
		proxy_url = proxy_url,
		height = height,
		width = width,
	}
end

--[=[
	Removes the thumbnail.
]=]
function Embed:RemoveThumbnail()
	self.thumbnail = nil
end

--[=[
	Adds a video to the embed.

	@param url string -- The url of the video
	@param proxy_url string? -- Proxy version of the url
	@param height number? -- The height of the video
	@param width number? -- The width of the video
]=]
function Embed:SetVideo(url: string, proxy_url: string?, height: number?, width: number?)
	Utils.CheckArgumentTypes({ "string", "string?", "number?", "number?" }, url, proxy_url, height, width)
	Utils.CheckUrl(url)

	if proxy_url then
		Utils.CheckUrl(proxy_url)
	end

	self.video = {
		url = url,
		proxy_url = proxy_url,
		height = height,
		width = width,
	}
end

--[=[
	Removes the video.
]=]
function Embed:RemoveVideo()
	self.video = nil
end

--[=[
	Sets the provider of the embed.

	@param name string? -- The name of the provider
	@param url string? -- The url of the provider
]=]
function Embed:SetProvider(name: string?, url: string?)
	Utils.CheckArgumentTypes({ "string?", "string?" }, name, url)

	if url then
		Utils.CheckUrl(url)
	end

	self.provider = {
		name = name,
		url = url,
	}
end

--[=[
	Removes the provider from the embed.
]=]
function Embed:RemoveProvider()
	self.provider = nil
end

--[=[
	Sets the author of the embed.

	@param name string -- Name of the author
	@param url string? -- Adds an url to author
	@param icon_url string? -- Adds an image to the author

	@error "UrlFail" -- Something went wrong while checking the url
]=]
function Embed:SetAuthor(name: string, url: string?, icon_url: string?)
	Utils.CheckArgumentTypes({ "string", "string?", "string?" }, name, url, icon_url)

	if url then
		Utils.CheckUrl(url)
	end

	if icon_url then
		Utils.CheckUrl(icon_url)
	end

	self.author = {
		name = name,
		url = url,
		icon_url = icon_url,
	}
end

--[=[
	Removes the author from the embed.
]=]
function Embed:RemoveAuthor()
	table.clear(self.author)
end

--[=[
	Adds a field to the embed.

	@param name string -- Field name
	@param value string -- Value of field
	@param inline boolean? -- Should the field be inline?
]=]
function Embed:AddField(name: string, value: string, inline: boolean?)
	Utils.CheckArgumentTypes({ "string", "string", "boolean?" }, name, value, inline)
	Utils.CheckArgumentCharacters({ Utils.Limits.Fields.Name, Utils.Limits.Fields.Value }, name, value)

	table.insert(self.fields, {
		name = name,
		value = value,
		inline = inline or false,
	})
end

--[=[
	Allows you to add a custom field to the embed.

	@param field EmbedField -- The field to add
]=]
function Embed:AppendField(field: EmbedField)
	table.insert(self.fields, field)
end

--[=[
	Inserts a field at the given index.

	@param index number -- The index to insert it at
	@param name string -- Field name
	@param value string -- Value of field
	@param inline boolean? -- Should the field be inline?
]=]
function Embed:InsertFieldAt(index: number, name: string, value: string, inline: boolean?)
	Utils.CheckArgumentTypes({ "number", "string", "string", "boolean?" })
	Utils.CheckArgumentCharacters({ Utils.Limits.Fields.Name, Utils.Limits.Fields.Value }, name, value)

	table.insert(self.fields, index, {
		name = name,
		value = value,
		inline = inline or false,
	})
end

--[=[
	Removes a certain field.

	@param index number -- The index to remove
]=]
function Embed:RemoveField(index: number)
	Utils.CheckArgumentTypes({ "number" }, index)

	table.remove(self.fields, index)
end

--[=[
	Removes all fields.
]=]
function Embed:ClearFields()
	table.clear(self.fields)
end

--[=[
	Counts all the characters in the embed

	@return (number, {}) -- Returns the amount and the table containing the structure
]=]
function Embed:CountCharacters()
	local result = { total = 0 }

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

--[=[
	Creates a new Embed.

	@param title string? -- Title of embed
	@param description string? -- The description of the embed
	@param color Color3? -- The color of the embed
	@param url string? -- The url of the embed
	@param timestamp DateTime? -- The timestamp of the embed

	@return Embed
]=]
function Embed.new(title: string?, description: string?, color: Color3?, url: string?, timestamp: DateTime?)
	local self = setmetatable({}, Embed)

	Utils.CheckArgumentTypes(
		{ "string?", "string?", "Color3?", "string?", "DateTime?" },
		title,
		description,
		color,
		url,
		timestamp
	)
	Utils.CheckArgumentCharacters({ Utils.Limits.Title, Utils.Limits.Description }, title, description)

	self.title = title or ""
	self.description = description or ""

	if color then
		self.color = Utils.RGBtoHex(color)
	end

	if timestamp then
		self.timestamp = timestamp:ToIsoDate()
	end

	if url then
		self.url = url
	end

	return self
end

return Embed
