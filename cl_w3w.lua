local wordsList = LoadResourceFile(GetCurrentResourceName(), "words.txt")
local words = {}

TriggerEvent('chat:addSuggestion', '/w3w', 'Get your current W3W or search for another', {
    { name="Words", help="Example: london.studios.test" },
})

function magiclines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

function all_trim(s)
    return s:match"^%s*(.*)":match"(.-)%s*$"
end

for line in magiclines( wordsList ) do
    local t = line=="" and "(blank)" or line
    local s = all_trim(line)
    if string.len(tostring(s)) > 1 then
        table.insert(words, tostring(s))
    end
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


RegisterCommand("w3w", function(source, args)
    local ped = PlayerPedId()
    if args[1] == nil then
        local coords = GetEntityCoords(ped)
        local index1 = round(math.abs((coords.x + 8000)) / 8)
        local word1 = words[index1]
        local index2 = round(math.abs((coords.y + 8000)) / 8)
        local word2 = words[index2]
        local word3 = words[index1 + 10]
        chatMessage("Your location is "..word1.."."..word2.."."..word3..".")        
    else
        if args[1] then
            local newWords = mysplit(args[1], ".")
            if newWords[1] ~= nil and newWords[2] ~= nil then 
                local index1 = round((tableIndex(words, newWords[1]) * 8) - 8000)
                local index2 = round((tableIndex(words, newWords[2]) * 8) - 8000)
                if index1 ~= nil and index2 ~= nil then
                    local coords = vector3(index1, index2, 20.0)
                    local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
                    if found then coords.groundZ = groundZ end
                    ClearGpsPlayerWaypoint()
                    SetNewWaypoint(coords.x, coords.y)
                    chatMessage("Waypoint set for "..args[1])
                else
                    chatMessage("Invalid W3W location")
                end
            else return end
            
        end
    end
end, false)

function round(n)
    return math.floor(n + 0.5)
end

function chatMessage(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"W3W", message}
    })
end

function tableIndex(table, value)
    for k in pairs(table) do
        if table[k] == value then
            return k
        end
    end
    return nil
end