util = class("utill")
----------------------------------------------
--工具方法
----------------------------------------------
--打印
local debugUI = false
local autoScale = CC_DESIGN_RESOLUTION.autoscale
local socket = require "socket"
function util:isExamine()--是否是审核包（审核包需要屏蔽相关模块）
    return false
end
--当前使用的域名
function util.curDomainName()
    --return "ddz.com"
    return "36y.com"
end

function util.exit()
	cc.Director:getInstance():endToLua()
end

util.STR_TRUE = "STR_TRUE16161434"
util.STR_FALSE = "STR_FALSE16161434"

function util.getKey(key,def)
	local value =  cc.UserDefault:getInstance():getStringForKey(key,def)
	if value == util.STR_TRUE then
		value = true
	elseif value == util.STR_FALSE then
		value = false
	end

	return value
end

function util.setKey( key,str )
	if type(str) == "boolean" then
		str = str and util.STR_TRUE or util.STR_FALSE
	end
	cc.UserDefault:getInstance():setStringForKey(key,str)
	cc.UserDefault:getInstance():flush()
end

function util.merge(dest,src)
	for k,v in pairs(src) do
		dest[k]=v
	end
end

function util.clone(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
				return object
		elseif lookup_table[object] then
				return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for key, value in pairs(object) do
				new_table[_copy(key)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	 end
	return _copy(object)
end
-----------------------------------------------
--界面创建
-----------------------------------------------
--从csd界面转lua的界面创建
function util.createlua(obj,callback)
	local temp = require(obj.uipath)
	local node = temp.create(callback)
	node.textures = temp.textures
	return node
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

function util.getAndroidPackPath()
	return "com/ddz/"
end

function util.splitStringByKey( value ,key1,key2)
    local item_list={}
    if not (type(value) == "string") then
        return item_list
    end
    if not string.find(value,key1) then
        return item_list
    else
        for str in string.gmatch(value,"([^"..key1.."]+)") do
            local t = string.split(str,key2)
            item_list[t[1]] = t[2]
        end
    end
    return item_list
end


-- 根据屏幕宽度适应
function util.fixWidth(node)

end
-- 拉伸到满全屏
function util.fixWidth(node)

end