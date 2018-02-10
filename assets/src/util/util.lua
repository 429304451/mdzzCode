util = class("utill")
----------------------------------------------
--工具方法
----------------------------------------------
--打印
local debugUI = false
local autoScale = CC_DESIGN_RESOLUTION.autoscale

function util.exit()
	cc.Director:getInstance():endToLua()
end

function util.setLayout(obj, win)
	if not (type(obj) == "table") then
		return
	end
	util._wins = util._wins or {}
	util._wins[obj.path] = win
end
function util.delayCall(node, func, delay, bRepeat)
	node._delayCallhandles = node._delayCallhandles or {}
	local sharedScheduler = cc.Director:getInstance():getScheduler()
	local _delayCallhandle
	_delayCallhandle = sharedScheduler:scheduleScriptFunc(function(dt)
		if node._delayCallhandles and node._delayCallhandles[_delayCallhandle] and not bRepeat then
			sharedScheduler:unscheduleScriptEntry(_delayCallhandle)
			node._delayCallhandles[_delayCallhandle] = nil
		end
		if not tolua.isnull(node) then
			func(dt)
		elseif node._delayCallhandles and node._delayCallhandles[_delayCallhandle] then
			sharedScheduler:unscheduleScriptEntry(_delayCallhandle)
			node._delayCallhandles[_delayCallhandle] = nil
		end
	end,delay or 0,false)

	node._delayCallhandles[_delayCallhandle] = true
end

-- 根据屏幕宽度适应
function util.fixWidth(node)

end
-- 拉伸到满全屏
function util.fixWidth(node)

end
----------------------------------------
--界面管理
----------------------------------------

local scenes = {}
local lastMainLayer = nil
local lastName = ""
local lastWinLayer = {}

function util.init()
	require("util.functions")
	-- util.initScene()
	
    -- math.randomseed(os.time())
end
