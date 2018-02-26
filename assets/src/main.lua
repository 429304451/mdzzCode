print = release_print
trace = print
cc.FileUtils:getInstance():setPopupNotify(false)
-- 平台 0-window,1-linux,2-mac,3-android, 4-iphone,5-ipad
__Platform__ = cc.Application:getInstance():getTargetPlatform()

-- ## require "config" 篇
CC_USE_FRAMEWORK = true
DEBUG = 2
CC_SHOW_FPS = true
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_HEIGHT"
}
-- 使用fix height 的可能造成的麻烦就是左右之间在pad可能重叠
if CC_SHOW_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end
require "cocos.init"

-- ## 游戏重启篇
local loadedModle = {}
local reloadPath = {
	ui = true,
	Common = true,
	util = true,
	modules = true,
	config = true,
	ccext = true,
	script = true,
}
local oldRequire = require

function require(path, ...)
	for i,j in pairs(reloadPath) do
		if string.find(path, i) then
			table.insert(loadedModle, path)
			break
		end
	end
	return oldRequire(path,...)
end

local function clearCatch()
	for i,j in pairs(loadedModle) do
		package.loaded[j] = nil
		trace("reload ", j)
	end

	local director = cc.Director:getInstance()
	local textureCache = director:getTextureCache()
	textureCache:removeAllTextures()
	local ccspc = cc.SpriteFrameCache:getInstance()
	ccspc:removeSpriteFrames()
end

--重启游戏
function reloadGame()
	local runingscene = cc.Director:getInstance():getRunningScene()
	if runingscene then
		runingscene:removeAllChildren()
	end    
	clearCatch()
	require("util.init")
	--table.clear(package.loaded)
	local scene = cc.Scene:create()
	if runingscene then
		cc.Director:getInstance():replaceScene(scene)
	else
		cc.Director:getInstance():runWithScene(scene)
	end
	-- ## 登录界面
	local loginWin = require("modules.login.Login"):create()    
	BASE_NODE = cc.Node:create()
	scene:addChild(BASE_NODE)
	BASE_NODE:addChild(loginWin)

	-- ## 测试用例
	-- local spr = cc.Sprite:create("HelloWorld.png"):addTo(scene):move(display.center)
	-- spr:quickBt(function ()
	-- 	mlog("quickBt()")
	-- end)
end

local function main()
	collectgarbage("collect")
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)
	-- setDesignResolution(CC_DESIGN_RESOLUTION, framesize)
	reloadGame()
end

-- ## Debug 篇
-- [[
-- 是否使用断点调试 （高性能消耗，版本发布必须关闭。）
local USE_BREAKPOINT_DEBUG = true

local cclog = function(...)
	print(string.format(...))
end

local breakInfoFun , xpCallFun
if USE_BREAKPOINT_DEBUG then
	--本地调试
	breakInfoFun , xpCallFun = require("LuaDebugjit")("localhost",7003)
	--手机端调试															--电脑IP
	--breakInfoFun , xpCallFun = require("LuaDebugjit")("192.168.0.109",7004)
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)
end

local postedLog = {}

function __G__TRACKBACK__(msg)
	local debuglog = debug.traceback()
	cclog("----------------------------------------")
	cclog("LUA ERROR: " .. tostring(msg) .. "\n")
	cclog(debuglog)
	cclog("----------------------------------------")

	if USE_BREAKPOINT_DEBUG then
		xpCallFun()
	end

	if not postedLog[msg] then
		postedLog[msg] = true
		debuglog = tostring(msg)..debuglog
		util.postLogToServer(debuglog)  --目前我还没有写util 
	end

	trace = function() end
	traceObj = function() end
	return msg
end
--]]

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    -- print(msg)
    trace(msg)
end
