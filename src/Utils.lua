local HttpService = game:GetService("HttpService")

local Utils = {
	["Limits"] = { -- Max amount that is allowed
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

function Utils.CheckArgumentTypes(types: { string }, ...: any)
	for index, argument in ipairs({ ... }) do
		if typeof(argument) ~= types[index] then
			if types[index]:find("?") and typeof(argument) == "nil" then
				continue
			end
			error("Expected " .. types[index] .. ", got " .. typeof(argument))
		end
	end

	return true
end

function Utils.CheckArgumentCharacters(limits: { number }, ...: string)
	for index, argument in ipairs({ ... }) do
		if argument:len() > limits[index] then
			error("Expected " .. tostring(limits[index]) .. "characters or less, got " .. tostring(argument:len()))
		end
	end

	return true
end

function Utils.CheckUrl(url: string)
	if string.find(url, "http", 1) then
		local success, response = pcall(HttpService.GetAsync, HttpService, url)

		if success then
			return true
		else
			warn("[DAPI]: Got bad response while checking url, response:", response)
			return false, "bad response"
		end
	else
		return false
	end
end

function Utils.RGBtoHex(color: Color3)
	return string.format("#%02X%02X%02X", color.R * 0xFF, color.G * 0xFF, color.B * 0xFF)
end

function Utils.HextoRGB(hex: string)
	local r, g, b = string.match(hex, "^#?(%w%w)(%w%w)(%w%w)$")
	return Color3.fromRGB(tonumber(r, 16),tonumber(g, 16), tonumber(b, 16))
end

return Utils
