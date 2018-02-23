-- 动画管理器
-- Author: gaomeng.ning
-- Date: 2016-03-12 13:10:47

AnimationUtil = {}

_au = AnimationUtil
--[[
	--创建帧动画1 图片序列创建
	local sprite = ui.createSprite({pic = "luaassets/res/animation/sprite1.png"})
	sprite:setPosition(cc.p(320,480))
	local animation = cc.Animation:create()
	for i=1,10 do
		animation:addSpriteFrameWithFile("luaassets/res/animation/sprite"..i..".png")
	end
	animation:setDelayPerUnit(0.08)
	sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
	pParent:addChild(sprite,5)

	--创建帧动画2  plist 图集创建
	--加载纹理
	cc.SpriteFrameCache:getInstance():addSpriteFrames("animation/Sprites.plist")
	--or
	cc.SpriteFrameCache:getInstance():addSpriteFrames("animation/Sprites.plist", "animation/Sprites.png")
	local ActionNode = cc.Sprite:createWithSpriteFrameName("Sprites_1.png")
	local animation = cc.Animation:create()
	for i=1,10 do
		local sf = cc.SpriteFrameCache:getInstance():getSpriteFrame("Sprites_" .. i ..".png")
		animation:addSpriteFrame(sf)
	end
	animation:setDelayPerUnit(0.05)
	ActionNode:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))

	--帧动画缓存 
	--将其加载到缓存中
	AnimationCache:getInstance():addAnimation(dance_animate,"dance")--第二个参数是动画存入缓存时对应的key
	AnimationCache:getInstance():addAnimation(sleep_animate,"sleep")
	--读取缓存中的动画
	local  dance_animate = AnimationCache:getInstance():animationByName("dance")--根据key从缓存中提取动画
	local  sleep_animate = AnimationCache:getInstance():animationByName("sleep")

]]

--特效管理初始化
function AnimationUtil:fun_init()
	--特效资源是否已加载
	self.isLoad = false
	--点击屏蔽层
	self.maskLayer = nil
	--半透明特效蒙版
	self.bgColorLayer = nil
	--调度器管理
	self.schList = {}

	--特效精灵缓存
	self.effSpList = {}

end


--加载图片资源（纹理）
function AnimationUtil:loadPicResource(imgArr, completeFunc)
	local num = #imgArr
	for i, imgStr in ipairs(imgArr) do
		cc.Director:getInstance():getTextureCache():addImageAsync(imgStr, function()
			if i == num then
				completeFunc()
			end
		end)
	end
end

--缓存帧动画  pName传入标识字符串
function AnimationUtil:addAnimation(pAnimation,pName)
	AnimationCache:getInstance():addAnimation(pAnimation,pName)
end

--获取已缓存的帧动画
function AnimationUtil:getAnimationByName(pName)
	return AnimationCache:getInstance():animationByName(pName)
end

--清除已缓存的帧动画
function AnimationUtil:removeAnimation(name)
	AnimationCache:getInstance():removeAnimation(name)
end

--预加载图集图片资源
function AnimationUtil:addSpriteFrames(plistFilename, image, handler)
	local asyncHandler = function()
		cc.SpriteFrameCache:getInstance():addSpriteFrames(plistFilename, image)
		handler(plistFilename, image)
	end
	cc.Director:getInstance():getTextureCache():addImageAsync(image, asyncHandler)
end

--创建 .csd 模块
function AnimationUtil:creatCsd(pData)
	--资源路径
	local path = pData.path
	--是否重复播放
	local isRepeat = pData.isRepeat or false
	--是否截取帧
	local useFrame = pData.useFrame or false
	--起始帧
	local frameBegin = pData.frameBegin or 0
	--结束帧
	local frameEnd = pData.frameEnd

	--添加动画
	--action:addAnimationInfo(ccs.AnimationInfo("walk", 0 , 40))
	--action:play("walk", true)
	--local child = node:getChildByTag(5)

	local node = cc.CSLoader:getInstance():createNodeWithFlatBuffersForSimulator(path)
	local action = ccs.ActionTimelineCache:getInstance():createActionWithFlatBuffersForSimulator(path)
	node:runAction(action)
	if useFrame == true then
		action:gotoFrameAndPlay(frameBegin,frameEnd,isRepeat)--从第0帧到60帧循环播放。还有其他重载函数，具体看源码。 
	else
		action:gotoFrameAndPlay(frameBegin,isRepeat)
	end
	local function onFrameEvent(frame)
		if nil == frame then
			return
		end
		local str = frame:getEvent()
		if str == "changeColor" then
			 frame:getNode():setColor(cc.c3b(0, 0, 0))
		elseif(str == "endChangeColor") then
		end
	end
	action:setFrameEventCallFunc(onFrameEvent)
	return node
end

--执行csd动画
function AnimationUtil:runCsdAction(pPath,pSprite,frameBegin,frameEnd,isRepeat)
	local action = ccs.ActionTimelineCache:getInstance():createActionWithFlatBuffersForSimulator(pPath)
	-- pSprite:runAction(action)
	action:gotoFrameAndPlay(frameBegin,frameEnd,isRepeat)
end

--创建 粒子 模块
function AnimationUtil:creatPar(pParName,pPlistName)
	local starNode = cc.ParticleBatchNode:create("img2/effect/particle/"..pParName)
	local particle = cc.ParticleSystemQuad:create("img2/effect/particle/"..pPlistName)
	starNode:addChild(particle)
	particle:setPosition(cc.p(0,0))
	return starNode
end

--序列帧动画
function AnimationUtil:creatPlistEffByRes(pData)
	local fileName = pData.fileName
	local path = pData.path
	local startNum = pData.startNum
	local endNum = pData.endNum
	local perTime = pData.perTime or 0.05
	local isRepeat = pData.isRepeat or false
	local fadetime = pData.fadetime or 0.3
	local callbackFun = pData.callbackFun or function () end
	cc.SpriteFrameCache:getInstance():addSpriteFrames(path..fileName..".plist", path..fileName..".png")
	local actionNode = cc.Sprite:createWithSpriteFrameName(fileName.."_"..startNum..".png")
	local animation = cc.Animation:create()
	for i=startNum,endNum do
		local sf = cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName.."_"..i..".png")
		animation:addSpriteFrame(sf)
	end
	animation:setDelayPerUnit(perTime)
	if isRepeat == true then
		actionNode:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
	else
		local animate = cc.Animate:create(animation)
		local function cFun()
			callbackFun()
		end
		local callFunAction = cc.CallFunc:create(cFun)
		local sequenceAction = cc.Sequence:create(animate,callFunAction,cc.FadeOut:create(fadetime))
		actionNode:runAction(sequenceAction)
	end
	return actionNode
end

--序列帧动画
function AnimationUtil:creatPlistEff(pData)
	local fileName = pData.fileName
	local startNum = pData.startNum
	local endNum = pData.endNum
	local perDelay = pData.perDelay or 0
	local perTime = pData.perTime or 0.05
	local isRepeat = pData.isRepeat or false
	local fadetime = pData.fadetime or 0.3
	local callbackFun = pData.callbackFun or function () end
	local actionNode = cc.Sprite:createWithSpriteFrameName(fileName.."_"..startNum..".png")
	local animation = cc.Animation:create()
	for i=startNum,endNum do
		local sf = cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName.."_"..i..".png")
		animation:addSpriteFrame(sf)
	end
	animation:setDelayPerUnit(perTime)
	if isRepeat == true then
		if perDelay ~= 0 then
			local animate = cc.Animate:create(animation)
			local delay = cc.DelayTime:create(perDelay)
			local sequence = cc.Sequence:create(animate,delay)
			actionNode:runAction(cc.RepeatForever:create(sequence))
		else
			local animate = cc.Animate:create(animation)
			actionNode:runAction(cc.RepeatForever:create(animate))
		end
	else
		local animate = cc.Animate:create(animation)
		local function cFun()
			callbackFun()
		end
		local callFunAction = cc.CallFunc:create(cFun)
		local sequenceAction = cc.Sequence:create(animate,callFunAction,cc.FadeOut:create(fadetime))
		actionNode:runAction(sequenceAction)
	end
	return actionNode
end

--点击屏蔽层
function AnimationUtil:showMaskLayer(bool,pShowColor,pMaskDelay,pClickFun)
	local clickFun = pClickFun or function() cclog(self,"特效层屏蔽点击") end
	local function onBtnClick(pSender, type)
		if type == ccui.TouchEventType.ended then
			clickFun()
		end
	end
	if bool == true then
		if self.maskLayer then
			self.maskLayer:removeFromParent()
			self.maskLayer = nil
			self.bgColorLayer = nil
		end
		self.maskLayer = cc.Node:create()
		local spaceButton = ui.createSpaceButton({size=cc.size(1440,2560),pos=cc.p(0,0),anchor=cc.p(0.5,0.5)},onBtnClick)
		-- spaceButton:setSwallowTouches(true)
		self.maskLayer:addChild(spaceButton)
		local showColor = pShowColor or false
		if showColor == true then
			self.bgColorLayer = cc.LayerColor:create(cc.c3b(0,0,0))
			self.bgColorLayer:setOpacity(0)
			local fadeAction = cc.FadeTo:create(0.15,120)
			self.bgColorLayer:runAction(fadeAction)
			self.maskLayer:addChild(self.bgColorLayer)
		end
		self:getEffParent():addChild(self.maskLayer,-1)
		return self.maskLayer
	else
		if self.maskLayer then
			if self.bgColorLayer then
				local maskDelay = pMaskDelay or 0.2
				local fadeAction = cc.FadeOut:create(0.15)
				local function cFun()
					self.maskLayer:removeFromParent()
					self.maskLayer = nil
					self.bgColorLayer = nil
				end
				local callFunAction = cc.CallFunc:create(cFun)
				local delayAction = cc.DelayTime:create(maskDelay)
				local sequenceAction = cc.Sequence:create(fadeAction,delayAction,callFunAction)
				self.bgColorLayer:runAction(sequenceAction)
			else
				self.maskLayer:removeFromParent()
				self.maskLayer = nil
			end
		end
	end
end

--获取最高特效层
function AnimationUtil:getEffParent()
	if _ctm:fun_Get(Container.EFFECT) then
		return _ctm:fun_Get(Container.EFFECT).effLayer
	else
		cclog(self,"------------获取特效父节点失败------ %s -------",_ctm:fun_Get(Container.EFFECT))
		return nil
	end
end

--创建特效
function AnimationUtil:playEff(pEffId,pData,callback)
	local returnEff = nil
	if pEffId == "slotUp" then
		returnEff = self:creatEffSlotUp(callback)
	end
	return returnEff
end

function AnimationUtil:btnJumpAct()
	local jump = cc.JumpBy:create(0.3,cc.p(0,0),50,1)
	local scale1 = cc.ScaleTo:create(0.15,1.1)
	local scale2 = cc.ScaleTo:create(0.15,1)
	local sequence2 = cc.Sequence:create(scale1,scale2)
	local spawn = cc.Spawn:create(jump,sequence2)
	return spawn
end

--椭圆运动动作
function AnimationUtil:ellipseAction(actionNode,actionSetIndex)
	--动画四分之一周期
	local time = nil
	--大小变化比例
	local scale = nil
	--x位移量
	local x = nil
	--y位移量
	local y = nil
	--x方向
	local x1 = nil
	local x2 = nil
	local x3 = nil
	local x4 = nil
	--y方向
	local y1 = nil
	local y2 = nil
	local y3 = nil
	local y4 = nil
	--阶段大小变化
	local s1 = nil
	local s2 = nil
	local s3 = nil
	local s4 = nil

	if actionSetIndex == 1 then
		time = 20
		scale = 0.16
		x = 20
		y = 50
		x1 = -1
		x2 = 1
		x3 = 1
		x4 = -1
		y1 = 1
		y2 = 1
		y3 = -1
		y4 = -1
	elseif actionSetIndex == 2 then
		time = 20
		scale = 0.05
		x = 10
		y = 20
		x1 = 1
		x2 = -1
		x3 = -1
		x4 = 1
		y1 = 1
		y2 = 1
		y3 = -1
		y4 = -1
	end

	s1 = 1 - y1*(scale/2)
	s2 = s1 - y2*(scale/2)
	s3 = s2 - y3*(scale/2)
	s4 = s3 - y4*(scale/2)

	local moveAction_1_1 = cc.MoveBy:create(time,cc.p(x*x1,0))
	local moveAction_1_2 = cc.MoveBy:create(time,cc.p(x*x2,0))
	local moveAction_1_3 = cc.MoveBy:create(time,cc.p(x*x3,0))
	local moveAction_1_4 = cc.MoveBy:create(time,cc.p(x*x4,0))
	local EaseSineAction_1_1 = cc.EaseSineOut:create(moveAction_1_1)
	local EaseSineAction_1_2 = cc.EaseSineIn:create(moveAction_1_2)
	local EaseSineAction_1_3 = cc.EaseSineOut:create(moveAction_1_3)
	local EaseSineAction_1_4 = cc.EaseSineIn:create(moveAction_1_4)
	local sequence1 = cc.Sequence:create(EaseSineAction_1_1,EaseSineAction_1_2,EaseSineAction_1_3,EaseSineAction_1_4)

	local moveAction_2_1 = cc.MoveBy:create(time,cc.p(0,y*y1))
	local moveAction_2_2 = cc.MoveBy:create(time,cc.p(0,y*y2))
	local moveAction_2_3 = cc.MoveBy:create(time,cc.p(0,y*y3))
	local moveAction_2_4 = cc.MoveBy:create(time,cc.p(0,y*y4))
	local EaseSineAction_2_1 = cc.EaseSineIn:create(moveAction_2_1)
	local EaseSineAction_2_2 = cc.EaseSineOut:create(moveAction_2_2)
	local EaseSineAction_2_3 = cc.EaseSineIn:create(moveAction_2_3)
	local EaseSineAction_2_4 = cc.EaseSineOut:create(moveAction_2_4)
	local sequence2 = cc.Sequence:create(EaseSineAction_2_1,EaseSineAction_2_2,EaseSineAction_2_3,EaseSineAction_2_4)

	local scaleAction_3_1 = cc.ScaleTo:create(time,s1)
	local scaleAction_3_2 = cc.ScaleTo:create(time,s2)
	local scaleAction_3_3 = cc.ScaleTo:create(time,s3)
	local scaleAction_3_4 = cc.ScaleTo:create(time,s4)
	local EaseSineAction_3_1 = cc.EaseSineIn:create(scaleAction_3_1)
	local EaseSineAction_3_2 = cc.EaseSineOut:create(scaleAction_3_2)
	local EaseSineAction_3_3 = cc.EaseSineIn:create(scaleAction_3_3)
	local EaseSineAction_3_4 = cc.EaseSineOut:create(scaleAction_3_4)
	local sequence3 = cc.Sequence:create(EaseSineAction_3_1,EaseSineAction_3_2,EaseSineAction_3_3,EaseSineAction_3_4)

	local spawn = cc.Spawn:create(sequence1,sequence2,sequence3)
	actionNode:runAction(cc.RepeatForever:create(spawn))
end

--初始化金币雨
local RainCoins = {}
function AnimationUtil:initCoinRain()
	self.isInCoinRain = false
	cc.SpriteFrameCache:getInstance():addSpriteFrames("img2/effect/jinbi/jinbi.plist", "img2/effect/jinbi/jinbi.png")
	for i=1,50 do
		local actionNode = cc.Sprite:createWithSpriteFrameName("jinbi_1.png")
		local animation = cc.Animation:create()
		for i=1,4 do
			local sf = cc.SpriteFrameCache:getInstance():getSpriteFrame("jinbi_"..i..".png")
			animation:addSpriteFrame(sf)
		end
		animation:setDelayPerUnit(0.05)
		local coinAction = cc.RepeatForever:create(cc.Animate:create(animation))
		actionNode:runAction(coinAction)
		local effLayer = util.getBaseLayer("effectLayer")
		effLayer:addChild(actionNode)
		actionNode:setPosition(cc.p(-1000,-1000))
		table.insert(RainCoins,actionNode)
	end
end

function AnimationUtil:clearCoinRain()
	RainCoins = {}
end

--播放金币雨
function AnimationUtil:playCoinRain()
	if #RainCoins == 0 then
		self:initCoinRain()
	end
	if self.isInCoinRain then
		return
	end
	self.isInCoinRain = true
	scheduleFunOne(function () self.isInCoinRain = false end, 1.5)
	for i=1,#RainCoins do
		local curIndex = i
		local coin = RainCoins[curIndex]
		if not tolua.isnull(coin) then
			local delay = cc.DelayTime:create(math.random(0,50)/100)
			local function cFun1()
				coin:setVisible(true)
			end
			local callFun1 = cc.CallFunc:create(cFun1)
			local staPoi = cc.p(math.random(0,WIN_Width),math.random(WIN_Height-100,WIN_Height+100))
			local endPoi = cc.p(staPoi.x,0)
			coin:setPosition(staPoi)
			local actTime = 0.5
			local move = cc.MoveTo:create(actTime,endPoi)
			local ease = cc.EaseIn:create(move,2)
			local jump = cc.JumpBy:create(0.5, cc.p(math.random(-50,50), -100), math.random(250,350), 1 )
			local function cFun2()
				coin:setVisible(false)
			end
			local callFun2 = cc.CallFunc:create(cFun2)
			local sequence = cc.Sequence:create(delay,callFun1,ease,jump,callFun2)
			coin:runAction(sequence)
		end
	end
end

--线路激活粒子光效
function AnimationUtil:roadLightPar(parent,poiList)
	local parNode = self:creatPar("particle_star.png","star.plist")
	local newPoiList = clone(poiList)
	table.insert(newPoiList, 1, cc.p(poiList[1].x - 80,poiList[1].y))
	table.insert(newPoiList, cc.p(poiList[5].x + 1000,poiList[5].y))
	parent:addChild(parNode,10)
	parNode:setPosition(newPoiList[1])
	local time1 = cc.pGetDistance(newPoiList[1], newPoiList[2])/1200
	local move1 = cc.MoveTo:create(time1,newPoiList[2])
	local time2 = cc.pGetDistance(newPoiList[2], newPoiList[3])/1200
	local move2 = cc.MoveTo:create(time2,newPoiList[3])
	local time3 = cc.pGetDistance(newPoiList[3], newPoiList[4])/1200
	local move3 = cc.MoveTo:create(time3,newPoiList[4])
	local time4 = cc.pGetDistance(newPoiList[4], newPoiList[5])/1200
	local move4 = cc.MoveTo:create(time4,newPoiList[5])
	local time5 = cc.pGetDistance(newPoiList[5], newPoiList[6])/1200
	local move5 = cc.MoveTo:create(time5,newPoiList[6])
	local time6 = cc.pGetDistance(newPoiList[6], newPoiList[7])/1200
	local move6 = cc.MoveTo:create(time6,newPoiList[7])
	local function cFun()
		parNode:removeFromParent()
	end
	local callFun = cc.CallFunc:create(cFun)
	local sequence = cc.Sequence:create(move1,move2,move3,move4,move5,move6,callFun)
	parNode:runAction(sequence)
end

--获取移动动作
function AnimationUtil:getMoveAct(action,actType,actTime,updateFun)
	if actType == 1 then -- 加速
		local move = cc.MoveBy:create(actTime,cc.p(0,-130))
		local easeSine = cc.EaseSineIn:create(move)
		return cc.Sequence:create(updateFun,easeSine)
	elseif actType == 2 then -- 匀速
		local move = cc.MoveBy:create(actTime,cc.p(0,-130))
		return cc.Sequence:create(action,move)
	elseif actType == 3 then -- 减速
		local move = cc.MoveBy:create(actTime,cc.p(0,-130))
		local easeElastic = cc.EaseElasticOut:create(move, 0.65)
		return cc.Sequence:create(action,easeElastic)
	elseif actType == 4 then -- 回顶
		local move = cc.MoveTo:create(actTime,cc.p(0,130*2))
		local fade1 = cc.FadeOut:create(0.02)
		local delay = cc.DelayTime:create(actTime-0.04)
		local fade2 = cc.FadeIn:create(0.02)
		local sequence = cc.Sequence:create(fade1,delay,fade2)
		local spawn = cc.Spawn:create(move,sequence)
		return cc.Sequence:create(action,updateFun,spawn)
	end
end

--播放获得奖池
function AnimationUtil:playGetJackpotEff(parent,callBackFun)
	_am:playEffect("audio/fruit/win3.mp3")
	local getJackpotNode = ui.loadCS("img2/fruits/effect/winEff_6")
	parent:addChild(getJackpotNode)
	getJackpotNode:setPosition(WIN_center)
	local effAction = ui.loadCSTimeline("img2/fruits/effect/winEff_6")
	getJackpotNode:runAction(effAction)
	effAction:gotoFrameAndPlay(0,120,false)

	local lbl_getGold = getJackpotNode:getChildByName("zhuanfan"):getChildByName("lbl")
	lbl_getGold:setString(_pdm.fruitsMainData.playingData.prizePoolReward)
	_uim:getLayer(ui.fruits_game).mainLayer:updateShow()
	scheduleFunOne(function ()
		if tolua.isnull(getJackpotNode) then
			return
		end
		getJackpotNode:removeFromParent()
		callBackFun()
	end, 2)
end

--播放免费摇奖获取金币总量
function AnimationUtil:playFreeWinGoldEff(parent,callBackFun)
	_am:playEffect("audio/fruit/win3.mp3")
	local freeGetEffNode = ui.loadCS("img2/fruits/effect/winEff_4")
	parent:addChild(freeGetEffNode)
	freeGetEffNode:setPosition(WIN_center)
	local effAction = ui.loadCSTimeline("img2/fruits/effect/winEff_4")
	freeGetEffNode:runAction(effAction)
	effAction:gotoFrameAndPlay(0,120,false)
	local lbl = freeGetEffNode:getChildByName("zhuanfan"):getChildByName("lbl")
	lbl:setString(_pdm.fruitsMainData.curFreeGetGold)
	_pdm.fruitsMainData.curFreeGetGold = 0
	scheduleFunOne(function ()
		if tolua.isnull(freeGetEffNode) then
			return
		end
		freeGetEffNode:removeFromParent()
		callBackFun()
	end, 2)
end

--播放获得免费摇奖特效
function AnimationUtil:playWinFreeEff(parent,freeNum,callBackFun)
	_am:playEffect("audio/fruit/win3.mp3")
	local freeEffNode = ui.loadCS("img2/fruits/effect/winEff_5")
	parent:addChild(freeEffNode)
	freeEffNode:setPosition(WIN_center)
	local effAction = ui.loadCSTimeline("img2/fruits/effect/winEff_5")
	freeEffNode:runAction(effAction)
	effAction:gotoFrameAndPlay(0,120,false)
	local free_num = freeEffNode:getChildByName("zhuanfan"):getChildByName("free_num")
	free_num:setTexture("img2/fruits/effect/free_"..freeNum..".png")
	scheduleFunOne(function ()
		if tolua.isnull(freeEffNode) then
			return
		end
		freeEffNode:removeFromParent()
		callBackFun()
	end, 2)
end


--播放得奖特效
function AnimationUtil:playWinGoldEff(parent,winTimes,winGold,callBackFun)
	local effIndex = 0
	if winTimes < _pdm.fruitsMainData.nowSelLineNum then
		effIndex = 1
		_am:playEffect("audio/fruit/win2.mp3")
	elseif winTimes >= _pdm.fruitsMainData.nowSelLineNum and winTimes < _pdm.fruitsMainData.nowSelLineNum*10 then
		effIndex = 2
		_am:playEffect("audio/fruit/win2.mp3")
	elseif winTimes >= _pdm.fruitsMainData.nowSelLineNum*10 then
		effIndex = 3
		_am:playEffect("audio/fruit/win3.mp3")
	end

	local winGoldNode = ui.loadCS("img2/fruits/effect/winEff_"..effIndex.."")
	parent:addChild(winGoldNode)
	winGoldNode:setPosition(WIN_center)
	local effAction = ui.loadCSTimeline("img2/fruits/effect/winEff_"..effIndex.."")
	winGoldNode:runAction(effAction)
	effAction:gotoFrameAndPlay(0,120,false)
	local lbl = winGoldNode:getChildByName("zhuanfan"):getChildByName("lbl")
	lbl:setString(winGold)
	scheduleFunOne(function ()
		if tolua.isnull(winGoldNode) then
			return
		end
		winGoldNode:removeFromParent()
		callBackFun()
	end, 2)
end

--播放其他玩家中奖
function AnimationUtil:otherPlayerWinEff(parent)
	local freeEffNode = ui.loadCS("img2/fruits/effect/kuang_3")
	parent:addChild(freeEffNode)
	freeEffNode:setPosition(cc.p(114,42))
	scheduleFunOne(function ()
		if tolua.isnull(freeEffNode) then
			return
		end
		freeEffNode:removeFromParent()
	end, 3)
end

--初始化红包雨
local RedRainCoins = {}
function AnimationUtil:initRedRain()
	self.isInRedRain = false
	local effLayer = util.getBaseLayer("effectLayer")
	for i=1,40 do
		local actionNode = cc.Sprite:create("img2/effect/hongbb.png")
		actionNode:setScale(0.9)
		effLayer:addChild(actionNode)
		actionNode:setPosition(cc.p(-1000,-1000))
		table.insert(RedRainCoins,actionNode)
	end
end

--播放红包雨
function AnimationUtil:playRedRain()
    if util.isExamine() then
        return
    end
	if #RedRainCoins == 0 then
		self:initRedRain()
	end
	if self.isInRedRain then
		return
	end
	self.isInRedRain = true
	scheduleFunOne(function () self.isInRedRain = false end, 3)
	for i=1,#RedRainCoins do
		local curIndex = i
		local coin = RedRainCoins[curIndex]
		if not tolua.isnull(coin) then
			local delay = cc.DelayTime:create(math.random(0,50)/100)
			local function cFun1()
				coin:setVisible(true)
			end
			local callFun1 = cc.CallFunc:create(cFun1)
			local staPoi = cc.p(math.random(0,WIN_Width),math.random(WIN_Height-300,WIN_Height+300))
			local endPoi = cc.p(staPoi.x,staPoi.y - 1500 + (math.random(0,500) - 50))
			coin:setPosition(staPoi)
			coin:setRotation(math.random(0,360))
			local orbit = cc.RepeatForever:create(cc.OrbitCamera:create(0.75, 0, 50, 0, 360, 0, 0))
			coin:runAction(orbit)
			local move = cc.MoveTo:create(math.random(15,25)/10,endPoi)
			local ease = cc.EaseIn:create(move,2)
			local function cFun2()
				coin:setVisible(false)
			end
			local callFun2 = cc.CallFunc:create(cFun2)
			local sequence = cc.Sequence:create(delay,callFun1,ease,callFun2)
			coin:runAction(sequence)
		end
	end
end

--dlg打开动画
function AnimationUtil:runDlgOpenAct(dlgNode)
	dlgNode:setScale(0.7)
	dlgNode:setOpacity(0)
	local fade = cc.FadeIn:create(0.2)
	local scale = cc.ScaleTo:create(0.5,1)
	local easeElastic = cc.EaseElasticOut:create(scale, 0.6)
	local spawn = cc.Spawn:create(fade,easeElastic)
	dlgNode:runAction(spawn)
end





