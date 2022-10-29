--[[
	Description: Utils, helps with arguments and converting stuff.
	Author: GGshor
	Date: 28 October, 2022
]]

local HttpService = game:GetService("HttpService")

--[=[
	Holds the limits in the class so you don't forget them

	@class Utils
]=]
local Utils = {
	["Limits"] = { -- Max amount that is allowed
		["Content"] = 2000,
		["UserName"] = 32,
		["Title"] = 256,
		["Description"] = 4096,
		["Fields"] = {
			["Name"] = 256,
			["Value"] = 1024,
			["Text"] = 2048,
			["MaxFields"] = 25,
		},
		["Author"] = {
			["Name"] = 256,
		},
		["MaxCharacters"] = 6000,
	},
}

--[=[
	Checks if the given types are the same as arguments

	@param types {string} -- The array with the types
	@param ... any -- Arguments

	@error "Unexpected" -- If one of the arguments is not the same as given type it will error
]=]
function Utils.CheckArgumentTypes(types: { string }, ...: any)
	for index, argument in ipairs({ ... }) do
		if typeof(argument) ~= types[index] then
			if types[index]:find("?") and typeof(argument) == "nil" then
				continue
			end
			error("Expected " .. types[index] .. ", got " .. typeof(argument))
		end
	end

	return
end

--[=[
	Checks if the arguments doesn't go over the character limit.

	@param limits {number} -- Array of limits
	@param ... string -- Arguments

	@error "Unexpected" -- When character amount is above the limits
]=]
function Utils.CheckArgumentCharacters(limits: { number }, ...: string)
	for index, argument in ipairs({ ... }) do
		if argument:len() > limits[index] then
			error("Expected " .. tostring(limits[index]) .. "characters or less, got " .. tostring(argument:len()))
		end
	end

	return
end

--[=[
	Checks if the url is valid and also does get a get to be sure.

	@param url string -- The url to check

	@error "InvalidURL" -- Given url is invalid
	@error "BadResponse" -- Got bad response from url
]=]
function Utils.CheckUrl(url: string)
	if string.find(url, "http", 1) then
		local success, response = pcall(HttpService.GetAsync, HttpService, url)

		if success == false then
			error("Got bad response from url, response: " .. tostring(response))
		end
	else
		error("Given URL is invalid")
	end
end

--[=[
	Transforms Color3 to Hex value

	@param color Color3 -- The color3 to transform

	@return string -- The new hex value
]=]
function Utils.RGBtoHex(color: Color3)
	return string.format("#%02X%02X%02X", color.R * 0xFF, color.G * 0xFF, color.B * 0xFF)
end

--[=[
	Transforms Hex value back to Color3.

	@param hex string -- The hex value to transform

	@return Color3 -- The new color3 value
]=]
function Utils.HextoRGB(hex: string)
	local r, g, b = string.match(hex, "^#?(%w%w)(%w%w)(%w%w)$")
	return Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end

return Utils
