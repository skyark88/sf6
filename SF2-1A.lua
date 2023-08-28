print("Loading...");
--开局是否加载全部地图
load_all_map_when_start = false
Invisfunc = function()
	local removeNametags = false;
	local plr = game:GetService("Players").LocalPlayer;
	local character = plr.Character;
	local hrp = character.HumanoidRootPart;
	local old = hrp.CFrame;
	if (not character:FindFirstChild("LowerTorso") or (character.PrimaryPart ~= hrp)) then
		return print("unsupported");
	end
	if removeNametags then
		local tag = hrp:FindFirstChildOfClass("BillboardGui");
		if tag then
			tag:Destroy();
		end
		hrp.ChildAdded:Connect(function(item)
			if item:IsA("BillboardGui") then
				task.wait();
				item:Destroy();
			end
		end);
	end
	local newroot = character.LowerTorso:Clone();
	hrp.Parent = workspace;
	character.PrimaryPart = hrp;
	character:MoveTo(Vector3.new(old.X, 8999999488, old.Z));
	hrp.Parent = character;
	task.wait(0.5);
	newroot.Parent = hrp;
	hrp.CFrame = old;
end;


if ((#game.Players:GetPlayers() > 1) and isfile("SFS Sript/set") and (readfile("SFS Sript/set") == "true")) then
	Invisfunc();
end
local ConfigurationName = "SFS-stable";
local udatas_file_name = "udatas-stable.json"
local closest = nil;
local selectedEgg = "Molten Egg";
local SelectedRelic = "";
local selecetWeaponGroup = "";
local ExpRelicList = {};
local Secret = {};
local RarityWl = {};
local DisRarityWl = {};
local DisSkillList = {}
local Eggs = {};
local DisplayEggs = {};
--local AreaMobsList = {};
--local RelicLabelList = {};
--local RelicButtonList = {};
local RelicPresetSetting = {Selected=nil,Default=nil,Dungeon=nil,BloodMoon=nil,Ngiht=nil};
local MobBlackList = {};
local MobWhiteList = {};
local BloodMoonSelectMobList = {};
--local WeaponLabelList = {};
--local WeaponButtonList = {};
--local RollList = {};
local EnchantsRefuse = {};
local PetEnchantsRefuse = {};
local SelectedEnchant;
local SelectedPetEnchant;
local InfiniteJump = false;
local isBloodMoon = false;
local isServerBoss = false;
local isKillServerBoss = false;
local isSunBurst = false;
local isNight = false;
local hasUsedBoosts = false;
local hasUsedBoostsQuest = false;
local nhasUsed = false;
local bhasUsed = false;
local shasUsed = false;
local nhasUsedQuest = false;
local bhasUsedQuest = false;
local shasUsedQuest = false;
local InDungeon = false;
local InTower = false
local EvenBeforeSunBurst = ""
insane_dungeon_seen_mobs = {}
local BloodMoonMingInit = false;
--1:"Not started" 2:"working on 1" 3:"1 finished" 4:"working on 2"  5:"2 finished"

local CorruptMingStatus = 1
local Nighting = false;
local SunBursting = false;
local SolarEclipseing = false;
local KillingGlobalBoss = false;
local ActiveRaid = nil;
local ContinueButtonUID = false;
local DungeonContinueButton = false;
local Buy_Egg_Args = {eggName="Egg 25",auto=false,amount=4};

local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local KnitService = game:GetService("ReplicatedStorage").Packages.Knit.Services;
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Workspace = game:GetService("Workspace");
local Knit_Pkg = require(game:GetService("ReplicatedStorage").Packages.Knit);
local PlayerData = Knit_Pkg.GetController("DataController"):GetData("PlayerData");
local SwordDatabase = Knit_Pkg.GetController("DatabaseController"):GetDatabase("Weapons");
local EggsDatabase = Knit_Pkg.GetController("DatabaseController"):GetDatabase("Eggs");
local PetsDatabase = Knit_Pkg.GetController("DatabaseController"):GetDatabase("Pets");
local GlobalBoss = Knit_Pkg.GetController("DatabaseController"):GetDatabase("GlobalBoss");
local UIController = Knit_Pkg.GetController("UIController");
local TPController = Knit_Pkg.GetController("TeleportController");
local WController = Knit_Pkg.GetController("WheelController");
local KWController = Knit_Pkg.GetController("KoreanWheelController");
local NPCController = Knit_Pkg.GetController("NPCController");
local IllusionistService = Knit_Pkg.GetService("IllusionistService");
local SkillService = Knit_Pkg.GetService("SkillService");
local Dungeon_Service = Knit_Pkg.GetService("DungeonService");
local NPCService = Knit_Pkg.GetService("NPCService");
local ClickService = Knit_Pkg.GetService("ClickService")
local LimitedController = Knit_Pkg.GetController("LimitedShopsController");
local Util = require(Knit_Pkg.Util.Utility);
local MyGui = Instance.new("ScreenGui");


--local Knit_Pkg = require(game:GetService("ReplicatedStorage").Packages.Knit);
NPCsDatabase = Knit_Pkg.GetController("DatabaseController"):GetDatabase("NPCs")
mobs_big_table = {}
local AreaMaps = {"Fragment","Comet","Server Boss"}
local AllMobs = {["Fragment"]={},["Comet"]={},["Server Boss"]={}}
local BloodMoonMobs = {}
local ServerBossList = {}
local FragmentList = {}
local CometList = {}
local GlobalBossList = {}
local SpecialMobsList = {}

for i,npc in next, NPCsDatabase do
	if npc.isComet then
		table.insert(CometList, npc.name)
		table.insert(AllMobs["Comet"], npc.name)
	elseif npc.isFragment then
		table.insert(FragmentList, npc.name)
		table.insert(AllMobs["Fragment"], npc.name)
	elseif npc.isGlobalBoss then
		table.insert(GlobalBossList, npc.name)
	else
        
		if mobs_big_table[npc.index] then
            mob_id = npc.index
            while mobs_big_table[mob_id] do
                mob_id = mob_id + 1
            end
			mobs_big_table[mob_id] = npc
		else
			mobs_big_table[npc.index] = npc
		end
	end
end
table.sort(AllMobs["Fragment"])
table.sort(AllMobs["Comet"])
local mobs_big_table_keys = {}
for k in pairs(mobs_big_table) do
	table.insert(mobs_big_table_keys, k)
end
table.sort(mobs_big_table_keys)
for i, k in ipairs(mobs_big_table_keys) do
	if mobs_big_table[k].area then
		local area_npc = mobs_big_table[k]
		if not AllMobs[area_npc.area] then
			AllMobs[area_npc.area] = {}
			table.insert(AreaMaps, area_npc.area)
		end
		table.insert(AllMobs[area_npc.area], area_npc.name)
		if area_npc.eventDrops and area_npc.eventDrops.BloodEvent  then
			table.insert(BloodMoonMobs, area_npc.name)
		end
	else
		local noarea_npc = mobs_big_table[k]
		print(noarea_npc.name, noarea_npc.eventDrops)
		if noarea_npc.eventDrops then
			table.insert(AllMobs["Server Boss"], noarea_npc.name)
			table.insert(ServerBossList, noarea_npc.name)
		else
			table.insert(SpecialMobsList, noarea_npc.name)
		end
	end
end
for ii, vv in AllMobs do
	print(ii, vv)
end



local repo = "https://gitee.com/wrk226/SFS/raw/master/LinoriaLibUI/";
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))();
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))();
SaveManager:SetFolder("SFSConfiguration");
SaveManager:SetLibrary(Library);
local Window = Library:CreateWindow({Title="SFS Sript",
									 Center=true,
									 AutoShow=true,
									--Size = UDim2.fromOffset(550, 340)
});
--added code
local my_UDatas = {}
--local my_Labels = {}
local Labels = {}
--------------------
--Library:CreateUserData("UDatas");
local Tabs = {MainTab=Window:AddTab("主目录-地牢"),RelicTab=Window:AddTab("饰品-事件"),Farm=Window:AddTab("扫荡-宠物-其他"),MiscTab=Window:AddTab("筛选器"),EnchantTab=Window:AddTab("附魔-技能")};
local AutoClick = Tabs.MainTab:AddLeftGroupbox("自动点击");
local Pet = Tabs.MainTab:AddLeftGroupbox("宠物");
local Weapon = Tabs.MainTab:AddLeftGroupbox("武器");

local Dungeon = Tabs.MainTab:AddRightGroupbox("地牢");
local Tower = Tabs.MainTab:AddRightGroupbox("塔");
local Raid = Tabs.MainTab:AddLeftGroupbox("突袭");
local BloodMoonEvent = Tabs.RelicTab:AddLeftGroupbox("血月事件");
local HightEvent = Tabs.RelicTab:AddLeftGroupbox("夜晚事件");
local Upgrade = Tabs.RelicTab:AddRightGroupbox("升级");
local UpgradeList = Tabs.RelicTab:AddRightGroupbox("升级列表");
local OtherEvent = Tabs.RelicTab:AddRightGroupbox("其他事件");
local AutoFarmBox = Tabs.Farm:AddLeftGroupbox("自动扫荡");
local BlackList = Tabs.Farm:AddLeftGroupbox("排除列表");
local WhiteListList = Tabs.Farm:AddLeftGroupbox("保留列表");
local Egg = Tabs.Farm:AddRightGroupbox("宠物");
local Misc = Tabs.Farm:AddRightGroupbox("其他");
local Filter = Tabs.MiscTab:AddLeftGroupbox("武器筛选器");
local FilterList = Tabs.MiscTab:AddLeftGroupbox("武器筛选列表");
local PetFilter = Tabs.MiscTab:AddRightGroupbox("宠物筛选器");
local PetFilterList = Tabs.MiscTab:AddRightGroupbox("宠物筛选列表");
local Enchant = Tabs.EnchantTab:AddLeftGroupbox("附魔");
--local RollList = Tabs.EnchantTab:AddLeftGroupbox("附魔列表");
local Skill = Tabs.EnchantTab:AddRightGroupbox("技能");
local SkillList = Tabs.EnchantTab:AddRightGroupbox("技能列表");
Library:OnUnload(function()
	MyGui:Destroy();
end);
AutoClick:AddToggle("AutoPower", {Text="快速点击",Default=false,Tooltip="快速点击"});
AutoClick:AddToggle("AutoPowerDuringNight", {Text="夜晚和日照时自动开启快速点击",Default=false,Tooltip="快速点击"});
AutoClick:AddSlider("AuraDistance", {Text="索敌距离",Default=40,Min=0,Max=50,Rounding=0,Compact=false});
AutoClick:AddSlider("ClickSpeed", {Text="点击速度(建议1-5,高了容易崩溃)",Default=1,Min=0,Max=100,Rounding=0,Compact=false});

AutoClick:AddButton("加载所有地图", function()
	for i, v in next, EggsDatabase do
		wait(0.1)
		LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[v.name].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
	end
end);


Pet:AddToggle("AutoDismantle", {Text="自动拆解",Default=false,Tooltip="自动拆解"});
Pet:AddSlider("DismantleDelay", {Text="拆解延迟",Default=60,Min=0,Max=100,Rounding=0,Compact=false});
Pet:AddToggle("DisRarityCheck", {Text="稀有度检测",Default=false,Tooltip="Rarity Check"});
Pet:AddDropdown("PetAddToWhitelist", {Values={"Common","Rare","Epic","Legendary","Mythic","Secret"},Default=0,Multi=true,Text="加入保留列表",Tooltip="加入保留列表"});
Weapon:AddToggle("AutoSell", {Text="自动售卖",Default=false,Tooltip="自动售卖"});
Weapon:AddSlider("SWordSellDelay", {Text="售卖延迟",Default=30,Min=0,Max=100,Rounding=0,Compact=false});
Weapon:AddToggle("WeaponRarityCheck", {Text="稀有度检测",Default=false,Tooltip="稀有度检测"});
Weapon:AddDropdown("WeaponAddtoWhitelist", {Values={"Common","Rare","Epic","Legendary","Mythic","Secret"},Default=0,Multi=true,Text="加入保留列表",Tooltip="加入保留列表"});
Egg:AddToggle("AutoOpenEggs", {Text="自动开蛋",Default=false,Tooltip="自动开蛋"});
Egg:AddToggle("IgnoreOpneAmination", {Text="跳过开蛋动画",Default=false,Tooltip="跳过开蛋动画"});
Egg:AddDropdown("EggsSelected", {Values={},Default=0,Multi=false,Text="目标蛋",Tooltip="目标蛋"});
Egg:AddDropdown("EggsAmounts", {Values={1,2,3,4},Default=0,Multi=false,Text="开蛋数量",Tooltip="开蛋数量"});
Egg:AddButton("传送到目标蛋", function()
	LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
end);
Dungeon:AddToggle("AutoEasy", {Text="自动简单地牢",Default=false,Tooltip="自动简单地牢"});
Dungeon:AddSlider("EasyRoom", {Text="层数",Default=30,Min=0,Max=50,Rounding=0,Compact=false});
Dungeon:AddToggle("AutoHard", {Text="自动困难地牢",Default=false,Tooltip="自动困难地牢"});
Dungeon:AddSlider("HardRoom", {Text="层数",Default=30,Min=0,Max=50,Rounding=0,Compact=false});
Dungeon:AddToggle("AutoInsane", {Text="自动炼狱地牢",Default=false,Tooltip="自动炼狱地牢"});
Dungeon:AddSlider("InsaneRoom", {Text="层数",Default=30,Min=0,Max=160,Rounding=0,Compact=false});
Dungeon:AddSlider("WaitTime", {Text="等待时间",Default=0,Min=0,Max=1,Rounding=2,Compact=false});
--Dungeon:AddInput("UseDamageRooms", {Default="0",Numeric=true,Finished=false,Text="困难地牢自动使用攻击药的层数",Tooltip="困难地牢自动使用攻击药的层数",Placeholder="Placeholder text"});
Dungeon:AddInput("UseInsaneBoostRooms", {Default="0",Numeric=true,Finished=false,Text="炼狱地牢自动吃药的层数",Tooltip="炼狱地牢自动吃药的层数",Placeholder="Placeholder text"});

Dungeon:AddToggle("InsaneAutoUseDmg", {Text="伤害药水",Default=false,Tooltip="伤害药水"})
Dungeon:AddToggle("InsaneAutoUseDmgQuest", {Text="任务伤害药水",Default=false,Tooltip="任务伤害药水"});
Dungeon:AddToggle("InsaneAutoUseLuck", {Text="幸运药水",Default=false,Tooltip="幸运药水"})
Dungeon:AddToggle("InsaneAutoUseLuckQuest", {Text="任务幸运药水",Default=false,Tooltip="任务幸运药水"});
Dungeon:AddToggle("InsaneAutoUseSecretLuck", {Text="秘密幸运药水",Default=false,Tooltip="秘密幸运药水"})
Dungeon:AddToggle("InsaneAutoUseSecretLuckQuest", {Text="任务秘密幸运药水",Default=false,Tooltip="任务秘密幸运药水"});



--Dungeon:AddInput("UseInsaneLuckRooms", {Default="0",Numeric=true,Finished=false,Text="炼狱地牢自动使用幸运药的层数",Tooltip="炼狱地牢自动使用幸运药的层数",Placeholder="Placeholder text"});
Dungeon:AddDropdown("DungeonWeapon", {Values={},Default=0,Multi=false,Text="炼狱地牢装备",Tooltip="选取炼狱地牢装备"});
Dungeon:AddButton("重置地牢状态", function()
	InDungeon = false;
	insane_dungeon_seen_mobs = {}
end);

Dungeon:AddSlider("insane_dungeon_delay", {Text="炼狱地牢每层停留时间",Default=0,Min=0,Max=10,Rounding=0,Compact=false});
Tower:AddToggle("AutoTower", {Text="自动爬塔",Default=false,Tooltip="自动爬塔"});
Tower:AddSlider("TowerRoom", {Text="层数",Default=55,Min=0,Max=55,Rounding=0,Compact=false});
Tower:AddButton("重置塔状态", function()
	print("292-intower:",InTower)
	InTower = false;
	towerlock1 = false
	zero = false
end);
Raid:AddToggle("AutoRaid", {Text="自动突袭",Default=false,Tooltip="自动突袭"});
Labels.UpgradeId = UpgradeList:AddLabel("升级饰品ID", "", true);
Labels.UpgradeName = UpgradeList:AddLabel("升级饰品名", "", true);
Labels.UpgradeExp = UpgradeList:AddLabel("升级饰品经验", "", true);
Upgrade:AddToggle("AutoUpgradeRelic", {Text="自动升级饰品",Default=false,Tooltip="自动升级饰品"});
Labels.BlackList = Upgrade:AddLabel("熔炼列表", "20/25");
Upgrade:AddButton("增加所有到熔炼列表", function()
	for i, v in pairs(PlayerData.RelicAutoDelete) do
		if not v then
			KnitService.RelicInvService.RF.ToggleAutoDelete:InvokeServer(i);
			wait();
		end
	end
end);
Upgrade:AddButton("保存熔炼清单", function()
	ExpRelicList = {};
	for i, v in pairs(PlayerData.RelicAutoDelete) do
		if v then
			table.insert(ExpRelicList, i);
			KnitService.RelicInvService.RF.ToggleAutoDelete:InvokeServer(i);
			wait();
		end
	end
	my_UDatas["ExpRelicList"] = ExpRelicList
	--UserDatas.UDatas:SetValue("ExpRelicList", ExpRelicList);
	--my_Labels['BlackList'] = "All:" .. #ExpRelicList
	Labels.BlackList:SetText("All:" .. #ExpRelicList);
end):AddButton("选择要升级的饰品", function()
	local selec = nil;
	for i, v in pairs(LocalPlayer.PlayerGui.Inventory.Background.ImageFrame.Window.Frames.ItemsFrame.ItemsHolder.ItemsScrolling:GetChildren()) do
		if (v:IsA("Frame") and (v.Frame.Selected.Visible == true)) then
			selec = v.Name;
		end
	end
	if selec then
		SelectedRelic = selec;
		--my_Labels["UpgradeId"] = selec
		Labels.UpgradeId:SetText(selec);
		my_UDatas["UpgradeId"] = selec
		--UserDatas.UDatas:SetValue("UpgradeId", selec);
		--my_Labels["UpgradeName"] = PlayerData.RelicInv[selec].name
		Labels.UpgradeName:SetText(PlayerData.RelicInv[selec].name);
		my_UDatas["UpgradeName"] = PlayerData.RelicInv[selec].name
		--UserDatas.UDatas:SetValue("UpgradeName", PlayerData.RelicInv[selec].name);
		--my_Labels["UpgradeExp"] = PlayerData.RelicInv[selec].exp
		Labels.UpgradeExp:SetText(PlayerData.RelicInv[selec].exp);
		my_UDatas["UpgradeExp"] = PlayerData.RelicInv[selec].exp
		--UserDatas.UDatas:SetValue("UpgradeExp", PlayerData.RelicInv[selec].exp);
	else
		--my_Labels["UpgradeId"] = "NULL"
		Labels.UpgradeId:SetText("NULL");
	end
end);
Upgrade:AddDropdown("Relic_DefaultWeaponGroup", {Values={},Default=0,Multi=false,Text="默认装备",Tooltip="默认装备"});
AutoFarmBox:AddToggle("autoFarm", {Text="自动扫荡",Default=false,Tooltip="自动扫荡"});
AutoFarmBox:AddToggle("FarmAllMap", {Text="扫荡所有地图",Default=false,Tooltip="扫荡所有地图"});
AutoFarmBox:AddToggle("FarmSelectedMobs", {Text="扫荡选定怪",Default=false,Tooltip="扫荡选定怪"});
Labels.MonstersLabel = AutoFarmBox:AddLabel("怪物列表", "list");
AutoFarmBox:AddDropdown("SelectedArea", {Values=AreaMaps,Default=0,Multi=false,Text="选择地图",Tooltip="选择地图"});
AutoFarmBox:AddDropdown("SelectedMob", {Values={},Default=0,Multi=true,Text="排除列表",Tooltip="排除列表"});
Labels.BlackListLabel = BlackList:AddLabel("排除列表", "", true);
Labels.WhiteListLabel =  WhiteListList:AddLabel("保留列表", "", true);
AutoFarmBox:AddDropdown("OtherMob", {Values={},Default=0,Multi=true,Text="保留列表",Tooltip="保留列表"});
AutoFarmBox:AddButton("保存排除列表", function()
	--my_Labels["BlackListLabel"] = ""
	Labels.BlackListLabel:SetText("");
	local MobBlackListStr = "";
	for key, value in next, Options.SelectedMob.Value do
		if not table.find(MobBlackList, key) then
			table.insert(MobBlackList, key);
		end
	end
	for key, value in next, MobBlackList do
		MobBlackListStr = MobBlackListStr .. value .. "\n";
	end
	if (#MobBlackList == 0) then
		MobBlackListStr = MobBlackListStr .. "is NULL";
	end
	--my_Labels["BlackListLabel"] = MobBlackListStr
	Labels.BlackListLabel:SetText(MobBlackListStr);
	my_UDatas["MobBlackList"] =  MobBlackList
	--UserDatas.UDatas:SetValue("MobBlackList", MobBlackList);
end):AddButton("保存保留列表", function()
	--my_Labels["WhiteListLabel"] = ""
	Labels.WhiteListLabel:SetText("");
	local MobWhiteListStr = "";
	for key, value in next, Options.OtherMob.Value do
		if not table.find(MobWhiteList, key) then
			table.insert(MobWhiteList, key);
		end
	end
	for key, value in next, MobWhiteList do
		MobWhiteListStr = MobWhiteListStr .. value .. "\n";
	end
	if (#MobWhiteList == 0) then
		MobWhiteListStr = MobWhiteListStr .. "is NULL";
	end
	--my_Labels["WhiteListLabel"] = MobWhiteListStr
	Labels.WhiteListLabel:SetText(MobWhiteListStr);
	my_UDatas["MobWhiteList"]=MobWhiteList
	--UserDatas.UDatas:SetValue("MobWhiteList", MobWhiteList);
end);
AutoFarmBox:AddButton("清除排除列表", function()
	--my_Labels["BlackListLabel"] = ""
	Labels.BlackListLabel:SetText("");
	MobBlackList = {};
	my_UDatas["MobBlackList"]=MobBlackList
	--UserDatas.UDatas:SetValue("MobBlackList", MobBlackList);
end):AddButton("清除保留列表", function()
	--my_Labels["WhiteListLabel"] = ""
	Labels.WhiteListLabel:SetText("");
	MobWhiteList = {};
	my_UDatas["MobWhiteList"]=MobWhiteList
	--UserDatas.UDatas:SetValue("MobWhiteList", MobWhiteList);
end);
AutoFarmBox:AddSlider("FarmSpeed", {Text="刷怪速度",Default=5,Min=0,Max=10,Rounding=0,Compact=false});
BloodMoonEvent:AddToggle("BloodMoonCheck", {Text="血月事件监测",Default=false,Tooltip="血月事件检测"});
BloodMoonEvent:AddToggle("CorruptEventCheck", {Text="腐坏事件监测",Default=false,Tooltip="Corrupt Event Check"});
BloodMoonEvent:AddLabel("自动使用药水", "自动使用药水", false);
BloodMoonEvent:AddToggle("AutoUseLuck", {Text="幸运药水",Default=false,Tooltip="幸运药水"})
BloodMoonEvent:AddToggle("AutoUseLuckQuest", {Text="任务幸运药水",Default=false,Tooltip="任务幸运药水"});
BloodMoonEvent:AddToggle("AutoUseSecretLuck", {Text="秘密幸运药水",Default=false,Tooltip="秘密幸运药水"})
BloodMoonEvent:AddToggle("AutoUseSecretLuckQuest", {Text="任务秘密幸运药水",Default=false,Tooltip="任务秘密幸运药水"});
BloodMoonEvent:AddToggle("AutoUseCoin", {Text="金币药水",Default=false,Tooltip="金币药水"})
BloodMoonEvent:AddToggle("AutoUseCoinQuest", {Text="任务金币药水",Default=false,Tooltip="任务金币药水"});
--BloodMoonEvent:AddToggle("AutoUsePower", {Text="力量药水",Default=false,Tooltip="力量药水"})
--BloodMoonEvent:AddToggle("AutoUsePowerQuest", {Text="任务力量药水",Default=false,Tooltip="任务力量药水"});
BloodMoonEvent:AddToggle("AutoUseDmg", {Text="伤害药水",Default=false,Tooltip="伤害药水"})
BloodMoonEvent:AddToggle("AutoUseDmgQuest", {Text="任务伤害药水",Default=false,Tooltip="任务伤害药水"});
BloodMoonEvent:AddDropdown("BloodMoonSelectMob", {Values=BloodMoonMobs,Default=BloodMoonMobs,Multi=true,Text="血月扫荡列表",Tooltip="选择你要扫荡的怪物"});
BloodMoonEvent:AddDropdown("SetWeaponGroup", {Values={},Default=0,Multi=false,Text="设置血月装备",Tooltip="设置血月装备"});
HightEvent:AddToggle("EggNight", {Text="夜晚开蛋",Default=false,Tooltip="夜晚开蛋"});
HightEvent:AddToggle("EggBurst",{Text="日照开蛋",Default= false,Tooltip="日照开蛋"})
HightEvent:AddToggle("EggEclipse",{Text="日食开蛋",Default= false,Tooltip="日食开蛋"})
HightEvent:AddLabel("自动使用药水");
HightEvent:AddToggle("hAutoUseLuck", {Text="幸运药水",Default=false,Tooltip="幸运药水"})
HightEvent:AddToggle("hAutoUseLuckQuest", {Text="任务幸运药水",Default=false,Tooltip="任务幸运药水"});
HightEvent:AddToggle("hAutoUseSecretLuck", {Text="秘密幸运药水",Default=false,Tooltip="秘密幸运药水"})
HightEvent:AddToggle("hAutoUseSecretLuckQuest", {Text="任务秘密幸运药水",Default=false,Tooltip="任务秘密幸运药水"});
HightEvent:AddToggle("hAutoUsePower", {Text="力量药水",Default=false,Tooltip="力量药水"})
HightEvent:AddToggle("hAutoUsePowerQuest", {Text="任务力量药水",Default=false,Tooltip="任务力量药水"});
HightEvent:AddDropdown("hSetWeaponGroup", {Values={},Default=0,Multi=false,Text="设置夜晚装备",Tooltip="设置夜晚装备"});
OtherEvent:AddToggle("ServerBossCheck", { Text="技能boss", Default=false, Tooltip="技能boss"});
OtherEvent:AddToggle("CometCheck", { Text="自动打陨石(暂时不能用)", Default=false, Tooltip="自动打陨石"});
OtherEvent:AddToggle("FragmentCheck", { Text="自动打矿石(暂时不能用)", Default=false, Tooltip="自动打矿石"});
Misc:AddLabel("自动购买");
Misc:AddToggle("DungeonItems", {Text="地牢老商店",Default=false,Tooltip="地牢老商店"});
Misc:AddToggle("FragmentItems", {Text="地牢新商店",Default=false,Tooltip="地牢新商店"});
Misc:AddToggle("CorruptItems", {Text="腐化商店",Default=false,Tooltip="腐化商店"});
Misc:AddToggle("TravellingMerchantItems", {Text="旅行商人物品",Default=false,Tooltip="旅行商人物品"});
Misc:AddToggle("AutoClaimChests", {Text="自动开箱",Default=false,Tooltip="自动开箱"});
Misc:AddToggle("AutoHug", {Text="自动抱公主",Default=false,Tooltip="自动抱公主"});
Misc:AddToggle("InfiniteJump", {Text="无限跳跃",Default=false,Tooltip="无限跳跃"});
Misc:AddInput("PickUpRange", {Default="",Numeric=true,Finished=true,Text="拾取半径",Tooltip="拾取半径",Placeholder="PickUp Range"});
Misc:AddButton("交任务", function()
	for i, v in pairs(Knit_Pkg.GetController("DatabaseController"):GetDatabase("Questlines")) do
		task.spawn(function()
			KnitService.QuestService.RF.ActionQuest:InvokeServer(tostring(i));
		end);
		wait(0.5);
	end
end);
Misc:AddButton("打开宠物附魔机", function()
	UIController:OpenScreen("Traits");
end):AddButton("打开武器附魔机", function()
	UIController:OpenScreen("Enchant");
end);
Misc:AddButton("腐化商店", function()
	if Workspace:GetAttribute("CORRUPT_EVENT") then
		LimitedController:LoadElements("LurkingShadow");
		LimitedController:Open();
	else
		Library:Notify("没有检测到腐化事件", 5);
	end
end);
Misc:AddToggle("UnlockTP", {Text="解锁传送",Default=false,Tooltip="解锁传送"});
Misc:AddToggle("UnlockAutoSwing", {Text="解锁自动挥剑",Default=false,Tooltip="解锁自动挥剑"});
Misc:AddToggle("Invisibility", {Text="隐身",Default=false,Tooltip="隐身"});
Misc:AddToggle("pps_repair", {Text="pps修复",Default=false,Tooltip="临时用于修复pps的bug"});
Filter:AddToggle("UseFilterForAutoShell", {Text="使用脚本设置筛选武器附魔",Default=false,Tooltip="使用脚本设置筛选武器附魔"});
Filter:AddToggle("UseFilterForAutoRoll", {Text="使用附魔机设置筛选武器附魔",Default=false,Tooltip="使用附魔机设置筛选武器附魔"});
Filter:AddDropdown("Enchant", {Values={},Default=0,Multi=false,Text="Enchant",Tooltip="Enchant"});
Filter:AddDropdown("Tiers", {Values={0,1,2,3,4,5},Default=0,Multi=false,Text="Tiers",Tooltip="Tiers"});
Labels.FList = FilterList:AddLabel("筛选列表", "", true);
PetFilter:AddToggle("UsePetFilterForAutoShell", {Text="使用脚本设置筛选宠物附魔",Default=false,Tooltip="使用脚本设置筛选宠物附魔"});
PetFilter:AddDropdown("PetEnchant", {Values={},Default=0,Multi=false,Text="附魔种类",Tooltip="附魔种类"});
PetFilter:AddDropdown("PetTiers", {Values={0,1,2,3,4,5},Default=0,Multi=false,Text="附魔等级",Tooltip="附魔等级"});
Labels.PetFList = PetFilterList:AddLabel("宠物附魔列表", "", true);
--Enchant:AddToggle("AutoRoll", {Text="自动附魔",Default=false,Tooltip="自动附魔"});
--Enchant:AddToggle("CloseRollAnimation", {Text="关闭附魔动画",Default=false,Tooltip="关闭附魔动画"});
--local RollList = Tabs.EnchantTab:AddLeftGroupbox("附魔列表");
--Labels.RList = RollList:AddLabel("附魔列表", "", true);
--Enchant:AddButton("添加", function()
--	 	local selec = nil
--		for i,v in pairs(LocalPlayer.PlayerGui.WeaponInv.Background.ImageFrame.Window.WeaponHolder.WeaponScrolling:GetChildren()) do
--			if v:IsA("Frame") and v.Frame.Selected.Visible == true then
--				selec = v.Name
--			end
--		end
--		if selec and not table.find(RollList,selec) then
--			table.insert(RollList,selec)
--
--			Labels.RList:SetText("");
--			local RListStr = "";
--
--			for key, value in next, RollList.Value do
--				RListStr = RListStr .. value .. "\n";
--			end
--			if (#RList == 0) then
--				RListStr = RListStr .. "is NULL";
--			end
--			Labels.RList:SetText(RListStr);
--			my_UDatas["RList"]=RList
--
--		end
--end);


--Enchant:AddButton("锁定", function()
--			if not next(RollList) then return end
--		for _,v in pairs(RollList) do
--			if not PlayerData.WeaponInv[v].locked then
--				KnitService.WeaponInvService.RF.LockWeapon:InvokeServer(v)
--			end
--		end
--end):AddButton("清除", function()
--			RollList = {}
--		RollListDispaly:Set({
--			Title = "RollList :",
--			Content = ""
--		})
--end);

--local SkillList = Tabs.EnchantTab:AddLeftGroupbox("技能");
Skill:AddToggle("AutoSkill", {Text="自动释放技能",Default=false,Tooltip="自动释放技能"});
--Skill:AddSlider("SkillDelay", {Text="技能延迟",Default=1.5,Min=0,Max=5,Rounding=1,Compact=false});
Skill:AddDropdown("SelectSkill", {Values={},Default=0,Multi=true,Text="技能列表",Tooltip="选择你要自动释放的技能"});
--Upgrade:AddDropdown("Relic_DefaultWeaponGroup", {Values={},Default=0,Multi=false,Text="默认装备",Tooltip="默认装备"});
Labels.SklList = SkillList:AddLabel("技能列表", "", true);


getgenv()._MAIN = true;
getgenv()._POWER = false;
getgenv().do_pps_repair = false;
getgenv()._POWERNight = false;
getgenv().IsAutoSkill = false;
getgenv().AutoFarm = false;
getgenv().FarmAllMap = false;
getgenv().FarmSelected = false;
getgenv().BloodMoonCheck = false;
getgenv().ServerBossCheck = false;
getgenv().CorruptEventCheck = false;
getgenv().CometCheck = false;
getgenv().ServerBossCheck = false;
getgenv().FragmentCheck = false;
getgenv().isCorruptEvent = false;
getgenv().PetDis = false;
getgenv().SwordSell = false;
getgenv().OpEgg = false;
getgenv().ignoreAmin = false;
getgenv().UpRelic = false;
getgenv().DungeonAutoBuy = false;
getgenv().FragmentAutoBuy = false;
getgenv().CorruptAutoBuy = false;
getgenv().TravellingMerchantAutoBuy = false;
getgenv().AutoClaimChests = false;
getgenv().AutoHug = false;
getgenv().EasyDungeon = false;
getgenv().HardDungeon = false;
getgenv().InsaneDungeon = false;
--getgenv().HardDungeonUseDamage = 0;
getgenv().InsaneDungeonUseBoost = 0;
getgenv().AutoTower = false;
getgenv().AutoRaid = false;

getgenv().bAutoUseLuckBoost = false;
getgenv().bAutoUseSecretLuckBoost = false;
getgenv().bAutoUseCoinBoost = false;
getgenv().bAutoUseDmgBoost = false;
getgenv().bAutoUseLuckBoostQuest = false;
getgenv().bAutoUseSecretLuckBoostQuest = false;
getgenv().bAutoUseCoinBoostQuest = false;
getgenv().bAutoUseDmgBoostQuest = false;

getgenv().InsaneAutoUseLuckBoost = false;
getgenv().InsaneAutoUseSecretLuckBoost = false;
getgenv().InsaneAutoUseDmgBoost = false;
getgenv().InsaneAutoUseLuckBoostQuest = false;
getgenv().InsaneAutoUseSecretLuckBoostQuest = false;
getgenv().InsaneAutoUseDmgBoostQuest = false;

getgenv().nAutoUseLuckBoost = false;
getgenv().nAutoUseSecretLuckBoost = false;
getgenv().nAutoUsePowerBoost = false;
getgenv().nAutoUseLuckBoostQuest = false;
getgenv().nAutoUseSecretLuckBoostQuest = false;
getgenv().nAutoUsePowerBoostQuest = false;

getgenv().RarityCheck = false;
getgenv().DisRarityCheck = false;
getgenv().UseFilter = false;
getgenv().UsePetFilter = false;
getgenv().Distance = 45;
getgenv().ClickSpeed = 5;
getgenv().insane_dungeon_delay_time = 0;
getgenv().SwordSellDelay = 40;
getgenv().DismantleDelay = 60;
getgenv().EasyReach = 50;
getgenv().HardReach = 40;
getgenv().InsaneReach = 10;
getgenv().DungeonWaitTime = 0;
--getgenv().SkillDelayTime = 1.5;
getgenv().FarmSpeedTime = 7;
getgenv().TowerReach = 0;
getgenv().lastOpenTime = 0;
getgenv().beforePos = LocalPlayer.Character.HumanoidRootPart.CFrame;
getgenv().RollResult = {};
--getgenv().AutoRoll = false;
--getgenv().IgnRollAmin = false;
getgenv().RollUseFilter = false;
getgenv().enchantsLevel = {"I","II","III","IV","V"};
for i, v in next, EggsDatabase do
	Eggs[v.name] = i;
	table.insert(DisplayEggs, v.name);
end
Options.EggsSelected.Values = DisplayEggs;
Options.EggsSelected:SetValues();
local EnchantTables = Knit_Pkg.GetController("DatabaseController"):GetDatabase("EnchantTables");
local WeaponEnchantTable = {};
local PetEnchantTable = {};
for i, v in pairs(EnchantTables) do
	for i, v2 in pairs(v) do
		local Ratestable = Knit_Pkg.GetController("DatabaseController"):GetDatabase(v2);
		if not Ratestable then
			continue;
		end
		for i, v3 in pairs(Ratestable) do
			if not v3 then
				continue;
			end
			if (v2 == "EnchantRates") then
				table.insert(WeaponEnchantTable, v3.name);
				EnchantsRefuse[v3.name] = 0;
			end
			if (v2 == "PetEnchantRates") then
				table.insert(PetEnchantTable, v3.name);
				PetEnchantsRefuse[v3.name] = 0;
			end
		end
	end
end
Options.Enchant.Values = WeaponEnchantTable;
Options.Enchant:SetValues();
Options.PetEnchant.Values = PetEnchantTable;
Options.PetEnchant:SetValues();
local WeaponGroups = {};
local loadWeaponGroup = function()
	local Loadouts = PlayerData.Loadouts;
	local WeaponGroupOptions = {};
	for addressId, WeaponGroup in Loadouts, nil do
		WeaponGroups[WeaponGroup.Name] = addressId;
		table.insert(WeaponGroupOptions, WeaponGroup.Name);
	end
	Options.Relic_DefaultWeaponGroup.Values = WeaponGroupOptions;
	Options.Relic_DefaultWeaponGroup:SetValues();
	Options.DungeonWeapon.Values = WeaponGroupOptions;
	Options.DungeonWeapon:SetValues();
	Options.SetWeaponGroup.Values = WeaponGroupOptions;
	Options.SetWeaponGroup:SetValues();
	Options.hSetWeaponGroup.Values = WeaponGroupOptions;
	Options.hSetWeaponGroup:SetValues();
end;
local SkillGroups = {};
local loadSkills = function()
	local SkillsInv = PlayerData.SkillsInv
	local SkillsList = {}
	for skill_name, skill_value in SkillsInv, nil do
		if skill_value.amount >= 0 then
			SkillGroups[skill_name] = skill_value.amount
			table.insert(SkillsList, skill_name);
		end
	end
	Options.SelectSkill.Values = SkillsList;
	Options.SelectSkill:SetValues();
end;
loadSkills()
Skill:AddButton("重新加载技能", function()
	loadSkills();
end);
local EquipRelics = function(Preset)
	print("EquipRelics");
	task.spawn(function()
		Knit_Pkg.GetService("LoadoutService").EquipLoadout:Fire(WeaponGroups[Preset]);
		wait(2);
		Knit_Pkg.GetService("LoadoutService").EquipLoadout:Fire(WeaponGroups[Preset]);
	end);
	Knit_Pkg.GetService("LoadoutService").EquipLoadout:Fire(WeaponGroups[Preset]);
end;
loadWeaponGroup();
Upgrade:AddButton("使用默认装备", function()
	if (selecetWeaponGroup ~= nil) then
		EquipRelics(selecetWeaponGroup);
		Knit_Pkg.GetController("NotificationController"):Notification({message=("使用装备组 " .. selecetWeaponGroup),color="Red",multipleAllowed=false});
	end
end):AddButton("重新加载装备", function()
	loadWeaponGroup();
end);



local useBoost = function(Name, boost_length)
	local length = boost_length or 20
	local useBoostsTask = task.spawn(function()
		local timeleft = (length * 60) - PlayerData.Boosts[Name].timeLeft;
		while timeleft > 300 do
			boosts_not_enough = false
			if ((timeleft >= 1800) and PlayerData.Boosts[Name].remaining["1800"] and (PlayerData.Boosts[Name].remaining["1800"] > 0)) then
				KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "1800");
			elseif ((timeleft >= 1500) and PlayerData.Boosts[Name].remaining["1500"] and (PlayerData.Boosts[Name].remaining["1800"] > 0)) then
				KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "1500");
			elseif ((timeleft >= 1200) and PlayerData.Boosts[Name].remaining["1200"] and PlayerData.Boosts[Name].remaining["1200"] > 0) then
				KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "1200");
			elseif ((timeleft >= 900) and PlayerData.Boosts[Name].remaining["900"] and (PlayerData.Boosts[Name].remaining["900"] > 0)) then
				KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "900");
			elseif ((timeleft >= 600) and PlayerData.Boosts[Name].remaining["600"] and (PlayerData.Boosts[Name].remaining["600"] > 0)) then
				KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "600");
			elseif ((timeleft >= 300) and PlayerData.Boosts[Name].remaining["300"] and (PlayerData.Boosts[Name].remaining["300"] > 0)) then
				KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "300");
			else
				boosts_not_enough = true
			end
			wait(1);
			if boosts_not_enough then
				boosts_not_enough = false
				if timeleft >= 1200 then
					if PlayerData.Boosts[Name].remaining["1500"] and PlayerData.Boosts[Name].remaining["1500"] > 0 then
						KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "1500");
					elseif PlayerData.Boosts[Name].remaining["1800"] and PlayerData.Boosts[Name].remaining["1800"] > 0 then
						KnitService.BoostService.RF.UseBoost:InvokeServer(Name, "1800");
					else
						boosts_not_enough = true
					end
				end
			end
			wait(1);
			timeleft = ((length+1) * 60) - PlayerData.Boosts[Name].timeLeft;
		end
	end);
end;
local FarmAllMap_idx = 1
local Closest_NPC = function(AutoFarmMode)
	local Closest = nil;
	local Dist = Distance;
	if AutoFarmMode then
		Dist = 900000000;
	end
	if (BloodMoonCheck and isBloodMoon and next(BloodMoonSelectMobList) and AutoFarmMode) then
		--print("blood attack mode")
		--server中找到的位置是怪物出生的位置，而client中找到的位置是怪物的真实位置
		--但server会返回全图的怪，而client只返回当前地图的怪，因此血月时需要检测两次。
		for i, v in next, Workspace.Live.NPCs.Client:GetChildren() do
			--print("nearest attack mode")
			if v:IsA("Model") then
				local DstRoot = v:FindFirstChild("HumanoidRootPart");
				if not DstRoot then
					continue;
				end
				local NPCTag = DstRoot:FindFirstChild("NPCTag");
				if NPCTag and table.find(BloodMoonSelectMobList, NPCTag:FindFirstChild("NameLabel").Text) then
					--print("blood moon precise coord")
					return DstRoot
				end
			end
		end

		closest = nil
		for i, v in next, Workspace.Live.NPCs.Server:GetChildren() do
			if v:IsA("Part") then
				if table.find(BloodMoonSelectMobList, v:GetAttribute("Name")) then
					if (v:GetAttribute("Health") == 0) then
						continue;
					end
					--print("blood moon rough coord")
					return v;
				end
			end
		end
		return closest
	end

	if (ServerBossCheck and isServerBoss and not InDungeon and AutoFarmMode) then
		--print("server boss attack mode")
		for i, v in next, Workspace.Live.NPCs.Server:GetChildren() do
			if (v:IsA("Part") and table.find(ServerBossList, v:GetAttribute("Name"))) then
				if isKillServerBoss then
					return nil;
				end
				return v;
			end
		end
		print("No ServerBoss");
		isServerBoss = false;
		task.spawn(function()
			if (typeof(RelicPresetSetting.Default) == "string") then
				EquipRelics(RelicPresetSetting.Default);
			end
			wait(2);
			LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
		end);
	end

	--if (CometCheck and isComet and not InDungeon and AutoFarmMode) then
	--	--print("server boss attack mode")
	--	for i, v in next, Workspace.Live.NPCs.Server:GetChildren() do
	--		if (v:IsA("Part") and table.find(CometList, v:GetAttribute("Name"))) then
	--			if isKillComet then
	--				return nil;
	--			end
	--			return v;
	--		end
	--	end
	--	print("No Comet");
	--	isComet = false;
	--	task.spawn(function()
	--		if (typeof(RelicPresetSetting.Default) == "string") then
	--			EquipRelics(RelicPresetSetting.Default);
	--		end
	--		wait(2);
	--		LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
	--	end);
	--end
	--
	--if (FragmentCheck and isFragment and not InDungeon and AutoFarmMode) then
	--	--print("server boss attack mode")
	--	for i, v in next, Workspace.Live.NPCs.Server:GetChildren() do
	--		if (v:IsA("Part") and table.find(FragmentList, v:GetAttribute("Name"))) then
	--			if isKillFragment then
	--				return nil;
	--			end
	--			return v;
	--		end
	--	end
	--	print("No Fragment");
	--	isFragment = false;
	--	task.spawn(function()
	--		if (typeof(RelicPresetSetting.Default) == "string") then
	--			EquipRelics(RelicPresetSetting.Default);
	--		end
	--		wait(2);
	--		LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
	--	end);
	--end


	if (FarmAllMap and not InDungeon and not InTower and AutoFarmMode) then
		--print("fast attack mode")
		local idx = 0

		local children_table = Workspace.Live.NPCs.Server:GetChildren()
		if FarmAllMap_idx > #children_table then
			FarmAllMap_idx = 1
		end
		for i, v in next, children_table do
			idx = idx + 1
			if idx<FarmAllMap_idx then
				--已经攻击过
				--print("已经攻击过")
				continue
			else
				FarmAllMap_idx = idx + 1
			end
			if not v:IsA("Part") then
				continue
			end
			if (not InDungeon and FarmSelected and next(MobWhiteList) and not table.find(MobWhiteList, v:GetAttribute("Name"))) then
				--怪物不在保留列表内
				--print("怪物不在保留列表内")
				continue;
			end
			if (table.find(MobBlackList, v:GetAttribute("Name")) and not KillingGlobalBoss) then
				--怪物在排除列表内
				--print("怪物在排除列表内")
				continue;
			end
			if (v:GetAttribute("Health") == 0) then
				--怪物死亡
				--print("怪物死亡")
				continue;
			end
			if (table.find(CometList, v:GetAttribute("Name")) ) then
				--陨石停两秒
				wait(2)
			end

			return v;
		end
		return nil;
	end
	if (((InDungeon == 2) or (InDungeon == 3)) and (DungeonWaitTime > 0)) then
		wait(DungeonWaitTime);
	end
	--只读取当前地图的怪
	--print("Local attack mode")
	for i, v in next, Workspace.Live.NPCs.Client:GetChildren() do
		--print("nearest attack mode")
		if v:IsA("Model") then
			local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
			local DstRoot = v:FindFirstChild("HumanoidRootPart");
			if (not Root or not DstRoot) then
				continue;
			end
			if not InDungeon
					and not LocalPlayer:GetAttribute("Raid")
					and AutoFarm  and FarmSelected and next(MobWhiteList) then
				local NPCTag = DstRoot:FindFirstChild("NPCTag");
				if (NPCTag and not table.find(MobWhiteList, NPCTag:FindFirstChild("NameLabel").Text)) then
					continue;
				end
			end
			local Magnitude = (Root.Position - DstRoot.Position).Magnitude;
			if (Magnitude < Dist) then
				Closest = DstRoot;
				Dist = Magnitude;
			end

		end
	end
	return Closest;
end;
local CheckBMSpawn = function()
	for i, v in next, Workspace.Live.NPCs.Server:GetChildren() do
		if v:IsA("Part") then
			if table.find(BloodMoonSelectMobList, v:GetAttribute("Name")) then
				print("Founded!");
				return v;
			end
		end
	end
	print("Not Found!");
	return false;
end;
local CheckAccept = function(v, mode)
	local TierAccepts = PlayerData.AutoRerollTierAccepts;
	local Accept = PlayerData.AutoRerollAccept;
	local isDelete = true;
	if (#v.enchants == 0) then
		return false;
	end
	if mode then
		for i = 1, EnchantsRefuse[v.enchants[1].name] do
			if (enchantsLevel[i] == v.enchants[1].tier) then
				isDelete = false;
				break;
			end
		end
		return isDelete;
	elseif (Accept[v.enchants[1].name] and TierAccepts[v.enchants[1].tier]) then
		return true;
	end
	if (#v.enchants == 1) then
		return false;
	end
	if mode then
		if (EnchantsRefuse[v.enchants[2].name] and table.find(EnchantsRefuse[v.enchants[2].name], v.enchants[2].tier)) then
			return false;
		end
	elseif ((Accept[v.enchants[2].name] == false) or (TierAccepts[v.enchants[2].tier] == false)) then
		return false;
	end
end;
local CheckPet = function(v, mode)
	local TierLevel = PlayerData.AutoRerollTierAccepts;
	local Accept = PlayerData.AutoRerollAccept;
	local isDelete = true;
	if (#v.enchants == 0) then
		return false;
	end
	if mode then
		for i = 1, PetEnchantsRefuse[v.enchants[1].name] do
			if (enchantsLevel[i] == v.enchants[1].tier) then
				isDelete = false;
				break;
			end
		end
		return isDelete;
	elseif (Accept[v.enchants[1].name] and TierLevel[v.enchants[1].tier]) then
		return true;
	end
end;
local vu = game:GetService("VirtualUser");
game:GetService("Players").LocalPlayer.Idled:connect(function()
	vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame);
	wait(1);
	vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame);
end);
Workspace:SetAttribute("PICKUP_RANGE", 1000);
for i, v in next, SwordDatabase do
	if (v.rarity == "Secret") then
		table.insert(Secret, v.name);
	end
end



task.spawn(function()
	local Foot = game:GetService("Players").LocalPlayer.Character:FindFirstChild("RightFoot");
	local Hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
	local oldPos = Hrp.CFrame;
	local dConnection = false;
	task.spawn(function()
		task.wait(1);
		getgenv().Connection = Foot.Touched:Connect(function()
			dConnection = true;
		end);
	end);
	repeat
		task.wait();
		Hrp.CFrame = CFrame.new(Workspace:GetAttribute("DungeonSpawn"));
		wait(2);
	until dConnection == true
	getgenv().Connection:Disconnect();
	wait(0.5);
	TPController:Teleport({pos=GlobalBoss.spawnPos,areaName=nil,regionName="Global Boss",leaveGamemode=true});
	wait(0.5);

	--加载所有地图.lua
	if load_all_map_when_start then
		for i, v in next, EggsDatabase do
			wait(0.2)
			LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[v.name].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
		end
		wait(0.2)
	end
	LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
	--Hrp.CFrame = oldPos;
	wait(0.2)
	if (typeof(RelicPresetSetting.Default) == "string") then
		--print(EquipRelics, RelicPresetSetting,RelicPresetSetting.Default)
		EquipRelics(RelicPresetSetting.Default);
	end

end);

coroutine.wrap(function()
	--todo:看看这里会不会导致地牢出问题，出问题的话就把1删掉
	while wait() do
		--closest = nil;
		closest = Closest_NPC();
	end
end)();
local CurrentNPCIsAlive = function()
	curr_NPC = LocalPlayer:GetAttribute("NPC")
	is_alive = false
	for i, v in next, Workspace.Live.NPCs.Server:GetChildren() do
		if tostring(curr_NPC) == tostring(v) then
			is_alive = v:GetAttribute("Health")>0
			break
		end
	end
	return is_alive
end
--skill 1
--local skill1lastCastTime = 0
--local SkillDelayTime = 1 --不同技能释放时间间隔
coroutine.wrap(function()
	while wait(0.2) do
		if (LocalPlayer:GetAttribute("NPC") ~= nil) and IsAutoSkill then
			for idx, skill_value in DisSkillList, nil do
				if not CurrentNPCIsAlive then
					break
				end
				SkillService:CastSpell(LocalPlayer:GetAttribute("NPC"), skill_value)
			end
		--else
		--	local Skills = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SkillsBottom"):WaitForChild("Skills");
		--	local firstSkill = Skills:WaitForChild("Template");
		--	SkillService:CastSpell(LocalPlayer:GetAttribute("NPC"), firstSkill:GetAttribute("Skill"));
		end
		--skill1lastCastTime = os.clock()
	end
end)();

--
----skill 2
--local skill2lastCastTime = 0
--coroutine.wrap(function()
--	while wait(0.2) do
--		if (LocalPlayer:GetAttribute("NPC") ~= nil) then
--			local Skills = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SkillsBottom"):WaitForChild("Skills");
--			local secondSkill = Skills:WaitForChild("Template2");
--			--如果上次第1技能和第2技能释放时间间隔过短，则延缓第2技能释放
--			if math.abs(skill2lastCastTime - skill1lastCastTime) < SkillDelayTime then
--				wait(SkillDelayTime - math.abs(skill2lastCastTime - skill1lastCastTime))
--			end
--			SkillService:CastSpell(LocalPlayer:GetAttribute("NPC"), secondSkill:GetAttribute("Skill"));
--			skill2lastCastTime = os.clock()
--		end
--	end
--end)();
----skill 3
--local skill3lastCastTime = 0
--coroutine.wrap(function()
--	while wait(0.2) do
--		if (LocalPlayer:GetAttribute("NPC") ~= nil) then
--			local Skills = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SkillsBottom"):WaitForChild("Skills");
--			local thirdSkill = Skills:WaitForChild("Template3");
--			--如果上次第2技能和第3技能释放时间间隔过短，则延缓第3技能释放
--			if math.abs(skill3lastCastTime - skill2lastCastTime) < SkillDelayTime then
--				wait(SkillDelayTime - math.abs(skill3lastCastTime - skill2lastCastTime))
--			end
--			SkillService:CastSpell(LocalPlayer:GetAttribute("NPC"), thirdSkill:GetAttribute("Skill"));
--			skill3lastCastTime = os.clock()
--		end
--	end
--end)();

game:GetService("ReplicatedStorage").ActiveRaids.ChildAdded:Connect(function()
	if AutoRaid then
		wait(3);
		getgenv().lastOpenTime = Workspace:GetAttribute("CURRENT_TIME");
		print("Raid Opened");
		Knit_Pkg.GetController("NotificationController"):Notification({message="突袭开始",color="RobuxColor",multipleAllowed=false});
		Knit_Pkg.GetController("NotificationController"):Notification({message="将在170秒后加入...",color="Orange",multipleAllowed=false});
	end
end);
local first_corrupt_map = true
coroutine.wrap(function()
	while wait(4) do
		if BloodMoonCheck then
			isBloodMoon = Workspace:GetAttribute("BLOOD_MOON_EVENT");
			if (isBloodMoon and not BloodMoonMingInit) then
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = beforePos;
				local BMSpawn = CheckBMSpawn();
				if not BMSpawn then
					continue;
				end
				Knit_Pkg.GetController("NotificationController"):Notification({message="检测到血月事件，即将开始刷怪...",color="Red",multipleAllowed=false});
				print("检测到血月事件");
				if (bAutoUseLuckBoost or bAutoUseSecretLuckBoost or bAutoUseCoinBoost or (bAutoUseDmgBoost and not hasUsedBoosts)) then
					hasUsedBoosts = true;
					if bAutoUseLuckBoost then
						print("Blood moon event use Luck boosts");
						useBoost("Luck");
					end
					if bAutoUseSecretLuckBoost then
						print("Blood moon event use SecretLuck boosts");
						useBoost("SecretLuck");
					end
					if bAutoUseCoinBoost then
						print("Blood moon event use Coins boosts");
						useBoost("Coins");
					end
					--if bAutoUsePowerBoost then
					--	print("Blood moon event use Power boosts");
					--	useBoost("Power");
					--end
					if bAutoUseDmgBoost then
						print("Blood moon event use Damage boosts");
						useBoost("Damage");
					end
				end
				if (bAutoUseLuckBoostQuest or bAutoUseSecretLuckBoostQuest or bAutoUseCoinBoostQuest or (bAutoUseDmgBoostQuest and not hasUsedBoostsQuest)) then
					hasUsedBoostsQuest = true;
					if bAutoUseLuckBoostQuest then
						print("Blood moon event use LuckQuest boosts");
						useBoost("LuckQuest");
					end
					if bAutoUseSecretLuckBoostQuest then
						print("Blood moon event use SecretLuckQuest boosts");
						useBoost("SecretLuckQuest");
					end
					if bAutoUseCoinBoostQuest then
						print("Blood moon event use CoinsQuest boosts");
						useBoost("CoinsQuest");
					end
					--if bAutoUsePowerBoostQuest then
					--	print("Blood moon event use PowerQuest boosts");
					--	useBoost("PowerQuest");
					--end
					if bAutoUseDmgBoostQuest then
						print("Blood moon event use DamageQuest boosts");
						useBoost("DamageQuest");
					end
				end

				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = BMSpawn.CFrame * CFrame.new(0, 6, -2.5);
				if (typeof(RelicPresetSetting.BloodMoon) == "string") then
					EquipRelics(RelicPresetSetting.BloodMoon);
				end
				BloodMoonMingInit = true;
			end
			if (not isBloodMoon and BloodMoonMingInit) then
				if (typeof(RelicPresetSetting.Default) == "string") then
					EquipRelics(RelicPresetSetting.Default);
				end
				BloodMoonMingInit = false;
				hasUsedBoosts = false;
				hasUsedBoostsQuest = false;

				local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
				if (Root and beforePos) then
					Root.CFrame = beforePos;
				end
				Knit_Pkg.GetController("NotificationController"):Notification({message="血月事件结束，传送回抽蛋位置。",color="Blue",multipleAllowed=false});
				print("BloodMoon Event Off");
				--isCorruptEvent = true;
			end
		end
		-- if (CorruptEventCheck and Workspace:GetAttribute("CORRUPT_EVENT") and isCorruptEvent) then
		if (CorruptEventCheck and Workspace:GetAttribute("CORRUPT_EVENT")) then
			--print("corrupt status".. CorruptMingStatus)
			--1:"Not started" 2:"working on 1" 3:"1 finished" 4:"working on 2"  5:"2 finished"
			if CorruptMingStatus==1 or CorruptMingStatus == 3 then
				corrupt_map_idx = 1
				if CorruptMingStatus == 3 then
					corrupt_map_idx = 2
				end
				if CorruptMingStatus==1 then
					--print("record farm setting before corrupt",Toggles.autoFarm.Value, Toggles.FarmAllMap.Value,Toggles.FarmSelectedMobs.Value)
					autoFarmRecord = Toggles.autoFarm.Value;
					FarmAllMapRecord = Toggles.FarmAllMap.Value;
					FarmSelectedMobsRecord = Toggles.FarmSelectedMobs.Value;
				end
				-- 进入刷怪状态
				CorruptMingStatus = CorruptMingStatus + 1



				task.spawn(function()
					Knit_Pkg.GetController("NotificationController"):Notification({message="检测到腐坏事件，即将开始刷怪...",color="Red",multipleAllowed=false});

					local v14 = string.split(Workspace:GetAttribute("CORRUPT_EVENT"), ", ");
					Knit_Pkg.GetController("NotificationController"):Notification({message="传送至腐坏世界" .. corrupt_map_idx,color="Red",multipleAllowed=false});
					--print("teleport to corrupt area",corrupt_map_id)
					Toggles.autoFarm:SetValue(false);
					Toggles.FarmAllMap:SetValue(false);
					Toggles.FarmSelectedMobs:SetValue(false);
					TPController:TeleportArea(v14[corrupt_map_idx])
					wait(0.5);
					Toggles.autoFarm:SetValue(true);
					wait(10);
					Toggles.autoFarm:SetValue(autoFarmRecord);
					Toggles.FarmAllMap:SetValue(FarmAllMapRecord);
					Toggles.FarmSelectedMobs:SetValue(FarmSelectedMobsRecord);
					--print("reset farm setting after corrupt",autoFarmRecord,FarmAllMapRecord,FarmSelectedMobsRecord)
					LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
					Knit_Pkg.GetController("NotificationController"):Notification({message="腐坏世界" .. corrupt_map_idx .. "刷怪结束，即将传送至抽蛋位置",color="Blue",multipleAllowed=false});
					--CorruptMingFinished[corrupt_map_idx] = false
					--刷怪结束，进入下一状态
					CorruptMingStatus = CorruptMingStatus + 1
				end);
			end
		else
			--1:"Not started" 2:"working on 1" 3:"1 finished" 4:"working on 2"  5:"2 finished"
			CorruptMingStatus = 1
		end

		if SolarEclipseCheck then
			isSolarEclipse = Workspace:GetAttribute("SOLAR_ECLIPSE_EVENT");
			if (isSolarEclipse and not SolarEclipseing) then
				print("SolarEclipse Event On");
				EvenBeforeSunBurst = "SolarEclipse"

				if (typeof(RelicPresetSetting.Night) == "string") then
					EquipRelics(RelicPresetSetting.Night);
				end
				if (nAutoUseLuckBoost or nAutoUseSecretLuckBoost or (nAutoUsePowerBoost and not shasUsed)) then
					shasUsed = true;
					if nAutoUseLuckBoost then
						print("SolarEclipse event use Luck boosts");
						useBoost("Luck", 30);
					end
					if nAutoUseSecretLuckBoost then
						print("SolarEclipse event use SecretLuck boosts");
						useBoost("SecretLuck", 30);
					end
					if nAutoUsePowerBoost then
						print("SolarEclipse event use Power boosts");
						useBoost("Power", 30);
					end
				end
				if (nAutoUseLuckBoostQuest or nAutoUseSecretLuckBoostQuest or (nAutoUsePowerBoostQuest and not shasUsedQuest)) then
					shasUsedQuest = true;
					if nAutoUseLuckBoostQuest then
						print("SolarEclipse event use LuckQuest boosts");
						useBoost("LuckQuest", 30);
					end
					if nAutoUseSecretLuckBoostQuest then
						print("SolarEclipse event use SecretLuckQuest boosts");
						useBoost("SecretLuckQuest", 30);
					end
					if nAutoUsePowerBoostQuest then
						print("SolarEclipse event use PowerQuest boosts");
						useBoost("PowerQuest", 30);
					end
				end
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
				wait();
				--Toggles.EggNight:SetValue(true);
				Toggles.AutoOpenEggs:SetValue(true);
				SolarEclipseing = true;
				wait();
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
				wait();
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
			end
			if (not isSolarEclipse and SolarEclipseing) then
				SolarEclipseing = false;
				shasUsed = false;
				shasUsedQuest = false;
				if (typeof(RelicPresetSetting.Default) == "string") then
					EquipRelics(RelicPresetSetting.Default);
				end

				local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
				if (Root and beforePos) then
					Root.CFrame = beforePos;
				end
				print("SolarEclipse Event Off");
			end
		end

		if NightCheck then
			isNight = Workspace:GetAttribute("NIGHT_EVENT");
			if (isNight and not Nighting) then
				print("Night Event On");
				EvenBeforeSunBurst = "Night"

				if (typeof(RelicPresetSetting.Night) == "string") then
					EquipRelics(RelicPresetSetting.Night);
				end
				if (nAutoUseLuckBoost or nAutoUseSecretLuckBoost or (nAutoUsePowerBoost and not nhasUsed)) then
					hasUsedBoosts = true;


					if nAutoUseLuckBoost then
						print("Night event use Luck boosts");
						useBoost("Luck");
					end
					if nAutoUseSecretLuckBoost then
						print("Night event use SecretLuck boosts");
						useBoost("SecretLuck");
					end
					if nAutoUsePowerBoost then
						print("Night event use Power boosts");
						useBoost("Power");
					end
				end
				if (nAutoUseLuckBoostQuest or nAutoUseSecretLuckBoostQuest or (nAutoUsePowerBoostQuest and not nhasUsedQuest)) then
					hasUsedBoostsQuest = true;


					if nAutoUseLuckBoostQuest then
						print("Night event use LuckQuest boosts");
						useBoost("LuckQuest");
					end
					if nAutoUseSecretLuckBoostQuest then
						print("Night event use SecretLuckQuest boosts");
						useBoost("SecretLuckQuest");
					end
					if nAutoUsePowerBoostQuest then
						print("Night event use PowerQuest boosts");
						useBoost("PowerQuest");
					end
				end
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
				wait();
				--Toggles.EggNight:SetValue(true);
				Toggles.AutoOpenEggs:SetValue(true);
				Nighting = true;
				wait();
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
				wait();
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
			end
			if (not isNight and Nighting) then
				Nighting = false;
				nhasUsed = false;
				nhasUsedQuest = false;
				if SunBurstCheck then
					isSunBurst = workspace:GetAttribute("SUNBURST_EVENT")
					if (not isSunBurst and not SunBursting) then
						if (typeof(RelicPresetSetting.Default) == "string") then
							EquipRelics(RelicPresetSetting.Default);
						end

						local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
						if (Root and beforePos) then
							Root.CFrame = beforePos;
						end
						print("Night Event Off");
					end
				else
						if (typeof(RelicPresetSetting.Default) == "string") then
							EquipRelics(RelicPresetSetting.Default);
						end

						local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
						if (Root and beforePos) then
							Root.CFrame = beforePos;
						end
						print("Night Event Off");
				end
			end
		end

		if SunBurstCheck then
			isSunBurst = workspace:GetAttribute("SUNBURST_EVENT")
			if (isSunBurst and not SunBursting) then
				print("Burst Event On");
				if (typeof(RelicPresetSetting.Night) == "string") then
					EquipRelics(RelicPresetSetting.Night);
				end
				local BoostLength = 20
				if EvenBeforeSunBurst == "SolarEclipse" then
					BoostLength = 5
				end
				if (nAutoUseLuckBoost or nAutoUseSecretLuckBoost or (nAutoUsePowerBoost and not bhasUsed)) then
					bhasUsed = true;
					if nAutoUseLuckBoost then
						print("SunBurst event use Luck boosts");
						useBoost("Luck",BoostLength);
					end
					if nAutoUseSecretLuckBoost then
						print("SunBurst event use SecretLuck boosts");
						useBoost("SecretLuck",BoostLength);
					end
					if nAutoUsePowerBoost then
						print("SunBurst event use Power boosts");
						useBoost("Power",BoostLength);
					end
				end
				if (nAutoUseLuckBoostQuest or nAutoUseSecretLuckBoostQuest or (nAutoUsePowerBoostQuest and not bhasUsedQuest)) then
					bhasUsedQuest = true;
					if nAutoUseLuckBoostQuest then
						print("SunBurst event use LuckQuest boosts");
						useBoost("LuckQuest",BoostLength);
					end
					if nAutoUseSecretLuckBoostQuest then
						print("SunBurst event use SecretLuckQuest boosts");
						useBoost("SecretLuckQuest",BoostLength);
					end
					if nAutoUsePowerBoostQuest then
						print("SunBurst event use PowerQuest boosts");
						useBoost("PowerQuest",BoostLength);
					end
				end
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
				wait();
				--Toggles.EggBurst:SetValue(true);
				Toggles.AutoOpenEggs:SetValue(true);
				SunBursting = true;
				wait();
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
				wait();
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
			end

			if (not isSunBurst and SunBursting) then
				SunBursting = false;
				bhasUsed = false;
				bhasUsedQuest = false;
				if (typeof(RelicPresetSetting.Default) == "string") then
					EquipRelics(RelicPresetSetting.Default);
				end
				local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
				if (Root and beforePos) then
					Root.CFrame = beforePos;
				end
				print("Burst Event Off");
			end
		end
		if next(Workspace.Resources.Gamemodes.DungeonLobby.ZoneAutoJoins:GetChildren()) then
			local currentTime = Workspace:GetAttribute("CURRENT_TIME") % 1800;
			--print("Dungeon detected", currentTime)
			--print("hard",not BloodMoonMingInit, not Nighting, not SunBursting, not SolarEclipseing, (currentTime > (51 + (15 * 60))), (currentTime < (58 + (15 * 60))))
			--print("insane",not BloodMoonMingInit, not Nighting, not SunBursting, not SolarEclipseing, (currentTime > 51), (currentTime < 58))
			if (not BloodMoonMingInit and not Nighting and not SunBursting and not SolarEclipseing and (currentTime > (51 + (15 * 60))) and (currentTime < (58 + (15 * 60)))) then
				print("Hard Dungeon Open");
				ContinueButtonUID = nil;
				DungeonContinueButton = false;
				if (HardDungeon and not LocalPlayer:GetAttribute("Raid")) then
					local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
					if Root then
						_MAIN = false;
						local Dst = Workspace.Resources.Gamemodes.DungeonLobby.ZoneAutoJoins["Dungeon 2"].CFrame * CFrame.new(0, 6, 0);
						LocalPlayer:RequestStreamAroundAsync(Dst.Position);
						LocalPlayer.Character:SetPrimaryPartCFrame(Dst);
						wait(1);
						local Dungeon_Parts = Workspace.Resources.Gamemodes.DungeonLobby.JoinParts;
						for _, DungeonJoinPart in pairs(Dungeon_Parts:GetChildren()) do
							DungeonUID = DungeonJoinPart:GetAttribute("UID") or DungeonUID;
							local Join_Res = Dungeon_Service:JoinDungeon(DungeonUID);
							if Join_Res then
								TPController:Teleport({pos=Join_Res,areaName=nil,regionName="Dungeon",leaveGamemode=false});
								InDungeon = 2;
								print("Join Hard Dungeon");
								if (typeof(RelicPresetSetting.Default) == "string") then
									EquipRelics(RelicPresetSetting.Default);
								end
								break;
							end
						end
						wait(3);
						_MAIN = true;
					end
				end
			end
			if (not BloodMoonMingInit and not Nighting and not SunBursting and not SolarEclipseing and (currentTime > 51) and (currentTime < 58)) then
				print("Easy And Insane Dungeon Open");
				ContinueButtonUID = nil;
				DungeonContinueButton = false;
				if ((EasyDungeon or InsaneDungeon) and not LocalPlayer:GetAttribute("Raid")) then
					local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
					if Root then
						_MAIN = false;
						local selectedDungeon = "Dungeon 1";
						if InsaneDungeon then
							selectedDungeon = "Dungeon 3";
						end
						local Dst = Workspace.Resources.Gamemodes.DungeonLobby.ZoneAutoJoins[selectedDungeon].CFrame * CFrame.new(0, 6, 0);
						LocalPlayer:RequestStreamAroundAsync(Dst.Position);
						LocalPlayer.Character:SetPrimaryPartCFrame(Dst);
						wait(1);
						local Dungeon_Parts = Workspace.Resources.Gamemodes.DungeonLobby.JoinParts;
						for _, DungeonJoinPart in pairs(Dungeon_Parts:GetChildren()) do
							if (EasyDungeon and (DungeonJoinPart.name == "Dungeon 1")) then
								local Join_Res = Dungeon_Service:JoinDungeon(DungeonJoinPart:GetAttribute("UID"));
								if Join_Res then
									TPController:Teleport({pos=Join_Res,areaName=nil,regionName="Dungeon",leaveGamemode=false});
									InDungeon = 1;
									print("Join Easy Dungeon");
									break;
								end
							end
							if (InsaneDungeon and (DungeonJoinPart.name == "Dungeon 3")) then
								local Join_Res = Dungeon_Service:JoinDungeon(DungeonJoinPart:GetAttribute("UID"));
								if Join_Res then
									TPController:Teleport({pos=Join_Res,areaName=nil,regionName="Dungeon",leaveGamemode=false});
									InDungeon = 3;
									print("Join Insane Dungeon");
									if (typeof(RelicPresetSetting.Dungeon) == "string") then
										EquipRelics(RelicPresetSetting.Dungeon);
									end
									break;
								end
							end
						end
						wait(3);
						_MAIN = true;
					end
				end
			end
		end
		ActiveRaid = game:GetService("ReplicatedStorage").ActiveRaids:FindFirstChildWhichIsA("BoolValue");
		if not (BloodMoonMingInit or Nighting or InDungeon or SunBursting or SolarEclipseing) then
			if (AutoRaid and ActiveRaid and not LocalPlayer:GetAttribute("Raid")) then
				local diffTime = Workspace:GetAttribute("CURRENT_TIME") - lastOpenTime;
				if ((diffTime >= 168) and (diffTime < 178)) then
					if not Workspace.Resources.Gamemodes.RaidJoins:FindFirstChild(ActiveRaid.Name) then
						_MAIN = false;
						wait();
						TPController:TeleportArea("Area " .. string.match(ActiveRaid.Name, "%d+"));
						wait();
						_MAIN = true;
					end
					if Workspace.Resources.Gamemodes.RaidJoins:FindFirstChild(ActiveRaid.Name) then
						uid = Workspace.Resources.Gamemodes.RaidJoins[ActiveRaid.Name]:GetAttribute("UID");
						if uid then
							_MAIN = false;
							wait(1);
							local res = KnitService.RaidService.RF.JoinRaid:InvokeServer(uid);
							print("Join " .. ActiveRaid.Name .. " ," .. PlayerData.RaidTickets .. " tickets remain");
							wait(2);
							_MAIN = true;
						end
					end
				end
			end
		end
		local RoomLabel = LocalPlayer.PlayerGui.Dungeon:FindFirstChild("Background"):FindFirstChild("Active"):FindFirstChild("RoomLabel");
		local Room = nil;
		local TimeChec = (((Workspace:GetAttribute("CURRENT_TIME") % 1800) > 120) and ((Workspace:GetAttribute("CURRENT_TIME") % 1800) < 900)) or (((Workspace:GetAttribute("CURRENT_TIME") % 1800) > (17 * 60)) and ((Workspace:GetAttribute("CURRENT_TIME") % 1800) < (30 * 60)));
		if RoomLabel then
			Room = tonumber(string.match(RoomLabel.Text, "%d+"));
		end
		if InDungeon == 3 and Room then
			if (InsaneDungeonUseBoost > 0) and (Room >= InsaneDungeonUseBoost) then
				task.spawn(function()
					use_boost = function(boostsName)
						local timeleft = PlayerData.Boosts[boostsName].timeLeft;
						while timeleft < 20 do
							if ((timeleft < 20) and PlayerData.Boosts[boostsName].remaining["300"] and (PlayerData.Boosts[boostsName].remaining["300"] > 0)) then
								KnitService.BoostService.RF.UseBoost:InvokeServer(boostsName, "300");
							elseif ((timeleft < 20) and PlayerData.Boosts[boostsName].remaining["600"] and (PlayerData.Boosts[boostsName].remaining["600"] > 0)) then
								KnitService.BoostService.RF.UseBoost:InvokeServer(boostsName, "600");
							end
							wait(1);
							timeleft = PlayerData.Boosts[boostsName].timeLeft;
						end
					end
					if InsaneAutoUseLuckBoost then
						use_boost("Luck")
					end
					if InsaneAutoUseSecretLuckBoost then
						use_boost("SecretLuck")
					end
					if InsaneAutoUseDmgBoost then
						use_boost("Damage")
					end
					if InsaneAutoUseLuckBoostQuest then
						use_boost("LuckQuest")
					end
					if InsaneAutoUseSecretLuckBoostQuest then
						use_boost("SecretLuckQuest")
					end
					if InsaneAutoUseDmgBoostQuest then
						use_boost("DamageQuest")
					end

				end);
			end
		end
		if (InDungeon and not LocalPlayer:GetAttribute("InDungeon") and (EasyDungeon or HardDungeon or InsaneDungeon) and TimeChec) then
			print("Error Leave");
			print(InDungeon);
			print(TimeChec);
			InDungeon = false;
			insane_dungeon_seen_mobs = {}
			if (typeof(RelicPresetSetting.Default) == "string") then
				EquipRelics(RelicPresetSetting.Default);
			end
			KnitService.DungeonService.RF.LeaveDungeon:InvokeServer();

		else
			if ((InDungeon == 1) and EasyDungeon and Room and (Room > EasyReach) and TimeChec) then
				KnitService.DungeonService.RF.LeaveDungeon:InvokeServer();
				print("Reached and Leave EasyDungeon at Room " .. Room);
				wait(1);
			end
			if ((InDungeon == 2) and HardDungeon and Room and (Room > HardReach) and TimeChec) then
				KnitService.DungeonService.RF.LeaveDungeon:InvokeServer();
				print("Reached and Leave HardDungeon at Room " .. Room);
				wait(1);
			end
			if ((InDungeon == 3) and InsaneDungeon and Room and (Room > InsaneReach) and TimeChec) then
				KnitService.DungeonService.RF.LeaveDungeon:InvokeServer();
				print("Reached and Leave InsaneDungeon at Room " .. Room);
				wait(1);
			end
		end
	end
end)();
autoFarmRecord = false
FarmAllMapRecord = false
FarmSelectedMobsRecord = false

task.spawn(function()
	local Dungeon3 = false;
	local Tower2 = false;
	local Tower3 = false;
	local Raid2 = false;
	local Raid3 = false;
	task.spawn(function()
		RunService.Stepped:Connect(function()
			if not _MAIN then
				return;
			end
			if (AutoTower and LocalPlayer:GetAttribute("InTower") and (Tower2 == false) and not closest)  then
				if not InTower then
					print("1356-intower:",InTower)
					InTower = true
					autoFarmRecord = Toggles.autoFarm.Value;
					FarmAllMapRecord = Toggles.FarmAllMap.Value;
					FarmSelectedMobsRecord = Toggles.FarmSelectedMobs.Value;
					print("before tower",autoFarmRecord,FarmAllMapRecord,FarmSelectedMobsRecord)
					Toggles.autoFarm:SetValue(true);
					Toggles.FarmAllMap:SetValue(false);
					Toggles.FarmSelectedMobs:SetValue(false);
				end
				local Button = Workspace.Live.Towers:FindFirstChild("ContinueButton", true);
				local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
				if (Button and next(Button:GetAttributes())) then
					coroutine.wrap(function()
						--塔中的继续按钮
						Tower2 = true;
						task.wait(0.2);
						if not Root then
							return;
						end
						Root.CFrame = Button.CFrame * CFrame.new(0, 6.75, 0);
						task.wait(0.2);
						KnitService.TowerService.RF.ContinueTower:InvokeServer(Button:GetAttribute("UID"));
						task.wait(0.2);
						Tower2 = false;
					end)();
				end

			end
			if (AutoRaid and ActiveRaid and LocalPlayer:GetAttribute("Raid") and (Raid2 == false)) then
				local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
				local Background = PlayerGui:WaitForChild("Raid"):WaitForChild("Background");
				local Active = Background:WaitForChild("Active");
				local TimerLabel = Background:WaitForChild("TimerLabel");
				local EnemiesLeft = Active:WaitForChild("EnemiesLeft");
				local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
				if (EnemiesLeft and Root and (TimerLabel.Text == "STARTS IN 00:00") and Workspace.Resources.Gamemodes.Raids[ActiveRaid.Name].Boss:FindFirstChild("Spawn")) then
					EnemiesLeft = tonumber(EnemiesLeft.TextLabel.Text);
					coroutine.wrap(function()
						Raid2 = true;
						if (EnemiesLeft == 0) then
							Root.CFrame = Workspace.Resources.Gamemodes.Raids[ActiveRaid.Name].Boss.Spawn.CFrame * CFrame.new(0, 3, -5.5);
							wait(1);
						end
						if (EnemiesLeft == 3) then
							Root.CFrame = Workspace.Resources.Gamemodes.Raids[ActiveRaid.Name].NPCs:GetChildren()[1].Spawn.CFrame * CFrame.new(0, 3, -5.5);
							wait(1);
						end
						if (EnemiesLeft == 2) then
							Root.CFrame = Workspace.Resources.Gamemodes.Raids[ActiveRaid.Name].NPCs:GetChildren()[2].Spawn.CFrame * CFrame.new(0, 3, -5.5);
							wait(1);
						end
						if (EnemiesLeft == 1) then
							Root.CFrame = Workspace.Resources.Gamemodes.Raids[ActiveRaid.Name].NPCs:GetChildren()[3].Spawn.CFrame * CFrame.new(0, 3, -5.5);
							wait(1);
						end
						Raid2 = false;
					end)();
				end
			end
		end);
	end);
	task.spawn(function()
		RunService.Stepped:Connect(function()
			if (_MAIN and InDungeon and (EasyDungeon or HardDungeon or InsaneDungeon) and (Dungeon3 == false)) then
				coroutine.wrap(function()
					--用于离开地牢后的结算界面点击操作
					Dungeon3 = true;
					repeat
						wait();
					until LocalPlayer.PlayerGui.DungeonResult.Background.AbsolutePosition == Vector2.new(0, -36)
					InDungeon = false;
					insane_dungeon_seen_mobs = {}
					print("Finished and Leave");
					if (typeof(RelicPresetSetting.Default) == "string") then
						EquipRelics(RelicPresetSetting.Default);
					end
					_MAIN = false;
					task.wait(2);
					firesignal(LocalPlayer.PlayerGui.DungeonResult.Background.Frame.Continue.Button.MouseButton1Click);
					task.wait(1);
					while not LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1) do
						task.wait()
					end
					LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = beforePos;
					task.wait(1);
					_MAIN = true;
					Dungeon3 = false;
				end)();
			end
			--if (false and _MAIN and AutoTower and (Tower3 == false)) then
			--	coroutine.wrap(function()
			--		Tower3 = true;
			--		repeat
			--			wait();
			--		until LocalPlayer.PlayerGui.TowerResult.Background.AbsolutePosition == Vector2.new(0, -36)
			--		task.wait(3);
			--		--关闭出塔后的结算界面
			--		firesignal(LocalPlayer.PlayerGui.TowerResult.Background.Frame.Continue.Button.MouseButton1Click);
			--		task.wait(2);
			--		--默认选择替换光环
			--		firesignal(LocalPlayer.PlayerGui.AuraSwap.Background.ImageFrame.Window.Buttons.Replace.Button.MouseButton1Click);
			--		task.wait(2);
			--		Tower3 = false;
			--
			--		Toggles.autoFarm:SetValue(autoFarmRecord);
			--		Toggles.FarmAllMap:SetValue(FarmAllMapRecord);
			--		Toggles.FarmSelectedMobs:SetValue(FarmSelectedMobsRecord);
			--		InTower = false
			--	end)();
			--end
			if (_MAIN and AutoRaid and (Raid3 == false)) then
				coroutine.wrap(function()
					Raid3 = true;
					repeat
						wait();
					until LocalPlayer.PlayerGui.RaidResult.Background.AbsolutePosition == Vector2.new(0, -36)
					print("Leave Raid");
					_MAIN = false;
					task.wait(1);
					firesignal(LocalPlayer.PlayerGui.RaidResult.Background.Frame.Continue.Button.MouseButton1Click);
					task.wait(3);
					LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = beforePos;
					_MAIN = true;
					Raid3 = false;
				end)();
			end
		end);
	end);
end);
--task.spawn(function()
--	local Connection;
--	local Force;
--	local Attachment;
--	if not Force then
--		Force = Instance.new("VectorForce");
--		Attachment = Instance.new("Attachment");
--	end
--	local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart");
--	Force.ApplyAtCenterOfMass = true;
--	Force.Attachment0 = Attachment;
--	Force.Force = Util.GetMass(LocalPlayer.Character) * Vector3.new(0, workspace.Gravity, 0);
--	Force.Parent = Root;
--	Attachment.Parent = Root;
--	Force.Enabled = false;
--	local function Float(Character)
--		if Connection then
--			Connection:Disconnect();
--			Connection = nil;
--		end
--		local stoptick = 0;
--		local flag = true;
--		Connection = game:GetService("RunService").Stepped:Connect(function()
--			if (_MAIN and (AutoFarm or InDungeon)) then
--				Root.Velocity = Vector3.new(Root.Velocity.X, 0, Root.Velocity.Z);
--				Force.Enabled = true;
--				if not closest then
--					Force.Enabled = false;
--				end
--			else
--				Force.Enabled = false;
--			end
--		end);
--	end
--	if LocalPlayer.Character then
--		Float(LocalPlayer.Character);
--	end
--	LocalPlayer.CharacterAdded:Connect(Float);
--end);
local zero = false;
local towerlock1 = false
task.spawn(function()
	RunService.Heartbeat:Connect(function()
		if (zero == false) then
			zero = true;
			coroutine.wrap(function()
				while _MAIN
						and (AutoFarm or InDungeon or (BloodMoonCheck and isBloodMoon)
						or (ServerBossCheck and isServerBoss)
						or (FragmentCheck and isFragment)
						or (CometCheck and isComet))
						and not Nighting
						and not LocalPlayer:GetAttribute("Raid")
						and not SolarEclipseing
						and (not SunBursting or (SunBursting and ServerBossCheck and isServerBoss)) do
					local currentClosest = Closest_NPC(true);
					local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
					if (currentClosest and Root) then
						if ((FarmAllMap and not InDungeon) or
								(BloodMoonCheck and isBloodMoon and next(BloodMoonSelectMobList)) or
								(ServerBossCheck and isServerBoss) or
								(FragmentCheck and isFragment) or
								(CometCheck and isComet)) then
							local OldErr, OldMsg = pcall(function()
								return currentClosest.CFrame;
							end);
							if not OldErr then
								print("No currentClosest");
								continue;
							end
							Root.CFrame = currentClosest.CFrame * CFrame.new(0, 6, -2.5);

							local count = 0;
							repeat
								task.wait();
								coroutine.wrap(function()
									KnitService.ClickService.RF.Click:InvokeServer(tostring(currentClosest));
								end)();
								count = count + 1;
							until not _MAIN
									--or (BloodMoonCheck and isBloodMoon)
									--or not AutoFarm
									or (currentClosest:GetAttribute("Health") == 0) or (count > FarmSpeedTime)

							continue;
						else
							if AutoTower and InTower and not towerlock1 then
								print("1564-towerlock1:",towerlock1)
								towerlock1 = true
								local RoomLabel = LocalPlayer.PlayerGui.Dungeon:FindFirstChild("Background"):FindFirstChild("Active"):FindFirstChild("RoomLabel")
								if not RoomLabel then
									continue
								end
								local Room = tonumber(string.match(RoomLabel.Text, "%d+"));
								if Room and Room >= TowerReach - 1  and InTower then
									task.wait(1)

									print("after tower",autoFarmRecord,FarmAllMapRecord,FarmSelectedMobsRecord)
									TPController:TeleportArea("Area 8")
									Toggles.autoFarm:SetValue(autoFarmRecord);
									Toggles.FarmAllMap:SetValue(FarmAllMapRecord);
									Toggles.FarmSelectedMobs:SetValue(FarmSelectedMobsRecord);

									task.wait(1)
									repeat
										task.wait();
									until LocalPlayer.PlayerGui.DungeonResult.Background.AbsolutePosition == Vector2.new(0, -36)
									--task.wait(3);
									--关闭出塔后的结算界面
									firesignal(LocalPlayer.PlayerGui.DungeonResult.Background.Frame.Continue.Button.MouseButton1Click)
									task.wait(1);
									--默认选择替换光环
									--firesignal(LocalPlayer.PlayerGui.AuraSwap.Background.ImageFrame.Window.Buttons.Replace.Button.MouseButton1Click);
									--task.wait(1);
									Room = 0
									print("1507-intower:",InTower)
									print("1507-tower locl:",towerlock1)
									InTower = false
									towerlock1 = false
									zero = false;
									return
								end
								print("1596-tower locl:",towerlock1)
								towerlock1 = false

							end
							if insane_dungeon_delay_time > 0 and InDungeon == 3 then
								local NPCTag = currentClosest:FindFirstChild("NPCTag")
								if NPCTag and not table.find(insane_dungeon_seen_mobs, NPCTag:FindFirstChild("NameLabel").Text) then
									table.insert(insane_dungeon_seen_mobs, NPCTag:FindFirstChild("NameLabel").Text)
									--print("wait for " .. insane_dungeon_delay_time .. " seconds before leave the room")
									task.wait(insane_dungeon_delay_time)
								--else
								--	print("didn't find name tag")
								--	print(NPCTag, not table.find(insane_dungeon_seen_mobs, NPCTag:FindFirstChild("NameLabel").Text))
								end
							elseif InDungeon then
								local NPCTag = currentClosest:FindFirstChild("NPCTag")
									if NPCTag and not table.find(insane_dungeon_seen_mobs, NPCTag:FindFirstChild("NameLabel").Text) then
										table.insert(insane_dungeon_seen_mobs, NPCTag:FindFirstChild("NameLabel").Text)
										--print("wait for " .. insane_dungeon_delay_time .. " seconds before leave the room")
										task.wait(1)
								end
							end
							Root.CFrame = currentClosest.CFrame * CFrame.new(0, 6, -2.5);
							KnitService.ClickService.RF.Click:InvokeServer(tostring(currentClosest));
							while _MAIN and LocalPlayer:GetAttribute("NPC") do
								task.wait();
							end
						end
					end


					task.wait();
				end
				zero = false;
			end)();
		end
	end);
end);

--power_count = 0
--task.spawn(function()
--	RunService.Heartbeat:Connect(function()
--		if power_count == 0 then
--			if _POWER or (_POWERNight and ((Nighting and NightCheck) or (SunBursting and SunBurstCheck))) then
--				for i = 1, ClickSpeed do
--					power_count = power_count + 1
--					coroutine.wrap(function()
--						if closest then
--							KnitService.ClickService.RF.Click:InvokeServer(tostring(closest));
--						else
--							ClickService:Click(nil)
--						end
--						power_count = power_count - 1
--						print(power_count)
--					end)();
--				end
--			end
--
--		end
--	end);
--end);

local one = false;
task.spawn(function()
	RunService.Heartbeat:Connect(function()
		if (one == false) then
			one = true;
			while task.wait() and (
					_POWER
					or (_POWERNight and ((Nighting and NightCheck) or (SunBursting and SunBurstCheck) or (SolarEclipseing and SolarEclipseCheck)))) do
				for i = 1, ClickSpeed do
					coroutine.wrap(function()
						if closest then
							KnitService.ClickService.RF.Click:InvokeServer(tostring(closest));
						else
							ClickService:Click(nil)
						end
					end)();
				end
			end
			one = false;
		end
	end);
end);
pps_lock = false
task.spawn(function()
	RunService.Heartbeat:Connect(function()
		if (pps_lock == false) then
			pps_lock = true;
			while do_pps_repair do
				Knit_Pkg.GetService("SettingsService"):ToggleSlowAuto();
				task.wait()
				Knit_Pkg.GetService("SettingsService"):ToggleAuto();
				task.wait(10)
			end
			pps_lock = false;
		end
	end);
end);



local two = false;
task.spawn(function()
	RunService.Heartbeat:Connect(function()
		if (two == false) then
			two = true;
			while getgenv().PetDis and wait(2) do
				local dPetFound = false;
				local dPets = {};
				for i, v in next, Knit_Pkg.GetController("DataController"):GetData("PlayerData").PetInv do
					if (DisRarityCheck and table.find(DisRarityWl, PetsDatabase[v.name].rarity)) then
						continue;
					end
					if CheckPet(v, UsePetFilter) then
						continue;
					end
					if ((v.locked ~= true) and (v.equipped ~= true)) then
						dPetFound = true;
						table.insert(dPets, v.uid);
					end
				end
				if (dPetFound == true) then
					KnitService.PetLevelingService.RF.Dismantle:InvokeServer(dPets);
					dPetFound = false;
					UIController:CloseScreen("PetLeveling");
				end
				wait(DismantleDelay);
			end
			two = false;
		end
	end);
end);
local three = false;
task.spawn(function()
	RunService.Heartbeat:Connect(function()
		if (three == false) then
			three = true;
			while getgenv().SwordSell and wait(2) do
				local SwordFound = false;
				local Swords = {};
				local Equipped = {};
				table.insert(Equipped, PlayerData.EquippedWeapon.Left);
				table.insert(Equipped, PlayerData.EquippedWeapon.Right);
				for i, v in next, PlayerData.WeaponInv do
					if (RarityCheck and table.find(RarityWl, SwordDatabase[v.name].rarity)) then
						continue;
					end
					if table.find(Secret, v.name) then
						continue;
					end
					if (v.locked or table.find(Equipped, v.uid)) then
						continue;
					end
					if not v.enchants then
						continue;
					end
					if not next(v.enchants) then
						SwordFound = true;
						Swords[tostring(v.uid)] = true;
						continue;
					end
					if CheckAccept(v, UseFilter) then
						continue;
					end
					SwordFound = true;
					Swords[tostring(v.uid)] = true;
					continue;
				end
				if (SwordFound == true) then
					KnitService.WeaponInvService.RF.MultiSell:InvokeServer(Swords);
					SwordFound = false;
				end
				wait(SwordSellDelay);
			end
			three = false;
		end
	end);
end);
local four = false;
local fou = false;
task.spawn(function()
	RunService.Heartbeat:Connect(function()
		if (four == false) then
			four = true;
			coroutine.wrap(function()
				while getgenv().OpEgg do
					local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
					if not Root then
						continue;
					end
					local EggMagnitude = (Root.Position - Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.Position).Magnitude;
					if (EggMagnitude <= 60) then
						KnitService.EggService.RF.BuyEgg:InvokeServer(Buy_Egg_Args);
						if ignoreAmin then
							Knit_Pkg.GetController("EggOpenController"):Reset();
						else
							UIController:AlwaysOnTop(true);
							UIController:CloseScreen("EggEffect");
						end
					else
						wait(5);
					end
					wait(0.05);
				end
				four = false;
			end)();
		end
		--if (AutoRoll and not fou) then
		--	fou = true;
		--	coroutine.wrap(function()
		--		while AutoRoll and next(RollList) do
		--			KnitService.EnchantService.RF.RequestRoll:InvokeServer({
		--				modeType="Weapons",
		--				weaponUID=RollList[1],
		--				enchantTableName="Normal",
		--				rollType="Shard",
		--				auto=false
		--			});
		--			wait(4);
		--			if (next(RollResult) and CheckAccept(RollResult, RollUseFilter)) then
		--				table.remove(RollList, 1);
		--				RollListDispaly:Set({
		--					Title="RollList :",
		--					Content=table.concat(RollList, "\n")});
		--				if not next(RollList) then
		--					AutoRollToggle:Set(false);
		--					print("Roll Finished");
		--					Knit_Pkg.GetController("NotificationController"):Notification({
		--						message="结束附魔",
		--						color="Orange",
		--						multipleAllowed=false});
		--					break;
		--				end
		--			end
		--			RollResult = {};
		--		end
		--		fou = false;
		--	end)();
		--end
	end);
end);
local five = false;
task.spawn(function()
	RunService.Heartbeat:Connect(function()
		if (five == false) then
			five = true;
			local expRelicFound = false;
			if (UpRelic or DungeonAutoBuy or TravellingMerchantAutoBuy or AutoClaimChests or AutoHug or FragmentAutoBuy or CorruptAutoBuy) then
				if (UpRelic and (string.len(SelectedRelic) > 0) and PlayerData.RelicInv[SelectedRelic]) then
					local RelicExp = {};
					for i, v in next, PlayerData.RelicInv do
						if (v.equipped or v.locked) then
							continue;
						end
						if table.find(ExpRelicList, v.name) then
							table.insert(RelicExp, v.uid);
							expRelicFound = true;
						end
					end
					if expRelicFound then
						KnitService.RelicLevelingService.RF.LevelUp:InvokeServer(SelectedRelic, RelicExp);
						UIController:CloseScreen("RelicLeveling");
						--my_Labels["UpgradeExp"] = PlayerData.RelicInv[SelectedRelic].exp
						Labels.UpgradeExp:SetText(PlayerData.RelicInv[SelectedRelic].exp);
						my_UDatas["UpgradeExp"]=PlayerData.RelicInv[SelectedRelic].exp
						--UserDatas.UDatas:SetValue("UpgradeExp", PlayerData.RelicInv[SelectedRelic].exp);
					end
				end
				if DungeonAutoBuy then
					for j = 1, 3 do
						for i = 1, 5 do
							KnitService.LimitedShopsService.RF.BuyItem:InvokeServer("DungeonShop", i);
							wait(0.8);
						end
					end
				end
				if FragmentAutoBuy then
					for j = 1, 3 do
						for i = 1, 6 do
							KnitService.LimitedShopsService.RF.BuyItem:InvokeServer("FragmentLordShop", i);
							wait(0.8);
						end
					end
				end
				if CorruptAutoBuyAutoBuy then
					for j = 1, 3 do
						for i = 1, 5 do
							KnitService.LimitedShopsService.RF.BuyItem:InvokeServer("LurkingShadow", i);
							wait(0.8);
						end
					end
				end
				if TravellingMerchantAutoBuy then
					for j = 1, 3 do
						for i = 1, 5 do
							KnitService.LimitedShopsService.RF.BuyItem:InvokeServer("TravellingMerchant", i);
							wait(0.8);
						end
					end
				end
				if AutoClaimChests then
					for i, v in {"Chest 1","Chest 2","Chest 3","Free Ticket 1","Free Ticket 2","Free Ticket 3"} do
						KnitService.ChestService.RF.ClaimChest:InvokeServer(v);
						wait(0.8);
					end
				end
				if AutoHug then
					KnitService.PrincessEventService.RF.DoHug:InvokeServer()
					wait(0.8);
				end
				local WheelTime = 43200 - (os.time() - PlayerData.WheelStamp);
				if (WheelTime <= 0) then
					WController:SpinWheel(true);
				end
				local IllusionistTime = 172800 - (os.time() - PlayerData.IllusionistTicketStamp);
				if (WheelTime <= 0) then
					IllusionistService:ClaimTicket();
				end
                local KoreanWheelTime = 86400 - (os.time() - PlayerData.KoreanWheelStamp);
                if (KoreanWheelTime <= 0) then
                    KWController:SpinWheel(true);
                end
				wait(10);
			end
			wait(3);
			five = false;
		end
	end);
end);
local Loadouts = PlayerData.Loadouts;
local WeaponGroups = {};
local WeaponGroupOptions = {};
for addressId, WeaponGroup in Loadouts, nil do
	WeaponGroups[WeaponGroup.Name] = addressId;
	table.insert(WeaponGroupOptions, WeaponGroup.Name);
end
--local Target = Knit_Pkg.GetController("EnchantRollController");
--local Target = require(game:GetService("ReplicatedStorage").ClientModules.Controllers.AfterLoad.EnchantRollController)
--oldRoll = hookfunction(Target['Roll'], function(this, result)
--	RollResult = result;
--	if not (AutoRoll and IgnRollAmin) then
--		return oldRoll(this, result);
--	end
--end);
--关闭技能前摇
local Target_anime = Knit_Pkg.GetController("SkillsBottomController")
oldVFX = hookfunction(Target_anime['SpinAndShootOrb'], function(p15, p16, p17, p18)
	Knit_Pkg.GetService("SkillService"):DamageNPC(p18);
end);

local cButton;
local cRoot;

Dungeon_Service.DungeonReplicate:Connect(function(DungeonData)
	if (DungeonData and (DungeonData.roomReached > 0) and ((DungeonData.roomReached % 4) == 0)) then
		if (InDungeon and (EasyDungeon or HardDungeon or InsaneDungeon) and (DungeonContinueButton == false) and not closest) then
			DungeonContinueButton = true;
			coroutine.wrap(function()
				cButton = Workspace.Live.Dungeons:FindFirstChild("ContinueButton", true);
				cRoot = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
				if ContinueButtonUID then
					--print("Button found, I am going to press it.")
					if (DungeonData.roomReached > 4) then
						task.wait(0.3);
						if (not cRoot or not cRoot.CFrame) then
							--print("Player not found, try again later.")
							return;
						end
						cRoot.CFrame = CFrame.new(cRoot.CFrame.x - 200, cRoot.CFrame.y, cRoot.CFrame.z, 1, 0, 0, 0, 1, 0, -4, 0, 1);
					end
					task.wait(0.2);
					if InDungeon == 3 then
						task.wait(insane_dungeon_delay_time)
						--print("wait" .. insane_dungeon_delay_time .. "second before press the button")
					elseif InDungeon then
						task.wait(1)
					end
					KnitService.DungeonService.RF.ContinueDungeon:InvokeServer(ContinueButtonUID);
					--print("Button pressed")
				else
					--print("Button not found, tp again.")
					task.wait(0.2);
					if (not cRoot or not cRoot.CFrame or not cButton or not cButton.CFrame) then
						--print("Button not found, try again later.")
						return;
					end
					cRoot.CFrame = cButton.CFrame * CFrame.new(0, 7, -8);
				end
				DungeonContinueButton = false;
			end)();
		end
	end
end);
map_loading = false
game:GetService("CollectionService"):GetInstanceAddedSignal("ServerNPC"):Connect(function(p9)
	task.wait();
	if (ServerBossCheck and p9 and table.find(ServerBossList, p9:GetAttribute("Name")) and not InDungeon ) then

		task.wait(6)
		if (SunBurstCheck and isSunBurst) then
			task.wait(900)
		end

		if not map_loading then
			map_loading = true
			Knit_Pkg.GetController("NotificationController"):Notification({message="检测到服务器boss，即将加载所有地图，并更换为血月装备",color="Red",multipleAllowed=false});
			print("Server Boss, wait for 6 s");
			wait(6);
			for i, v in next, EggsDatabase do
				wait(0.1)
				LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = Workspace.Live.FloatingEggs[v.name].HumanoidRootPart.CFrame * CFrame.new(0, 4, -3.5);
			end
			if (ServerBossCheck and typeof(RelicPresetSetting.BloodMoon) == "string") then
				EquipRelics(RelicPresetSetting.BloodMoon);
			end
			isServerBoss = true;
			isKillServerBoss = false;
			map_loading = false
		end
	end
end);
game:GetService("CollectionService"):GetInstanceAddedSignal("SkillCrate"):Connect(function(p13)
	--print("kkkkk");
	wait(0.5);
	if ServerBossCheck then
		Knit_Pkg.GetService("ServerBossService"):OpenCrate();
	end
	isKillServerBoss = true;
end);
game:GetService("CollectionService"):GetInstanceRemovedSignal("SkillCrate"):Connect(function(p14)
	--print("next");
	wait(4);
	isKillServerBoss = false;
end);
game:GetService("CollectionService"):GetInstanceRemovedSignal("DungeonContinueButton"):Connect(function(Button)
	--print("button trrigered", ContinueButtonUID, Button:GetAttribute("UID"))
	if (not ContinueButtonUID and Button:GetAttribute("UID")) then
		--print("button uid found")
		ContinueButtonUID = Button:GetAttribute("UID");
	end
end);
--local Knit_Pkg = require(game:GetService("ReplicatedStorage").Packages.Knit);
local DungeonController = Knit_Pkg.GetController("DungeonController");
local DCActivate;
DCActivate = hookfunction(DungeonController['Activate'], function(this, result)
	--print("hooked button trrigered", this, result )
	wait(0.2);
	if (result ~= nil) then
		--print("hooked button info:",ContinueButtonUI, result, result:GetAttribute("UID"))

		if (not ContinueButtonUID and result:GetAttribute("UID")) then
			--print("hooked button uid found")
			ContinueButtonUID = result:GetAttribute("UID");
		end
	end
	return DCActivate(this, result);
end);
--------------
--local Knit_Pkg = require(game:GetService("ReplicatedStorage").Packages.Knit);
--local SkillsBottomController = Knit_Pkg.GetController("SkillsBottomController");
--local oldRoll
--oldSBC = hookfunction(SkillsBottomController['KnitStart'], function(this)
--	print(this)
--	return oldSBC(this);
--end);
--------------


hookfunction(require(game:GetService("ReplicatedStorage").ClientModules.Controllers.AfterLoad.ItemDropController.ItemDropNode)['Pickup'], function(this)
	return this:Claim();
end);
game.NetworkClient.ChildRemoved:Connect(function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer);

end);

print("Done!");
Toggles.AutoPower:OnChanged(function()
	getgenv()._POWER = Toggles.AutoPower.Value;
end);
Toggles.AutoPowerDuringNight:OnChanged(function()
	getgenv()._POWERNight = Toggles.AutoPowerDuringNight.Value;
end);
Toggles.AutoSkill:OnChanged(function()
	--print("开启auto skill",Toggles.AutoSkill.Value)
	getgenv().IsAutoSkill = Toggles.AutoSkill.Value;
	--卸下当前技能
	--local SkillsBottom = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SkillsBottom")
	--local Skills = SkillsBottom:WaitForChild("Skills")
	--local skill_slot_list = { Skills:WaitForChild("Template"), Skills:WaitForChild("Template2"), Skills:WaitForChild("Template3") };
	--skill_slot_list[1]:SetAttribute("Skill", "")
	--skill_slot_list[1].Icon.Image = ""
	--skill_slot_list[2]:SetAttribute("Skill", "")
	--skill_slot_list[3]:SetAttribute("Skill", "")
end);
--Toggles.CloseRollAnimation:OnChanged(function()
--	getgenv().IgnRollAmin = Toggles.CloseRollAnimation.Value;
--end);

Options.AuraDistance:OnChanged(function()
	getgenv().Distance = Options.AuraDistance.Value;
end);
Options.ClickSpeed:OnChanged(function()
	getgenv().ClickSpeed = Options.ClickSpeed.Value;
end);
Options.insane_dungeon_delay:OnChanged(function()
	getgenv().insane_dungeon_delay_time = Options.insane_dungeon_delay.Value;
end);
Toggles.AutoDismantle:OnChanged(function()
	getgenv().PetDis = Toggles.AutoDismantle.Value;
end);
Options.AuraDistance:OnChanged(function()
	getgenv().Distance = Options.AuraDistance.Value;
end);
Options.DismantleDelay:OnChanged(function()
	getgenv().DismantleDelay = Options.DismantleDelay.Value;
end);
Toggles.DisRarityCheck:OnChanged(function()
	getgenv().DisRarityCheck = Toggles.DisRarityCheck.Value;
end);
Options.PetAddToWhitelist:OnChanged(function()
	DisRarityWl = {};
	for key, value in next, Options.PetAddToWhitelist.Value do
		if not table.find(DisRarityWl, key) then
			table.insert(DisRarityWl, key);
		end
	end
end);
Options.SelectSkill:OnChanged(function()
	--selecetSkill = Options.SelectSkill.Value;
	DisSkillList = {}
	Labels.SklList:SetText("");
	local SkillStr = "";
	for key, value in pairs(Options.SelectSkill.Value) do
		if not table.find(DisSkillList, key) then
			table.insert(DisSkillList, key);
			SkillStr = SkillStr .. key .. "\n"
		end
	end
	Labels.SklList:SetText(SkillStr);
end);
Toggles.AutoSell:OnChanged(function()
	getgenv().SwordSell = Toggles.AutoSell.Value;
end);
Options.SWordSellDelay:OnChanged(function()
	SwordSellDelay = Options.SWordSellDelay.Value;
end);
Toggles.WeaponRarityCheck:OnChanged(function()
	getgenv().RarityCheck = Toggles.WeaponRarityCheck.Value;
end);
Options.WeaponAddtoWhitelist:OnChanged(function()
	RarityWl = {};
	for key, value in next, Options.WeaponAddtoWhitelist.Value do
		if not table.find(RarityWl, key) then
			table.insert(RarityWl, key);
		end
	end
end);
Toggles.AutoOpenEggs:OnChanged(function()
	getgenv().OpEgg = Toggles.AutoOpenEggs.Value;
end);
Toggles.IgnoreOpneAmination:OnChanged(function()
	getgenv().ignoreAmin = Toggles.IgnoreOpneAmination.Value;
end);
Options.EggsSelected:OnChanged(function()
	if not Options.EggsSelected.Value then
		return;
	end
	selectedEgg = Options.EggsSelected.Value;
	Buy_Egg_Args.eggName = Eggs[selectedEgg];
	beforePos = Workspace.Live.FloatingEggs[selectedEgg].HumanoidRootPart.CFrame * CFrame.new(0, 6, -3.5);
end);
Options.EggsAmounts:OnChanged(function()
	Buy_Egg_Args.amount = Options.EggsAmounts.Value;
end);
Toggles.AutoUpgradeRelic:OnChanged(function()
	getgenv().UpRelic = Toggles.AutoUpgradeRelic.Value;
end);
Options.Relic_DefaultWeaponGroup:OnChanged(function()
	RelicPresetSetting.Default = Options.Relic_DefaultWeaponGroup.Value;
	selecetWeaponGroup = Options.Relic_DefaultWeaponGroup.Value;
end);
Toggles.AutoEasy:OnChanged(function()
	getgenv().EasyDungeon = Toggles.AutoEasy.Value;
	if Toggles.AutoEasy.Value then
		Toggles.AutoInsane:SetValue(false);
	end
end);
Options.EasyRoom:OnChanged(function()
	getgenv().EasyReach = Options.EasyRoom.Value;
end);
Toggles.AutoHard:OnChanged(function()
	getgenv().HardDungeon = Toggles.AutoHard.Value;
end);
Options.HardRoom:OnChanged(function()
	getgenv().HardReach = Options.HardRoom.Value;
end);
Toggles.AutoInsane:OnChanged(function()
	getgenv().InsaneDungeon = Toggles.AutoInsane.Value;
	if Toggles.AutoInsane.Value then
		Toggles.AutoEasy:SetValue(false);
	end
end);
Options.InsaneRoom:OnChanged(function()
	getgenv().InsaneReach = Options.InsaneRoom.Value;
end);
Options.TowerRoom:OnChanged(function()
	getgenv().TowerReach = Options.TowerRoom.Value;
end);
Options.WaitTime:OnChanged(function()
	getgenv().DungeonWaitTime = Options.WaitTime.Value;
end);
--Options.SkillDelay:OnChanged(function()
--	getgenv().SkillDelayTime = Options.SkillDelay.Value;
--end);
Options.DungeonWeapon:OnChanged(function()
	RelicPresetSetting.Dungeon = Options.DungeonWeapon.Value;
end);
--Options.UseDamageRooms:OnChanged(function()
--	HardDungeonUseDamage = tonumber(Options.UseDamageRooms.Value);
--end);
Options.UseInsaneBoostRooms:OnChanged(function()
	InsaneDungeonUseBoost = tonumber(Options.UseInsaneBoostRooms.Value);
end);
Toggles.AutoTower:OnChanged(function()
	getgenv().AutoTower = Toggles.AutoTower.Value;
end);
Toggles.AutoRaid:OnChanged(function()
	getgenv().AutoRaid = Toggles.AutoRaid.Value;
end);
Options.FarmSpeed:OnChanged(function()
	getgenv().FarmSpeedTime = Options.FarmSpeed.Value;
end);
Toggles.autoFarm:OnChanged(function()
	getgenv().AutoFarm = Toggles.autoFarm.Value;
end);
Toggles.FarmAllMap:OnChanged(function()
	getgenv().FarmAllMap = Toggles.FarmAllMap.Value;
end);
Toggles.FarmSelectedMobs:OnChanged(function()
	getgenv().FarmSelected = Toggles.FarmSelectedMobs.Value;
end);
Options.SelectedArea:OnChanged(function()
	if not Options.SelectedArea.Value then
		return;
	end
	Options.SelectedMob.Values = AllMobs[Options.SelectedArea.Value];
	Options.OtherMob.Values = AllMobs[Options.SelectedArea.Value];
	Options.SelectedMob:SetValues();
	Options.OtherMob:SetValues();
	local B_List = {};
	local M_List = {};
	for k, v in AllMobs[Options.SelectedArea.Value] do
		if table.find(MobBlackList, v) then
			B_List[v] = true;
		end
		if table.find(MobWhiteList, v) then
			M_List[v] = true;
		end
	end
	Options.SelectedMob:SetValue(B_List);
	Options.OtherMob:SetValue(M_List);
end);
Toggles.BloodMoonCheck:OnChanged(function()
	getgenv().BloodMoonCheck = Toggles.BloodMoonCheck.Value;
	if not BloodMoonCheck then
		isBloodMoon = false
	end
end);
Toggles.CorruptEventCheck:OnChanged(function()
	getgenv().CorruptEventCheck = Toggles.CorruptEventCheck.Value;
	--1:"Not started" 2:"working on 1" 3:"1 finished" 4:"working on 2"  5:"2 finished"
	CorruptMingStatus = 1
end);
Toggles.AutoUseLuck:OnChanged(function()
	getgenv().bAutoUseLuckBoost = Toggles.AutoUseLuck.Value;
end);
Toggles.AutoUseSecretLuck:OnChanged(function()
	getgenv().bAutoUseSecretLuckBoost = Toggles.AutoUseSecretLuck.Value;
end);
Toggles.AutoUseCoin:OnChanged(function()
	getgenv().bAutoUseCoinBoost = Toggles.AutoUseCoin.Value;
end);
--Toggles.AutoUsePower:OnChanged(function()
--	getgenv().bAutoUsePowerBoost = Toggles.AutoUsePower.Value;
--end);
Toggles.AutoUseDmg:OnChanged(function()
	getgenv().bAutoUseDmgBoost = Toggles.AutoUseDmg.Value;
end);
Toggles.AutoUseLuckQuest:OnChanged(function()
	getgenv().bAutoUseLuckBoostQuest = Toggles.AutoUseLuckQuest.Value;
end);
Toggles.AutoUseSecretLuckQuest:OnChanged(function()
	getgenv().bAutoUseSecretLuckBoostQuest = Toggles.AutoUseSecretLuckQuest.Value;
end);
Toggles.AutoUseCoinQuest:OnChanged(function()
	getgenv().bAutoUseCoinBoostQuest = Toggles.AutoUseCoinQuest.Value;
end);
--Toggles.AutoUsePowerQuest:OnChanged(function()
--	getgenv().bAutoUsePowerBoostQuest = Toggles.AutoUsePowerQuest.Value;
--end);
Toggles.AutoUseDmgQuest:OnChanged(function()
	getgenv().bAutoUseDmgBoostQuest = Toggles.AutoUseDmgQuest.Value;
end);

--dungeon
Toggles.InsaneAutoUseLuck:OnChanged(function()
	getgenv().InsaneAutoUseLuckBoost = Toggles.InsaneAutoUseLuck.Value;
end);
Toggles.InsaneAutoUseSecretLuck:OnChanged(function()
	getgenv().InsaneAutoUseSecretLuckBoost = Toggles.InsaneAutoUseSecretLuck.Value;
end);
Toggles.InsaneAutoUseDmg:OnChanged(function()
	getgenv().InsaneAutoUseDmgBoost = Toggles.InsaneAutoUseDmg.Value;
end);
Toggles.InsaneAutoUseLuckQuest:OnChanged(function()
	getgenv().InsaneAutoUseLuckBoostQuest = Toggles.InsaneAutoUseLuckQuest.Value;
end);
Toggles.InsaneAutoUseSecretLuckQuest:OnChanged(function()
	getgenv().InsaneAutoUseSecretLuckBoostQuest = Toggles.InsaneAutoUseSecretLuckQuest.Value;
end);
Toggles.InsaneAutoUseDmgQuest:OnChanged(function()
	getgenv().InsaneAutoUseDmgBoostQuest = Toggles.InsaneAutoUseDmgQuest.Value;
end);


Options.BloodMoonSelectMob:OnChanged(function()
	BloodMoonSelectMobList = {};
	for key, value in next, Options.BloodMoonSelectMob.Value do
		if not table.find(BloodMoonSelectMobList, key) then
			table.insert(BloodMoonSelectMobList, key);
		end
	end
end);
Options.SetWeaponGroup:OnChanged(function()
	RelicPresetSetting.BloodMoon = Options.SetWeaponGroup.Value;
end);
Toggles.EggNight:OnChanged(function()
	getgenv().NightCheck = Toggles.EggNight.Value;
	if not NightCheck then
		Nighting = false
	end
end);
Toggles.EggBurst:OnChanged(function()
	getgenv().SunBurstCheck = Toggles.EggBurst.Value;
	if not SunBurstCheck then
		isSunBurst = false
	end
end);
Toggles.EggEclipse:OnChanged(function()
	getgenv().SolarEclipseCheck = Toggles.EggEclipse.Value;
	if not SolarEclipseCheck then
		isSolarEclipse = false
	end
end);
Toggles.hAutoUseLuck:OnChanged(function()
	getgenv().nAutoUseLuckBoost = Toggles.hAutoUseLuck.Value;
end);
Toggles.hAutoUseSecretLuck:OnChanged(function()
	getgenv().nAutoUseSecretLuckBoost = Toggles.hAutoUseSecretLuck.Value;
end);
Toggles.hAutoUsePower:OnChanged(function()
	getgenv().nAutoUsePowerBoost = Toggles.hAutoUsePower.Value;
end);
Toggles.hAutoUseLuckQuest:OnChanged(function()
	getgenv().nAutoUseLuckBoostQuest = Toggles.hAutoUseLuckQuest.Value;
end);
Toggles.hAutoUseSecretLuckQuest:OnChanged(function()
	getgenv().nAutoUseSecretLuckBoostQuest = Toggles.hAutoUseSecretLuckQuest.Value;
end);
Toggles.hAutoUsePowerQuest:OnChanged(function()
	getgenv().nAutoUsePowerBoostQuest = Toggles.hAutoUsePowerQuest.Value;
end);
Options.hSetWeaponGroup:OnChanged(function()
	RelicPresetSetting.Night = Options.hSetWeaponGroup.Value;
end);
Toggles.ServerBossCheck:OnChanged(function()
	getgenv().ServerBossCheck = Toggles.ServerBossCheck.Value;
end);
Toggles.DungeonItems:OnChanged(function()
	getgenv().DungeonAutoBuy = Toggles.DungeonItems.Value;
end);
Toggles.FragmentItems:OnChanged(function()
	getgenv().FragmentAutoBuy = Toggles.FragmentItems.Value;
end);
Toggles.CorruptItems:OnChanged(function()
	getgenv().CorruptAutoBuy = Toggles.CorruptItems.Value;
end);
Toggles.TravellingMerchantItems:OnChanged(function()
	getgenv().TravellingMerchantAutoBuy = Toggles.TravellingMerchantItems.Value;
end);
Toggles.AutoClaimChests:OnChanged(function()
	getgenv().AutoClaimChests = Toggles.AutoClaimChests.Value;
end);
Toggles.AutoHug:OnChanged(function()
	getgenv().AutoHug = Toggles.AutoHug.Value;
end);
Toggles.InfiniteJump:OnChanged(function()
	InfiniteJump = Toggles.InfiniteJump.Value;
	game:GetService("UserInputService").JumpRequest:connect(function()
		if InfiniteJump then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping");
		end
	end);
end);
Options.PickUpRange:OnChanged(function()
	Text = tonumber(Options.PickUpRange.Value);
	if Text then
		Workspace:SetAttribute("PICKUP_RANGE", Text);
	end
end);
Toggles.UnlockTP:OnChanged(function()
	if Toggles.UnlockTP.Value then
		local Button = LocalPlayer.PlayerGui.LeftSidebar.Background.Frame.MinorButtons.Teleport.Button;
		local ButtonC = Button:Clone();
		ButtonC.Parent = Button.Parent;
		Button:Remove();
		ButtonC.Activated:Connect(function()
			UIController:OpenScreen("Teleport");
		end);
	end
end);
Toggles.UnlockAutoSwing:OnChanged(function()
	if Toggles.UnlockAutoSwing.Value then
		local Button = LocalPlayer.PlayerGui.RightSidebar.Background.Frame.Window.Items.AutoSwing.Button;
		local ButtonC = Button:Clone();
		ButtonC.Parent = Button.Parent;
		Button:Remove();
		ButtonC.Activated:Connect(function()
			Knit_Pkg.GetService("SettingsService"):ToggleAuto();
		end);
	end
end);
Toggles.Invisibility:OnChanged(function()
	if Toggles.Invisibility.Value then
		Invisfunc();
		writefile("SFS Sript/set", "true");
	else
		writefile("SFS Sript/set", "false");
	end
end);
Toggles.pps_repair:OnChanged(function()
	getgenv().do_pps_repair = Toggles.pps_repair.Value
end);
Toggles.UseFilterForAutoShell:OnChanged(function()
	UseFilter = Toggles.UseFilterForAutoShell.Value;
end);
Toggles.UseFilterForAutoRoll:OnChanged(function()
	RollUseFilter = Toggles.UseFilterForAutoRoll.Value;
end);
Options.Enchant:OnChanged(function()
	SelectedEnchant = Options.Enchant.Value;
	Options.Tiers:SetValue(0);
end);
Options.Tiers:OnChanged(function()
	if not SelectedEnchant then
		return;
	end
	if not EnchantsRefuse[SelectedEnchant] then
		EnchantsRefuse[SelectedEnchant] = 0;
	end
	EnchantsRefuse[SelectedEnchant] = Options.Tiers.Value;
	--my_Labels["FList"] = ""
	Labels.FList:SetText("");
	local TiersStr = "";
	for key, value in EnchantsRefuse do
		TiersStr = TiersStr .. key .. ":" .. value .. "\n";
	end
	--my_Labels["FList"] = TiersStr
	Labels.FList:SetText(TiersStr);



end);
Toggles.UsePetFilterForAutoShell:OnChanged(function()
	UsePetFilter = Toggles.UsePetFilterForAutoShell.Value;
end);
Options.PetEnchant:OnChanged(function()
	SelectedPetEnchant = Options.PetEnchant.Value;
	Options.PetTiers:SetValue(0);
end);
Options.PetTiers:OnChanged(function()
	if not SelectedPetEnchant then
		return;
	end
	if not PetEnchantsRefuse[SelectedPetEnchant] then
		PetEnchantsRefuse[SelectedPetEnchant] = 0;
	end
	PetEnchantsRefuse[SelectedPetEnchant] = Options.PetTiers.Value;
	--my_Labels["PetFList"] = ""
	Labels.PetFList:SetText("");
	local TiersStr = "";
	for key, value in PetEnchantsRefuse do
		TiersStr = TiersStr .. key .. ":" .. value .. "\n";
	end
	--my_Labels["PetFList"] = TiersStr
	Labels.PetFList:SetText(TiersStr);
end);
local MyButton = Instance.new("ImageButton");
MyGui.Parent = game.CoreGui;
MyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
MyButton.Parent = MyGui;
MyButton.Position = UDim2.new(0, 50, 0, 20);
MyButton.Size = UDim2.new(0, 35, 0, 35);
MyButton.Image = "rbxassetid://5198838744";
MyButton.BackgroundTransparency = 1;
local dragging;
local dragInput;
local dragStart;
local startPos;
local function update(input)
	local delta = input.Position - dragStart;
	MyButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
end
MyButton.InputBegan:Connect(function(input)
	if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
		dragging = true;
		dragStart = input.Position;
		startPos = MyButton.Position;
		input.Changed:Connect(function()
			if (input.UserInputState == Enum.UserInputState.End) then
				dragging = false;
			end
		end);
	end
end);
MyButton.InputChanged:Connect(function(input)
	if ((input.UserInputType == Enum.UserInputType.MouseMovement) or (input.UserInputType == Enum.UserInputType.Touch)) then
		dragInput = input;
	end
end);
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if ((input == dragInput) and dragging) then
		update(input);
	end
end);
MyButton.MouseButton1Click:connect(function()
	if Debounce then
		return;
	end
	Library.Toggle();
	my_UDatas["EnchantsRefuse"]=EnchantsRefuse
	--UserDatas.UDatas:SetValue("EnchantsRefuse", EnchantsRefuse);
	my_UDatas["PetEnchantsRefuse"]=PetEnchantsRefuse
	--UserDatas.UDatas:SetValue("PetEnchantsRefuse", PetEnchantsRefuse);
	SaveManager:Save(ConfigurationName);

	--直接存字典，不用savemanager了
	local success, encoded = pcall(HttpService.JSONEncode, HttpService, my_UDatas)
	if success then
		-- 将 JSON 字符串写入文件
		writefile(udatas_file_name, encoded)
		print("udatas存储成功")
	else
		print("udatas存储失败")
	end


end);
local loadUdatas = function()
	-- 从文件中读取 JSON 字符串
	if not isfile(udatas_file_name) then
        print("udatas读取失败")
		return
	end
    print("udatas读取成功")
    local jsonStr = readfile(udatas_file_name)
    -- 将 JSON 字符串解码为 Lua 表
    success, decoded = pcall(HttpService.JSONDecode, HttpService, jsonStr)
	--更新my_UDatas
	for k, v in pairs(decoded) do
		my_UDatas[k] = v
	end
end
local loadData = function()
	loadUdatas()

	local uData = my_UDatas
	--local uData = UserDatas.UDatas.Value;
	if uData["UpgradeId"] then
		--my_Labels["UpgradeId"] = uData["UpgradeId"]
		Labels.UpgradeId:SetText(uData["UpgradeId"]);
		SelectedRelic = uData["UpgradeId"];
		--my_Labels["UpgradeName"] = uData["UpgradeName"]
		Labels.UpgradeName:SetText(uData["UpgradeName"]);
		--my_Labels["UpgradeExp"] = uData["UpgradeExp"]
		Labels.UpgradeExp:SetText(uData["UpgradeExp"]);
	end
	local MobBlackListStr = "";
	MobBlackList = uData["MobBlackList"];
	MobWhiteList = uData["MobWhiteList"];
	EnchantsRefuse = uData["EnchantsRefuse"];
	PetEnchantsRefuse = uData["PetEnchantsRefuse"];
	ExpRelicList = uData["ExpRelicList"];
	--SelectSkill = uData["SelectSkill"]
	if (MobBlackList ~= nil) then
		for key, value in next, MobBlackList do
			MobBlackListStr = MobBlackListStr .. value .. "\n";
		end
		if (#MobBlackList == 0) then
			MobBlackListStr = MobBlackListStr .. "is NULL";
		end
		--my_Labels["BlackListLabel"] = MobBlackListStr
		Labels.BlackListLabel:SetText(MobBlackListStr);
	else
		MobBlackList = {};
	end
	MobBlackListStr = "";
	if (MobWhiteList ~= nil) then
		for key, value in next, MobWhiteList do
			MobBlackListStr = MobBlackListStr .. value .. "\n";
		end
		if (#MobWhiteList == 0) then
			MobBlackListStr = MobBlackListStr .. "is NULL";
		end
		--my_Labels["WhiteListLabel"] = MobBlackListStr
		Labels.WhiteListLabel:SetText(MobBlackListStr);
	else
		MobWhiteList = {};
	end
	if (EnchantsRefuse ~= nil) then
		local TiersStr = "";
		for key, value in EnchantsRefuse do
			TiersStr = TiersStr .. key .. ":" .. value .. "\n";
		end
		--my_Labels["FList"] = TiersStr
		Labels.FList:SetText(TiersStr);
	end
	if (PetEnchantsRefuse ~= nil) then
		local TiersStr = "";
		for key, value in PetEnchantsRefuse do
			TiersStr = TiersStr .. key .. ":" .. value .. "\n";
		end
		--my_Labels["PetFList"] = TiersStr
		Labels.PetFList:SetText(TiersStr);
	end
	--if (SelectSkill ~= nil) then
	--	print("技能记录载入成功")
	--	local SkillStr = "";
	--	for key, value in SelectSkill do
	--		SkillStr = SkillStr .. key .. "\n"
	--	end
	--	Labels.SklList:SetText(SkillStr);
	--else
	--	print("技能记录载入失败")
	--end
	if ExpRelicList then
		--my_Labels["BlackList"] = "All:" .. #ExpRelicList
		Labels.BlackList:SetText("All:" .. #ExpRelicList);
	end
end;
if SaveManager:Load(ConfigurationName) then
	wait(1.5);
	loadData();
end
print("End");