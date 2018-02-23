-- 页面基类
BaseLayer = class(..., function ()
	return cc.Layer:create()
end)

function BaseLayer:ctor(data)
	if data then
		self.m_sObj = data.obj
		-- self.m_sData = data.data
		-- self.m_sLogic = data.logic
	end
	-- 点击相应层
	self.layout = ccui.Layout:create()
	self:addChild(self.layout,-1)
	-- 1280 720
	self:setContentSize(CC_DESIGN_RESOLUTION)
	local size  = self:getContentSize()
	self.layout:setContentSize(cc.Director:getInstance():getWinSize())

	self.layout:setTouchEnabled(true)
	self.layout:setSwallowTouches(true)

	--按钮响应CD屏蔽节点
	self.canInCding = false
	self.canInCdNode = cc.Node:create()
	self:addChild(self.canInCdNode)
end

--启动响应CD屏蔽
function BaseLayer:runResponseCd(cdTime)
	local cdTime = cdTime or 0.3
	self.canInCding = true
	local delay = cc.DelayTime:create(cdTime)
	local function cFun()
		self.canInCding = false
	end
	local callFun = cc.CallFunc:create(cFun)
	local sequence = cc.Sequence:create(delay,callFun)
	self.canInCdNode:runAction(sequence)
end

--注册触摸事件
function BaseLayer:initDebugEvent()
	local function onTouchBegan( touch, event )
		return self:onDebugBegan(touch,event)
	end
	local function onTouchMove( touch, event )
		self:onDebugMove(touch,event)
	end
	local function onTouchEnded( touch, event )
		self:onDebugEnded(touch,event)
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(false)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMove, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function BaseLayer:onDebugBegan(touch,event)
	local touchPoint = touch:getLocation()
	trace("--------onTouchBegan--------point =  cc.p(%d,%d)",toint(touchPoint.x),toint(touchPoint.y))
	return true
end

function BaseLayer:onDebugMove(touch,event)
	local touchPoint = touch:getLocation()
	if self.testNode then
		local point = self.testNode:getParent():convertToNodeSpace(touchPoint)
		self.testNode:setPosition(point)
	end
	trace("--------onTouchMove--------point =  cc.p(%d,%d)",toint(touchPoint.x),toint(touchPoint.y))
end

function BaseLayer:onDebugEnded(touch,event)
	local touchPoint = touch:getLocation()
	trace("----触点----onTouchEnded--------point =  cc.p(%d,%d)",toint(touchPoint.x),toint(touchPoint.y))
	local point = NUtils.getBenchmarkPoint("center",touchPoint)
	trace("----中间----center--------point =  cc.p(%d,%d)",toint(point.x),toint(point.y))
	local point = NUtils.getBenchmarkPoint("left_down",touchPoint)
	trace("----左下----left_down--------point =  cc.p(%d,%d)",toint(point.x),toint(point.y))
	local point = NUtils.getBenchmarkPoint("left_up",touchPoint)
	trace("----左上----left_up--------point =  cc.p(%d,%d)",toint(point.x),toint(point.y))
	local point = NUtils.getBenchmarkPoint("right_down",touchPoint)
	trace("----右下----right_down--------point =  cc.p(%d,%d)",toint(point.x),toint(point.y))
	local point = NUtils.getBenchmarkPoint("right_up",touchPoint)
	trace("----右上----right_up--------point =  cc.p(%d,%d)",toint(point.x),toint(point.y))
	if self.testNode then
		local point = self.testNode:getParent():convertToNodeSpace(touchPoint)
		trace("----相对父节点----parent local point--------point =  cc.p(%d,%d)",toint(point.x),toint(point.y))
	end
end


return BaseLayer