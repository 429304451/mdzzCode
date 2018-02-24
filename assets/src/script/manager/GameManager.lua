-- 游戏管理器
GameManager = {}
_gm = GameManager
_gm.__cname = "GameManager"
--当前场景
_gm.curScene = nil
--当前层
_gm.curLayer = nil
--游戏系统层级ID
_gm.ID_BG    = 1
_gm.ID_Main  = 2
_gm.ID_Menu  = 3
_gm.ID_Win   = 4
_gm.ID_Dlg   = 5
_gm.ID_Guild = 6
_gm.ID_Effect= 7
_gm.ID_SysTip= 8
_gm.ID_Warn  = 9
_gm.ID_Debug = 10

function GameManager:init()
	--适配参数计算
	self:fun_calInv()
	--注册文件
	self:loadFiles()
end

--适配参数计算
function GameManager:fun_calInv()

	WIN_SIZE = cc.Director:getInstance():getWinSize()--CC_DESIGN_RESOLUTION
	WIN_Width = WIN_SIZE.width
	WIN_Height = WIN_SIZE.height

	--游戏基准参数及位置
	WIN_center = cc.p(WIN_Width/2,WIN_Height/2)
	WIN_left_up = cc.p(0,WIN_Height)
	WIN_left_down = cc.p(0,0)
	WIN_right_up = cc.p(WIN_Width,WIN_Height)
	WIN_right_down = cc.p(WIN_Width,0)
	WIN_up_center = cc.p(WIN_Width/2,WIN_Height)
	WIN_down_center = cc.p(WIN_Width/2,0)
	WIN_left_center = cc.p(0,WIN_Height/2)
	WIN_right_center = cc.p(WIN_Width,WIN_Height/2)
	BaseWidth = CC_DESIGN_RESOLUTION.width
	BaseHeight = CC_DESIGN_RESOLUTION.height

	-- --计算背景缩放比例
	-- local basePercentage = BaseWidth/BaseHeight
	-- local nowPercentage = WIN_Width/WIN_Height
	-- if nowPercentage > basePercentage then
	-- 	self.gameScaleRate = nowPercentage/basePercentage
	-- elseif nowPercentage < basePercentage then
	-- 	self.gameScaleRate = basePercentage/nowPercentage
	-- else
	-- 	self.gameScaleRate = 1
	-- end
	-- --背景缩放比例
	self.bgScaleW = WIN_Width / BaseWidth
	self.bgScaleW2 = self.bgScaleW > 1 and 1 or self.bgScaleW
	-- self.bgScaleH = WIN_Height / BaseHeight

	-- trace("WIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZE")
	-- trace(self.gameScaleRate)
	-- trace(WIN_Width,WIN_Height)
	-- trace("背景图缩放比例 W：", self.bgScaleW)
	-- trace("背景图缩放比例 H：", self.bgScaleH)
	-- trace("WIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZEWIN_SIZE")
end
function GameManager:startUIScene()
	-- local UIScene = require("game.views.scene.UIScene")
	-- local runningScene = cc.Director:getInstance():getRunningScene()
	-- local scene = UIScene.new(1)
	-- if runningScene then
	-- 	cc.Director:getInstance():replaceScene(scene)
	-- else
	-- 	cc.Director:getInstance():runWithScene(scene)
	-- end
end

--战斗跳转到主场景
function GameManager:turnToUIScene()
end

--打开是否关闭游戏弹出框
function GameManager:openEndGameDialog()
end

--重新加载lua文件
function GameManager:reloadLua()
	for k,v in pairs(package.loaded) do
		--只有lua模块卸载
		local path = string.gsub(k, "%.", "/")
		local filePath = cc.FileUtils:getInstance():fullPathForFilename("luaassets/script/"..path..".luac")
		if filePath == nil or filePath == "" then
			filePath = cc.FileUtils:getInstance():fullPathForFilename("luaassets/script/"..path..".lua")
		end
		if filePath ~= nil and filePath ~= "" then
			package.loaded[k] = nil
			require(k)
		end
	end
end

--游戏重新启动
function GameManager:gameReStart()
end

--退到登陆
function GameManager:backToLogin()
end

--心跳包
function GameManager:sendHeart()
end

--停止心跳包
function GameManager:stopHeart()
end

function GameManager:loginSdk(obj,pCallback)
end

function GameManager:logoutSdk()
end

function GameManager:loadFiles()
	require "script.util.AnimationUtil"
	require "script.util.UIUtils"
	require "script.util.NUtils"
	require "script.util.Log"

	require "script.base.BaseNode"
	require "script.base.BaseLayer"
	require "script.base.BaseContainer"
	require "script.base.BaseDialog"
	require "script.base.BaseNetHandle"
	require "script.base.BaseLogic"

	require "script.manager.Constants"
	require "script.manager.UiManager"
	require "script.manager.LayerManager"
	require "script.manager.AudioManager"
	require "script.manager.DialogManager"
	require "script.manager.ContainerManager"
	require "script.manager.NetHandleManager"
	require "script.manager.LogicSystemManager"
	require "script.manager.PlayerDynamicManager"

	PlayerDynamicManager:fun_init()
	NetHandleManager:fun_init()
	LogicSystemManager:fun_init()
	AudioManager:fun_init()

end


-- GameManager:init()