local firstTime = true
local termoProp = nil
local mateProp = nil

local function createProp(propName, bone, x, y, z, xRot, yRot, zRot)
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    local prop = CreateObject(GetHashKey(propName), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, bone), x, y, z, xRot, yRot, zRot, true, true, false, true, 1, true)
    return prop
end

-- Comando para cebar y tomar mate
RegisterCommand("tomarmate", function()
    local playerPed = PlayerPedId()
    
    -- Verificar si está de pie
    if not IsPedOnFoot(playerPed) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Sistema", "No puedes tomar mate mientras estas en un vehiculo o sentado."}
        })
        return
    end

    if firstTime then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Sistema", "Ay! El mate esta muy caliente!"}
        })
        firstTime = false
    end

    RequestAnimDict("mp_player_intdrink")
    while not HasAnimDictLoaded("mp_player_intdrink") do
        Citizen.Wait(100)
    end
    termoProp = createProp("prop_termos", 57005, 0.1, -0.1, 0.0, -90.0, 0.0, 0.0) -- Ajusta la posición y rotación según sea necesario
    mateProp = createProp("prop_mate", 18905, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0)

    TaskPlayAnim(playerPed, "mp_player_intdrink", "loop_bottle", 8.0, -8, -1, 49, 0, false, false, false)
    Citizen.Wait(3000) -- Esperar 3 segundos para simular el cebado
    ClearPedTasks(playerPed)
    TaskPlayAnim(playerPed, "mp_player_intdrink", "loop_bottle", 8.0, -8, -1, 49, 0, false, false, false)
    Citizen.Wait(5000) -- Esperar 5 segundos mientras toma el mate

    ClearPedTasks(playerPed)
    DeleteObject(termoProp)
    DeleteObject(mateProp)
    termoProp = nil
    mateProp = nil
end, false)

AddEventHandler('playerSpawned', function()
    firstTime = true
end)
