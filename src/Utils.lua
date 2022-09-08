local Utils = {}

function Utils.CheckArgument(types: {string}, ...: any)
    for index, argument in ipairs({...}) do
        if typeof(argument) ~= types[index] then
            if types[index]:find("?") and typeof(argument) == "nil" then
                continue
            end
            error("Expected " .. types[index] .. ", got " .. typeof(argument))
        end
    end
end

return Utils