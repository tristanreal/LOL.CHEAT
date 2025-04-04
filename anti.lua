-- Advanced Anti-Cheat System
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local ASCII_Art = {
    " ▄▄▄     ▄▄▄▄▄▄▄ ▄▄▄          ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ",
    "█   █   █       █   █        █       █  █ █  █       █       █       █",
    "█   █   █   ▄   █   █        █       █  █▄█  █    ▄▄▄█   ▄   █▄     ▄█",
    "█   █   █  █ █  █   █        █     ▄▄█       █   █▄▄▄█  █▄█  █ █   █  ",
    "█   █▄▄▄█  █▄█  █   █▄▄▄ ▄▄▄ █    █  █   ▄   █    ▄▄▄█       █ █   █  ",
    "█       █       █       █   ██    █▄▄█  █ █  █   █▄▄▄█   ▄   █ █   █  ",
    "█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄██▄▄▄▄▄▄▄█▄▄█ █▄▄█▄▄▄▄▄▄▄█▄▄█ █▄▄█ █▄▄▄█  "
}

-- Function to display ASCII art gradually
local function revealASCII()
    for _, line in ipairs(ASCII_Art) do
        print(line)
        task.wait(0.5) -- Reveal line by line
    end
end

-- Detect Flying
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        task.spawn(function()
            while task.wait(1) do
                if humanoid.FloorMaterial == Enum.Material.Air then
                    print("Fly detected! Flinging player...")
                    character:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame() + Vector3.new(0, 500, 0))
                    task.wait(3)
                    if character:GetPrimaryPartCFrame().Y < 50 then
                        character:BreakJoints()
                        print("Player exploded for trying to return!")
                    end
                end
            end
        end)
    end)
end)

-- Chat Spam Detection
local muteTime = {}
Players.PlayerAdded:Connect(function(player)
    muteTime[player.UserId] = 0
    player.Chatted:Connect(function(msg)
        if muteTime[player.UserId] > os.time() then
            print("Chat spam detected! Muting player.")
            player:Kick("Muted for spamming chat.")
        else
            muteTime[player.UserId] = os.time() + 60 -- Increase mute time progressively
        end
    end)
end)

-- Teleport Hack Detection
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local oldPos = character:GetPrimaryPartCFrame().Position
        task.spawn(function()
            while task.wait(1) do
                local newPos = character:GetPrimaryPartCFrame().Position
