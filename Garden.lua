-- سكربت رئيسي للعبة ازرع حديقة في Roblox
-- هذا السكربت يدير عملية الزرع والري والنمو بشكل عملي

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- إنشاء RemoteEvents إذا لم تكن موجودة
local PlantEvent = ReplicatedStorage:FindFirstChild("PlantSeed") or Instance.new("RemoteEvent", ReplicatedStorage)
PlantEvent.Name = "PlantSeed"
local WaterEvent = ReplicatedStorage:FindFirstChild("WaterPlant") or Instance.new("RemoteEvent", ReplicatedStorage)
WaterEvent.Name = "WaterPlant"

-- جدول لتخزين النباتات لكل لاعب
local playerGardens = {}

-- دالة لزرع البذور
local function plantSeed(player, seedType, position)
    local plant = Instance.new("Part")
    plant.Size = Vector3.new(2,2,2)
    plant.Position = position
    plant.BrickColor = BrickColor.new("Bright green")
    plant.Anchored = true
    plant.Name = "Plant"
    plant.Parent = workspace
    -- حفظ بيانات النبات
    playerGardens[player.UserId] = playerGardens[player.UserId] or {}
    table.insert(playerGardens[player.UserId], {instance = plant, type = seedType, growth = 0})
end

-- دالة لري النباتات
local function waterPlant(player, plantInstance)
    for _, plantData in ipairs(playerGardens[player.UserId] or {}) do
        if plantData.instance == plantInstance then
            plantData.growth = plantData.growth + 1
            plantInstance.BrickColor = BrickColor.new("Earth green")
            plantInstance.Size = plantInstance.Size + Vector3.new(0.5,0.5,0.5)
        end
    end
end

-- ربط الأحداث
PlantEvent.OnServerEvent:Connect(function(player, seedType, position)
    plantSeed(player, seedType or "Seed", position)
end)

WaterEvent.OnServerEvent:Connect(function(player, plantInstance)
    waterPlant(player, plantInstance)
end)

-- ملاحظة: تحتاج لسكربتات جهة اللاعب (Client) لإرسال الأحداث عند الزرع أو الري
-- مثال: عند الضغط بزر الماوس يرسل PlantSeed، وعند الضغط على زر E يرسل WaterPlant
