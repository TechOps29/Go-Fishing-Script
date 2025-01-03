-- Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Variables
local running = false
local cooldown = 0.001
local lastFightClickTime = 0

-- Notification Function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5; -- Default duration is 5 seconds
    })
end

-- Fishing Functions
local function opFightClick()
    if os.clock() - lastFightClickTime >= cooldown then
        ReplicatedStorage.events.fishing.fightClick:FireServer()
        lastFightClickTime = os.clock()
    end
end

local function startFightWithFish()
    ReplicatedStorage.events.fishing.startFightLocal:FireServer()
end

local function throwBait()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local position = character.HumanoidRootPart.Position

    local args = {
        [1] = 1,
        [2] = Vector3.new(position.X, position.Y, position.Z),
        [3] = Vector3.new(position.X, position.Y, position.Z)
    }

    ReplicatedStorage.events.fishing.throwBait:InvokeServer(unpack(args))
end

-- Toggle Functionality
local function toggleFishing()
    running = not running
    notify("LUNAR", "To Start/End Press Q")

    if running then
        -- Fishing loop
        while running do
            opFightClick()
            startFightWithFish()
            throwBait()
            task.wait(0.1) -- A slight delay to prevent excessive calls
        end
    end
end

-- Keybind Listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        toggleFishing()
    end
end)

-- Initial Notification
notify("LUNAR", "To Start/End Press Q")
