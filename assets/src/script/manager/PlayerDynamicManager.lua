--玩家动态数据管理类
PlayerDynamicManager = {}
_pdm = PlayerDynamicManager
_pdm.__cname = "PlayerDynamicManager"

function PlayerDynamicManager:fun_init_login()
	trace("PlayerDynamicManager:fun_init_login")
	
	-- --登陆
	-- self.loginMainData = require("game.data.login.LoginMainData").new()
	
	-- --界面信息
	-- self.uiData = require("game.data.ui.UiMainData").new()

end

function PlayerDynamicManager:fun_init()
	trace("PlayerDynamicManager:fun_init")
	
	-- --玩家信息
	-- self.playerData = require("script.data.PlayerData").new()
	
	--水果机
	self.fruitsMainData = require("script.data.fruits.FruitsMainData").new()

end

--解析游戏数据
function PlayerDynamicManager:fun_ParseData(resData)

	-- trace(self,"------------解析游戏数据-------------")
	
	-- self.playerData:init(resData)
	
	-- --读取本地存储
	-- LocalStorageManager:fun_Instance():read()
	
	-- self.propMainData:init(resData)
	
	-- self.fightMainData:init(resData)
	
	-- -- 初始化主界面数据
	-- self.homeMainData:init()
	-- -- 初始化首充礼包数据
	-- self.firstChargeData:init(resData.fristPay)
	-- -- 初始化好友数据
	-- self.friendData:init()
	-- -- 初始化背包数据
	-- self.backpackData:init()
	-- -- 初始化商店数据
	-- self.shopData:init(resData.fristPay)
	
end
