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
	inline: boolean?
}


local Embed = {}

return Embed
