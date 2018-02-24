-- 弹出框基类
BaseDialog = class(..., function()
	return cc.Layer:create()
end)

function BaseDialog:ctor(data)
	self.m_obj = data.obj
	self._uiInfo = data.obj
	self:openMask()
	--按钮响应CD屏蔽节点
	self.canInCding = false
	self.canInCdNode = cc.Node:create()
	self:addChild(self.canInCdNode)
end

--启动响应CD屏蔽
function BaseDialog:runResponseCd(cdTime)
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

--开启蒙版
function BaseDialog:openMask()
	--蒙版
	self.mask = ccui.Layout:create()
	self:addChild(self.mask,-1)
	self.mask:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	self.mask:setBackGroundColor(cc.c3b(0,0,0))
	self.mask:setContentSize(cc.Director:getInstance():getWinSize())
	self.mask:setBackGroundColorOpacity(100)
	self.mask:setTouchEnabled(true)
	self.mask:setAnchorPoint(cc.p(0.5, 0.5))
	self.mask:setPosition(WIN_center)
	self.mask:setOpacity(0)
	local fade = cc.FadeTo:create(0.3,255)
	self.mask:runAction(fade)

	--点击响应层
	self.maskLayout = ccui.Layout:create()
	self:addChild(self.maskLayout,-1)
	self.maskLayout:setContentSize(cc.Director:getInstance():getWinSize())
	self.maskLayout:setTouchEnabled(true)
	self.maskLayout:setSwallowTouches(true)
	self.maskLayout:addTouchEventListener(function(pSender, type)
		if type == ccui.TouchEventType.ended then
			_uim:closeLayer(self.m_obj)
		end
	end)
end

--关闭自己
function BaseDialog:closeSelf()
	if not self.curClose then
		self.curClose = true
	else
		return
	end
	self.csNode:setVisible(false)
	self.maskLayout:setSwallowTouches(false)
	local fade = cc.FadeTo:create(0.3,0)
	self.mask:runAction(fade)
end

--注册触摸事件
function BaseDialog:initDebugEvent()
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

function BaseDialog:onDebugBegan(touch,event)
	local touchPoint = touch:getLocation()
	trace("--------onTouchBegan--------point =  cc.p(%d,%d)",toint(touchPoint.x),toint(touchPoint.y))
	return true
end

function BaseDialog:onDebugMove(touch,event)
	local touchPoint = touch:getLocation()
	if self.testNode then
		local point = self.testNode:getParent():convertToNodeSpace(touchPoint)
		self.testNode:setPosition(point)
	end
	trace("--------onTouchMove--------point =  cc.p(%d,%d)",toint(touchPoint.x),toint(touchPoint.y))
end

function BaseDialog:onDebugEnded(touch,event)
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

return BaseDialog

