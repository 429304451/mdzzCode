util = class("utill")
----------------------------------------------
--工具方法
----------------------------------------------
--打印
local debugUI = false
-- local autoScale = CC_DESIGN_RESOLUTION.autoscale
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

--加载列
function util.createluaItem(uipath,catch)
	catch = false
	util._itemCatch = util._itemCatch or {}
	util._itemCatch[uipath] = util._itemCatch[uipath] or {}
	if catch then
		for i,j in pairs(util._itemCatch[uipath]) do
			if not tolua.isnull(j) and tolua.isnull(j:getParent()) and j:getReferenceCount()==1 then
				--traceOnly("fromCatch",uipath,i)
				return j
			end
		end
	end
	local temp = require(uipath)
	local item = temp.create()
	if catch then
		item.root:retain()
		table.insert(util._itemCatch[uipath],item.root)
	end
	return item.root
end

--从cbs中获取节点 添加点击事件  func要处理回调事件的类型  参考 clickMain
function util.addEvent(root,name,func)
	local node = getnode(root,name)
	if node then
		if debugUI then 
			trace("util.addEvent "..name)
		end 
		node:addClickEventListener(func)
	else
		trace("util.addEvent not find "..name)
	end
end

--延迟初始化列表   see Task.lua   line:42
--type 为itemSetFun 第二个参数
function util.listview(list,tb,itemCreateFun,itemSetFun,type )
	if tb ==nil or #tb ==0 then 
		list:removeAllItems()
		list.items={}
		return 
	end 
	if list.items ==nil then 
		list.items={}
	end
	local lastLen = list.lastLen or 0

	local itr = list_iter(tb)
	
	--清除上次未完成的  防止快速切换
	util.listviewclear(list)
	list.index = 1
	-- print("setlen",#tb,list.lastLen)

	--清楚多余项
	local crrLen = #tb
	if lastLen >0 and lastLen > crrLen then 
		-- print("remove",crrLen,lastLen)
		for i=crrLen+1,lastLen do
			table.remove(list.items,crrLen+1)
			list:removeItem(crrLen)
		end
	end
	list.lastLen = crrLen

	local tickFun = function ()
		for i=1,10 do
			local v = itr()
			if v then 
				if list.items then
					local item = list.items[list.index]
					if tolua.isnull(item) then 
						item = itemCreateFun()
						list:pushBackCustomItem(item)
						list.items[list.index]=item
					end
					itemSetFun(item,v,type)
					list.index = list.index +1
				else
					trace("list.items found nil")
				end
			else
				util.listviewclear(list)
				break
			end
		end
	end
	list.tick = scheduler.scheduleGlobal(tickFun,0.001)
end

function util.removeAllSchedulerFuns(node)
	if node  then
		if node._schedulehandle then
			local sharedScheduler = cc.Director:getInstance():getScheduler()
			sharedScheduler:unscheduleScriptEntry(node._schedulehandle)
			node._scheduleFuns = nil
			node._schedulehandle = nil
		end
		if node._delayCallhandles then
			for _delayCallhandle in pairs(node._delayCallhandles) do
				local sharedScheduler = cc.Director:getInstance():getScheduler()
				sharedScheduler:unscheduleScriptEntry(_delayCallhandle)
				node._delayCallhandles[_delayCallhandle] = nil
			end
		end
   end
end

function util.delayCall(node,func,delay,bRepeat)
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

function util.removeSchedulerFun(node,func)
	if node._scheduleFuns then
		for i,j in pairs(node._scheduleFuns) do
			if j == func then
				table.remove(node._scheduleFuns,i)
			end
		end
	end
end

--延迟处理函数,同一个node中,根据添加的顺序,执行func
function util.addSchedulerFuns(node,func,bRepeat,timeStart,timeEnd,dt)
	node._scheduleFuns = node._scheduleFuns or {}
	table.insert(node._scheduleFuns,{dt = 0,bRepeat = bRepeat,func = func,timeStart = timeStart,endTime = timeEnd,lastTick = util.time()})
	local sharedScheduler = cc.Director:getInstance():getScheduler()
	node._schedulehandle = node._schedulehandle or sharedScheduler:scheduleScriptFunc(function()
		local info = (not tolua.isnull(node)) and node._scheduleFuns and table.remove(node._scheduleFuns,1)
		if info then     
			local func = info.func
			local endTime = info.endTime   
			local bRepeat = info.bRepeat
			local timeStart = info.timeStart
			local cd = info.dt
			local lastTick = info.lastTick
			local now = util.time()
			local tick = now - lastTick
			if (cd and cd>0) or (timeStart and timeStart>0) then
				info.dt = info.dt and (info.dt - tick)
				info.timeStart = info.timeStart and (info.timeStart - tick)
				table.insert(node._scheduleFuns,info)
				return
			end
			info.dt = dt
			if endTime then
				endTime = endTime - tick
				if endTime<0 then
					func(tick,true)
					return
				end
				info.endTime = endTime
			end
			func(tick)
			if bRepeat then
				info.lastTick = now
				table.insert(node._scheduleFuns,info)
			end
		elseif node._schedulehandle then
			sharedScheduler:unscheduleScriptEntry(node._schedulehandle)
			node._schedulehandle = nil
		end
	end,0,false)
	if node.registerScriptHandler then
		node:registerScriptHandler(function(state)
			if state == "exit" then
				if node._schedulehandle then
					sharedScheduler:unscheduleScriptEntry(node._schedulehandle)
					node._schedulehandle = nil
				end
			end
		end)
	end
end

function util.schedulerPairs(tab,fun,node)
	if node == nil then
		node = cc.Node:create()
		node:retain()
		node.autoRel = true
	end
	local num = table.nums(tab)
	for i,j in pairs(tab) do
		util.addSchedulerFuns(node,function()
			fun(i,j)
			num = num -1
			if num == 0 and node.autoRel then
				node:release()
			end
		end)
	end
end
--dispose  记得调用  预付被清理
function util.listviewclear(list)
	if list.tick then 
		scheduler.unscheduleGlobal(list.tick)
		list.tick =nil
	end
end
--点击全屏窗口  
--util.clickMain(self,"login_button",ui.gameLoading,self.checkSeclet)
function util.clickMain( root,name,uipath,funcheckClick)
	util.click(root,name,util.changeMainUI,uipath,funcheckClick)
end
--点击弹窗
function util.clickWin( root,name,uipath,funcheckClick,parameter2 )
	assert(uipath,"check ui path is nil")
	util.click(root,name,util.pushWin,uipath,funcheckClick,parameter2)
end
--点处理函数  funDot  util.m       funcheckClick class:m
--root 查找的根节点   
--name 查找对象名称
--funDot  root.functionName  
--parameter1 funDot参数
--funcheckClick  检查是否可以点击
--parameter2 funDot参数
function util.click( root,name,funDot,parameter1,funcheckClick,parameter2 )
	local node = getnode(root,name)
	if node then
		local touch = function ( cnode ,event )
			-- check can click
			if funcheckClick then 
				util.onTextEnd()
				local hd = handler(root,funcheckClick)
				if hd()==false then 
					if debugUI then 
						trace("util.click false "..name)
					end 
					return
				end
			end
		   funDot(parameter1,parameter2)
		end
		node:addClickEventListener(touch)
	else
		trace("util.click not find "..name)
	end
end
--点击函数class内部处理
 --util.clickSelf(self,"login_button",self.checkSeclet)
function util.clickSelfS( root,name,funcheckClick,... )
	local node = getnode(root,name)
	if node then
		util.onTextEnd()
		local parameters = {...}
		node:setTouchEnabled(true)
		local touch = function ( cnode ,event )
		   local hd = handler(root,funcheckClick)
		   hd(unpack(parameters))
		end
		node:addClickEventListener(touch)
   
	else
		trace("util.click not find "..(name or ""))
	end
end
local function hitTest(node,pos)
	--[[local touchChild = node:getChildByName("pnl_touch") or node

    if sdkManager:isNewCocosVersion() then
        local  tempCarmor =  cc.Camera:getVisitingCamera()
        --local temvec3 = cc.vec3(pos.x, pos.y, 0)
        return touchChild:hitTest(pos,tempCarmor,nil) and node:isClippingParentContainsPoint(pos)
    else
	    return touchChild:hitTest(pos) and node:isClippingParentContainsPoint(pos)
	end]]
	if not node:isClippingParentContainsPoint(pos) then
		return false
	end
	local pos = node:convertToNodeSpace(pos)
	local rect = cc.rect(0,0,node:getContentSize().width,node:getContentSize().height)
	return cc.rectContainsPoint(rect,pos)
end
local function isVisible(node)
	local parent = node
	while(true) do
		if not parent:isVisible() then
			return false
		end
		parent = parent:getParent()
		if tolua.isnull(parent) then
			break
		end
	end
	return true
end
local function isInList(node)
	local parent = node
	while(true) do
		local name = parent:getName()
		if name == "ListItem" then
			return true
		end
		parent = parent:getParent()
		if tolua.isnull(parent) then
			break
		end
	end
	return false
end

function util.DeletBtnSound(root)
	root.__noSound = true
end
function util.clickSelf( root,name,funcheckClick,...)
	local node = getnode(root,name)
	if node then
		local parameters = {...}
		local fun = function ( cnode ,event )
			util.onTextEnd()
			if not node.__noSound then
				util.playSound("Common_Panel_Dialog_Pop_Sound",false)
			end
		   local hd = handler(root,funcheckClick)
		   hd(unpack(parameters))
		end
		if node._clickfunc then
			node._clickfunc = fun
			return
		end
		node._clickfunc = fun

		local oldScaleX = node:getScaleX()
		local oldScaleY = node:getScaleY()
		local sizeChange = 1.1
		local time = 0.05
		local touched = false
		local moveDis = 20
		local startPos
		if iskindof(node,"cc.Sprite") then
			--util.loadSprite(node,img)
		else
			node:setTouchEnabled(true)
			node:setSwallowTouches(true)
		end
		
		
		local function doClickAction(bClick)
			if tolua.isnull(node) or touched == bClick then
				return
			end
			touched = bClick
			if (node:getDescription() ~="Button" and not node.clickAction) or node.notclickAction then
				return
			end
			node:stopAllActions()
			local actionScale = cc.ScaleTo:create(time,oldScaleX*sizeChange,oldScaleY*sizeChange)
			local actionBack = cc.ScaleTo:create(time,oldScaleX,oldScaleY)

			node:runAction(bClick and actionScale or actionBack)
		end

		local function onTouchBegan(touch, event) 
			doClickAction(false)
			if isVisible(node) and node:isEnabled() then
				local pos = touch:getLocation()
				if hitTest(node,pos) then
					doClickAction(true)
					startPos = pos
					if node.setHighlighted then
						node:setHighlighted(true)
					end
					return true
				end
			end
			return false
		end
		local function onTouchMove(touch, event)
			local pos = touch:getLocation()
			if touched and (not hitTest(node,pos) or (startPos and cc.pGetDistance(pos,startPos)>moveDis)) then
				doClickAction(false)
			end
		end
		local function onTouchEnded(touch, event)
			if touched then
				node._clickfunc()
			end
			touched = true
			doClickAction(false) 
		end
		cc.Director:getInstance():getEventDispatcher():removeEventListenersForTarget(node)
		local listener = cc.EventListenerTouchOneByOne:create()
		if not isInList(node) then
			listener:setSwallowTouches(true)
		end
		listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		listener:registerScriptHandler(onTouchMove,cc.Handler.EVENT_TOUCH_MOVED )
		listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)
	else
		trace("util.click not find "..(name or ""))
	end
end

--点下去就生效
function util.touchSelf( root,name,funcheckClick,parameters ,functionRelease,parameters2)
	local node = getnode(root,name)
	if node then
		if node.setTouchEnabled then
			node:setTouchEnabled(true)
			node:setSwallowTouches(true)
		end
		local hd = handler(root,funcheckClick)
		local hd2 = functionRelease and handler(root,functionRelease)
		local touched = false
		local function onTouchBegan(touch, event)
			touched = false
			if isVisible(node) and node.isEnabled and node:isEnabled() then
				local pos = touch:getLocation()
				if hitTest(node,pos) then
					touched = true
					if not node.__noSound then
						util.playSound("Common_Panel_Dialog_Pop_Sound",false)
					end
					hd(parameters)
					return true
				end
			end
		   return false
		end
 
		local function onTouchEnded(touch, event)
			if hd2 and touched then
				hd2(parameters2)
			end
		end

		cc.Director:getInstance():getEventDispatcher():removeEventListenersForTarget(node)
		local listener = cc.EventListenerTouchOneByOne:create()
		if not isInList(node) then
			listener:setSwallowTouches(true)
		end
		listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		--listener:registerScriptHandler(onTouchMove,cc.Handler.EVENT_TOUCH_MOVED )
		listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,node)    
	else
		trace("util.click not find "..(name or ""))
	end
end
--checkbox 事件侦听
function util.ckeckboxSelf( root,name,funcheckClick,parameters  )
	local node = getnode(root,name)
	if node then
		local touch = function ( ... )
		   local hd = handler(root,funcheckClick)
		   hd(...,parameters)
		end
		node:addEventListener(touch)
	else
		trace("util.click not find "..name)
	end
end
--获取世界坐标的区域
function util.getWorldBoundingBox(node)
	local rect = node:getBoundingBox()
	while node:getParent() ~= self do
		rect.x = rect.x + node:getParent():getPositionX()
		rect.y = rect.y + node:getParent():getPositionY()
		node = node:getParent()
	end
	return rect
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
	util.initScene()
	
    math.randomseed(os.time())
end
--初始化场景  全局只有一个scene在跑      禁止重新建立场景
function util.initScene()
	Platefrom:clearLogo()
	if not tolua.isnull(scenes.fixLayer) then
		return
	end
	local director = cc.Director:getInstance()
	director:setAnimationInterval(1.0/60);

	local ccspc = cc.SpriteFrameCache:getInstance()
	ccspc:removeSpriteFrames()
	cc.FileUtils:getInstance():purgeCachedEntries()

	local director = cc.Director:getInstance()
	director:setAnimationInterval(1.0/60);
	util.getsize()

	--[[
	local sc = cc.Director:getInstance():getRunningScene()
	if sc == nil then
		sc = cc.Scene:create()
		sc:setTag(1)
		cc.Director:getInstance():runWithScene(sc)
	--else
		--if sc:getTag() == -1 then 
		--    sc = cc.Scene:create()
			--sc:setTag(1)
	--        cc.Director:getInstance():replaceScene(sc)
		--end
	end]]
	--  主界面层   弹出窗口层   tip层
	scenes.fixLayer     = cc.Layer:create()
	scenes.mainLayer    = cc.Layer:create()
	scenes.menuLayer    = cc.Layer:create()
	scenes.winLayer  	= cc.Layer:create()
	scenes.dialogLayer  = cc.Layer:create()
	scenes.guildLayer   = cc.Layer:create()
	scenes.effectLayer  = cc.Layer:create()
	scenes.sysTipLayer  = cc.Layer:create()
	scenes.warnLayer    = cc.Layer:create()
	scenes.debugLayer   = cc.Layer:create()

	BASE_NODE:addChild(scenes.fixLayer      ,_gm.ID_BG     ,_gm.ID_BG)
	BASE_NODE:addChild(scenes.mainLayer     ,_gm.ID_Main   ,_gm.ID_Main)
	BASE_NODE:addChild(scenes.menuLayer     ,_gm.ID_Menu   ,_gm.ID_Menu)
	BASE_NODE:addChild(scenes.winLayer   	,_gm.ID_Win    ,_gm.ID_Win)
	BASE_NODE:addChild(scenes.dialogLayer   ,_gm.ID_Dlg    ,_gm.ID_Dlg)--层级在Win之上
	BASE_NODE:addChild(scenes.guildLayer    ,_gm.ID_Guild  ,_gm.ID_Guild)
	BASE_NODE:addChild(scenes.effectLayer   ,_gm.ID_Effect ,_gm.ID_Effect)
	BASE_NODE:addChild(scenes.sysTipLayer   ,_gm.ID_SysTip ,_gm.ID_SysTip)
	BASE_NODE:addChild(scenes.warnLayer     ,_gm.ID_Warn   ,_gm.ID_Warn)
	BASE_NODE:addChild(scenes.debugLayer    ,_gm.ID_Debug  ,_gm.ID_Debug)

	-- 返回键监听
	util.addKeyBack()
	util.hookSetFont()

	util.initSoundAndMusci()

	util.addEditFlag()
	util.reg()
end
function util.getBaseLayer(name)
	return scenes[name]
end
function util.setBackEnabled(state)
	if state then -- 添加返回
		if not util.keyBackListener then
			trace("添加返回监听")
			util.addKeyBack()
		end
	else -- 移除返回
		if util.keyBackListener then
			trace("移除返回监听")
			local eventDispatcher = scenes.winLayer:getEventDispatcher()
			eventDispatcher:removeEventListener(util.keyBackListener)
			util.keyBackListener = nil
		end 
	end
end
function util.getPopLayerCount()
	local childCount1 = scenes.sysTipLayer:getChildrenCount()
	local childCount2 = scenes.winLayer:getChildrenCount()
	return childCount1+childCount2
end
function util.isCanPop()
	local tag = scenes.winLayer:getChildrenCount()
	if tag > 0 then
		local win = scenes.winLayer:getChildByTag(tag)
		if win and win:getName() == ui.GameMaintenance then -- 如果是维护界面则不可关闭
			return false
		end
	end
	return true
end
-- 返回键监听
function util.addKeyBack()
	util._eventBackFunx = util._eventBackFunx or {}
	local function onKeyReleased(keyCode, event)
		if keyCode == cc.KeyCode.KEY_BACK then
			for i,j in pairs(util._eventBackFunx) do
				if not tolua.isnull(j.node) then
					if not j.func() then
						return
					end
				end
			end
		elseif keyCode == cc.KeyCode.KEY_MENU  then
		end
	end
	local listener = cc.EventListenerKeyboard:create()
	listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
	local eventDispatcher = scenes.winLayer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, scenes.winLayer)
	util.keyBackListener = listener
end
--添加返回事件
--超后面添加的越优先响应
function util.addEventBack(node,func)
	if not tolua.isnull(node) then
		if util._eventBackFunx then
			for i = table.nums(util._eventBackFunx),1 -1 do
				if util._eventBackFunx[i] and tolua.isnull(util._eventBackFunx[i].node) then
					table.remove(util._eventBackFunx,i)
				end
			end
			table.insert(util._eventBackFunx,1,{node = node,func = func})
		end
	end
end
function util.aptdown(node)
	if node == nil then
		trace("error:util.aptdown node is nil")
		return
	end
	node:setPositionY(node:getPositionY()-util.display.offy)
end
--没效果?
function util.aptright(node)
	if node == nil then
		trace("error:util.aptdown node is nil")
		return
	end
	node:setPositionX(node:getPositionX()-util.display.offx)
end
--底部节点适配
function util.aptnode(node)
	if node == nil then
		trace("error:util.aptnode node is nil")
		return
	end
	node:setPositionY(node:getPositionY()+util.display.offy)
end
--设置节点适配的时候,是等比缩放
function util.aptsetScaleEquireXY(node,flag)
	if tolua.isnull(node) then
		trace("error:util.aptsetScaleEquireXY node is nil")
		return
	end
	
	node._aptsetScaleEquireXY = flag
end
function util.aptNotScale(node,flag)
	if node == nil then
		trace("error:util.aptsetScaleEquireXY node is nil")
		return
	end
	
	node._aptsetNotScale = flag
end
function util.isScaleNode(node)
	return iskindof(node,"ccui.Button") or iskindof(node,"ccui.Text") or iskindof(node,"cc.Sprite") or iskindof(node,"ccui.EditBox")
end
function util.aptChildren(node)
	util.aptSelf(node,CC_DESIGN_RESOLUTION.width,CC_DESIGN_RESOLUTION.height)
end
--整窗口屏幕适配
--node为全屏窗口
--oldlayout 为递归使用,调用时不用填
function util.aptSelf(node,oldlayoutWidth,oldlayoutHeight)
	if node ==nil then
		trace("error:util.aptSelf node is nil")
		return
	end
	if node.hasApt then
		return
	end
	node.hasApt = true
	local director = cc.Director:getInstance()
	local viewsize = director:getWinSize()
	local size = node:getContentSize()
	local layoutHeight =  oldlayoutHeight or size.height
	local scaleY = viewsize.height / layoutHeight

	local layouWidth = oldlayoutWidth or size.width
	local scaleX = viewsize.width / layouWidth
	if not oldlayoutWidth then
		size.height = size.height*scaleY
		size.width = size.width*scaleX
		node:setContentSize(size)
	end
	local function changeScale(node)
		local scale = math.min(scaleX,scaleY)
		local cx = node:getScaleX()*scale
		local cy = node:getScaleY()*scale
		-- print("setScaleX", cx, "setScaleY", cy)
		node:setScaleX(cx)
		node:setScaleY(cy)
	end
	for _,child in pairs( node:getChildren()) do  
		local oldanchor
		if CC_DESIGN_RESOLUTION.autoscale == "FIXED_WIDTH" then
			oldanchor = util.changeAnchor(child,cc.p(0.5,1))
		elseif CC_DESIGN_RESOLUTION.autoscale == "FIXED_HEIGHT" then
			--oldanchor = util.changeAnchor(child,cc.p(0.5,0.5))
		end
		--[[if iskindof(child,"ccui.Button") then
			util.changeAnchor(child,cc.p(0.5,0.5))
		end]]
		local pos = cc.p(child:getPosition())
		--if oldlayoutWidth then
			pos.y = scaleY*pos.y
			pos.x = scaleX*pos.x
		--else
			--pos.y = pos.y + util.display.offy*(size.height/layoutHeight)*(size.height-pos.y)/size.height
			--pos.x = pos.x + util.display.offx*(size.width/layouWidth)*(size.width-pos.x)/size.width
		--end

		child:setPosition(pos.x,pos.y)
		if child._aptsetScaleEquireXY then
			changeScale(child)
		elseif child._aptsetNotScale then
		elseif util.isScaleNode(child) then
			changeScale(child)
		elseif  iskindof(child,"ccui.ListView") or iskindof(child,"ccui.ScrollView") then
			local size = child:getContentSize()
			size.height = size.height*scaleY
			size.width = size.width*scaleX
			child:setContentSize(size)
		elseif iskindof(child, "ccui.Slider") then
			child:setScaleX(scaleX)
			child:setScaleY(scaleY)
		else
			local size = child:getContentSize()
			size.height = size.height*scaleY
			size.width = size.width*scaleX
			-- print("setContentSize", scaleX, scaleY)
			child:setContentSize(size)
			util.aptSelf(child,layouWidth,layoutHeight)
	   end
	   if oldanchor then
		util.changeAnchor(child,oldanchor)
		end
   end
end
function util.aptheight( layoutHeight )
	local director = cc.Director:getInstance()
	local viewsize = director:getWinSize()
	local scaleY = viewsize.height / CC_DESIGN_RESOLUTION.height
	layoutHeight = layoutHeight*scaleY
	return layoutHeight
end
function util.aptSelffor960(node)
	if CC_DESIGN_RESOLUTION.height == 1136 then
		node:setPositionY(1136-960)
	end
	--util.aptnode(node)
	util.aptSelf(node)
end
--改变锚点,不移动位置
function util.changeAnchor(node,newAnchor)
	local oldAnchor = node:getAnchorPoint()
	if newAnchor == nil or (oldAnchor.y == newAnchor.y and oldAnchor.x == newAnchor.x) then
		return oldAnchor
	end

	local pos = cc.p(node:getPosition())
	local size = node:getContentSize()

	pos.x = pos.x + (newAnchor.x-oldAnchor.x)*size.width*node:getScaleX()
	pos.y = pos.y + (newAnchor.y-oldAnchor.y)*size.height*node:getScaleY()

	node:setPosition(pos.x,pos.y)
	if iskindof(node,"ccui.RichText") then
		node:setAnchorPoint(newAnchor)
	else
		node:setAnchorPoint(newAnchor.x,newAnchor.y)
	end

	return oldAnchor
end
function util.aptsize(node)
	local size = node:getContentSize()
	size.width = size.width + util.display.offx
	size.height = size.height - util.display.offy
	node:setContentSize(size)
   
	size = node:getAnchorPoint()

	if size.y== 0 then 
		util.aptnode(node)
	end

end

function util.aptRatio(node)
	local posRatio = node:getPositionY()/CC_DESIGN_RESOLUTION.height
	local posY = posRatio*util.display.size.height
	local posY = posY+util.display.offy
	node:setPositionY(posY)
end
--重设控件大小,并且子节点顶部适配,igonTab忽略列表
--主要用于Listview子控件的伸缩
function util.setSizeandAptTop(node,size,igonTab)
	local oldSize = node:getContentSize()
	node:setContentSize(size)
	local xoff = size.width - oldSize.width
	local yoff = size.height - oldSize.height
	local children = node:getChildren()
	for _,child in pairs(children) do
		if not igonTab  or igonTab[child] == nil then
			local x,y = child:getPosition()
			child:setPosition(x+xoff,y+yoff)
		end
	end
end
function util.setaddHight(node,hight,igonTab)
	local size = node:getContentSize()
	if node._defHeight == nil then
		node._defHeight = size.height
	end
	size.height = node._defHeight + hight
	util.setSizeandAptTop(node,size,igonTab)
end
--列表重新设置位置
function util.aptlist(node)

	local size = node:getContentSize()
	size.width = size.width + util.display.offx
	size.height = size.height - util.display.offy
	node:setContentSize(size)


	size = node:getInnerContainerSize()
	size.width = size.width + util.display.offx
	size.height = size.height + util.display.offy
	node:setInnerContainerSize(size)

	size = node:getAnchorPoint()

	if size.y== 0 then 
		util.aptnode(node)
	end
end
--stackType
util.ST_Main = 0
util.ST_Win  = 1
util.ST_Alter= 2 

--尝试用统一的销毁接口    销毁对象   然后再移除操作（全局精致调用node移除操作）
function util.tryDispose(node)
	if not tolua.isnull(node) then 
		if GameTCP then 
			GameTCP:revmoveTargetEvents(node)
		end
		if GameEvent then 
			GameEvent:revmoveTargetEvents(node)
		end
		if node.dispose then
			node:dispose()
		end
		if _gm.ID_Dlg == node._type then
			util.hideWin(node)
		else
			util.tryRemove(node,cleanup)
		end
	end
end
--尝试从父辈移除   是否销毁
function util.tryRemove(node)
	if not tolua.isnull(node) and node:getParent() then 
		if debugUI then 
			trace("removed :"..node:getName().."  count:"..node:getParent():getChildrenCount())
		end
		node:removeFromParent()
	end
end
local checkSlotKeys = {"create","dispose","getStackType","show","hide","isInStage","refresh","addEvents","removeEvents"}
--检查模块接口
function util.checkSlot(name,...)

	util.traceTime()
	local cl = require(name.path)
	local node = cl.create(...)
	util.traceTime(name.path.." use time")
	node._uiInfo = name

	if node.resize then
		node:resize()
	else
		util.aptSelf(node)
	end
	if node.addEvents then
		node:addEvents()
	end
	if node.refresh then
		node:refresh()
	end
	if node.pnl_close then
		util.clickSelf(node,node.pnl_close,function()
			if util.moveBaseNode() then
				return
			end
			util.popWin({node}) 
		end)
	end

	return node
end
function util.checkModuleSlot(name,...)
	util.traceTime()
	local cl = require(name.path)
	local node = cl.create(...)
	util.traceTime(name.path.." use time")
	node._uiInfo = name

		if node.resize then
			node:resize()
		else
			util.aptSelf(node)
		end
	util.delayCall(node,function()
		if node.addEvents then
			node:addEvents()
		end
		if node.refresh then
			node:refresh()
		end
	end,0.1)
	if node.pnl_close then
		util.clickSelf(node,node.pnl_close,function() 
			if util.moveBaseNode() then
				return
			end
			util.popWin({node}) 
		end)
	end

	return node
end
--获取最后一次添加的层
function util.lastLayer()
	return nil
end
--获取根场景
function util.getRoot()
	return cc.Director:getInstance():getRunningScene()
end
--获取主界面
function util.getMainLayer()
	return scenes.mainLayer
end
function util.addToMain(node)
	scenes.mainLayer:addChild(node)
end
--获取菜单界面
function util.getMenuLayer()
	return scenes.menuLayer
end
function util.addToMenu(node)
	scenes.menuLayer:addChild(node,1,_gm.ID_Menu)
	return node
end
function util.isOpenBigMap()
	local menu = util.hasMenu()
	if menu then
		return menu:isOpenBigMap()
	else
		return false
	end
end
function util.hasMenu()
	return scenes.menuLayer:getChildByTag(_gm.ID_Menu)
end
function util.clearTheGuide(luaRequirePath,...)
	scenes.guildLayer:removeAllChildren()
end
function util.pushToGuide(luaRequirePath,...)
	
	local win = util.checkSlot(luaRequirePath,...)
	scenes.guildLayer:addChild(win)
end
--获取弹出界面层
function util.getWinLayer()
	return scenes.winLayer
end
function util.addToWin(node)
	assert(not tolua.isnull(scenes.winLayer),"addToWin winLayer is null")
	scenes.winLayer:addChild(node)
end
function util.addToModule(node,backKeytoClose,notCloseOther)
	assert(not tolua.isnull(scenes.dialogLayer),"addToModule dialogLayer is null")
	if not notCloseOther then
		util.popAllModleWin()
	end
	scenes.dialogLayer:addChild(node)
	util.aptSelf(node) 

	if backKeytoClose~=false then
		util.addEventBack(node,function() 
			if node.cancelFunc then
				node.cancelFunc()
			end
			util.hideWin(node) 
		end)
	end

	return node
end
function util.addToPop(node)
	if tolua.isnull(scenes.sysTipLayer) then
		trace("addtopop error")
		return
	end
	node.dispose = node.dispose or function(node,...)
	end
	scenes.sysTipLayer:addChild(node)
	util.aptSelf(node) 
	node:setTag(scenes.sysTipLayer:getChildrenCount())
end

--获取提示界面层
function util.getTipLayer()
	return scenes.sysTipLayer
end
function util.addToWarn(node)
	scenes.warnLayer:addChild(node)
end
--获取提示界面层
function util.getWarnLayer()
	return scenes.warnLayer
end
function util.getLayout(path)
	return util._wins and util._wins[path]
end
function util.setLayout(obj,win)
	if not (type(obj) == "table") then
		return
	end
	util._wins = util._wins or {}
	util._wins[obj.path] = win
end

--全部界面切换
function util.ForcechangeUI(obj,...)
	util._wins = util._wins or {}
	if not tolua.isnull(util._wins[obj.path]) then
		trace("此窗口已经存在,重新创建"..tostring(obj.path))
		util.tryDispose(util._wins[obj.path])
	end
	util.changeUI(obj,...)
end
--全部界面切换
function util.changeUI(obj,...)
	util._wins = util._wins or {}
	if not tolua.isnull(util._wins[obj.path]) then
		--trace("util.changeUI 创建窗口失败,此窗口已经存在"..tostring(obj.path))
		util._wins[obj.path]:setVisible(true)
		return
	end

	local win
	if obj.type == _gm.ID_BG then 
		win = util.__changeFixUI(obj,...)
	elseif obj.type == _gm.ID_Main then 
		win = util.__changeMainUI(obj,...)
	elseif obj.type == _gm.ID_Menu then 
		if util.hasMenu() ==nil then 
			win = util.addToMenu(util.checkSlot(obj,...))
		end
	elseif obj.type == _gm.ID_Win then
		
		win = util.__pushWin(obj,...)        
		if obj.backKeytoClose then
			util.addEventBack(win,function()
				if win.cancelFunc then
					win.cancelFunc()
				end
				util.tryDispose(win) 
			end)
		end
	elseif obj.type == _gm.ID_Dlg then
		win = util.__pushModuleWin(obj,obj.backKeytoClose,obj.notCloseOther,...)
	elseif obj.type == _gm.ID_SysTip then
		win = util.checkSlot(obj,...)
		util.addToPop(win)
	end
	util._wins[obj.path] = win
	if win then
		win._type = obj.type
	end
	if _uim and _uim.hideObjChild then
		_uim:hideObjChild(obj)
	end
	return win
end
function util.__changeFixUI(luaRequirePath,...)
	local layer = util.checkSlot(luaRequirePath,...)
	layer:setName(luaRequirePath.path)
	scenes.fixLayer:addChild(layer)
	util.fixPath = luaRequirePath.path
	util.fixLayer = layer

	return layer
end
--切换界面
function util.__changeMainUI(luaRequirePath,...)
	if lastName== luaRequirePath then 
		return 
	end
	local temp = util.time()
	
	if not tolua.isnull(lastMainLayer) then 
		util.tryDispose(lastMainLayer)
	end

	if luaRequirePath.path ~= util.fixPath then 
		if util.fixLayer then 
			util.fixLayer:hide()
		end

		local layer = util.checkSlot(luaRequirePath,...)
		layer:setName(luaRequirePath.path)
		layer:setTag(util.getMainLayer():getChildrenCount())
		util.addToMain(layer)
 
		lastName = luaRequirePath.path
		lastMainLayer = layer
		if debugUI then 
			trace("mainLayer count:"..scenes.mainLayer:getChildrenCount(),"add time ",util.time()-temp)
		end
		return layer
	else
		lastName = ""
		if util.fixLayer then 
			util.fixLayer:show()
		end
	end

end
--推入窗口 缓动效果
function util.__pushWin(luaRequirePath,...)
	util.tryDispose(luaRequirePath.layer)
	local win = util.checkSlot(luaRequirePath,...)
	util.addToWin(win)
	luaRequirePath.layer = win
	win:setName(luaRequirePath.path)
	win:setTag(scenes.winLayer:getChildrenCount())


	if debugUI then 
		trace("win count:"..scenes.winLayer:getChildrenCount())
	end
	return win
end
function util.__pushModuleWin(luaRequirePath,backKeytoClose,notCloseOther,...)
	util.tryDispose(luaRequirePath.layer)
	local win = util.checkModuleSlot(luaRequirePath,...)
	util.addToModule(win,backKeytoClose,notCloseOther)
	luaRequirePath.layer = win
	win:setName(luaRequirePath.path)
	win:setTag(scenes.winLayer:getChildrenCount())

	return win
end
--刷新当前场景
function util.refreshMain(executeFun)
	if executeFun then
		if lastMainLayer[executeFun] then
			lastMainLayer[executeFun](lastMainLayer)
		end
	else
		lastMainLayer:refresh()
	end
end
function util.refreshBottomWin()
	-- local tag = scenes.winLayer:getChildrenCount()
	-- local win = scenes.winLayer:getChildByTag(tag-1)
	-- win:refresh()
end
function util.getBottomWin()
	local tag = scenes.winLayer:getChildrenCount()
	local win = scenes.winLayer:getChildByTag(tag-1)
	return win
end
function util.popAllModleWin(ignoreUI)
	local childTab = scenes.dialogLayer:getChildren()
	for _,chile in pairs(childTab) do
		local bFind = false
		if ignoreUI and  table.nums(ignoreUI) then
			for k,v in pairs(ignoreUI) do
				if chile._uiInfo == v then
					bFind = true
					break
				end
			end
		end

		if bFind == false then
			if chile.cancelFunc then
				chile.cancelFunc()
			end
			util.tryDispose(chile)
		end
	end

	return table.nums(childTab)
end
--推出窗口 缓动效果
function util.popWin(tipPopTab)
	local childTab = tipPopTab or {}
	count = table.nums(childTab)
	if count < 1 then
		childTab = scenes.dialogLayer:getChildren() or {}
		count = table.nums(childTab)
	end

	if count < 1 then
		childTab = scenes.winLayer:getChildren() or {}
		count = table.nums(childTab)
	end
	if count < 1 then -- 空表 直接return
		return
	end
	local tempTab = {}
	for k,v in pairs(childTab) do
		if not tolua.isnull(v) then
			local c_tag = v:getTag()
			local c_zorder = v:getLocalZOrder()
			table.insert(tempTab, {zorder=c_zorder, tag=c_tag, win=v})
		end
	end
	if table.nums(tempTab) > 0 then
	   sortByDoubleKey(tempTab, "zorder", "tag", true)
		util.tryDispose(tempTab[1].win)
	end
end
--推出窗口 缓动效果
function util.popWin(tipPopTab)
	local childTab = tipPopTab or {}
	count = table.nums(childTab)
	if count < 1 then
		childTab = scenes.dialogLayer:getChildren() or {}
		count = table.nums(childTab)
	end

	if count < 1 then
		childTab = scenes.winLayer:getChildren() or {}
		count = table.nums(childTab)
	end
	if count < 1 then -- 空表 直接return
		return
	end
	local tempTab = {}
	for k,v in pairs(childTab) do
		if not tolua.isnull(v) then
			local c_tag = v:getTag()
			local c_zorder = v:getLocalZOrder()
			table.insert(tempTab, {zorder=c_zorder, tag=c_tag, win=v})
		end
	end
	if table.nums(tempTab) > 0 then
	   sortByDoubleKey(tempTab, "zorder", "tag", true)
		util.tryDispose(tempTab[1].win)
	end
end
function util.popView()
	local childTab = scenes.sysTipLayer:getChildren() or {}
	local count = table.nums(childTab)
	trace("tipPop count:", count)
	util.popWin(childTab)
end
function util.popAllView()
	local tipChildTab = scenes.sysTipLayer:getChildren() or {}
	for k,v in pairs(tipChildTab) do
		util.tryDispose(v)
	end 
	util.popAllWin()
end
function util.popWinByName(name)
	local win = scenes.winLayer:getChildByName(name)
	util.tryDispose(win)
end
--退出全部窗口
function util.popAllWin()
	local childTab = scenes.winLayer:getChildren() or {}
	for k,v in pairs(childTab) do
		util.tryDispose(v)
	end
end
--显示模态窗口  缓动效果
function util.showModal()
	--scenes.dialogLayer:setVisible(true)
end

--隐藏模态窗口  缓动效果
function util.hideModal()
	--scenes.dialogLayer:setVisible(false)
end
--定时函数
function util.setTimeout(func,time)
	scheduler.performWithDelayGlobal(func,time)
end

function util.clearAllTimeout()
	scheduler.unscheduleAll()
end
local plisPath = {
	["img2/GameScene/buttons/"] = true,
	["img2/GameScene/pai/"] = true,
	["img2/GameScene/labels/"] = true,
	["img2/GameScene/TopMenus/"] = true,
	["img2/hall/"] = true,
	["img2/shop/"] = true,
	["img2/exchange/"] = true,
	["img2/watchbrandgame/"] = true,
	["img2/btn/"] = true,
}
function util.isPlistPath(path)
	local tem = path
	for str in pairs(plisPath) do
		tem = string.gsub(tem,str,"")
	end

	return not string.find(tem, "/")
end
local function addImgType(path)
	if not string.find(path, util.getImgType()) and not string.find(path,".jpg") then
		path = path..util.getImgType()
	end
	return path
end
function util.loadSprite(node, path)
	if not path or tolua.isnull(node) then
		return
	end
	path = addImgType(path)

	if not util.isPlistPath(path) then
		node:setTexture(path)
	else
		node:setSpriteFrame( path )
	end
end
function util.loadImage( node,path,resType )
	if not path or tolua.isnull(node) then
		return
	end
	path = addImgType(path)
	if not  tolua.isnull(node) and path then 
		if not util.isPlistPath(path) then
			node:loadTexture(path,0)
		else
			node:loadTexture(path,resType or 1)
		end
	end
end
function util.loadBackGroundImage(node,path,resType)
	if not  tolua.isnull(node) and path then 
		if not util.isPlistPath(path) then
			node:setBackGroundImage(path,0)
		else
			node:setBackGroundImage(path,resType or 1)
		end
	end
end
-- 重设按钮图片
function util.loadButton( node,path ,resType, path1, path2)
	if not  tolua.isnull(node) and path then
		resType = resType or 1
		path = addImgType(path)
		if not path1 then
			path1 = path
		end
		if not path2 then
			path2 = path
		end
		if not util.isPlistPath(path) then
			node:loadTextureNormal(path, 0)
			node:loadTexturePressed(path1, 0)
			node:loadTextureDisabled(path2, 0)
		else
			node:loadTextureNormal(path, resType)
			node:loadTexturePressed(path1, resType)
			node:loadTextureDisabled(path2, resType)            
		end
	end
end
function util.listAddItem(node,item)
	if not  tolua.isnull(node) then 
		node:pushBackCustomItem(item)
	end
end
--每行多个Item
function util.listAddLineItem(node,item,numPerLine)
	if not  tolua.isnull(node) then 
		local lineItem = node._lastLineItem
		if  not lineItem or (lineItem._itemNum >= numPerLine) then
			lineItem = ccui.Layout:create()
			lineItem:setLayoutType(ccui.LayoutType.HORIZONTAL)
			lineItem:setContentSize(cc.size(node:getContentSize().width,item:getContentSize().height))
			node:pushBackCustomItem(lineItem)
			lineItem._itemNum = 0
			node._lastLineItem = lineItem
		end

		lineItem._itemNum = lineItem._itemNum + 1
		lineItem:addChild(item)
	end
end
--获取文字长度
function util.getStringWidth(text,fontName,fontSize)
	local laber = ccui.Text:create()
	if type(fontSize) == "number" then
		laber:setFontSize(fontSize) 
	end
	laber:setFontName(fontName) 
	laber:setString(text)
	return laber:getContentSize().width
end
--自适应文字长度
function util.fixLaberWidth(laber,readOnly)
	local fontSize = laber:getFontSize()
	local fontName = laber:getFontName()
	local text =  laber:getString()
	local textWidth = util.getStringWidth(text,fontName,fontSize)
	if not readOnly and (textWidth ~= laber:getContentSize().width) then
		laber:setContentSize(cc.size(textWidth,laber:getContentSize().height))
	end
	return textWidth
end
--添加文本
function util.listAddString(node,text,fontSize,color4b,bStrMid)
	color4b = color4b or cc.c4b(255,255,255,255)
	local item = ccui.Layout:create()
	local laber = ccui.Text:create()
	item:addChild(laber)
	item.laber = laber
	if type(fontSize) == "number" then
		laber:setFontSize(fontSize) 
	end
	laber:setString(text)
	laber:setTextColor(color4b)
	laber:setAnchorPoint(0,0)   
	if bStrMid then
		laber:setTextHorizontalAlignment(1)
	end

	local width = node:getInnerContainerSize().width
	local height = laber:getContentSize().height * math.ceil(laber:getContentSize().width/width)
	item:setContentSize(cc.size(width,height+10))
	laber:ignoreContentAdaptWithSize(false)
	laber:setTextAreaSize(cc.size(width,height))

	item.setString = function(self,...) item.laber:setString(...) end
	item.setFuns = function(fun,arg) util.clickSelf(nil,item,fun,arg) end
	item.setTextColor = function(color) laber:setTextColor(color) end
	if not  tolua.isnull(node) then 
		node:pushBackCustomItem(item)
		return item
	end
end
--获取Listview滚动位置
function util.listGetPercent(list)
	if iskindof(list,"ccui.ListView") then
		local inner = list:getInnerContainer()

		local max
		local value
		trace("list:getDirection()",list:getDirection())
		if cc.SCROLLVIEW_DIRECTION_VERTICAL== list:getDirection() then--Direction::VERTICAL 
			max = list:getContentSize().height - inner:getContentSize().height
			value = inner:getPositionX()
		else
			max = list:getContentSize().width - inner:getContentSize().width
			value = inner:getPositionY()
		end

		return value/max*100

	elseif iskindof(list,"cc.TableView") then
		if cc.SCROLLVIEW_DIRECTION_VERTICAL== list:getDirection() then
			max = list:maxContainerOffset().y - list:minContainerOffset().y
			value = list:getContentOffset().y
		else
			max = list:maxContainerOffset().x - list:minContainerOffset().x
			value = list:getContentOffset().x
		end
		return math.abs(value/max*100)
	end
	return 0
end

function util.listSetPercent(list)
	if iskindof(list,"cc.TableView") then
		--list:setContentOffset(cc.p())
		--list:updateInset()
	end
end
function util.listAddBugString(node,text,fontSize,color4b)
	color4b = color4b or cc.c4b(255,255,255,255)
	local item = ccui.Layout:create()
	local tab = stringToChars(text)
	local textTab = {}
	local maxLen = 100
	local len = 0
	local str = ""
	for k,v in pairs(tab) do
		local tLen = string.len(v)
		len = len+tLen
		if len > maxLen then -- 换行
			table.insert(textTab, str)
			str = v
			len = tLen
		else
			str = str..v
		end
	end
	if string.len(str) > 0 then
		table.insert(textTab, str)
	end
	local str = table.concat(textTab, "\n")
	local ttf = cc.LabelTTF:create(str, "", fontSize, cc.size(0, 0), cc.TEXT_ALIGNMENT_LEFT)    
	item:addChild(ttf)
	ttf:setAnchorPoint(cc.p(0,0))
	ttf:setColor(color4b)
	item:setContentSize(ttf:getContentSize())
	
	if not  tolua.isnull(node) then 
		node:pushBackCustomItem(item)
		return item
	end 
end
function util.listRemoveAll(node)
	if not  tolua.isnull(node) then 
		node:removeAllItems()
	end
end

--设置按钮是否可用
function util.setEnabled(btn,v)
	btn:setEnabled(v)
	btn:setBright(v)
end

function util.bar( node,min,max )
	node.mixcount = min
	if max then 
		node.maxcount = max
	else
		max = node.maxcount
	end
	if not  tolua.isnull(node) then 
		node:setPercent(min/max*100)
	end
end
function util.getPS(path)
	path = "audio/"..path
	--平台 0-window,1-linux,2-mac,3-android, 4-iphone,5-ipad
	if __Platform__ == 2 or __Platform__ == 4 or __Platform__==5 then
		path = path..".mp3"
	elseif __Platform__ == 3 then 
		path = path..".mp3"
	elseif __Platform__ == 0 then
		path = path..".mp3"
	end
	return path
end
local soundVolume = require("config.soundVolume")

function util.playSound(path,isLoop)
	if not util.getEnableSound() then
		return
	end
	local pathex =  util.getPS(path)
	pathex = cc.FileUtils:getInstance():fullPathForFilename(pathex)
	if pathex and pathex~="" then
		--trace(pathex)
		local volume = soundVolume[path] or 100
		if util.getSoundVolume() ~= volume then
			util.getSoundVolume(volume)
			audio.setSoundsVolume(volume)
		end
		return audio.playSound(pathex,isLoop)
	else
		trace("sound not find: "..path,util.time())
	end
	--cc.SimpleAudioEngine:getInstance():playEffect(path)
end
function util.stopSound(handle)
	if handle then
		audio.stopSound(handle)
	end
end
function util.getMusicVolume(setValue)
	if setValue then
		util._musicVolume = setValue
	end
	return util._musicVolume or 100
end
function util.getSoundVolume(setValue)
	if setValue then
		util._soundVolume = setValue
	end
	return util._soundVolume or 100
end
function util.playMusic(path,isLoop)
	local volume
	if not util.getEnableMusic() then
		volume = 0
	else
		volume = soundVolume[path] or 100
		util.getMusicVolume(volume)
	end
	path = "audio/"..path..".mp3"
	--audio.preloadMusic(path)
	trace("playMusic "..path,volume)
	-- _am.setMusicName(path)
	audio.setMusicVolume(volume)
	audio.playMusic(path,isLoop)
end 
function util.stopMusic(isReleaseData)
	audio.stopMusic(isReleaseData)
end
function util.initSoundAndMusci()
	if not util.getEnableSound() then
		util.setEnableSound(false)
	end
	if not util.getEnableMusic() then
		util.setEnableMusic(false)
	end
end
function util.setEnableSound(enable)
	util._enableSound = enable
	audio.setSoundsVolume(enable and util.getSoundVolume() or 0)

	util.setKey("enableSound",enable )
end
function util.setEnableMusic(enable)
	util._enableMusic = enable
	audio.setMusicVolume(enable and util.getMusicVolume() or 0)

	trace("setEnableMusic ",enable and util.getMusicVolume() or 0)
	util.setKey("enableMusic",enable)
end
function util.getEnableSound()
	if util._enableSound == nil then
		util._enableSound = util.getKey("enableSound",util.STR_TRUE)
	end
	return util._enableSound
end
function util.getEnableMusic()
	if util._enableMusic == nil then
		util._enableMusic = util.getKey("enableMusic",util.STR_TRUE)
	end
	return util._enableMusic
end
function util.effect(path,loop,autoremove)
	local eff = SuperAnimNode:create(path,1)
	if eff then 
		if eff:HasSection("s6") then 
			eff:PlaySection("s6", loop)
		end
		if eff:HasSection("s1") then 
			eff:PlaySection("s1", loop)
		end

		if autoremove then 
			local time = eff:GetSectionTime("s6") or eff:GetSectionTime("s1")
			util.setTimeout(function()
				util.tryRemove(eff)
			end,time)
		end
	else
		print(path .."is not find !")
	end
	return eff
end
function util.AddParticleEffect(PlistName,autoremove,time)
	local Plisteffect = cc.ParticleSystemQuad:create("img/effect/"..PlistName..".plist") 
	if Plisteffect then 
		if autoremove then 
			Plisteffect:setAutoRemoveOnFinish(autoremove)    --设置播放完毕之后自动释放内存
		end
   
		if time then
			Plisteffect:setDuration(time) --设置粒子系统的持续时间秒 
			util.setTimeout(function()
				util.tryRemove(Plisteffect)
			end,time)            
		end    

		Plisteffect:setPositionType(cc.POSITION_TYPE_RELATIVE)
	else
		print(PlistName .."is not find !")
	end    
	return Plisteffect
end
--格式：json,atlas,scale,名称,是否循环
function util.AddSpineAnimation(SpineJson,SpineAtlas,scale,AnimationName,isLoop)
	if not scale then
		scale = 1 
	end
	local skeletonNode = sp.SkeletonAnimation:create("img/Spine/"..SpineJson..".json", 
	 "img/Spine/"..SpineAtlas..".atlas", scale)

	if skeletonNode then
		if AnimationName then
			--skeletonNode:setMix("ui_travelatore", "ui", 0.1)
			skeletonNode:setAnimation(0,AnimationName,isLoop)
			--skeletonNode:addAnimation(0, "ui_travelatore", true)
		end    
	else
		print(AnimationName .."is not find !")
	end    
	return skeletonNode
end

function util.sp(josn,atlas)

end
function util.time()
	return socket.gettime()
end
function util.timeEx()
	local time = socket.gettime()
	return  os.date("%X",time)..":"..math.floor((time*10000)%10000)
end
--格式转换为：年-月-日 时：分：秒
function util.timeTostr(time, splitStr)
	local year = os.date("%Y",time)
	local month = os.date("%m",time)
	local day = os.date("%d",time)
	local times = os.date("%X",time)
	local timestr = ""
	if splitStr then
		timestr = year..splitStr..month..splitStr..day.." "..times
	else
		timestr = year.."-"..month.."-"..day.." "..times
	end
	-- timestr = year.."-"..month.."-"..day.." "..times
	return timestr
end
--格式转换
function util.timeTostrHM(time)
	local year = os.date("%Y",time)
	local month = os.date("%m",time)
	local day = os.date("%d",time)
	local times = os.date("%X",time)
	local timestr = ""
	timestr = year.."-"..month.."-"..day.." "..times
	return timestr
end
--传入时间戳，计算时间差
function util.timeDifference(time)
	local timeDif = socket.gettime() - time
	if timeDif < 0 then
		timeDif = 0
	end
	local timestr =""
	local day = math.floor(timeDif/(60*60*24))
	if day > 1 then
		local month = os.date("%m",time)
		local day = os.date("%d",time)
		timestr = month.."-"..day
		return timestr
	elseif day > 0 then
		timestr = string.formatIndex(Language.get("28036"), day)
		return timestr
	end

	timeDif = timeDif % (60*60*24)
	local hour = math.floor(timeDif/(60*60))
	if hour > 0 then
		timestr = string.formatIndex(Language.get("28035"), hour)
		return timestr
	end
	timeDif = timeDif % (60*60)
	local minute = math.floor(timeDif/60)
	if minute > 0 then
		timestr = string.formatIndex(Language.get("28034"), minute)
	else
		timestr = Language.get("28133")
	end
	return timestr
end
function util.timeFormatHM( time,str,format)
	local hour = os.date("%H",time)
	local minute = os.date("%M",time)
	local timestr =""
	timestr = hour .. ":" .. minute
	return timestr
end
function util.showTimePourFormatHM(time)
	if time < 0 then
		return ""
	end
    local hour = math.floor(time / 3600)
    local min = os.date("%M",time)
    local sec = os.date("%S",time)
    local timestr = string.format("%02d", hour) .. ":" ..  string.format("%02d", min) .. ":" .. string.format("%02d", sec)
    return timestr
end
function util.timeFormatStrHM( time,str,format)
	local hour = os.date("%H",time)
	local minute = os.date("%M",time)
	local timestr =""
	str = str or ":|:|"
	format = format or "%H%M"
	local tip =  string.split(str,"|")
	timestr = string.format("%02d", minute)..(tip[#tip] or "")
	timestr = string.format("%02d", hour)..(tip[#tip-1] or "")..timestr
	return timestr
end
--比较时间，查看是否同一天
function util.checkSameDay(preTime, curTime)
	if not preTime or preTime == "" then
		return false
	end
	local preYear = os.date("%Y",preTime)
	local preMonth = os.date("%m",preTime)
	local preDay = os.date("%d",preTime)
	local curYear = os.date("%Y",curTime)
	local curMonth = os.date("%m",curTime)
	local curDay = os.date("%d",curTime)
	if preYear == curYear and preMonth == curMonth and preDay == curDay then
		return true
	end
	return false
end
--格式转换为：年-月-日 时：分：秒
function util.timeTostring(time,splitStr,bNoYear)
	local year = os.date("%Y",time)
	local month = os.date("%m",time)
	local day = os.date("%d",time)
	local timestr = ""
	if splitStr then
		timestr = year..splitStr..month..splitStr..day
	else
		if bNoYear then
			timestr = month.."月"..day.."日"
		else
			timestr = year.."年"..month.."月"..day.."日"
		end
	end
	-- timestr = year.."-"..month.."-"..day.." "..times
	return timestr
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
-- 传入秒数计算时间格式为 
--str 本地化文本 小时：分钟：秒
--format 显示时间 "%D%H%M%S"
function util.timeFormat(time,str,format)
	local day = math.floor(time/(60*60*24))
	time = time % (60*60*24)
	local hour = math.floor(time/(60*60))
	time = time % (60*60)
	local minute = math.floor(time/60)
	time = time%60
	local second = math.floor(time)
	str = str or ":|:|:|:|"--Language.get("10154")
	format = format or "%D%H%M%S"
	local tip =  string.split(str,"|")

	local hasDay = format:find("D")
	local hasHour = format:find("H")
	local hasMinute = format:find("M")
	local hasSecond = format:find("S")

	local timestr =""
	-- if hasSecond then 
		timestr =string.format("%02d", second)..(tip[#tip] or "")
	-- end
	-- if minute > 0 or hour > 0 and hasMinute then 
		timestr = string.format("%02d", minute)..(tip[#tip-1] or "")..timestr
	-- end 
	-- if hour >0 or day >0 and hasHour then 
		timestr = string.format("%02d", hour)..(tip[#tip-2] or "")..timestr
	-- end
	if day >0 and hasDay then 
		timestr = string.format("%02d", day)..(tip[#tip-3] or "")..timestr
	end

	return timestr
end
function util.getLastName()
	return lastName
end
function util.showNumberCoinFormat( number )
	if not (type(number) == "number") then
		trace("error:show num is not num")
		return 0
	end
	local desc = number
	if (number <= -10000 and number > -100000) or (number <= -100000000 and number > -1000000000) or (number >= 10000 and number < 100000) or (number >= 100000000 and number < 1000000000) then
	   desc =  util.numberFormat(number, nil, 3, true)
	elseif (number <= -100000 and number > -100000000) or (number <= -1000000000) or (number >= 100000 and number <= 100000000) or (number >= 1000000000) then
		desc =  util.numberFormat(number, nil, 1, true)
	end
	return desc
end
--数值 格式化
--@param：number：数值
--@param：formatFlg："short" or ","，默认为"short"
--@param：idot：数值 表示小数点后显示几位,默认为2
--@param：bChinese：bool 单位为千或万
--@return example：999 or 9.99K or 9.99M or 9,999,999
function util.numberFormat( number, formatFlg ,idot,bChinese)
	if type( number ) ~= "number" then
		printLog( "util.numberFormat", "非数值" )
		return number
	end
	
	if formatFlg == nil then
		formatFlg = "short"
	end

	if math.abs( number ) <= 999 then
		return tostring(number)
	end

	if formatFlg == "short" then
		local numberStr = ""
		local tmp = math.abs( number )
		if tmp ~= number then
			numberStr = "-"
		end
		idot = idot or 2
		if bChinese then
			if tmp / 10^8 >= 1 then  
	            tmp = math.floor(tmp / 10^(8-idot))  
	            numberStr = numberStr .. string.format("%."..idot.."f", tmp/10^idot)
	            numberStr =  string.format("%g",numberStr) .. "亿"
	            return numberStr
	        elseif tmp / 10^4 >= 1 then  
	            tmp = math.floor(tmp / 10^(4-idot))
	            numberStr = numberStr .. string.format("%."..idot.."f", tmp/10^idot)
	            numberStr =  string.format("%g",numberStr) .. "万"
	            return numberStr
	        else  
	            return number  
	        end  
		else
			if tmp / 1000000 >= 1 then
				numberStr = numberStr .. string.format( "%."..idot.."f", tmp / 1000000 ) .. "M"
			elseif tmp / 1000 >= 1 then
				numberStr = numberStr .. string.format( "%."..idot.."f", tmp / 1000 ) .. "K"
			end
		end
		return numberStr
	end

	if formatFlg == "," then 
		local str = string.reverse( tostring( number ) )
		local count
		repeat
			str,count = string.gsub( str, "(%d%d%d)(%d)", "%1,%2", 1 )
		until count == 0
		return string.reverse( str )
	end
	
	return number
end
--得到罗马数字精灵帧
function util.getRomanNumSpFrame( number )
	if number == nil or number <= 0 or number >= 11 then
		printLog( "util.getRomanNumPic", "number must [1,10]" )
		return
	end

	local picName = "Roman_" .. number ..util.getImgType()

	return picName
end
--解析"1|2,3|23"
function util.split_two( value )
	local item_list={}
	for str in string.gmatch(value,"[^,]+") do
		for k,v in string.gmatch(str,"([^|]+)|([^|]+)") do
			 item_list[tonumber(k)]=tonumber(v)
		 end
	end
	return item_list
end
function util.split( value )
	local item_list={}
	for str in string.gmatch(value,"[^,]+") do
		for k,v in string.gmatch(str,"([^|]+)|([^|]+)") do
			table.insert(item_list,{tonumber(k),tonumber(v)})
		 end
	end
	return item_list
end
--解析"1|2|3|4"
function util.split1(value)
	local result = {}
	string.gsub(value, '[^'.."|"..']+', function(w) table.insert(result, tonumber(w)) end )
	return result
	
end
--解析"a|2,b|23"
function util.splitString( value )
	local item_list={}
	for str in string.gmatch(value,"[^,]+") do
		for k,v in string.gmatch(str,"([^|]+)|([^|]+)") do
			table.insert(item_list,{k,v})
		 end
	end
	return item_list
end
function util.splitString2( value )
	local item_list={}
	for str in string.gmatch(value,"[^,]+") do
		for k,v in string.gmatch(str,"([^|]+)|([^|]+)") do
			item_list[k] = v
		 end
	end
	return item_list
end
---按钮禁用
function util.setEnabledBtn(btn,isenabled)
	btn:setBright(isenabled);
	btn:setEnabled(isenabled);
	btn:setTouchEnabled(isenabled);
end
------------------------------------
--  界面适配
------------------------------------
--界面位置适配
function util.getsize()
	local display = {}
	util.display = display
	local director = cc.Director:getInstance()
	local view = director:getOpenGLView()
	local sizeInPixels = view:getFrameSize()    --设备大小
	local viewsize = director:getWinSize()      --适配后大小
	local scaleX, scaleY = sizeInPixels.width / CC_DESIGN_RESOLUTION.width, sizeInPixels.height / CC_DESIGN_RESOLUTION.height
	--trace("设备分辨率:", sizeInPixels.width.." "..sizeInPixels.height)
	--trace("设计分辨率:", CC_DESIGN_RESOLUTION.width.." "..CC_DESIGN_RESOLUTION.height)
	--trace("适配后分辨率:", viewsize.width.." "..viewsize.height)
	display.sizeInPixels = {width = sizeInPixels.width, height = sizeInPixels.height}
	if CC_DESIGN_RESOLUTION.autoscale=="FIXED_WIDTH" then
		display.offx = (viewsize.width - CC_DESIGN_RESOLUTION.width)/2
		display.offy =  CC_DESIGN_RESOLUTION.height -viewsize.height
	elseif CC_DESIGN_RESOLUTION.autoscale=="FIXED_HEIGHT" then
		display.offx = CC_DESIGN_RESOLUTION.width -viewsize.width
		display.offy =  (viewsize.height - CC_DESIGN_RESOLUTION.height)/2
	end
	display.contentScaleFactor = director:getContentScaleFactor()
	display.size               = {width = viewsize.width, height = viewsize.height}
	display.width              = display.size.width
	display.height             = display.size.height
	display.cx                 = display.width / 2
	display.cy                 = display.height / 2
	display.c_left             = -display.width / 2
	display.c_right            = display.width / 2
	display.c_top              = display.height / 2
	display.c_bottom           = -display.height / 2
	display.left               = 0
	display.right              = display.width
	display.top                = display.height
	display.bottom             = 0
	display.center             = cc.p(display.cx, display.cy)
	display.left_top           = cc.p(display.left, display.top)
	display.left_bottom        = cc.p(display.left, display.bottom)
	display.left_center        = cc.p(display.left, display.cy)
	display.right_top          = cc.p(display.right, display.top)
	display.right_bottom       = cc.p(display.right, display.bottom)
	display.right_center       = cc.p(display.right, display.cy)
	display.top_center         = cc.p(display.cx, display.top)
	display.top_bottom         = cc.p(display.cx, display.bottom)
	display.scaleX             = scaleX
	display.scaleY             = scaleY
	--[[trace(string.format("# display.offx                 = %s", display.offx))
	trace(string.format("# display.offy                 = %s", display.offy))
	trace(string.format("# display.scaleX               = %s", scaleX))
	trace(string.format("# display.scaleY               = %s", scaleY))
	trace(string.format("# display.sizeInPixels         = {width = %0.2f, height = %0.2f}", display.sizeInPixels.width, display.sizeInPixels.height))
	trace(string.format("# display.size                 = {width = %0.2f, height = %0.2f}", display.size.width, display.size.height))
	trace(string.format("# display.contentScaleFactor   = %0.2f", display.contentScaleFactor))
	trace(string.format("# display.width                = %0.2f", display.width))
	trace(string.format("# display.height               = %0.2f", display.height))
	trace(string.format("# display.cx                   = %0.2f", display.cx))
	trace(string.format("# display.cy                   = %0.2f", display.cy))
	trace(string.format("# display.left                 = %0.2f", display.left))
	trace(string.format("# display.right                = %0.2f", display.right))
	trace(string.format("# display.top                  = %0.2f", display.top))
	trace(string.format("# display.bottom               = %0.2f", display.bottom))
	trace(string.format("# display.c_left               = %0.2f", display.c_left))
	trace(string.format("# display.c_right              = %0.2f", display.c_right))
	trace(string.format("# display.c_top                = %0.2f", display.c_top))
	trace(string.format("# display.c_bottom             = %0.2f", display.c_bottom))
	trace(string.format("# display.center               = {x = %0.2f, y = %0.2f}", display.center.x, display.center.y))
	trace(string.format("# display.left_top             = {x = %0.2f, y = %0.2f}", display.left_top.x, display.left_top.y))
	trace(string.format("# display.left_bottom          = {x = %0.2f, y = %0.2f}", display.left_bottom.x, display.left_bottom.y))
	trace(string.format("# display.left_center          = {x = %0.2f, y = %0.2f}", display.left_center.x, display.left_center.y))
	trace(string.format("# display.right_top            = {x = %0.2f, y = %0.2f}", display.right_top.x, display.right_top.y))
	trace(string.format("# display.right_bottom         = {x = %0.2f, y = %0.2f}", display.right_bottom.x, display.right_bottom.y))
	trace(string.format("# display.right_center         = {x = %0.2f, y = %0.2f}", display.right_center.x, display.right_center.y))
	trace(string.format("# display.top_center           = {x = %0.2f, y = %0.2f}", display.top_center.x, display.top_center.y))
	trace(string.format("# display.top_bottom           = {x = %0.2f, y = %0.2f}", display.top_bottom.x, display.top_bottom.y))
	trace("#")]]

end
function util.setGray(node)
	local vertDefaultSource = "\n"..
	"attribute vec4 a_position; \n" ..
	"attribute vec2 a_texCoord; \n" ..
	"attribute vec4 a_color; \n"..                                                    
	"#ifdef GL_ES  \n"..
	"varying lowp vec4 v_fragmentColor;\n"..
	"varying mediump vec2 v_texCoord;\n"..
	"#else                      \n" ..
	"varying vec4 v_fragmentColor; \n" ..
	"varying vec2 v_texCoord;  \n"..
	"#endif    \n"..
	"void main() \n"..
	"{\n" ..
	"gl_Position = CC_PMatrix * a_position; \n"..
	"v_fragmentColor = a_color;\n"..
	"v_texCoord = a_texCoord;\n"..
	"}"
	 
	local pszFragSource = "#ifdef GL_ES \n" ..
	"precision mediump float; \n" ..
	"#endif \n" ..
	"varying vec4 v_fragmentColor; \n" ..
	"varying vec2 v_texCoord; \n" ..
	"void main(void) \n" ..
	"{ \n" ..
	"vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
	"gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b); \n"..
	"gl_FragColor.w = c.w; \n"..
	"}"

	if tolua.type(node) == "ccui.ImageView" then
		local image = node:getVirtualRenderer()
		node = image:getSprite()
	end

	local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
	 
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
	pProgram:link()
	pProgram:updateUniforms()
	node:setGLProgram(pProgram)
end
function util.setnoGray(node)
	if tolua.type(node) == "ccui.ImageView" then
		local image = node:getVirtualRenderer()
		node = image:getSprite()
	end    
	node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
end
function util.encodeURL(s)
	return (string.gsub(s, "([^A-Za-z0-9_])", function(c)
		return string.format("%%%02x", string.byte(c))
	end))
end
--加载网络图片,Url图片地址,bForceRefer删除缓存强制刷新,callback回调,参数:成功与否,本地图片存放地址

local loadingImg = {}

function util.loadWebImg(Url,bForceRerfer,callback)
	if loadingImg[Url] then
		table.insert(loadingImg[Url],callback)
		return
	end
	loadingImg[Url] = {callback}
	local function doCallbacks(...)
		if loadingImg[Url] then
			for i,j in pairs(loadingImg[Url]) do
				j(...)
			end
		end
		loadingImg[Url] = nil
	end

	local File = require("util.File")
	local path = File.wirtePath
	path = path.."webImg/"
	File.mkdir(path)
	path = path..util.encodeURL(Url)--..".png"
	local imgType = string.sub(path,-4)
	if imgType~=".png" and imgType~=".jpg" then
		if string.find(path,".jpg") then
			path = path..".jpg"
		else
			path = path..".png"
		end
	end
	if not File.exists(path) or bForceRerfer then
		--GET手机端无法下载Facebook头像,原因未知
		local xhr = cc.XMLHttpRequest:new()
		xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
		xhr:open("GET", Url)
		local function onReadyStateChange()
			if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
				File.save(path,xhr.response,"wb")
				doCallbacks(true,path)
			else
				trace("util.loadWebImg xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
				doCallbacks(false)
			end
		end
		xhr:registerScriptHandler(onReadyStateChange)
		xhr:send()

		--[[改为用Loader
		local function downCallback(result)
			if result.state == 3 then -- 下载完成
				
			end
		end
		Loader:shared():setRemotePath(Url)
		Loader:shared():load("", handler(self, downCallback))]]
	else
		doCallbacks(true,path)
	end
end
function util.setImg(node,img)
	if tolua.isnull(node) or not img then
		trace("R:setImg no find image or node")
	end
	if iskindof(node,"cc.Sprite") then
		util.loadSprite(node,img)
	elseif iskindof(node,"ccui.ImageView") then
		util.loadImage(node,img)
	elseif iskindof(node,"ccui.Button") then
		util.loadButton( node,img)
	else
		trace("R:img unknown node")
	end
end
function util.setWebImg(node,url)
	if tolua.isnull(node) or not url or url == "" then
		return
	end
	util.loadWebImg(url,false,function(suc,path) if suc then util.setImg(node,path) end end)
end
function util.isChildWin()
   local popwin =scenes.winLayer:getChildrenCount() 
   local guildLayer =scenes.guildLayer:getChildrenCount()
   if popwin>0 or guildLayer >0 then
	   return false
   else
	   return true
   end
end
function util.reg()
	if util.isReg then -- 已注册过 就不用再重复注册
		return
	end
	util.isReg = true
	trace("reg LocalMsg")
	util.listener1 = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND",util.onEnerBackground )
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(util.listener1,1);  
	util.listener2 = cc.EventListenerCustom:create("APP_EXIT_BACKGROUND",util.onEnterForground)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(util.listener2,1);     
end

function util.removeReg()
	trace("移除后台监听")
	cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners("APP_ENTER_BACKGROUND")
	cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners("APP_EXIT_BACKGROUND")
end
-- 进入游戏
function util.onEnerBackground()
	if util._isInBackGround then
		trace("回到游戏")
		util._isInBackGround = false
		local isout,timeDiff = util.isTimeOut()
		if isout then
			trace("切入后台时间过久,重载游戏")
			util.setTimeout(function() util.backToLogin(sdkManager:is_IOS() or __Platform__ == 3) end,0.2)
			return
		end
		--if __Platform__==3 or __Platform__==4 or __Platform__==5 then
			--util.setTimeout(function() 
				GameEvent:notifyView(GameEvent.gameBackFromGround,timeDiff) 
			--end,0.01)
			
			--util.setTimeout(function() cc.SimpleAudioEngine:getInstance():resumeMusic() end,1)
		--end
	end
end
-- 退出游戏
function util.onEnterForground()
	trace("切入后台")
	util.enterForgroundTime = os.time()
	--if __Platform__==3 or __Platform__==4 or __Platform__==5 then
		--collectgarbage("collect")
		GameEvent:notifyView(GameEvent.gametoBack)
	--end
	util._isInBackGround = true
end
function util.isInBackGround()
	return util._isInBackGround
end
-- 切到后台是否超时
function util.isTimeOut()
	local time1 = util.enterForgroundTime and util.enterForgroundTime or os.time()
	local timeDiff = os.time() - time1
	if timeDiff > 120 then
		return true,timeDiff
	end
	return false,timeDiff
end
-- 重新登录
function util.reloadGame()
	util.gameTimeOut = false
	PlayerData:removeNetwokEvents()
	PlayerData:setHasaddevent(false)
	GameNetwork:removeNetwokEvents()
	trace("断开网络 disconnect----")
	GameTCP:disconnect()
	GameTCP:close()
	GameTCP = nil
	SocketTCP = nil
	package.loaded["util.SocketTCP"] = nil
	util.removeReg()
	util.clearLoadedLuaFile()
	cc.FileUtils:getInstance():purgeCachedEntries() -- 释放资源缓存
	reloadGame()    
end
-- 清理lua
function util.clearLoadedLuaFile()
	local clearTab = {}
	for k,v in pairs(package.loaded) do
		if not G_Loaded[k] then
			table.insert(clearTab, k)
		end
	end
	trace("clear count:"..#clearTab)
	for k,v in pairs(clearTab) do
		package.loaded[v] = nil
		trace("clear:"..v)      
	end
end
--资源图片格式,安卓平台获取的图片由png 变成pkm ios png ->pvr
function util.getImgType()
	--TODO:
	return ".png"
end
--十进制转二进制
function util.sec(num)
	num = tonumber(num)
	local bytetab = {}
	local temp 
	while(num and num>0)
	do
		temp = num%2
		num = math.floor(num/2)
		table.insert(bytetab,temp)
	end
	return bytetab  
end

function util.getAndroidPackPath()
	return "com/ddz/"
end

---------------------- 替换资源专用
function util.getresType()
	return ccui.TextureResType.localType
end
function util.getSprite(name)
	local spr
	if string.find(name, "/") then -- testing
		spr = cc.Sprite:create(name)
	else
		spr = cc.Sprite:createWithSpriteFrameName(name)
	end
	return spr
end
function util.viewScale(node, func, func2)
	if CC_DESIGN_RESOLUTION.width == 640 and CC_DESIGN_RESOLUTION.height == 1136 then -- 640*1136 底部正常显示 需处理顶部，中间伸缩部分
		if func2 then
			func2()
		else
			util.aptSelf(node)
		end
		
	else
		func()
	end
end
--解析时间串 格式“201603310800-20160410000”
function util.parseTime( timeStr )
	local nowdate = os.date("*t")
	local time_list = {}
	for str in string.gmatch(timeStr,"[^-]+") do 
		nowdate.year = tonumber(string.sub(str,1,4))
		nowdate.month = tonumber(string.sub(str,5,6))
		nowdate.day = tonumber(string.sub(str,7,8))
		nowdate.hour = tonumber(string.sub(str,9,10))
		nowdate.min = tonumber(string.sub(str,11,12))
		nowdate.sec = 0
		table.insert(time_list, os.time(nowdate))
	end
	return time_list
end
function util.numtoIp( num )
	local adress = ""
	for i=3,0,-1 do
		adress = (i~=0 and "." or "")..tostring(math.floor(num/math.pow(256,i)))..adress
		num = num%math.pow(256,i)
	end

	return adress
end
function util.setTblIndexStart0(tbl)
	if not tbl[0] then
		local res = {}
		for i,j in pairs(tbl) do
			if type(i)==num then
				res[i-1] = j
			else
				res[i] = j
			end
		end
		return res
	end
	return tbl
end
--获取设置标识如:ffffffff-d1ad-6432-0000-00000001aad7

function util.getDriverID()
	if util.driverID then 
		return util.driverID
	end
	if  __Platform__ == 3 then    --安卓平台
		local args = {}
		local sigs = "()Ljava/lang/String;"
		local funName = "getUniquePsuedoID"


		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			util.driverID = ret
			trace("设置ID:",util.driverID)
		end
	elseif __Platform__ == 4 or __Platform__ == 5 then
		local suc,str = LuaObjcBridge.callStaticMethod("AppController", "getDerviceID",nil)
		if not suc then
			trace("LuaObjcBridge.callStaticMethod fail res = ",str)
		end
		util.driverID = suc and str
	else
		--return "ffffffff-a526-86d0-0000-00001bf2e09f"
		util.driverID = "win32"
	end
	trace("util.driverID = ",util.driverID,"__Platform__ = ",__Platform__)
	return util.driverID
end
--获取 手机型号
function util.getPhoneModel()
	if util._PhoneModel then 
		return util._PhoneModel
	end
	if  __Platform__ == 3 then    --安卓平台
		local args = {}
		local sigs = "()Ljava/lang/String;"
		local funName = "getPhoneModel"


		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			util._PhoneModel = ret
			trace("手机型号:",util._PhoneModel)
			return util._PhoneModel
		end
	elseif __Platform__ == 0 then
		return "win32"
	elseif __Platform__ == 4 or __Platform__ == 5 then
		local suc,str = LuaObjcBridge.callStaticMethod("AppController", "getDerviceName",nil)
		if not suc then
			trace("LuaObjcBridge.callStaticMethod fail res = ",str)
		end
		util._PhoneModel = suc and str or "ios"
		trace("默认用户名:",str)
		return util._PhoneModel
	end

	return
end
function util.getMac()
	if util.macID then 
		return util.macID
	end
	if  __Platform__ == 3 then    --安卓平台
		local args = {}
		local sigs = "()Ljava/lang/String;"
		local funName = "getMacID"


		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			util.macID = string.sub(ret,1,16)
			trace("macID:",util.macID)
			return util.macID
		end
	end
	if sdkManager:is_IOS() then
		local suc,str = LuaObjcBridge.callStaticMethod("AppController", "getDerviceID",nil)
		if not suc then
			trace("LuaObjcBridge.callStaticMethod fail res = ",str)
		end
		util.macID = suc and str
		trace("macID:",util.macID)
		return util.macID
	end

	return "pc123456pc123456"
end
function util.setshakePos(node,pos)
	local anchor = cc.p(pos.x/util.display.width,pos.y/util.display.height)
	node._shakePos = anchor
end
function util.shakeWin(node)
	if tolua.isnull(node) then
		return
	end
	node:stopAllActions()
	local oldScaleX = node:getScaleX()
	local oldScaleY = node:getScaleY()
	local tagScale = 1.05
	local tagScale2 = 1
	local oldOpacity
	util.changeAnchor(node,node._shakePos or cc.p(0.5,0.5))
	--[[local bk =  node.pnl_close or node.pnl_bk or node.pnl_bg or node.img_bg or node.img_bg
	if bk and bk.setBackGroundColorOpacity then
		oldOpacity = bk:getBackGroundColorOpacity()
		bk:setBackGroundColorOpacity(0)
	end]]
	node:setScale(oldScaleX*tagScale2,oldScaleY*tagScale2)

	local actoinBig = cc.ScaleTo:create(0.03,oldScaleX*tagScale,oldScaleY*tagScale)
	local actoinSmall = cc.ScaleTo:create(0.06,oldScaleX,oldScaleY)
	local anchor2 = cc.CallFunc:create(function() 
		util.changeAnchor(node,cc.p(0,0))
		--[[if bk and oldOpacity  then
			util.delayCall(bk,function() 
				local nowOpacity = bk:getBackGroundColorOpacity()
				if nowOpacity <= oldOpacity and bk.setBackGroundColorOpacity then
					nowOpacity = nowOpacity + 50
					if nowOpacity>oldOpacity then
						nowOpacity = oldOpacity
					end
					bk:setBackGroundColorOpacity(nowOpacity)
				else
					util.removeAllSchedulerFuns(bk)
				end
			end,nil,true)
		end]]
	end)

	node:runAction(cc.Sequence:create(actoinBig,actoinSmall,anchor2))
end
function util.hideWin(node)
	if tolua.isnull(node) or node._isHiding then
		return
	end
	--[[node._isHiding = true
	node:stopAllActions()
	local bk = node.pnl_close or node.pnl_bk or node.pnl_bg or node.img_bg or node.img_bg
	if bk then
		if bk.setBackGroundColorOpacity  then
			bk:setBackGroundColorOpacity(0)
		elseif bk.setBackGroundColor then
			bk:setBackGroundColor(cc.c4b(0,0,0,0))
		end
	end

	local oldScaleX = node:getScaleX()
	local oldScaleY = node:getScaleY()
	local tagScale = 1.1
	local tagScale2 = 0.3

	--local anchor1 = cc.CallFunc:create(function() util.changeAnchor(node,cc.p(0.5*util.display.scaleX,0.5*util.display.scaleY)) end)
	local anchor1 = cc.CallFunc:create(function() util.changeAnchor(node,node._shakePos or cc.p(0.5,0.5)) end)
	local actoinBig = cc.ScaleTo:create(0.1,oldScaleX*tagScale,oldScaleY*tagScale)
	local actoinSmall = cc.ScaleTo:create(0.15,oldScaleX*tagScale2,oldScaleY*tagScale2)
	local remove = cc.CallFunc:create(function() util.tryRemove(node) end)

	node:runAction(cc.Sequence:create(anchor1,actoinBig,actoinSmall,remove))]]

	util.tryRemove(node)
end
function util.reloadPackage(path)
	package.loaded[path] = nil
	require(path)
end
function util.changeParent(node1,node2)
	if node1:getParent() == node2 then
		return
	end
	local zOrder = node1:getLocalZOrder()
	node1:retain()
	node1:removeFromParent(false)
	node2:addChild(node1,zOrder)
	node1:release()
end
function util.md5(string)
	if not type(string) == "string" then
		trace("error util.md5 string is not a string")
	end
	return cc.Crypto:MD5(string,false)
end


local __editBoxs = {
	--[edit] = {maxLen = 10,onlyNum = true,lastText},
}
function util.onTextEnd()
	if not tolua.isnull(util.focusTextField) then
		util.focusTextField:didNotSelectSelf()--失去焦点
	end
end
function util.moveBaseNode(textField)
	if not (__Platform__ == 3 or __Platform__ == 4 or __Platform__ == 5) then
		return
	end
	util.focusTextField = textField
	local isUp = not tolua.isnull(textField)
	if util._baseIsUp == isUp and not isUp then
		return false
	end

	if isUp then
		trace("showBoard")
		util._baseIsUp = false
		local screenSize = cc.Director:getInstance():getWinSize()
		local pos = cc.p(textField:getPosition())
		pos = textField:getParent():convertToWorldSpace(pos)
		pos = BASE_NODE:convertToNodeSpace(pos)
		local y = math.max(0,screenSize.height*3/4 - pos.y)
		BASE_NODE:stopAllActions()
		BASE_NODE:runAction(cc.Sequence:create(cc.MoveTo:create(0.225,cc.p(0, y)),cc.CallFunc:create(function() util._baseIsUp = isUp  end)) )
	else
		trace("HideBoard")
		BASE_NODE:stopAllActions()
		BASE_NODE:runAction(cc.Sequence:create(cc.MoveTo:create(0.175, cc.p(0, 0)),cc.CallFunc:create(function() util._baseIsUp = isUp  end)) )
		util.removeAllSchedulerFuns(BASE_NODE)
	end
	return true
end
function util.handlerOnKeyBoardChange()
	if __Platform__ == 3 then
		local args = {function(arg) if arg == "0" then util.moveBaseNode() end end}
		local sigs = "(I)V"
		local funName = "handlerOnKeyBoardChange"

		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			return 
		end
	elseif __Platform__ == 4 or __Platform__ == 5 then
		
	end
end
-- 文字编辑 
function util.onEditChange( textField,event)
	--trace("onEditChange",textField:getString())
	if event == ccui.TextFiledEventType.attach_with_ime then
		util.moveBaseNode(textField)
		return
	elseif event == ccui.TextFiledEventType.detach_with_ime then
		util.moveBaseNode()
		return
	elseif event == ccui.TextFiledEventType.insert_text then  
	elseif event == ccui.TextFiledEventType.delete_backward then

	end
	local str = textField:getString()
	if table.nums(__editBoxs[textField])== 0 then
		return
	end
	local lastText =  __editBoxs[textField].lastText
	local onlyNum = __editBoxs[textField].onlyNum
	local len = string.len( str )
	local maxLen = __editBoxs[textField].maxLen
	if maxLen and len > maxLen then
		if lastText then
			str = lastText
		else
			str = "" 
		end
	end
	if onlyNum and not tonumber(str) and not (str == "") then
		if lastText then
			str = lastText
		else
			str = ""
		end
	end
	if str then
		textField:setString(str)
		__editBoxs[textField].lastText = str
	end
	for _,fun in pairs(__editBoxs[textField].callback) do
		fun(textField,event)
	end
end
function util.setEditBox(__target__)
	if not __target__ then return __target__ end
	if not iskindof(__target__,"ccui.TextField") then
		return __target__
	end
	if not sdkManager:isNewCocosVersion() or not __target__.getTextColor then
		return __target__
	end
	local inputFlag,inputFlag
    local _editBox = ccui.EditBox:create(cc.size(__target__:getContentSize().width-8,__target__:getContentSize().height-2),ccui.Scale9Sprite:create())
	_editBox:setAnchorPoint(__target__:getAnchorPoint())
	_editBox:setPosition(__target__:getPosition())
	local fontColor = __target__:getTextColor()
	if fontColor then
		if table.equal(fontColor,cc.c4b(255,255,255,255)) then
			fontColor = cc.c4b(105,105,105,255)
		end
		_editBox:setFontColor(fontColor)
		_editBox:setPlaceholderFontColor(fontColor)
	end

	local fontSize = __target__:getFontSize()
	_editBox:setPlaceholderFontSize(fontSize or 22)
	_editBox:setFontSize(fontSize or 22)
	_editBox:setOpacity(0)

	local holder = __target__:getPlaceHolder()
	if holder then
		_editBox:setPlaceHolder(holder)
	end

	local holderColor = __target__:getPlaceHolderColor()
	if holderColor then
		_editBox:setPlaceholderFontColor(holderColor)
	end

	if __target__:isPasswordEnabled() then
		inputFlag = cc.EDITBOX_INPUT_FLAG_PASSWORD
	end

    _editBox:setInputMode(inputMode or cc.EDITBOX_INPUT_MODE_SINGLELINE)
	_editBox:setInputFlag(inputFlag or cc.EDITBOX_INPUT_FLAG_SENSITIVE)
	local maxLength = __target__:getMaxLength()
	if maxLength then
		_editBox:setMaxLength(maxLength)
	end
	if font then
		_editBox:setText(font)
	end
	--local hAlig = __target__:getTextHorizontalAlignment()
	_editBox:setTextHorizontalAlignment(1)
    _editBox:setName(__target__:getName())
	__target__:getParent():addChild(_editBox)
	__target__:removeSelf()

	_editBox.setTextColor = _editBox.setFontColor
	_editBox.getTextColor = _editBox.getFontColor
	_editBox.getString = _editBox.getText
	_editBox.setString = _editBox.setText
	_editBox.setTextColor = _editBox.setFontColor
	_editBox.didNotSelectSelf = function()end
	_editBox.setCursorEnabled = function()end
	_editBox.addEventListener = function()end--_editBox.registerScriptEditBoxHandler
	_editBox.setTextVerticalAlignment = function()end
	_editBox.setPlaceHolderColor = _editBox.setPlaceholderFontColor
	_editBox.setDetachWithIME = function()end

	return _editBox
end

function util.extendEditBox(editBox)
	if not __editBoxs[editBox] then
		__editBoxs[editBox] = {}
		if sdkManager:isNewCocosVersion() then
			editBox:setCursorEnabled(true)
			local color = editBox:getTextColor()
			if table.equal(color,cc.c4b(255,255,255,255)) then
				editBox:setTextColor(cc.c4b(105,105,105,255))
			end
		end
		editBox:setTextHorizontalAlignment(1)
		editBox:setTextVerticalAlignment(1)
		editBox:addEventListener( function(textField, event) util.onEditChange(textField, event) end)
		__editBoxs[editBox].callback = {}
		function editBox:addEventListener(func)
			table.insert(__editBoxs[editBox].callback,func)
		end
	end
end
function util.addEditFlag()
	util._baseIsUp = false
	util.handlerOnKeyBoardChange()
	local oldcreate = ccui.TextField.create
	function ccui.TextField.create(...)
		local editBox = oldcreate(...)
		util.extendEditBox(editBox)
		return editBox
	end
end
--设置最长输入,editBox为输入框,mlen为最长字节数
function util.setMaxEditLen(editBox,mlen)
	if not mlen or tolua.isnull(editBox) then
		return
	end
	if iskindof(editBox,"ccui.EditBox") then
		editBox:setMaxLength(mlen)
		return
	end
	util.extendEditBox(editBox)
	__editBoxs[editBox].maxLen = mlen
end

function util.setEditOnlyNum(editBox,flag)
	if tolua.isnull(editBox) then
		return
	end
	if iskindof(editBox,"ccui.EditBox") then
		editBox:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
		return
	end
	util.extendEditBox(editBox)

	__editBoxs[editBox].onlyNum = flag
end

--设置文本最长长度,超出的显示...,text为文本框,mlen为最长字节
function util.setTextMaxLen(text,mlen)
	if not mlen or tolua.isnull(text) then
		return
	end

	local oldSetString = text.setString
	local oldGetString = text.getString

	function text:setString(str)
		text._string = str
		oldSetString(text,stringToFormat(str,mlen))
	end
 
	function text:getString(str)
		return text._string or oldGetString(text)
	end
	
	text:setString(text:getString())
end
--设置文本最长长度,超出的显示...,text为文本框,mWdith为最长宽度
function util.setTextMaxWidth(text,mWdith)
	if  tolua.isnull(text) then
		return
	end
	if text.__mWdith then
		text.__mWdith = mWdith
		return
	end
	text.__mWdith = mWdith
	if not mWdith then
		text.setString = text.oldSetString or text.setString 
		text.getString = text.oldGetString or text.getString 
		return
	end
	text.oldSetString = text.setString
	text.oldGetString = text.getString

	function text:setString(str)
		text._string = str
		text.oldSetString(text,str)
		stringToFormatEx(text,text.__mWdith)
	end
 
	function text:getString(str)
		return text._string or text.oldGetString(text)
	end

	function text:getShowString(str)
		return text.oldGetString(text)
	end
	
	text:setString(text:getString())
end
--两个文字的中间居中(x锚点分别 为1,0)
function util.setTextCenter(text1,text2,space)
	local w1 = text1:getContentSize().width
	local w2 = text2:getContentSize().width
	local pw = text1:getParent():getContentSize().width
	if w1 == 0 or w2 ==0 then
		space = 0
	end

	local x1 = (pw - w1 - w2  - space)/2 + w1
	local x2 = x1 + space

	text1:setPositionX(x1)
	text2:setPositionX(x2)
end
function util.webPost(url,callbackfun,cookie)
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	if cookie then
		xhr:setRequestHeader("Cookie",cookie)
	end
	--xhr:setRequestHeader("Content-Type","text/xml")--xml
	xhr:open("POST", url)

	local function onReadyStateChange()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			callbackfun(true,xhr.response)
		else
			callbackfun(false,{readyState= xhr.readyState, status=xhr.status})
			trace(url)
			trace("webPost失败readyState= , status= ,response = ",xhr.readyState, xhr.status,xhr.response)
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send()
end
function util.webGet(url,callbackfun)
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	--xhr:setRequestHeader("Content-Type","text/xml")--xml
	xhr:open("GET", url)

	local function onReadyStateChange()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			callbackfun(true,xhr.response)
		else
			callbackfun(false,{readyState= xhr.readyState, status=xhr.status})
			trace(url)
			trace("webGet失败readyState= , status= ,response = ",xhr.readyState, xhr.status,xhr.response)
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send()
end
function util.encodeTab(tab)
	local str = ""
	for key,value in pairs(tab) do
		str = str..key.."="..util.encodeURI(value).."&"
	end
	str = string.sub(str,0,-2)
	return str
end
function util.tab2String(tab,splitKey)
	local str = ""
	for key,value in pairsKey(tab) do
		str = str..key.."="..tostring(value)..(splitKey or "&")
	end
	str = string.sub(str,0,-2)
	return str
end
function util.encodeURI(s)
	return (string.gsub(s, "([^A-Za-z0-9_])", function(c)
		return string.format("%%%02x", string.byte(c))
	end))
end
function util.encodeURL(w)
	local pattern="[^%w%d%._%-%* ]"  
	s=string.gsub(w,pattern,function(c)  
		local c=string.format("%%%02X",string.byte(c))  
		return c  
	end)  
	s=string.gsub(s," ","+")  
	return s  
end
function util.get(url,callbackfun)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", url)

    local function onReadyStateChange()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            callbackfun(true,xhr.response)
        else
            callbackfun(false)
            trace("get失败url= ,readyState= , status= ,response = ",url,xhr.readyState, xhr.status,xhr.response)
        end
    end
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end
--只post,不做url转码
function util.post(url,arg,callbackfun)
	arg = util.tab2String(arg)
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	xhr:open("POST", url)

	local function onReadyStateChange()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) and xhr.response and xhr.response~="" then
			local response   = xhr.response
			if callbackfun then
				callbackfun(true,response)
			end
		else
			trace(url.."?"..arg)
			trace("post失败readyState= , status= ,response = ",xhr.readyState, xhr.status,xhr.response)
			if callbackfun then
				callbackfun(false,{readyState= xhr.readyState, status=xhr.status})
			end
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send(arg)
end
function util.postJson(url,arg,callbackfun)
	arg = util.encodeTab(arg)
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	xhr:open("POST", url)

	local function onReadyStateChange()
		if callbackfun then
			if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) and xhr.response and xhr.response~="" then
				local response   = xhr.response
				local output = json.decode(response)
				callbackfun(true,output)
			else
				trace("post失败readyState= , status= ,response = ",xhr.readyState, xhr.status,xhr.response)
				callbackfun(false,{readyState= xhr.readyState, status=xhr.status})
			end
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send(arg)
	trace(url.."?"..arg)
end
--POST的参数为jsonstr={...}
function util.postJson2(url,arg,callbackfun)
	arg = {strjson = json.encode(arg)}
	util.postJson(url,arg,callbackfun)
end
--上传图片
function util.postJson3(url,arg,callbackfun)
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	xhr:setRequestHeader("Content-Type","multipart/form-data")--xml
	--xhr:setRequestHeader("Content-Type","application/x-www-form-urlencoded")--xml
	trace("上传头像大小",string.len(arg))
	xhr:open("POST", url)

	local function onReadyStateChange()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) and xhr.response and xhr.response~="" then
			local response   = xhr.response
			--local output = json.decode(response)
			callbackfun(true,response)
		else
			trace(url)
			trace("post失败readyState= , status= ,response = ",xhr.readyState, xhr.status,xhr.response)
			callbackfun(false,{readyState= xhr.readyState, status=xhr.status})
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send(arg)
end
--发送LOG到服务器,
function util.postLogToServer(logText,isnet)
	if not logText or __Platform__ == 0 then
        return
	end
	local arg = {
		_userID = PlayerData and PlayerData:getUserID() or "nil",
		_versionCode = Platefrom and Platefrom:getVersionCode() or "nil",
		__Platform__  = __Platform__,
		_phone = util.getPhoneModel(),
		_ver = PlayerData:getVersion(),
		_vername = Platefrom:getVersionName(),
		log = "\n\t"..logText,
	}
	local text  = util.tab2String(arg," ")

	--默认在OutOnline 目录,type =1在Client目录
    util.post("http://520.ddz.com/handler/common.ashx",{
        action="clientexption",
		logtxt = text,
		type = not isnet and "1" or "2",
    })
end
function util.webPost2(url,arg,callbackfun)
	arg = util.encodeTab(arg)
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	--xhr:setRequestHeader("Content-Type","text/xml")--xml
	xhr:open("POST", url)

	local function onReadyStateChange()
		if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
			callbackfun(true,xhr.response)
		else
			callbackfun(false,{readyState= xhr.readyState, status=xhr.status})
			trace("webPost失败readyState= , status= ,response = ",xhr.readyState, xhr.status,xhr.response)
		end
	end
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send(arg)
end
--微信中发消息
function util.SendMessageToWX(title,msg)
	local sharUrl = "http://wx." .. util.curDomainName() .. "/weixin/download.aspx"
	sdkManager:wxShare(sharUrl,title,msg,0)
end
--打开微信
function util.openWx()
	if  __Platform__ == 3 then    --安卓平台
		local args = {}
		local sigs = "()V"
		local funName = "openWX"

		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			return 
		end
    elseif sdkManager:is_IOS() then
	    local suc,str = LuaObjcBridge.callStaticMethod("AppController", "openWX",nil)
	    if not suc then
		    trace("util.openWx fail res = ",str)
	    end
	end
end
function util.ShareScreenToWX()
	if  __Platform__ == 3 then    --安卓平台
		local fileName = "share"
		fileName = util.screen(fileName)
		if not fileName then
			trace("分享失败,截图失败")
			return
		end
		local args = {fileName}
		local sigs = "(Ljava/lang/String;)V"
		local funName = "shareScreen"

		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			return 
		end
	end
end
--截屏代码 有一个咔嚓的动画
function util.screen(fileName)
	local path = File.root

	local size = cc.Director:getInstance():getWinSize()
	local screen = cc.RenderTexture:create(size.width, size.height)
	local temp  = cc.Director:getInstance():getRunningScene()
	screen:begin()
	temp:visit()
	screen:endToLua()
	local pathsave = path..fileName..".png"
	if screen:saveToFile(fileName..".png", 1) == true then
		return pathsave
	end
end

--移动位置,到其他节点上
function util.moveToNode(node,target)
	if tolua.isnull(node) or tolua.isnull(target) then
		return
	end

	local pos = cc.p(target:getPosition())
	pos = target:getParent():convertToWorldSpace(pos)
	pos = node:getParent():convertToNodeSpace(pos)
	node:setPosition(pos.x,pos.y)

	return pos
end
function util.moveToNodeCenter(node,target)
	if tolua.isnull(node) or tolua.isnull(target) then
		return
	end

	local pos = cc.p(target:getPosition())
	local pos = cc.p(target:getPosition())
	local size = target:getContentSize()
	local newAnchor = cc.p(0.5,0.5)
	local oldAnchor = target:getAnchorPoint()

	pos.x = pos.x + (newAnchor.x-oldAnchor.x)*size.width
	pos.y = pos.y + (newAnchor.y-oldAnchor.y)*size.height
	pos = target:getParent():convertToWorldSpace(pos)
	pos = node:getParent():convertToNodeSpace(pos)
	node:setPosition(pos.x,pos.y)

	return pos
end
--页面显示动态表现,参数:上面横条,下面主体页,回退按钮
function util.fadeInPage(TopNode,BottomNode,backBtn)
	assert(not (tolua.isnull(TopNode) or tolua.isnull(BottomNode) or tolua.isnull(backBtn)),"util.fadeInPage node is nil")
	local topChild = {}
	local time = 0.13

	--top
	util.addSchedulerFuns(TopNode,function()
		local hideTop = cc.FadeOut:create(0)
		local showTop = cc.CallFunc:create(function()
			TopNode:setVisible(true) 
		end)
		local moveUpTop = cc.MoveBy:create(0,cc.p(0,100))
		local moveDownTop = cc.MoveBy:create(time,cc.p(0,-100))
		local fadeIn = cc.FadeIn:create(time/3)
		local showTop2 = cc.Spawn:create(fadeIn,moveDownTop)
		local actionTop = cc.Sequence:create(hideTop,showTop,moveUpTop,showTop2)
		TopNode:runAction(actionTop)
	 end)
	--bottom
	util.addSchedulerFuns(BottomNode,function()
		local hideBottom = cc.FadeOut:create(0)
		local showBottom = cc.CallFunc:create(function() BottomNode:setVisible(true) end)
		local moveDownBottom = cc.MoveBy:create(0,cc.p(0,-600))
		local moveUpBottom = cc.MoveBy:create(time,cc.p(0,600))
		local fadeInBottom = cc.FadeIn:create(time/3)
		local showBottom2 = cc.Spawn:create(fadeInBottom,moveUpBottom)
		local actionBottom = cc.Sequence:create(hideBottom,showBottom,moveDownBottom,showBottom2)
		BottomNode:runAction(actionBottom)
	end)

	--child
	for _,child in pairs(TopNode:getChildren()) do
		if child:isVisible() and child~=backBtn then
			child:setVisible(false)
			table.insert(topChild,child)
		end
	end
	for _,child in pairs(BottomNode:getChildren()) do
		if child:isVisible() and child:getName()~="img_yellowBg" then
			child:setVisible(false)
			table.insert(topChild,child)
		end
	end

	for _,child in pairs(topChild) do
		--util.addSchedulerFuns(child,function()
			local delay = cc.DelayTime:create(time+0.01)
			local show = cc.CallFunc:create(function()
				child:setVisible(true) 
			end)
			child:runAction(cc.Sequence:create(delay,show))
		--end)
	end

	--btnback
	backBtn:setVisible(false)
	util.addSchedulerFuns(backBtn,function()
		local oldScale = backBtn:getScale()        
		local show = cc.CallFunc:create(function()
			backBtn:setScale(0.1)
			backBtn:setVisible(true) 
		end)
		local delay = cc.DelayTime:create(time)
		local scale = cc.ScaleTo:create(0.1,oldScale*1.2)
		local scale2 = cc.ScaleTo:create(0.1,oldScale)
		backBtn:runAction(cc.Sequence:create(delay,show,scale,scale2))
	end)
end
function util.showWith(node1,node2,del)
	if tolua.isnull(node1) or  tolua.isnull(node2) then
		return
	end

	node1._showWithNodes = node1._showWithNodes or {}
	if del then
		node1._showWithNodes[node2] = nil
		return
	end
	if node1._showWithNodes[node2] then
		return
	end
	node1._showWithNodes[node2] = true
	node1._oldsetVisible = node1._oldsetVisible or node1.setVisible
	node1.setVisible = function(this,...)
		node1._oldsetVisible(this,...)
		for tarNode in pairs(node1._showWithNodes) do
			if not tolua.isnull(tarNode) then
				tarNode:setVisible(...)
			else
				node1._showWithNodes[tarNode] = nil
			end
		end
	end
end


--创建列表控件
function util.tableView(parent,createItemFunc,itemSize,data,rowNum,colNum)
	local data = data
	local tableView = cc.TableView:create(cc.size(parent:getContentSize().width,parent:getContentSize().height))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)    
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setDelegate()
	parent:addChild(tableView)

	local parentW = parent:getContentSize().width
	local parentH = parent:getContentSize().height
	local scale = math.min(parentW/colNum/itemSize.width,parentH/rowNum/itemSize.height)
	local offsetX = (parentW - colNum*itemSize.width * scale)/(colNum+1)

	local function numberOfCellsInTableView(view)
		return math.ceil(table.nums(data)/colNum)
	end

	local function scrollViewDidScroll(view)
	end

	local function scrollViewDidZoom(view)
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(table,idx)
		if sdkManager:isNewCocosVersion() then
	        return parentW,parentH/rowNum
	    else
	        return parentH/rowNum,parentW
	    end
		-- return parentH/rowNum,parentW
	end
	function tableView:setData(newData)
		data = newData
	end
	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		if nil == cell then
			cell = cc.TableViewCell:new()
		end
		local itemStartFrom0 = data[0]
		for i=1,colNum do
			local item = cell:getChildByTag(i)
			local index = i + idx * colNum
			if itemStartFrom0 then
				index = index -1
			end
			local info = data[index]
			if info then
				xpcall(function()
					if tolua.isnull(item) then
						--util.addSchedulerFuns(cell,function()
							item = createItemFunc(info)
							if not tolua.isnull(item) then
								item:setScale(scale)
								cell:addChild(item)
								item:setPositionX(offsetX*i + (i-0.5)*itemSize.width*scale)
								item:setTag(i)
							end
						--end)
					else
						item = createItemFunc(info,item)
					end
				end,function() trace("tableView error") end)
			elseif not tolua.isnull(item) then
				item:removeFromParent()
			end
		end

		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --function() return table.nums(items) end
	tableView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
	tableView:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
	tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

	return tableView
end

function util.waitforNode(node,children,func)
	if tolua.isnull(node) then
		return
	end
	for index = table.nums(children),1,-1 do
		local child = children[index]
		if node[child] then
			table.remove(children,index)
		end
	end

	if table.nums(children) == 0 then
		func()
	else
		node._waitfors = node._waitfors or {}
		table.insert(node._waitfors,{children = children,func = func})
		if not node._metatable then
			node._metatable = true
			setmetatablenewindex(node,function(_,name,v)   
				rawset(_,name,v)
				local removeIndexs = {}
				for i,info in pairs(node._waitfors) do
					local childs = info.children
					local fun = info.func
					for index = table.nums(childs),1,-1 do
						if  childs[index] == name then
							table.remove(childs,index)
							if table.nums(childs) == 0 then
								fun()
								table.insert(removeIndexs,i)
							end
							break
						end
					end
				end
				for i = table.nums(removeIndexs),1,-1 do
					table.remove(node._waitfors,removeIndexs[i])
				end
			end)
		end
	end
end
function util.hookSetFont()
	--[[if __Platform__ ~= 3 then
		return
	end

	local text = ccui.Text
	local oldsetFontName = ccui.Text.setFontName

	ccui.Text.setFontName = function(node,name,...)
		if name == "img2/font/MSYH.TTF" then
			local color = node:getTextColor()
			node:enableShadow(color, cc.size(1, -1), 0)
		end
		oldsetFontName(node,name,...)
	end]]
end

function util.traceTime(msg,isOnly)
	local time = util.time()
	if not msg then
		util._tracetime = time
		return
	end
	util._tracetime = util._tracetime or time
	if isOnly then
		trace(msg,time - util._tracetime)
	else
		trace(msg,time - util._tracetime)
	end
	util._tracetime = time
end
function util.perLoadImg(loadPath)
	if not util._resPaths then
		local i = 0
		local imgListPath = "res/resList.xml"
		util._resPaths = cc.FileUtils:getInstance():getValueMapFromFile(imgListPath)
	end

	local director = cc.Director:getInstance()
	local textureCache = director:getTextureCache()
	local maxImg = table.nums(util._resPaths)
	local index = 0

	for path,j in pairs(util._resPaths) do
		if string.find(path,loadPath) and (string.find(path,".png") or string.find(path,".jpg")) then
			textureCache:addImageAsync(path,function ()
				--trace("load",path)
				util._resPaths[path] = nil
			end)
		end
	end
end

--返回登录
function util.backToLogin(autoLogin)
	PlayerData:initData()
	sdkManager:reloadData()
	if not autoLogin then
		PlayerData:setAutoLogin(false)
	end
	--GameEvent:removeAllEventListeners()
	RoomSocket:disconnect()
	GameSocket:disconnect()
	util.clearAllTimeout()

	local runingscene = cc.Director:getInstance():getRunningScene()
	if runingscene then
		runingscene:removeAllChildren()
	end
	collectgarbage("collect")
	local scene = cc.Scene:create()
	if runingscene then
		cc.Director:getInstance():replaceScene(scene)
	else
		cc.Director:getInstance():runWithScene(scene)
	end
	local loginWin = require("modules.login.Login"):create(true)
	BASE_NODE = cc.Node:create()
	scene:addChild(BASE_NODE)
	BASE_NODE:addChild(loginWin)
end
--软键盘是否开启
function util.isKeyBoardActive()
	if  __Platform__ == 3 then    --安卓平台
		local args = {}
		local sigs = "()Z"
		local funName = "isKeyBoardActive"

		local luaj = require "cocos.cocos2d.luaj"
		--local className = "org/cocos2dx/lib/Cocos2dxGLSurfaceView"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			trace("isKeyBoardActive = ",ret)
			return ret
		end
	end
end
--获取手机IEMI
function util.getIMEI()
	if  __Platform__ == 3 then
		local args = {}
		local sigs = "()Ljava/lang/String;"
		local funName = "getIMEI"

		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			return ret
		end
	end
end
--获取SIM卡ID
function util.getSIMID()
	if  __Platform__ == 3 then
		local args = {}
		local sigs = "()Ljava/lang/String;"
		local funName = "getSIMID"

		local luaj = require "cocos.cocos2d.luaj"
		local className = util.getAndroidPackPath().."AppActivity"
		local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

		if state then
			return ret
		end
	end
end
function util.utf8_substr(str,start,leng)
	if leng == 0 then
		return
	end
	local c
	--local strLen = string.len(str)-1
	local actualLength = 0
	local startOffset,lenOffset
	--trace(str)
	local index = 1
	while index <= leng do
		c = string.byte(string.sub(str,index,index+1))
		if c <= 127 then
			index = index + 1
			actualLength = actualLength + 1
		elseif c > 127 then
			index = index + 3
			actualLength = actualLength + 3
		end
		if actualLength > leng  then
			actualLength = actualLength - 3
		end
	end
	return string.sub(str,start,actualLength)
end
--把utf8最后截断的字去掉,避免在文本是显示不了
function util.utf8string(str)
	if not type(str) == "string" then
		return ""
	end
	local newStr = util.utf8_substr(str,1,string.len(str))
	return newStr
end
function util.sortBtns(...)
	local btns = {...}
	local showBtns = {}
	local showNum = 0
	for _,btn in ipairs(btns) do
		if not tolua.isnull(btn) and btn:isVisible() then
			showNum = showNum + 1
			table.insert(showBtns,btn)
		end
	end
	if showNum == 0 then
		return
	end
	local oldScale = showBtns[1]:getScale()
	local centerPos = showBtns[1]:getParent():getContentSize().width/2
	local btnW = showBtns[1]:getContentSize().width*showBtns[1]:getScale()
	local parentW = showBtns[1]:getParent():getContentSize().width*showBtns[1]:getParent():getScaleX()
	--中间按钮的间隔
	local spaceW = 20
	--按钮边上间隔
	local offSetW = 2*spaceW

	if showNum == 1 then
		showBtns[1]:setPositionX(centerPos)
	else
		local posStart = centerPos - btnW/2 - spaceW/2 - (showNum/2-1)*(btnW+spaceW)
		local index = 0
		for _,btn in pairs(showBtns) do
			btn:setPositionX(posStart + index*(btnW +spaceW))
			index = index + 1
		end
	end

	--缩放
	local totalW = offSetW*2+(btnW+spaceW)*showNum-spaceW
	if  totalW > parentW then
		oldScale = oldScale * parentW/totalW
	else
		spaceW = (parentW - btnW*showNum)/(showNum+3)
		offSetW = 2*spaceW
	end
	--排位置
	for index,btn in ipairs(showBtns) do
		btn:setScale(oldScale)
		btn:setPositionX(offSetW - spaceW + index*(spaceW+btnW) - btnW/2)
	end
end
function util.getRandByNum(before,after)
	--randomseed只要执行一次就行了
    local num = math.random(before,after)
    return num
end

--文字转换  
function  util.numberToString(szNum)  
    local szChMoney = ""
    local iLen = 0  
    local iNum = 0  
    local iAddZero = 0  
    --local hzUnit = {"", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟", "万", "拾", "佰", "仟"}  
    --local hzNum = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"}  
    local hzUnit = {"", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千", "万", "十", "百", "千"}  
    local hzNum = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"}  
  
	if nil == tonumber(szNum) then  
		return '错误的数字'  
	end  
		
	iLen =string.len(szNum)   
	
	if iLen > 15 or iLen == 0 or tonumber(szNum) < 0 then  
		return "错误的数字"   
		end  
	local i = 0  
	for i = 1, iLen  do   
		iNum = string.sub(szNum,i,i)  
		if iNum == 0 then  
		iAddZero = iAddZero + 1  
		else  
		if iAddZero > 0 then  
			szChMoney = szChMoney..hzNum[1]    
		end  
	
		szChMoney = szChMoney..hzNum[iNum + 1] --//转换为相应的数字  
		iAddZero = 0  
	
		end  
	
		if iNum ~=0 or iLen-i==3 or iLen-i==11 or ((iLen-i+1)%8==0 and iAddZero<4) then  
		szChMoney = szChMoney..hzUnit[iLen-i+1]  
		end  
	
	end  
	
	return szChMoney
end  


-- 根据屏幕宽度适应
function util.fixWidth(node)

end
-- 拉伸到满全屏
function util.fixWidth(node)

end