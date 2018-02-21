local Animation = class("Animation")

local gameId_cofig = require("Common.gameID")
local roomIcon = {}
roomIcon[gameId_cofig.HAPPY_POKER] = "img2/gaf/doudizhu/doudizhu.gaf"
roomIcon[gameId_cofig.CONTEST_POKER] = "img2/gaf/bisaichang/bisaichang.gaf"
roomIcon[gameId_cofig.CONTEST_POKERS] = "img2/gaf/bisaichang/bisaichang.gaf"
roomIcon[gameId_cofig.Friend_POKER] = "img2/gaf/huanleniuniu/huanleniuniu.gaf"
roomIcon[gameId_cofig.KANPAI] = "img2/gaf/niu/niu.gaf"
roomIcon[gameId_cofig.ACTIVITY] = "img2/gaf/huodongzhongxin/huodongzhongxin.gaf"
roomIcon[gameId_cofig.BAIREN] = "img2/gaf/bairen/100niuniu.gaf"
roomIcon[gameId_cofig.SHUIGUO] = "img2/gaf/fruitRoom/777.gaf"
roomIcon[gameId_cofig.PKSC] = "img2/gaf/saicherukou/saicherukou.gaf"

local viewsize

function Animation.create(...)
    local node = Animation.new(...)
    return node
end

function Animation:ctor(param)
	viewsize = cc.Director:getInstance():getWinSize()
	self._gafAssets = {}
end

local function getNumString(num,byte)
	return string.format("%0"..byte.."d",num)
end
------------------------------------------------
--[[
--火箭动画
function Animation:createKingBomb()
	--local kingBomb = self:createAnimation("rocket/rocket",1, 14,nil,false)
	local kingBomb = cc.Sprite:createWithSpriteFrameName("rocket/rocket04.png")
	local moves = cc.MoveBy:create(1,cc.p(0,viewsize.height))
	local remove = function() kingBomb:removeFromParent() end
	local  seq = cc.Sequence:create(moves,cc.CallFunc:create(remove))
	kingBomb:runAction(seq)
	kingBomb:setScale(2)
    return kingBomb
end]]--

function Animation:createKingBombs( ... )
	local anim ,suc= self:createGaf("img2/GameScene/huojian/huojian.gaf",replaceNode)
	if suc then
		util.playSound("Special_Long_Bomb",false)
		anim:setAniPosCenter()
		anim:setRemoveOnFinish()
	end
	return anim,suc
end

-- function Animation:createAirPlane( ... )
-- 	local anim ,suc= self:createGaf("img2/GameScene/feiji_0/feiji_0.gaf",replaceNode)
-- 	if suc then
-- 		util.playSound("Special_plane",false)
-- 		anim:setRemoveOnFinish()
-- 	end
-- 	return anim,suc
-- end
-- function Animation:createFlashLiandui( replaceNode )
-- 	local anim,suc = self:createGaf("img2/GameScene/liandui/liandui.gaf",replaceNode)
-- 	if suc then
-- 		util.playSound("shunzi",false)
-- 		anim:setRemoveOnFinish()
-- 		anim:setAniPosCenter()
-- 	end
-- 	return anim,suc
-- end
-- function Animation:createFlashShunZi( replaceNode )
-- 	local anim,suc = self:createGaf("img2/GameScene/shunzi/shunzi.gaf",replaceNode)
-- 	if suc then
-- 		util.playSound("shunzi",false)
-- 		anim:setRemoveOnFinish()
-- 		anim:setAniPosCenter()
-- 	end
-- 	return anim
-- end

--春天特效
function Animation:createChunTian( replaceNode )
	local anim,suc = self:createGaf("img2/GameScene/chun/chun.gaf",replaceNode)
	if suc then
		anim:setRemoveOnFinish()
		anim:setAniPosCenter()
	end
	return anim,suc
end

--反春特效
function Animation:createFanChun( replaceNode )
	local anim,suc = self:createGaf("img2/GameScene/fanchun/fanchun.gaf",replaceNode)
	if suc then
		anim:setRemoveOnFinish()
		anim:setAniPosCenter()
	end
	return anim,suc
end

--烟雾
function Animation:createLotterySmoke(  )
	local smoke = self:createAnimation("img2/grabredlords/lottery_smoke_",1, 6,0.5,false)
	smoke:setScale(0.7)
	return smoke
end

function Animation:createShanGuangAnim( ... )
	local shanguang = self:createAnimation("img2/GameScene/shanguang",1, 8,nil,true)
	return shanguang
end

--快速开始
function Animation:createKuaisu(replaceNode)
	local node,suc = self:createGaf("img2/gaf/kuaisukaishi/kuaidukaishi.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node,suc
end

--比赛
function Animation:createBisai(replaceNode)
	return self:createGaf("img2/gaf/bishai/bishai.gaf",replaceNode,true)
end
--报名进度
function Animation:createJinru( replaceNode,iMax)
	local img = "img2/matchgame/waitgamestart/" .. iMax .. "/" .. iMax .. ".gaf"
	return self:createGaf(img,replaceNode)
end
--冠军金币特效
function Animation:createGuanJun( replaceNode )
	local anim ,suc= self:createGaf("img2/matchgame/guangjunjinbi_1/guangjunjinbi_1.gaf",replaceNode)
	return anim,suc
end
--冠军钻石特效
function Animation:createGuanJunZs( replaceNode )
	local anim ,suc= self:createGaf("img2/matchgame/guangjunzhuangshi_1/guangjunzhuangshi_1.gaf",replaceNode)
	return anim,suc
end
--冠军奖券特效
function Animation:createGuanJunJQ( replaceNode )
	local anim ,suc= self:createGaf("img2/matchgame/guangjunjianquan_1/guangjunjianquan_1.gaf",replaceNode)
	return anim,suc
end
--结算赢动画
function Animation:createGameWin( replaceNode )
	local anim ,suc= self:createGaf("img2/GameScene/EndLayer/win/win.gaf",replaceNode)
	if suc then
		anim:setAniPosCenter()
	end
	return anim,suc
end
--结算输动画
function Animation:createGameLose( replaceNode )
	local anim ,suc= self:createGaf("img2/GameScene/EndLayer/lose/lose.gaf",replaceNode)
	if suc then
		anim:setAniPosCenter()
	end
	return anim,suc
end
--继续按钮动画
function Animation:createGameJixu( replaceNode )
	local anim ,suc= self:createGaf("img2/GameScene/EndLayer/jixu/jixuwuzi.gaf",replaceNode)
	--anim:setScale(0.89)
	return anim,suc
end
--[[
--比赛选择金币
function Animation:CreateSelectCoin( replaceNode )
	local anim ,suc= self:createGaf("img2/matchgame/matchtypeselect/jinbi/jinbi.gaf",replaceNode)
	return anim,suc
end
--比赛选择钻石
function Animation:CreateSelectZuanShi( replaceNode )
	local anim ,suc= self:createGaf("img2/matchgame/matchtypeselect/zhuangshi/zhuangshi.gaf",replaceNode)
	return anim,suc
end
--创建黄色星星
function Animation:CreateYellowstar( replaceNode )
	local anim ,suc= self:createGaf("img2/matchgame/matchtypeselect/yellowstar/yellowstar.gaf",replaceNode)
	return anim,suc
end
--创建蓝色星星
function Animation:CreateBluestar( replaceNode )
	local anim = self:createGaf("img2/matchgame/matchtypeselect/bluestar/bluestar.gaf",replaceNode)
	return anim
end
--创建竞赛进行中
function Animation:CreateFixGameIng( replaceNode )
	local anim = self:createGaf("img2/matchgame/matchtypeselect/ing/ing.gaf",replaceNode)
	return anim
end
]]--
--定时赛正常状态
function Animation:CreateMatchNormal( replaceNode )
	trace("CreateMatchNormal")
	local anim,suc = self:createGaf("img2/matchgame/matchtypeselect/jinsai/jinsai.gaf",replaceNode,true)
	return anim,suc
end
--定时赛开赛状态
function Animation:CreateMatchKaiSaiStaue( replaceNode )
	trace("CreateMatchKaiSaiStaue")
	local anim,suc = self:createGaf("img2/matchgame/matchtypeselect/jinsai_ing/jinsai_ing.gaf",replaceNode,true)
	return anim,suc
end
--比赛正在进行中大厅
function Animation:CreateFixGameIng2( replaceNode )
	local anim = self:createGaf("img2/matchgame/bisaichanging.gaf",replaceNode)
	return anim
end

--创建等待其他桌动画
function Animation:CreateWaitOtherDesk( replaceNode )
	local anim = self:createGaf("img2/matchgame/waitotherdesk/shengluehao/shengluehao.gaf",replaceNode)
	return anim
end
--匹配
function Animation:CreatePeiduiDengdai( replaceNode )
	local anim,suc = self:createGaf("img2/matchgame/peiduidengdai/peiduidengdai.gaf",replaceNode)
	if suc then
		anim:setAniPosCenter()
	end
	return anim,suc
end
--商城
function Animation:createShangchen(replaceNode)
	local anim,suc =  self:createGaf("img2/gaf/shangchen/shangdian.gaf",replaceNode)
	if suc then
		anim:setAniPosCenter()
	end
	return anim,suc
end

--邮件
function Animation:createRecMail(replaceNode)
	return self:createGaf("img2/gaf/youxiang/youxiang.gaf",replaceNode,true)
end

--发红包
function Animation:createSendHongbao(parent)
	local node ,suc= self:createGaf("img2/gaf/hongbao_chuxian_xunhuan/hongbao_chuxian_xunhuan.gaf",nil,true)
	if suc then
		node:moveToNode(parent)
		node:moveChildren(parent)
		--node:setAniPosCenter()
        node:setLoopKey("xunhuan")
	end
	return node,suc
end

--抢红包
function Animation:createRecHongbao(replaceNode)
	local node ,suc= self:createGaf("img2/gaf/hongbao_jinbi/hongbao_jinbi.gaf",replaceNode,true)
	node:setVisible(false)
	node.runAni = function()
		if suc then
			node:setAniPosCenter()
			node:setVisible(true)
			node:playSequence("chuxian",false)
	        node:setLoopKey("xunhuan",1)
		end
	end
	return node,suc
end

--[[抢红包 金币
function Animation:createRecHongbaoJb(replaceNode)
	local node ,suc= self:createGaf("img2/gaf/hongbao_jinbi/hongbao_jinbi.gaf",replaceNode)
	if suc then
		node:setLooped(false)
		node:setAniPosCenter()
	end
	return node,suc
end]]

--红包按钮
function Animation:createHongbaoBtn(replaceNode)
	local node,suc = self:createGaf("img2/gaf/hongbaoing/hongbaoing.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end


function Animation:createMainRoomHead(replaceNode,key)
	local img = roomIcon[key]
	local anim,suc
	if img then
		anim,suc =  self:createGaf(img,replaceNode)
		if suc then
			anim:setAniPosCenter()
			--anim:setPosition(anim:getPositionX() + 15,anim:getPositionY()+15)
			if key == gameId_cofig.KANPAI then
				anim:setPosition(anim:getPositionX()-2 ,anim:getPositionY()+31)
			elseif key == gameId_cofig.PKSC then
				anim:setPosition(anim:getPositionX() ,anim:getPositionY()+30)
			elseif key == gameId_cofig.BAIREN then
				anim:setPosition(anim:getPositionX()-5 ,anim:getPositionY()+15)
			elseif key== gameId_cofig.SHUIGUO then
				anim:setPosition(anim:getPositionX() -5,anim:getPositionY()+60)
			elseif key == gameId_cofig.Friend_POKER then
				anim:setPosition(anim:getPositionX()-3,anim:getPositionY()-71)
			elseif key == gameId_cofig.CONTEST_POKER or key == gameId_cofig.CONTEST_POKERS then
				anim:setPosition(anim:getPositionX()-5,anim:getPositionY()-71)
			elseif key== gameId_cofig.GRABRED_LOARDS then
				anim:setPosition(anim:getPositionX() ,anim:getPositionY()-50)
			elseif key == gameId_cofig.ACTIVITY then
				anim:setPosition(anim:getPositionX()+30,anim:getPositionY()-75)
			else
				anim:setPosition(anim:getPositionX(),anim:getPositionY())
			end
            anim:setScale(0.8)
		end
	end
	return anim,suc
end

--房间边框流光
function Animation:createRoomBorderMain(replaceNode)
	return  self:createGaf("img2/gaf/roomBorder/bishai_doudizhu.gaf",replaceNode)
end

--子房间边框流光
function Animation:createRoomBorder(replaceNode)
	return  self:createGaf("img2/gaf/erjijiemian/erjijiemian.gaf",replaceNode)
end

function Animation:createGold(parent)
	local node,suc =  self:createGaf("img2/gaf/zhu_ding_jinbi/zhu_ding_jinbi.gaf")
	if suc then
		node:moveToNode(parent)
		node:setAniPosCenter()
	end
	return node
end
--周卡
function Animation:createWeekCardAnim( replaceNode , bKaitong)
	local node,suc= self:createGaf("img2/gaf/zhouyueka_zhouka/zhouyueka_zhouka.gaf",replaceNode,true)
	if suc then
		--node:playSequence("kaitong",false)
		node:setAniPosCenter()
		node:setLoopKey("pingshi",1)  
	end 
	return node,suc
end
--月卡
function Animation:createMonthCardAnim( replaceNode , bKaitong)
	local node,suc= self:createGaf("img2/gaf/zhouyueka_yueka/zhouyueka_yueka.gaf",replaceNode,true)
	if suc then
		node:setAniPosCenter()
		node:setLoopKey("pingshi",1)  
	end
	return node,suc
end

function Animation:createTreasure(replaceNode)
	local node,suc =  self:createGaf("img2/gaf/zhu_ding_zhuangshi/zhu_ding_zhuangshi.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end

function Animation:createQuan(replaceNode)
	local node,suc =  self:createGaf("img2/gaf/zhu_quan/zhu_quan.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end

function Animation:createLoing(replaceNode)
	local node,suc =  self:createGaf("img2/gaf/zhuangquan/zhuangquan.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end

--创建好友房
function Animation:createFriendRoomAnim( replaceNode )
	local node,suc =  self:createGaf("img2/FriendGame/haoyoufang_chuangjian/haoyoufang_chuangjian.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end
--加入好友房
function Animation:createJiaruFriendRoomAnim( replaceNode )
	local node,suc =  self:createGaf("img2/FriendGame/haoyoufang_jiaru/haoyoufang_jiaru.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end
-- --闹钟
-- function Animation:createNaoZhong( replaceNode)
-- 	local node,suc =  self:createGaf("img2/gaf/naozhong2/naozhong2.gaf",replaceNode)
-- 	if suc then
-- 		node:setScale(1.2)
-- 		node:setAniPosCenter()
-- 		node:playSequence("zhengch",true)
-- 	end 
-- 	return node,suc
-- end

--首充
-- function Animation:createShouChong( parent )
-- 	local left,suc =  self:createGaf("img2/gaf/shouchong/shouchong.gaf")
-- 	if suc then
-- 		left:setAniPosCenter()
-- 		parent:addChild(left)
-- 		left:setPosition(95,91)
-- 	end
-- 	return left,suc
-- end

function Animation:createLoadingBar()
	local node,suc =  self:createGaf("img2/gaf/loading/loading.gaf")
	if suc then
		node:setAniPosCenter()
	end
	return node,suc
end

function Animation:cretatRankAnim(replaceNode)
	local node,suc =  self:createGaf("img2/gaf/bisai_paihang/bisai_paihang9090.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node,suc
end


local daojuGaf = {
	[303] = {name = "feiwen",time = 0.4,sound = "mf_kiss"},
	[304] = {name = "fangqie",time = 0.4,sound = "mf_xihongshi"},
	[305] = {name = "egg2",time = 0.4,sound = "ie_egg"},
	[306] = {name = "taoxin",time = 0.4,sound = "ie_flower"},
	[10001] = {name = "zhadan",time = 0.4,sound = "Special_Bomb"},
}

--daoju
function Animation:createDaoju(id,startNode,endNode)
	local info = daojuGaf[id]
	if not info then
		trace("道具特效没找到,id = ",id)
		return
	end
	local name = info.name
	local time = info.time
	local soundPath = info.sound
	local path = string.format("img2/gaf/%s/%s.gaf",name,name)
	local ani,suc = self:createGaf(path)
	if not suc then
		return
	end
	ani:setScale(1.5)
	ani:setAnchorPoint(cc.p(0.5,0.5))
	ani:setAniPosCenter()
	util.getTipLayer():addChild(ani)
	local pos = cc.p(startNode:getPosition())
	pos = startNode:getParent():convertToWorldSpace(pos)
	pos = util.getTipLayer():convertToNodeSpace(pos)
	ani:setPosition(pos.x+startNode:getContentSize().width/2,pos.y+startNode:getContentSize().height/2)

	pos = cc.p(endNode:getPosition())
	pos = endNode:getParent():convertToWorldSpace(pos)
	pos = util.getTipLayer():convertToNodeSpace(pos)
	ani:runAction(cc.MoveTo:create(time,pos))
	util.delayCall(ani,function() 
		util.playSound(soundPath,false)
	end,time)
	ani:setRemoveOnFinish()
end


--list中解决裁剪BUG
function Animation:fixClippingList(scrollview)
	local zOrder = scrollview:getLocalZOrder()
    local box=scrollview:getBoundingBox()        
    local myScrollView=cc.ClippingRectangleNode:create(box)                          --使用cc.ClippingRectangleNode创建一个新裁切节点
    scrollview:setClippingEnabled(false)                                                                 --取消原来的裁切
    scrollview:getParent():addChild(myScrollView,zOrder)                                                                   --原来scrollview的parent
    util.changeParent(scrollview,myScrollView)                                                --我自己写的把原来的scrollview放到新创建的ClippingRectangleNode里的方法
end

--name:图片名
--frameNum,帧数
--startIndex,起始帧图片标志,默认为1
--aTime,帧间隔,默认0.2秒
--brepeat:循环播放
function Animation:createAnimation(name,startIndex ,frameNum, aTime,brepeat)
	startIndex = startIndex or 1
	local byteNum = 2--math.floor(math.log10(frameNum)+1	
	local namePrefix = name
	local spr = self:getSprite(namePrefix..getNumString(startIndex,byteNum)..util.getImgType())
	trace(namePrefix..getNumString(startIndex,byteNum)..util.getImgType())
	local animation = cc.Animation:create()
	for i=startIndex,frameNum + startIndex - 1 do
		local szName = namePrefix..getNumString(i,byteNum)..util.getImgType()
		if string.find(szName,"/") then
			animation:addSpriteFrameWithFile(szName)
		else
			local s = self.spriteFrameCache:getSpriteFrame(szName)	
			animation:addSpriteFrame(s)
		end
	end
	aTime = aTime and (aTime/frameNum) or 0.2
	animation:setDelayPerUnit(aTime)
	animation:setRestoreOriginalFrame(false)
	local action = cc.Animate:create(animation)
	local seq
	if brepeat then
		seq = cc.Sequence:create(cc.DelayTime:create(0.2), action)
    	spr:runAction(cc.RepeatForever:create(seq))
    else
    	local remove = function() spr:removeFromParent() end
    	seq = cc.Sequence:create(cc.DelayTime:create(0.2), action,cc.CallFunc:create(remove))
    	spr:runAction(seq)
    end
	return spr
end

function Animation:getSprite(name)
	local spr
	if string.find(name, "/") then -- testing
		spr = cc.Sprite:create(name)
	else
		spr = cc.Sprite:createWithSpriteFrameName(name)
	end
	return spr
end

function Animation:createGaf(path,replaceNode,copyChild)
	if __Platform__ == 0  then--3.16 pc上 gaf动画会崩溃
		return replaceNode or cc.Node:create(),false
	end
	local _finishCallback = nil
    local layOut = ccui.Widget:create()
    --util.traceTime()
    local asset = self._gafAssets[path]
    if tolua.isnull(asset) then
    	asset =  gaf.GAFAsset:create(path)
    end
    --util.traceTime(path.." useTime1 ")
    local animation = asset:createObjectAndRun(true)
    --util.traceTime(path.." useTime2 ")
    self._gafAssets[path] = asset
    local size  = not tolua.isnull(replaceNode) and replaceNode:getContentSize() or animation:getContentSize()
	function layOut:moveToNode(tarNode,addZ)
		if tolua.isnull(tarNode) then
			trace("error:Animation createGaf moveToNode tarNode = nil")
			return
		end
		local parent = tarNode:getParent()
		if parent then
			parent:addChild(layOut)
		end
		layOut:setScaleX(tarNode:getScaleX())
		layOut:setScaleY(tarNode:getScaleX())
		layOut:setAnchorPoint(tarNode:getAnchorPoint())
		layOut:setPosition(tarNode:getPosition())
		layOut:setLocalZOrder(tarNode:getLocalZOrder() + (addZ or 0))
		layOut:setGlobalZOrder(tarNode:getGlobalZOrder())
		size = tarNode:getContentSize()
    	layOut:setContentSize(size)
    	animation:setPosition(0,size.height)
	end
	if not tolua.isnull(replaceNode) then
		if util.isScaleNode(replaceNode) then
			util.aptsetScaleEquireXY(layOut,true)
		end
		layOut:moveToNode(replaceNode)
		if replaceNode.isTouchEnabled then
			layOut:setTouchEnabled(replaceNode:isTouchEnabled())
		end
	end
    layOut:setContentSize(size)
    animation:setPosition(0,size.height)
    layOut:addChild(animation)
    layOut.clickAction = true
    layOut.animation = animation

	local count = animation:getTotalFrameCount()
	local tickTime = animation:getFps()
	local totalTime = count/tickTime
	util.delayCall(layOut,function() if _finishCallback then _finishCallback() end end,totalTime)

	function layOut:setAniPos(x,y)
		if x then
			animation:setPositionX(x) 
		end
		if y then
			animation:setPositionY(y) 
		end
	end

	function layOut:getTotalTime()
		return totalTime
	end
	--播放指定帧
	function layOut:playSequence(name,loop)
		if name then
    		animation:playSequence(name,loop)
    	end
	end


	function layOut:setLooped(flag)
		animation:setLooped(flag)
	end

	--设置循环帧(正常播放完后,再循环播放)
	function layOut:setLoopKey(name,time)
		self._lootKey = name
		self:setLooped(false)
		if time then
			util.delayCall(layOut,function() self:playSequence(self._lootKey,true) end,time)
		else
			self:setFinish(function()
				self:playSequence(self._lootKey,true)
			end)
		end
	end
	--动画的锚点是在中间时调用.
	function layOut:setAniPosCenter()
		animation:setPosition(size.width/2,size.height/2)
	end


	function layOut:setFinish(callBack)
		_finishCallback = callBack
		return totalTime
	end

	--只能在最开始的时候调用,并且中间没有改内容
	function layOut:setRemoveOnFinish(callBack)
		--lua 不能用
    	--animation:setAnimationFinishedPlayDelegate(function() 
    		--layOut:removeFromParent()
    	--end)
		return self:setFinish(function() 
			if not tolua.isnull(self) then
				self:removeFromParent()
			end
			if callBack then 
				callBack() 
			end 
		end)
	end

	local oldScale = layOut.setScale
	function layOut:setScale(...)
		local oldAn = util.changeAnchor(layOut,cc.p(0,1))
		oldScale(layOut,...)
		util.changeAnchor(layOut,oldAn)
	end

	function layOut:moveChildren(fromNode)
    	if fromNode.getTouchEnabled and fromNode:getTouchEnabled() then
    		layOut:setTouchEnabled(true)
    	end
		if copyChild then
			for _,child in pairs(fromNode:getChildren()) do
				if child ~= fromNode.animation then
					util.changeParent(child,layOut)
				end
			end
		else
			local child = fromNode:getChildByName("pnl_touch")
			if child then
				util.changeParent(child,layOut)
			end
		end
	end

    if not tolua.isnull(replaceNode) then
    	layOut:moveChildren(replaceNode)
		util.delayCall(replaceNode,function() replaceNode:removeFromParent() end,0.1)
	end
    return layOut,true
end

--local ain = Animation:createAtlas("img2/gaf/xy/xueguai","attack")
--self:addChild(ain)
function Animation:createAtlas(path,key)
	local skeletonNode = sp.SkeletonAnimation:create(path..".json", path..".atlas", 1)
	skeletonNode:setAnimation(0, key, true)

	return skeletonNode
end


------------------------看牌抢庄特效-------------------------------------
--[[
function Animation:createBullBullAni(icardType)
	local node,suc
	if icardType == 0x0D then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/wuxiaoniu/wuxiaoniu.gaf")
	elseif icardType == 0x0C then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/wuhuaniu/wuhuaniu.gaf")
	elseif icardType == 0x0B then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/siza/siza.gaf")
	elseif icardType == 0x0A then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niuniu/niuniu.gaf")
	elseif icardType == 0x09 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu9/niu9.gaf")
	elseif icardType == 0x08 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu8/niu8.gaf")
	elseif icardType == 0x07 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu7/niu7.gaf")
	elseif icardType == 0x06 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu6/niu6.gaf")
	elseif icardType == 0x05 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu5/niu5.gaf")
	elseif icardType == 0x04 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu4/niu4.gaf")
	elseif icardType == 0x03 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu3/niu3.gaf")
	elseif icardType == 0x02 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu2/niu2.gaf")
	elseif icardType == 0x01 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/niu1/niu1.gaf")
	elseif icardType == 0x00 then
		node,suc =  self:createGaf("img2/gaf/bairenandwuren/meiniu/meiniu.gaf")
	end
	if suc then
		node:setAniPosCenter()
		node:setLooped(false)
	end
	return node,suc
end]]--


--抢庄
function Animation:createBullQiangZhuang(parent)
	local node,suc =  self:createGaf("img2/watchbrandgame/gaf/kuang_xuanzhuang/kuang_xuanzhuang.gaf")
	if suc then
		node:moveToNode(parent)
		node:setAniPosCenter()
		node:setLooped(false)
		node:setRemoveOnFinish()
	end
	return node,suc
end

--庄家
function Animation:createBullZhuangjia(parent)
	util.tryRemove(self._bulllord)
	local node,suc =  self:createGaf("img2/watchbrandgame/gaf/zhuangjia/zhuangjia.gaf")
	if suc then
		self._bulllord = node
		node:moveToNode(parent)
		node:setAniPosCenter()
		node:setPositionX(node:getPositionX() + 2)
		node:setLooped(false)
	end
	return node,suc
end


--金币结算
function Animation:createBulljinbijiesuan(parent)
	local node,suc =  self:createGaf("img2/gaf/bairenandwuren/jinbijiesuan/jinbijiesuan.gaf")
	if suc then
		node:moveToNode(parent)
		node:setAniPosCenter()
		node:setLooped(false)
	end
	return node,suc
end

--胜利失败结算
function Animation:createBullWinOrLose(parent,bIsWin)
	local pathWin = "img2/watchbrandgame/gaf/win/win.gaf"
	local pathLose = "img2/watchbrandgame/gaf/lose/lose.gaf"
	local node,suc =  self:createGaf(bIsWin and pathWin or pathLose)
	if suc then
		local bk = ccui.Layout:create()
		bk:setBackGroundColorType(1)
		bk:setBackGroundColor(cc.c4b(0,0,0,255))
		bk:setBackGroundColorOpacity(140)
		bk:setContentSize(cc.size(2000,2000))
		bk:setPositionY(-100)
		bk:runAction(cc.FadeOut:create(0))
		bk:runAction(cc.FadeIn:create(0.1))
		node:addChild(bk,0)
		node.animation:setLocalZOrder(1)
		node:moveToNode(parent,10000)
		node:setPositionY(420)
		node:setAniPosCenter()
		node:setLooped(false)
		node:setFinish(function() 
			bk:runAction(cc.FadeOut:create(0.1))
			util.delayCall(node,function() util.tryRemove(node) end,0.1)
		end)
	end
	return node,suc
end

function Animation:createBullTongSha(parent,num)
	local path = "img2/watchbrandgame/gaf/tongshaquanchang/tongshaquanchang.gaf"
	local node,suc =  self:createGaf(path)
	if suc then
		local bk = ccui.Layout:create()
		bk:setBackGroundColorType(1)
		bk:setBackGroundColor(cc.c4b(0,0,0,255))
		bk:setBackGroundColorOpacity(140)
		bk:setContentSize(cc.size(2000,2000))
		bk:setPositionY(-100)
		bk:runAction(cc.FadeOut:create(0))
		bk:runAction(cc.FadeIn:create(0.1))

		if num then
			local nodeNum = ui.createCsbItem("csb.watchbrandgame.allKillPoint")
			nodeNum.bf_point:setString("+"..num)
			node:addChild(nodeNum,2)
			nodeNum:setPosition(util.display.cx,util.display.cy-120)
			util.setTextCenter(nodeNum.Image_1,nodeNum.bf_point,10)
		end

		node:addChild(bk,0)
		node.animation:setLocalZOrder(1)
		node:moveToNode(parent,10000)
		node:setPositionY(420)
		node:setAniPosCenter()
		node:setLooped(false)
		node:setFinish(function() 
			bk:runAction(cc.FadeOut:create(0.1))
			util.delayCall(node,function() util.tryRemove(node) end,0.1)
		end)
	end
	return node,suc
end

--开始
function Animation:createBullBegin(parent)
	local path = "img2/watchbrandgame/gaf/kaishi/kaishi.gaf"
	local node,suc =  self:createGaf(path)
	if suc then
		node:moveToNode(parent,10000)
		node:setPositionY(370)
		node:setAniPosCenter()
		node:setLooped(false)
		node:setRemoveOnFinish()
	end
	return node,suc
end

--斗牛匹配
--匹配
function Animation:CreateBullPeidui( replaceNode )
	local anim,suc = self:createGaf("img2/watchbrandgame/gaf/pipei/pipei.gaf",replaceNode)
	if suc then
		anim:setAniPosCenter()
	end
	return anim,suc
end

--连胜
function Animation:CreateBullLianSheng( parent )
	local path = "img2/watchbrandgame/gaf/liansheng/liansheng.gaf"
	local node,suc =  self:createGaf(path)
	if suc then
		node:moveToNode(parent)
		node:setAniPosCenter()
		node:setLooped(false)
		node:setRemoveOnFinish()
	end
	return node,suc
end

--匹配
function Animation:CreateBullAdd( parent )
	local node,suc = self:createGaf("img2/watchbrandgame/gaf/j/j.gaf")
	if suc then
		node:moveToNode(parent,1000)
		node:setAniPosCenter()
	end
	return node,suc
end

function Animation:CreateSuanniuji( replaceNode )
	local node,suc = self:createGaf("img2/watchbrandgame/gaf/suanniuji/suanniuji.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
		node:playSequence("kaishi",false)
		node:setLoopKey("2",1.6)
	end
	return node,suc
end

function Animation:Createkaichangjiemian( parent )
	local node,suc = self:createGaf("img2/gaf/kaichangjiemian/kaichangjiemian.gaf")
	if suc then
		node:moveToNode(parent,0)
		node:setAniPosCenter()
	end
	return node,suc
end
--红包广场特效
function Animation:creteSendRedSquare( replaceNode )
	local node,suc = self:createGaf("img2/gaf/hongbaoguangchang/hongbaoguangchang.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
		node:playSequence("1",true)
	end
	return node,suc
end

--排行榜红点
function Animation:creteRank( parent )
	local node,suc = self:createGaf("img2/gaf/bisai_paihang1/bisai_paihang1.gaf",replaceNode)
	if suc then
		node:moveToNode(parent,0)
		node:setAniPosCenter()
	end
	return node,suc
end

--排行榜红点2
function Animation:creteRank2( parent )
	local node,suc = self:createGaf("img2/gaf/jiang/jiang.gaf",replaceNode)
	if suc then
		node:moveToNode(parent,0)
		node:setAniPos(130)
	end
	return node,suc
end

function Animation:createFudaiAni( replaceNode )
	local node,suc = self:createGaf("img2/gaf/fu/fu.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
		node:playSequence("1",true)
	end
	return node,suc
end

function Animation:createtuxin( parent )
	local node,suc = self:createGaf("img2/gaf/tuxin/tuxin.gaf",replaceNode)
	if suc then
		node:moveToNode(parent,0)
	end
	return node,suc
end

function Animation:createVipLevelAnim(parent,num)
	if num > 7 and num <= 10 then
		local vipAnim = ui.createCsbItem("csb.vip.vipInfoAni")
		for i=1,3 do
			if not tolua.isnull(vipAnim["par_vip" .. num .. "_" .. i]) then
				vipAnim["par_vip" .. num .. "_" .. i]:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA,gl.ONE))
			end
		end
		if not tolua.isnull(vipAnim["vip_anim_" .. num]) then
			vipAnim["vip_anim_" .. num]:setVisible(true)
			vipAnim:setScale(parent:getContentSize().width/260)
			parent:addChild(vipAnim)
			return
		end
	end
	return
end
--创建宝箱特效
function Animation:createBoxSignAni( replaceNode )
	local node,suc =  self:createGaf("img2/gaf/qiandaobaoxiang/qiandaobaoxiang.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end
--------------------------------------百人特效-----------------------------------------------------
function Animation:createJiangchi( replaceNode )
	local node,suc =  self:createGaf("img2/hundredniuniu/gaf/jiangchi.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
		node:playSequence("2",false)
		node:setLoopKey("2")
	end
	return node,suc
end
function Animation:createJiangchiJinru( replaceNode )
	local node,suc =  self:createGaf("img2/hundredniuniu/gaf/jinrujiangchi.gaf")
	if suc then
		node:setAniPosCenter()
		node:setRemoveOnFinish()
	end
	return node,suc
end
function Animation:createJianchikaijiang( replaceNode )
	local node,suc =  self:createGaf("img2/hundredniuniu/gaf/jianchikaijiang.gaf",replaceNode)
	if suc then
		node:setAniPosCenter()
	end
	return node
end
function Animation:createAniCoin( parent )
	local node,suc =  self:createGaf("img2/hundredniuniu/gaf/jcbb.gaf")
	if suc then
		node:moveToNode(parent,0)
		node:setAniPosCenter()
		node:setRemoveOnFinish()
	end
	return node
end
--[[
function Animation:createExpressionAni(iExpreID)
	local node,suc
	if iExpreID == 10101 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-1zang/bq-1zang.gaf")
	elseif iExpreID == 10102 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-2ku/bq-2ku.gaf")
	elseif iExpreID == 10103 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-3deyi/bq-3deyi.gaf")
	elseif iExpreID == 10104 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-4/bq-4.gaf")
	elseif iExpreID == 10105 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-6haixiu/bq-6haixiu.gaf")
	elseif iExpreID == 10106 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-5han/bq-5han.gaf")
	elseif iExpreID == 10107 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-7heihei/bq-7heihei.gaf")
	elseif iExpreID == 10108 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-8jinya/bq-8jinya.gaf")
	elseif iExpreID == 10109 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-9shaoxiang/bq-9shaoxiang.gaf")
	elseif iExpreID == 10110 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-10yumen/bq-10yumen.gaf")
	elseif iExpreID == 10111 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-9shaoxiang/bq-9shaoxiang.gaf")
	elseif iExpreID == 10112 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-10yumen/bq-10yumen.gaf")
	elseif iExpreID == 10113 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-11se/bq-11se.gaf")
	elseif iExpreID == 10114 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-12touxiao/bq-12touxiao.gaf")
	elseif iExpreID == 10115 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-13xinlie/bq-13xinlie.gaf")
	elseif iExpreID == 10116 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-14zeixiao/bq-14zeixiao.gaf")
	elseif iExpreID == 10117 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-16baibai/bq-16baibai.gaf")
	elseif iExpreID == 10118 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-15ye/bq-15ye.gaf")
	elseif iExpreID == 10119 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-16baibai/bq-16baibai.gaf")
	elseif iExpreID == 10120 then
		node,suc =  self:createGaf("img2/gaf/biaoqing/bq-16baibai/bq-16baibai.gaf")
	end
	if suc then
		node:setAniPosCenter()
		node:setLooped(false)
		node:setRemoveOnFinish()
	end
	return node,suc
end
]]--
function Animation:createSpeciallyEffect(iEffectname,iBegin,iEnd,iLoop)
    local ani,aniAction 
    ani = ui.loadCS(iEffectname)
    aniAction = ui.loadCSTimeline(iEffectname)
    aniAction:gotoFrameAndPlay(iBegin,iEnd,iLoop)
    if ani and aniAction then
        ani:runAction(aniAction)
    else    
        trace("ERROR load effect " .. iEffectname)
    end
    return ani
end
function Animation:createCSExpressionAni(iExpreID, bPlay)
    local ani,aniAction 
    if iExpreID == 10101 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10102 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_5ku")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_5ku")
        aniAction:gotoFrameAndPlay(0,20,true)
    elseif iExpreID == 10103 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_3deyi")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_3deyi")
        aniAction:gotoFrameAndPlay(0,80,true)
	    local light = _au:sweepLight({
				clippingPic = "img2/effect/biaoqing/b_eye.png",
				effType = 5,
				lightTime = 1,
				perDelay = 5,
				lightOpacity = 128,
				lightRotate = 30
			})
	    ani:getChildByName("b_eye_2"):addChild(light)
    elseif iExpreID == 10104 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_4emo")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_4emo")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10105 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_6haixiu")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_6haixiu")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10106 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_7han")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_7han")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10107 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_12hanxiao_0")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_12hanxiao_0")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10108 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_2xjinya")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_2xjinya")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10109 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_18haha")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_18haha")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10111 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_9shaoxiang")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_9shaoxiang")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10112 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_11shaui")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_11shaui")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10113 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_10se")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_10se")
        aniAction:gotoFrameAndPlay(0,20,true)
    elseif iExpreID == 10114 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_8xiao")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_8xiao")
        aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 10115 then
        ani = ui.loadCS("img2/effect/biaoqing/biaoqing_13xinlie")
        aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_13xinlie")
        aniAction:gotoFrameAndPlay(0,80,true)
   	elseif iExpreID == 10116 then
	    ani = ui.loadCS("img2/effect/biaoqing/biaoqing_14zeiixiao_0")
	    aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_14zeiixiao_0")
	    aniAction:gotoFrameAndPlay(0,20,true)
	elseif iExpreID == 10118 then
	    ani = ui.loadCS("img2/effect/biaoqing/biaoqing_15ye")
	    aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_15ye")
	    aniAction:gotoFrameAndPlay(0,20,true)
    elseif iExpreID == 10117 then
	    ani = ui.loadCS("img2/effect/biaoqing/biaoqing_16baibai")
	    aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_16baibai")
	    aniAction:gotoFrameAndPlay(0,40,true)
    elseif iExpreID == 10110 then
	    ani = ui.loadCS("img2/effect/biaoqing/biaoqing_17zhuangkuang")
	    aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_17zhuangkuang")
	    aniAction:gotoFrameAndPlay(0,80,true)
    elseif iExpreID == 20000 then
	    ani = ui.loadCS("csb/effect/08shangcheng")
	    aniAction = ui.loadCSTimeline("csb/effect/08shangcheng")
        --ani = ui.loadCS("img2/effect/biaoqing/biaoqing_17zhuangkuang")
	    --aniAction = ui.loadCSTimeline("img2/effect/biaoqing/biaoqing_17zhuangkuang")
	    aniAction:gotoFrameAndPlay(0,64,true)
    elseif iExpreID == 20001 then
    	ani = ui.loadCS("csb/effect/shouchong_guangyun")
	    aniAction = ui.loadCSTimeline("csb/effect/shouchong_guangyun")
	    aniAction:play("play", true)
    elseif iExpreID == 20006 then
    	ani = ui.loadCS("csb/effect/06zhuanpanrukou")
	    aniAction = ui.loadCSTimeline("csb/effect/06zhuanpanrukou")
	    aniAction:gotoFrameAndPlay(0,200,true)
	elseif iExpreID == 20004 then
    	ani = ui.loadCS("csb/effect/04gongxihuode_xunhuan")
	    aniAction = ui.loadCSTimeline("csb/effect/04gongxihuode_xunhuan")
	    aniAction:gotoFrameAndPlay(0,250,true)
	elseif iExpreID == 20002 then
    	ani = ui.loadCS("csb/effect/02choujiang_xunhuan")
	    aniAction = ui.loadCSTimeline("csb/effect/02choujiang_xunhuan")
	    aniAction:gotoFrameAndPlay(0,78,true)
	elseif iExpreID == 20005 then
    	ani = ui.loadCS("csb/effect/05daoju")
	    aniAction = ui.loadCSTimeline("csb/effect/05daoju")
	    aniAction:gotoFrameAndPlay(0,145,false)
    elseif iExpreID == 20007 then
    	ani = ui.loadCS("csb/effect/yaosi")
	    aniAction = ui.loadCSTimeline("csb/effect/yaosi")
	    aniAction:play("animation0",true)
    elseif iExpreID == 20008 then
    	ani = ui.loadCS("csb/effect/shouchonganniu")
	    aniAction = ui.loadCSTimeline("csb/effect/shouchonganniu")
	    aniAction:play("animation0",true)
    elseif iExpreID == 20009 then
    	ani = ui.loadCS("csb/effect/choujiang_xunhuan")
	    aniAction = ui.loadCSTimeline("csb/effect/choujiang_xunhuan")
	    aniAction:play("choujiang_xunhuan",true)
    elseif iExpreID == 20010 then
    	ani = ui.loadCS("csb/effect/choujiang_zhongjiang")
	    aniAction = ui.loadCSTimeline("csb/effect/choujiang_zhongjiang")
	    aniAction:play("choujiang_zhongjiang",false)
    elseif iExpreID == 20011 then
    	ani = ui.loadCS("csb/effect/xianshihuodong")
	    aniAction = ui.loadCSTimeline("csb/effect/xianshihuodong")
	    aniAction:play("xianshihuodong",true)
    elseif iExpreID == 20012 then
    	ani = ui.loadCS("csb/effect/hongbaorukou")
	    aniAction = ui.loadCSTimeline("csb/effect/hongbaorukou")
	    aniAction:play("hongbao",true)
	elseif iExpreID == 20013 then
    	ani = ui.loadCS("csb/effect/gu")
	    aniAction = ui.loadCSTimeline("csb/effect/gu")
	    aniAction:play("gu",true)
    elseif iExpreID == 20014 then
    	ani = ui.loadCS("csb/effect/baoxiang")
	    aniAction = ui.loadCSTimeline("csb/effect/baoxiang")
	    aniAction:play("baoxiang",true)
    end
    if ani and aniAction then
        ani:runAction(aniAction)
    end
    return ani,aniAction
end

function Animation:createForTuneAni( ... )
	local ani,aniAction
	ani = ui.loadCS("csb/effect/zhaocaijinbao")
	aniAction = ui.loadCSTimeline("csb/effect/zhaocaijinbao")
	aniAction:gotoFrameAndPause(1)
	if ani and aniAction then
        ani:runAction(aniAction)
    end
    return ani,aniAction
end

-- function Animation:createHongbaoQuan(replaceNode)
-- 	local node,suc =  self:createGaf("img2/gaf/ddz_new/ddz_new.gaf",replaceNode)
-- 	if suc then
-- 		node:setAniPosCenter()
-- 		node:playSequence("1",false)
-- 	end
-- 	return node,suc
-- end

function Animation:createHongbaoGameFinsh()
	local node,suc =  self:createGaf("img2/gaf/jushu/jushu.gaf")
	if suc then
		node:setAniPosCenter()
		node:setRemoveOnFinish()
	end
	return node,suc
end

--千人抢红包游戏特效
function Animation:createGrabredAni(iExpreID, bPlay)
    local ani,aniAction 
    if iExpreID == 10000 then
        ani = ui.loadCS("csb/grabredlords_game/feiji")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/feiji")
        util.playSound("Special_plane",false)
        aniAction:gotoFrameAndPlay(0,38,false)
 	elseif iExpreID == 10001 then 	--连队
 	  	ani = ui.loadCS("csb/grabredlords_game/liandui")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/liandui")
        util.playSound("shunzi",false)
        aniAction:play("shunzi",false) 
    elseif iExpreID == 10002 then
    	ani = ui.loadCS("csb/grabredlords_game/baoxiang_dailingqu")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/baoxiang_dailingqu")
        aniAction:play("baoxiang_dailingqu",true) 
    elseif iExpreID == 10003 then
    	ani = ui.loadCS("csb/grabredlords_game/baoxiang_lingqu")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/baoxiang_lingqu")
        aniAction:play("baoxiang_lingqu",true) 
    elseif iExpreID == 10004 then 	--顺子
    	ani = ui.loadCS("csb/grabredlords_game/shunzi")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/shunzi")
        util.playSound("shunzi",false)
        aniAction:play("shunzi",false) 
    elseif iExpreID == 10005 then
    	ani = ui.loadCS("csb/grabredlords_game/shibai")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/shibai")
        aniAction:play("shibai",true) 
    elseif iExpreID == 10006 then
    	ani = ui.loadCS("csb/grabredlords_game/shengli")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/shengli")
        aniAction:gotoFrameAndPlay(0,105,false)
        util.delayCall(ani,function() 
			aniAction:gotoFrameAndPlay(105,550,true)
		end,2)
    elseif iExpreID == 10007 then
    	ani = ui.loadCS("csb/grabredlords_game/huojian")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/huojian")
        aniAction:play("huojian",true) 
    elseif iExpreID == 10008 then
    	ani = ui.loadCS("csb/grabredlords_game/wangzha")
        aniAction = ui.loadCSTimeline("csb/grabredlords_game/wangzha")
        aniAction:play("wangzha",false) 
        util.playSound("Special_Long_Bomb",false)
        util.delayCall(ani,function() 
			util.playSound("Special_Bomb",false)
		end,1.5)
    end
    if ani and aniAction then
        ani:runAction(aniAction)
    end
    return ani
end

--创建新手签到任务特效
function Animation:create7TaskSignItemAni(iExpreID, bPlay)
    local ani,aniAction 
    if iExpreID == 1 then  		--金币
        ani = ui.loadCS("csb/effect/jiemianwupin_jinbi")
        aniAction = ui.loadCSTimeline("csb/effect/jiemianwupin_jinbi")
        aniAction:play("jiemian",true)
 	elseif iExpreID == 4 then 	--钻石
 	  	ani = ui.loadCS("csb/effect/jiemianwupin_zuanshi")
        aniAction = ui.loadCSTimeline("csb/effect/jiemianwupin_zuanshi")
        aniAction:play("jiemian",true) 
    elseif iExpreID == 7 then --红包卷
    	ani = ui.loadCS("csb/effect/jiemianwupin_hongbao")
        aniAction = ui.loadCSTimeline("csb/effect/jiemianwupin_hongbao")
        aniAction:play("jiemian",true) 
    elseif iExpreID == 8 then --钥匙
    	ani = ui.loadCS("csb/effect/jiemianwupin_yaoshi")
        aniAction = ui.loadCSTimeline("csb/effect/jiemianwupin_yaoshi")
        aniAction:play("jiemian",true) 
    elseif iExpreID == 9 then  --周卡
    	ani = ui.loadCS("csb/effect/jiemianwupin_zhouka")
        aniAction = ui.loadCSTimeline("csb/effect/jiemianwupin_zhouka")
        aniAction:play("jiemian",true) 
    end
    if ani and aniAction then
        ani:runAction(aniAction)
    end
    return ani
end

return Animation