-- 主界面房间节点
local gameId_cofig = require("Common.gameID")
local crazyRoomInfo = require("config.template.CrazyTen")
--local roomSort = {gameId_cofig.GRABRED_LOARDS,gameId_cofig.CONTEST_POKER,gameId_cofig.Friend_POKER,gameId_cofig.ACTIVITY}
--local roomSort = {gameId_cofig.GRABRED_LOARDS,gameId_cofig.BAIREN,gameId_cofig.KANPAI,gameId_cofig.SHUIGUO}
local roomSort = {gameId_cofig.GRABRED_LOARDS,gameId_cofig.KANPAI,gameId_cofig.HUANLEBIPAI,gameId_cofig.TWOAGAINST_DDZ,gameId_cofig.TWOMAHJONG_GAME,gameId_cofig.ACTIVITY}
-- local roomSort = {gameId_cofig.GRABRED_LOARDS,gameId_cofig.KANPAI,gameId_cofig.HUANLEBIPAI,gameId_cofig.TWOAGAINST_DDZ,gameId_cofig.TWOMAHJONG_GAME,gameId_cofig.ACTIVITY}

local GroundNode = class(...,BaseNode)

local GAME_TYPE = {}
GAME_TYPE[gameId_cofig.GRABRED_LOARDS] = {path="csb/effect/doudizhu_01",framenumber=160}
-- GAME_TYPE[gameId_cofig.CONTEST_POKER] = {path="csb/effect/doudizhu_01",framenumber=160}
GAME_TYPE[gameId_cofig.KANPAI] = {path="csb/effect/kanpanqiangzhuang_03",framenumber=160}
GAME_TYPE[gameId_cofig.Friend_POKER] = {path="csb/effect/doudizhu_01",framenumber=160}
GAME_TYPE[gameId_cofig.ACTIVITY] = {path="csb/effect/gengduowanfa_06",framenumber=160}
-- GAME_TYPE[gameId_cofig.BAIREN] = {path="csb/effect/bairenkuanghuan_02",framenumber=160}
-- GAME_TYPE[gameId_cofig.SHUIGUO] = {path="csb/effect/fengkuangshuiguo_04",framenumber=160}
GAME_TYPE[gameId_cofig.HUANLEBIPAI] = {path="csb/effect/fengkuangshuangshi_05",framenumber=120}
GAME_TYPE[gameId_cofig.TWOAGAINST_DDZ] = {path="csb/effect/dizhupo",framenumber=160}
GAME_TYPE[gameId_cofig.TWOMAHJONG_GAME] = {path="csb/effect/majiang",framenumber=160}

--=================================================
local GAME_NAME = {}
GAME_NAME[gameId_cofig.GRABRED_LOARDS] = "img2/hall/doudizhu1.png"
GAME_NAME[gameId_cofig.BAIREN] = "img2/hall/bairenkuanghuang1.png"
GAME_NAME[gameId_cofig.KANPAI] = "img2/hall/kanpanqiangzhuang1.png"
GAME_NAME[gameId_cofig.SHUIGUO] = "img2/hall/fengkuangshuiguo1.png"
GAME_NAME[gameId_cofig.HUANLEBIPAI] = "img2/hall/huanlebipai1.png"
GAME_NAME[gameId_cofig.ACTIVITY] = "img2/hall/gengduowanfa1.png"


--=================================================



local roomIcon = {}
roomIcon[gameId_cofig.GRABRED_LOARDS	] = "img2/hall/_0010_dizhu.png"
roomIcon[gameId_cofig.CONTEST_POKER] = "img2/hall/_0008_dizhupo.png"
--roomIcon[gameId_cofig.KANPAI] = "img2/hall/_0006_douniu.png"
roomIcon[gameId_cofig.Friend_POKER] = "img2/hall/_0004_huodong.png"
roomIcon[gameId_cofig.ACTIVITY] = "img2/hall/_0006_douniu.png"
roomIcon[gameId_cofig.PKSC] = "img2/hall/tem/fksc.png"
roomIcon[gameId_cofig.HUANLEBIPAI] = "img2/hall/_0044_huanlebipai_head.png"
local GAME_ROOM_LEVEL = {}
GAME_ROOM_LEVEL[gameId_cofig.GRABRED_LOARDS] = "img2/hall/btn_happy_"
GAME_ROOM_LEVEL[gameId_cofig.KANPAI] = "img2/watchbrandgame/btn_bull_"
GAME_ROOM_LEVEL[gameId_cofig.HUANLEBIPAI] = "img2/carzyRes/roomLevel/btn_crazy_"
GAME_ROOM_LEVEL[gameId_cofig.BAIREN] = "img2/hundredniuniu/roomLevel/roomBg_"

local game_level_kind = 4
local viewsize = cc.Director:getInstance():getWinSize()

local matchinfoCofig = require("config.competition")

local activityRoomData = {
	{bk = "img2/hall/_0007_niuniu",	key = gameId_cofig.KANPAI},
	--{bk = "img2/hall/brkh",	key = gameId_cofig.BAIREN},
	--{bk = "img2/hall/fksg",	key = gameId_cofig.SHUIGUO},
	{bk = "img2/hall/pksc",	key = gameId_cofig.PKSC,wait = true},
	--{bk = "img2/hall/fksg",	key = gameId_cofig.SHUIGUO},
	{bk = "img2/hall/_0009_bishai",	key = gameId_cofig.CONTEST_POKER,bNoVisble = true},
	{bk = "img2/hall/_0005_huodong",	key = gameId_cofig.Friend_POKER,bNoVisble = true},
}

--返回退出的ID
local _backID = {
	-- [gameId_cofig.KANPAI] = gameId_cofig.ACTIVITY,
	-- [gameId_cofig.BAIREN] = gameId_cofig.ACTIVITY,
	-- [gameId_cofig.SHUIGUO]	= gameId_cofig.ACTIVITY,
	-- [gameId_cofig.PKSC]	= gameId_cofig.ACTIVITY,
}

--主界面一级界面创建
function GroundNode:ctor()
	GroundNode.super.ctor(self)
	-- --主界面图标列表
	-- self._mainRoomItems = {}
	-- --当前二级界面列表
	-- self.curSecondItemList = {}
	-- --斗地主图标列表
	-- self._happyRoomItems = {}
	-- --比赛场图标列表
	-- self._matchRoomItems = {}
	-- --好友场图标列表
	-- self._friendRoomItems = {}
	-- --看牌抢庄图标列表
	-- self._watchBrandRoomItems = {}

	self._containItems = {}

	-- --当前页面Id
	-- self:getParent()._gameId = gameId_cofig.MAIN
	-- --被点击的按钮
	self.touchedBtn = {btn = nil,scale = 1,inUse = false}
	-- --当前快速开始房间
	-- self:getParent()._iCurStartRoom = 1
	-- --

	self.twoPoiList = {cc.p(-280,0),cc.p(280,0)}
	self.SixPoiList = {cc.p(200*_gm.bgScaleW2,105+105*(1-_gm.bgScaleW2)),
    cc.p(-112.5,110+110*(1-_gm.bgScaleW2)),cc.p(170,110+110*(1-_gm.bgScaleW2)),cc.p(462.5,110+110*(1-_gm.bgScaleW2)),
    cc.p(-112.5,-155-155*(1-_gm.bgScaleW2)),cc.p(170,-155-155*(1-_gm.bgScaleW2)),cc.p(462.5,-155-155*(1-_gm.bgScaleW2))}
	self.FourPoiList = {cc.p(-457.5,25),cc.p(-152.5,25),cc.p(152.5,25),cc.p(457.5,25)}
	self.ThreePoiList = {cc.p(-390,0),cc.p(0,0),cc.p(390,0)}
end
local ONLINE_NUM = ""
--显示   隐藏   Items
function GroundNode:showMainItems(bShow)
	for k,v in pairs(self._containItems) do
		v:setVisible(bShow)
	end
	-- if bShow then
	-- 	self:addContainItemFromRight(self._containItems)
	-- else
	-- 	self:delContainItemToLeft()
	-- end
end

--按钮事件
function GroundNode:onBtnClick(pSender, type)
	local function clearTouchedBtn()
		if self.touchedBtn.inUse then
			self.touchedBtn.btn:getChildByName("img"):setScale(self.touchedBtn.scale)
			self.touchedBtn = {btn = nil,scale = 1,inUse = false}
		end
	end
	if type == ccui.TouchEventType.began then
		local scaleImage = pSender:getChildByName("img")
		if scaleImage then
			--self.touchedBtn = {btn = pSender,scale = pSender:getScale(),inUse = true}
			--scaleImage:setScale(self.touchedBtn.scale*0.95)
		end
	elseif type == ccui.TouchEventType.moved then
	elseif type == ccui.TouchEventType.ended then
		util.playSound("Common_Panel_Dialog_Pop_Sound",false)
		clearTouchedBtn()
		if self:getParent().canInCding then
			trace("-------------响应屏蔽------------")
			return
		end
		
		self:getParent():runResponseCd(0.5)
		--if self.canInCding then
			--trace("-------------响应屏蔽------------")
			--return
		--end
		--self:runResponseCd(0.5)
		if pSender.tag.layerId == gameId_cofig.MAIN or pSender.tag.layerId == gameId_cofig.ACTIVITY then
			if gameId_cofig.KANPAI == pSender.tag.clickData then
				local downloader = downLoadModule:create(pSender:getChildByName("img") and pSender:getChildByName("img"):getChildByName("sp_hallSpace"))
		        downloader:downLoadMod(MODULE_KANPAI,function()
		        	self:onSelectGameType(pSender.tag.clickData)
		        end)
			elseif pSender.tag.clickData == gameId_cofig.BAIREN then
				local downloader = downLoadModule:create(pSender:getChildByName("img") and pSender:getChildByName("img"):getChildByName("sp_hallSpace"))
		        downloader:downLoadMod(MODULE_BAIREN,function()
		        	GameSocket:sendMsg(MDM_GP_LIST,ASS_GP_GET_GAMELEVEL_PEOPLE_COUNT,{iKindID=2,iGameNameID=gameId_cofig.BAIREN})
		        	self:onSelectGameType(pSender.tag.clickData)
					-- self:getParent()._iCurGameId = gameId_cofig.BAIREN
					-- self:getParent():onSelectBairen({uNameID = gameId_cofig.BAIREN,iRoomLevel = 1})
		        end)
			elseif gameId_cofig.SHUIGUO == pSender.tag.clickData then
				--水果
				-- Alert:showTip("还未开放哦，请耐心等待",2)
				local downloader = downLoadModule:create(pSender:getChildByName("img") and pSender:getChildByName("img"):getChildByName("sp_hallSpace"))
		        downloader:downLoadMod(MODULE_FRIUTMAC,function()
		        	self:onSelectGameType(pSender.tag.clickData)
					-- self:getParent()._iCurGameId = gameId_cofig.SHUIGUO
					-- self:getParent():onSelectFruits({uNameID = gameId_cofig.SHUIGUO,iRoomLevel = 1})
				end)
            elseif gameId_cofig.ACTIVITY == pSender.tag.clickData then
				--pk
				 Alert:showTip("更多玩法 还未开放哦，请耐心等待",2)
				--self:getParent()._iCurGameId = gameId_cofig.PKSC
				--self:getParent():onSelectPksc({{uNameID = gameId_cofig.PKSC, iRoomLevel = 1}})
				return
			elseif gameId_cofig.TWOAGAINST_DDZ == pSender.tag.clickData or gameId_cofig.TWOMAHJONG_GAME == pSender.tag.clickData then
				Alert:showTip("该游戏未开放，敬请期待",2)
				return
			elseif gameId_cofig.HUANLEBIPAI == pSender.tag.clickData then
				local downloader = downLoadModule:create(pSender:getChildByName("img") and pSender:getChildByName("img"):getChildByName("sp_hallSpace"))
		        downloader:downLoadMod(MODULE_CARZY,function()
		        	self:onSelectGameType(pSender.tag.clickData)
		        end)
				 -- Alert:showTip("疯狂双十 还未开放哦，请耐心等待",2)
				--self:getParent()._iCurGameId = gameId_cofig.PKSC
				--self:getParent():onSelectPksc({{uNameID = gameId_cofig.PKSC, iRoomLevel = 1}})
				return
			elseif gameId_cofig.PKSC == pSender.tag.clickData then
				--pk
				 Alert:showTip("还未开放哦，请耐心等待",2)
				--self:getParent()._iCurGameId = gameId_cofig.PKSC
				--self:getParent():onSelectPksc({{uNameID = gameId_cofig.PKSC, iRoomLevel = 1}})
				return
		    elseif pSender.tag.clickData == gameId_cofig.GRABRED_LOARDS then
		    	self:onSelectGameType(pSender.tag.clickData)
		        -- self:getParent():onSelectRoom({uNameID = gameId_cofig.GRABRED_LOARDS,iRoomLevel = 1})
		    else
		    	self:onSelectGameType(pSender.tag.clickData)
			end
		-- elseif pSender.tag.layerId == gameId_cofig.HAPPY_POKER then
			-- self:getParent():onSelectRoom(pSender.tag.clickData)
			--self:getParent():onSelectBairen({uNameID = gameId_cofig.GRABRED_LOARDS,iRoomLevel = 1})
		elseif pSender.tag.layerId == gameId_cofig.CONTEST_POKER then
			self:getParent():onSelectMatchRoom(pSender.tag.clickData)
		elseif pSender.tag.layerId == gameId_cofig.Friend_POKER then
			if pSender.tag.clickData == "create" then
				self:getParent():onCreateRoom()
			elseif pSender.tag.clickData == "join" then
				self:getParent():onJiaRuRoom()
			end
		elseif pSender.tag.layerId == gameId_cofig.KANPAI then
			self:getParent():onSelectBullRoom(pSender.tag.clickData)
		elseif pSender.tag.layerId == gameId_cofig.BAIREN then
			self:getParent():onSelectBairen(pSender.tag.clickData)
		elseif pSender.tag.layerId == gameId_cofig.HUANLEBIPAI then
			if pSender.tag.clickData == gameId_cofig.CRAZY_FRIEND_GAME then
				self:onSelectGameType(pSender.tag.clickData)
			else
				self:getParent():onSelectCrazyRoom(pSender.tag.clickData)
			end
		elseif pSender.tag.layerId == gameId_cofig.CRAZY_FRIEND_GAME then
			self:getParent():onSelectCrazyFriendRoom(pSender.tag.clickData)
		elseif pSender.tag.layerId == gameId_cofig.GRABRED_LOARDS then
			self:getParent():onSelectRoom(pSender.tag.clickData)
		elseif pSender.tag.layerId == gameId_cofig.SHUIGUO then
			self:getParent():onSelectFruits(pSender.tag.clickData)
		end
	elseif type == ccui.TouchEventType.canceled then
		clearTouchedBtn()
	end
end

--切换到上级页
function GroundNode:changeContainToMain(createFunc)
	local time = self:delContainItemToLeft()
	util.delayCall(self,function() 
		local item = createFunc and createFunc() or self:createMainRoomItems()
		self:addContainItemFromRight(item) 
	end,time/2)
end

--切换到下级页
function GroundNode:changeContainToSecond(createFunc)
	local time = self:delContainItemToTop()
	util.delayCall(self,function()
		local tblItems = createFunc()
		self:addContainItemFromBottom(tblItems)
	end,0.05)	
end

--一级二级页面切换 逻辑
function GroundNode:onSelectGameType(gameId)
	gameId  = gameId or self:getBackGameID() or gameId_cofig.MAIN
	if self:getParent()._gameId == gameId  then
		return false
	end
	--[[if self:getParent()._gameId~=gameId_cofig.MAIN and gameId~=gameId_cofig.MAIN then
		return false
	end]]
	if self._selecTypeting then
		return false
	end
	self._selecTypeting = true
	if gameId == gameId_cofig.CONTEST_POKER then
		local tbl =
		{
			iUserID = PlayerData:getUserID(),
		}
		GameSocket:sendMsg(MDM_GP_BATTLE_MSG,ASS_GP_BATTLE_USER_SIGNUP_INFO_REQ,tbl)
	elseif gameId == gameId_cofig.CRAZY_FRIEND_GAME  then
		GameSocket:sendMsg(MDM_GP_VIP_LOGE,ASS_GP_HAS_CREATE_FRIEND_ROOM)
	end
	self:getParent():showInfo(gameId == gameId_cofig.MAIN)
	self:getParent():showBottomNode(gameId == gameId_cofig.MAIN)
	self:getParent():showStartGameBtn(gameId ~= gameId_cofig.GRABRED_LOARDS and gameId ~= gameId_cofig.CRAZY_FRIEND_GAME and gameId ~= gameId_cofig.Friend_POKER and gameId ~= gameId_cofig.MAIN)
	--self.btn_jlsm:setVisible(gameId_cofig.HAPPY_POKER == gameId)

	self:updateList(gameId)
	return true
end

function GroundNode:getBackGameID()
	return _backID[self:getParent()._gameId] or gameId_cofig.MAIN
end

--一级二级页面切换 UI
function GroundNode:updateList(gameId)
	if self:getParent()._gameId == gameId then
		self._selecTypeting = false
		return
	end
	self:getParent()._iMatchItem = nil
	self:getParent()._iCurStartRoom = 1
	local func_change = self:getParent()._gameId == gameId_cofig.MAIN and self.changeContainToSecond or self.changeContainToMain-- 切换动画
	local func_create -- 按钮内容

	if gameId_cofig.MAIN == gameId then--切换到一级页面
		func_change = self.changeContainToMain
		self:getParent()._iCurStartRoom = 1
	-- elseif gameId_cofig.Friend_POKER == gameId then
		-- func_create = self.createFriendRoomItem
	--elseif gameId_cofig.ACTIVITY == gameId then
		--func_create = self.createActivityRoomItems
		--self:getParent()._iCurStartRoom = 3
	--elseif gameId_cofig.HAPPY_POKER == gameId then
		-- func_create = self.createHappyRoomItem
	elseif gameId_cofig.GRABRED_LOARDS == gameId then
		self:getParent()._iCurStartRoom = 1
		func_change = self.changeContainToSecond
		func_create = self.createGrabredLordsRoomItem
	elseif gameId_cofig.KANPAI == gameId then
		self:getParent()._iCurStartRoom = 3
		func_change = self.changeContainToSecond
		func_create = self.createWatchBrandRoomItems
	elseif gameId_cofig.BAIREN == gameId then
		self:getParent()._iCurStartRoom = 4
		func_change = self.changeContainToSecond
		func_create = self.createHundredRoomItems
	elseif gameId_cofig.SHUIGUO == gameId then
		self:getParent()._iCurStartRoom = 2
		func_change = self.changeContainToSecond
		func_create = self.createFruitRoomItems
	elseif gameId_cofig.HUANLEBIPAI == gameId then
		self:getParent()._iCurStartRoom = 5
		func_change = self.changeContainToSecond
		func_create = self.createCarzyRoomItems
	elseif gameId_cofig.CRAZY_FRIEND_GAME == gameId then
		self:getParent()._iCurStartRoom = 6
		func_change = self.changeContainToSecond
		func_create = self.createCarzyFriendRoomItems
	elseif gameId == gameId_cofig.CONTEST_POKER or gameId == gameId_cofig.CONTEST_POKERS then
		-- self:getParent()._iCurStartRoom = 2
		--self:updateMatchItem(false)
		func_create = self.createMatchInfoItem
	end
	func_change(self,function() return func_create and func_create(self) end)
	self:getParent()._iCurGameId = gameId
	self:getParent()._gameId = gameId
end

--异步创建二级界面图标
function GroundNode:initListItems()
	-- util.delayCall(self,function() self:createFriendRoomItem() end)
	--util.delayCall(self,function() self:createHappyRoomItem() end)
	--util.delayCall(self,function() self:createWatchBrandRoomItems() end)--这里不能预创建,因为图片可能未下载

	--util.delayCall(self,function() self:createActivityRoomItems() end)
	util.delayCall(self,function() 
		-- self:updateMatchItem(false)
		-- self:createMatchInfoItem() 
	end)

	util.delayCall(self,function() 
		for k,v in pairs(PlayerData:getPopSequence()) do
			_uim:showLayer(v.str, v.data)
			break
		end
	end,1)
end
--滚动广告
function RollingAdvertising()
    if _gm.mainLayer.groundNode ~= nil then
        _gm.mainLayer.groundNode:RollingAdvertising()
    end
end

function GroundNode:RollingAdvertising()
    if self:getParent()._gameId ==gameId_cofig.MAIN then
        trace("RollingAdvertising")
    end 
end
--创建主界面图标
function GroundNode:createMainRoomItems()
	if self._mainRoomItems then
		return self._mainRoomItems
	end
    --scheduler.scheduleGlobal(RollingAdvertising, 3)
	self._mainRoomItems = {}
	self._gameRoomItems = {}
    local tempNode = _gm.mainLayer.csLeftNode
    tempNode:setPosition(self.SixPoiList[1])
    local imgback = tempNode:getChildByName("img_hall_frame_left")
    if imgback ~= nil then 
        imgback:setLocalZOrder(10)
    end
    table.insert(self._mainRoomItems,_gm.mainLayer.csLeftNode)
	local tbl =
	{
		[1] = 213,
		[2] = 114,
		[3] = 123,
		[4] = 78,
		[5] = 0,
		[6] = 0,
	}
    --trace("===========spine----------------")
     
    --local skeletonNode = Animation:createAtlas("spine/bingongchang2","animation")
    --skeletonNode:setPosition(-252.5,-150)
    --skeletonNode:setLocalZOrder(100)
    --self:addChild(skeletonNode)
	for i,key in pairs(roomSort) do
		local item = ui.loadCS("csb/hall/gameModelNode")
		item:setPosition(self.SixPoiList[i])
		item:setTag(key)
		item:setLocalZOrder(10-i)
		self:addChild(item)
		ui.setNodeMap(item,item)
		--util.loadSprite(item.sp_head,roomIcon[key])
        
        if key == gameId_cofig.GRABRED_LOARDS then
            item.sp_head:setScale(0.8)
            item.sp_head:setPosition(item.sp_head:getPositionX()+8, item.sp_head:getPositionY()-38)
        elseif key == gameId_cofig.HUANLEBIPAI then
            item.sp_head:setPosition(item.sp_head:getPositionX()+1, item.sp_head:getPositionY()-40)
        end
		--头像动画
		--item.sp_head = Animation:createMainRoomHead(item.sp_head,key)
		--util.loadButton(item.hall_btn_game, GAME_TYPE[key])
		--util.loadSprite(item.sp_hallSpace,GAME_TYPE[key])
		--util.delayCall(item,function()
			--边框动画
		--	local ani,suc = Animation:createRoomBorderMain()
		--	if suc then
		--		ani:moveToNode(item.sp_hallSpace,-1)
		--	end
		--end,i) 
		if key == gameId_cofig.GRABRED_LOARDS then
            if util.isExamine() ~= true then
                local ani = Animation:createSpeciallyEffect("csb/effect/06qianghongbao", 0, 27, true)     
	            item:addChild(ani)
                ani:setPosition(90,105)
            end
        --elseif key == gameId_cofig.HUANLEBIPAI then

		end
        local ani = Animation:createSpeciallyEffect(GAME_TYPE[key].path, 0, GAME_TYPE[key].framenumber, true)
        --ani:setPosition(item.btn_game:getPositionX()+150, item.btn_game:getPositionY()+98)
        ani:setLocalZOrder(-100)
        item.Image_1:addChild(ani)
        --util.setImg(item.Image_1,GAME_NAME[key])
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item.btn_game.tag = {layerId = gameId_cofig.MAIN , clickData = key}
		table.insert(self._mainRoomItems,item)

		-- if key == gameId_cofig.KANPAI then
		-- 	self._bullRoomItem = item.sp_hallSpace
		-- end
		-- if key == gameId_cofig.BAIREN then
		-- 	self._BairenRoomItem = item.sp_hallSpace
		-- end
		-- if key == gameId_cofig.SHUIGUO then
		-- 	self._FruitRoomItem = item.sp_hallSpace
		-- end
	end
	return self._mainRoomItems
end

function GroundNode:findRecordPeople( ... )
	local renshu = 0
	for k,v in pairsKey(self:getParent().recordPeople) do
		if v.uNameID == gameId_cofig.KANPAI or v.uNameID == gameId_cofig.BAIREN or v.uNameID == gameId_cofig.SHUIGUO then
			-- renshu = renshu + math.floor(v.uRoomPeople*1.5)
		end
	end
	return renshu
end

--创建千人抢红包图标
function GroundNode:createGrabredLordsRoomItem()
	if self._grabredLordsRoomItems then
		return self._grabredLordsRoomItems
	end
	local gameId = gameId_cofig.GRABRED_LOARDS
	self._grabredLordsRoomItems = {}
	local grabredRoomInfo = TemplateData:getRoom(gameId)
	for i = 1,3 do
		local item = ui.loadCS("csb/grabredlords_game/grabredlordsRoomLevel")
		item:setPosition(self.ThreePoiList[i])
		self:addChild(item)
		ui.setNodeMap(item,item)
		item.Text_room_limt:setString("入场门票 " .. grabredRoomInfo[i].gold1)
		item.Text_room_desc:setString(grabredRoomInfo[i].desc)
		util.loadButton(item.btn_grabred_room_level, "img2/grabredlords/iRoomLevel/ditu_" .. i .. ".png")
		util.loadImage(item.img_icon, "img2/grabredlords/iRoomLevel/icon_" .. i .. ".png")
		util.loadImage(item.img_room_level, "img2/grabredlords/iRoomLevel/title_" .. i .. ".png")
		util.loadImage(item.img_number_bg, "img2/grabredlords/iRoomLevel/piao" .. i .. ".png")
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item.btn_game.tag = {layerId = gameId , clickData = {uNameID = gameId,iRoomLevel = grabredRoomInfo[i].iRoomLevel}}
		if PlayerData:getPlayerInfoAdd() and PlayerData:getPlayerInfoAdd().iDDZSignUpLevel and PlayerData:getPlayerInfoAdd().iDDZSignUpLevel == grabredRoomInfo[i].iRoomLevel then
			item.img_bSignUp:setVisible(true)
		else
			item.img_bSignUp:setVisible(false)
		end
		item:setTag(grabredRoomInfo[i].iRoomLevel)
		item:setVisible(false)
		table.insert(self._grabredLordsRoomItems,item)
	end
	--复活入口
	self._ResurrectItem = ui.loadCS("csb/grabredlords_game/resurrectionEnter")
	self._ResurrectItem:setScale(_gm.bgScaleW)
	self._ResurrectItem:setPosition(0, -285)
	ui.setNodeMap(self._ResurrectItem, self._ResurrectItem)
	self._ResurrectItem.btn_resurrection.tag = "btn_resurrection"
	self._ResurrectItem.btn_resurrection:addTouchEventListener(function(...) self:getParent():onBtnClick(...) end)
	self._grabredLordsRoomItems[2]:addChild(self._ResurrectItem)
	self:onSartResurrectTime()
	return self._grabredLordsRoomItems
end

function GroundNode:onSartResurrectTime( ... )
	if not tolua.isnull(self._ResurrectItem) and not tolua.isnull(self._ResurrectItem) then
		util.removeAllSchedulerFuns(self._ResurrectItem)
		local resuTime = PlayerData:getForTurnTime() - (PlayerData:getServerTime() - PlayerData:getPlayerInfoAdd().tmResurrectionTM)
		if resuTime > 0 then
			self._ResurrectItem.lb_resutte_time:setString("复活倒计时 " .. util.showTimePourFormatHM(resuTime))
			util.delayCall(self._ResurrectItem,function()
				resuTime = resuTime - 1
				if resuTime > 0 then
					self._ResurrectItem.lb_resutte_time:setString("复活倒计时 " .. util.showTimePourFormatHM(resuTime))
				else
					self._ResurrectItem.lb_resutte_time:setString("")
					PlayerData._player.iResurrection = 0
					util.removeAllSchedulerFuns(self._ResurrectItem)
					 GameEvent:notifyView(GameEvent.updateStartResurre)
				end
		    end,1,true)
		end
	end
end

function GroundNode:onUpdateDDZSignUpInfo( ... )
	if self._grabredLordsRoomItems then
		for k,item in pairs(self._grabredLordsRoomItems) do
			if item:getTag() == PlayerData:getPlayerInfoAdd().iDDZSignUpLevel then
				item.img_bSignUp:setVisible(true)
			else
				item.img_bSignUp:setVisible(false)
			end
		end
	end
end

function GroundNode:updateMatch( ... )
	--local obj = self._matchitems
	for i,v in ipairs(self._matchitems) do
		if v and v:getTag() == 30 then
			if PlayerData:isSignMatch() then
				v.ybm_1:setVisible(true)
			else
				v.ybm_1:setVisible(false)
			end
			break
		end
	end
end

--创建看牌抢庄图标
function GroundNode:createWatchBrandRoomItems()
	if self._WatchBrandRoomItems then
		return self._WatchBrandRoomItems
	end
	local gameId = gameId_cofig.KANPAI
	self._WatchBrandRoomItems = {}
	for i = 1,game_level_kind do
		local item = ui.loadCS("csb/hall/watchBrandNode")
		item:setPosition(self.FourPoiList[i])
		self:addChild(item)
		ui.setNodeMap(item,item)
    	--item.Text_room_limt:setString(TemplateData:getRoomGoldDesc(gameId,i))
    	--item.Text_online_number:setString(TemplateData:getRoomBottomInfo(gameId,i))
    	item.Text_room_limt:setString(TemplateData:getRoomGoldDesc(10900500,i))
    	item.Text_online_number:setString(TemplateData:getRoomBottomInfo(10900500,i))
		util.loadButton(item.btn_bull_room_level, GAME_ROOM_LEVEL[gameId]..i..util.getImgType())
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item.btn_game.tag = {layerId = gameId , clickData = {uNameID = gameId,iRoomLevel = i}}
		util.delayCall(item,function()     		
			local ani,suc = Animation:createRoomBorder()
			if suc then
				ani:moveToNode(item.btn_bull_room_level,-1)
				ani:setAniPos(18,378)
				ani:setScale(1.03)
			end
		end,i)
		item:setVisible(false)
		table.insert(self._WatchBrandRoomItems,item)
	end
	return self._WatchBrandRoomItems
end

--创建百人牛牛房间图标
function GroundNode:createHundredRoomItems()
	if self._HundredRoomItems then
		return self._HundredRoomItems
	end
	local gameId = gameId_cofig.BAIREN
	self._HundredRoomItems = {}
	local configBiaren = TemplateData:getRoom(gameId)
	for i = 1,3 do
		local item = ui.loadCS("csb/hundredniuniu/hundredRoomLevel")
		item:setPosition(self.ThreePoiList[i])
		self:addChild(item)
		ui.setNodeMap(item,item)
    	item.Text_room_limt:setString("上庄：" .. util.showNumberCoinFormat(configBiaren[i].num3))
    	item.Text_online_number:setString(configBiaren[i].gold1)
    	util.loadImage(item.img_icon, "img2/hundredniuniu/roomLevel/_img_icon_" .. i .. ".png")
    	util.loadImage(item.img_room_level, "img2/hundredniuniu/roomLevel/_img_level_" .. i .. ".png")
    	util.loadImage(item.img_number_bg, "img2/hundredniuniu/roomLevel/_img_zhuang_" .. i .. ".png")
		util.loadButton(item.btn_crazy_room_level, GAME_ROOM_LEVEL[gameId]..i..util.getImgType())
		item.btn_game.tag = {layerId = gameId , clickData = {uNameID = gameId,iRoomLevel = configBiaren[i].iRoomLevel}}
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item:setTag(configBiaren[i].iRoomLevel)
		item:setVisible(false)
		table.insert(self._HundredRoomItems,item)
	end
	self:updateSingleGamePeople(gameId_cofig.BAIREN)
	return self._HundredRoomItems
end

--创建疯狂水果房间图标
function GroundNode:createFruitRoomItems()
	if self._FruitsRoomItems then
		return self._FruitsRoomItems
	end
	local gameId = gameId_cofig.SHUIGUO
	self._FruitsRoomItems = {}
	local configFruit = TemplateData:getRoom(gameId)
	for i = 1,3 do
		local item = ui.loadCS("img2/fruits/friutRoomLevel")
		item:setPosition(self.ThreePoiList[i])
		self:addChild(item)
		ui.setNodeMap(item,item)
    	item.Text_room_limt:setString("入场:" .. TemplateData:getRoomGoldDesc(gameId,i))
    	item.Text_online_number:setString(configFruit[i].desc)
    	util.loadImage(item.img_icon, "img2/fruits/roomLevel/_img_icon_" .. i .. ".png")
    	util.loadImage(item.img_room_level, "img2/fruits/roomLevel/_img_level_" .. i .. ".png")
    	util.loadImage(item.img_number_bg, "img2/fruits/roomLevel/_img_zhuang_" .. i .. ".png")
		util.loadButton(item.btn_crazy_room_level, "img2/fruits/roomLevel/ditu_" .. i .. ".png")
		item.btn_game.tag = {layerId = gameId , clickData = {uNameID = gameId,iRoomLevel = configFruit[i].iRoomLevel}}
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item:setTag(configFruit[i].iRoomLevel)
		item:setVisible(false)
		table.insert(self._FruitsRoomItems,item)
	end
	return self._FruitsRoomItems
end

--创建疯狂双十房间图标
function GroundNode:createCarzyRoomItems()
	if self._CrazyRoomItems then
		return self._CrazyRoomItems
	end
	local gameId = gameId_cofig.HUANLEBIPAI
	self._CrazyRoomItems = {}
	for i = 1,3 do
		local item = ui.loadCS("csb/crazyGame/crazyRoomLevel")
		item:setPosition(self.ThreePoiList[i])
		self:addChild(item)
		ui.setNodeMap(item,item)
		item.img_no_open_icon:setVisible(false)
		-- if i == 3 then
		-- 	item.img_no_open_icon:setVisible(true)
		-- else
		-- 	item.img_no_open_icon:setVisible(false)
		-- end
    	item.Text_room_limt:setString(TemplateData:getRoomGoldDesc(gameId,i+1))
    	item.Text_online_number:setString(TemplateData:getRoomBottomInfo(gameId,i+1))
    	util.loadImage(item.img_icon, "img2/carzyRes/roomLevel/roomIcon" .. i .. ".png")
    	util.loadImage(item.img_room_level, "img2/carzyRes/roomLevel/_img_roomLvel_" .. i .. ".png")
    	util.loadImage(item.img_number_bg, "img2/carzyRes/roomLevel/img_difenbg_" .. i .. ".png")
		util.loadButton(item.btn_crazy_room_level, GAME_ROOM_LEVEL[gameId]..i..util.getImgType())
		item.btn_game.tag = {layerId = gameId , clickData = {uNameID = gameId,iRoomLevel = i+1}}
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item:setVisible(false)
		table.insert(self._CrazyRoomItems,item)
	end
	--好友房入口
	local item = ui.loadCS("csb/crazyGame/crazyFriendEnter")
	item:setPositionY(-310)
	self._CrazyRoomItems[1]:addChild(item)
	ui.setNodeMap(item,item)
	item.btn_game.tag = {layerId = gameId_cofig.HUANLEBIPAI , clickData = gameId_cofig.CRAZY_FRIEND_GAME}
	item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)

	return self._CrazyRoomItems
end

--创建疯狂双十房间图标
function GroundNode:createCarzyFriendRoomItems()
	if self._CarzyFriendRoomItems then
		return self._CarzyFriendRoomItems
	end
	local gameId = gameId_cofig.CRAZY_FRIEND_GAME
	self._CarzyFriendRoomItems = {}
	for i = 1,3 do
		local item = ui.loadCS("csb/crazyGame/crazyFriendRoomLevel")
		item:setPosition(self.ThreePoiList[i])
		self:addChild(item)
		ui.setNodeMap(item,item)
		item._img_crateImg:setVisible(false)
    	item.Text_room_limt:setString("至少携带" .. crazyRoomInfo[i+4].gold1 .. "金币")
    	item.Text_online_number:setString("最小投注" .. crazyRoomInfo[i+4].num2)
    	util.loadImage(item.img_icon, "img2/carzyRes/friendRoolLevel/roomIcon" .. i .. ".png")
    	util.loadImage(item.img_room_level, "img2/carzyRes/friendRoolLevel/_img_roomLvel_" .. i .. ".png")
    	util.loadImage(item.img_number_bg, "img2/carzyRes/friendRoolLevel/img_difenbg_" .. i .. ".png")
		util.loadButton(item.btn_crazy_room_level, "img2/carzyRes/friendRoolLevel/btn_crazy_" .. i .. ".png")
		item.btn_game.tag = {layerId = gameId , clickData = {uNameID = gameId,iRoomLevel = i+4}}
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item:setVisible(false)
		item:setTag(i+4)
		table.insert(self._CarzyFriendRoomItems,item)
	end

	return self._CarzyFriendRoomItems
end

function GroundNode:onShowCreateIcon( iRoomLevel )
	if self._CarzyFriendRoomItems then
		for k,v in pairs(self._CarzyFriendRoomItems) do
			if v:getTag() == iRoomLevel then
				v._img_crateImg:setVisible(true)
			else
				v._img_crateImg:setVisible(false)
			end
		end
	end
	
end


--创建活动中心
function GroundNode:createActivityRoomItems()
	if self._ActivityRoomItems then
		-- self:updatePeopel()
		return self._ActivityRoomItems
	end
	local gameId = gameId_cofig.ACTIVITY
	self._ActivityRoomItems = {}

	local tbl =
	{
		[1] = 832,
		[2] = 170,
		[3] = 152,
		[4] = 0,
		[5] = 685,
		[6] = 22,
	}

	for index,info in pairs(activityRoomData) do
		local key = info.key
		local img = info.bk
		local item = ui.loadCS("csb/hall/gameModelNode")
		item:setTag(key)
		item:setPosition(self.FourPoiList[index])
		item:setVisible(false)
		item:setLocalZOrder(10-index)
		self:addChild(item)
		ui.setNodeMap(item,item)
		local bFind = false

		for k,v in pairs(self:getParent().recordPeople) do
			if key == v.uNameID then
				bFinds = true
				m = tbl[index] +  math.floor(v.uRoomPeople*1.5)
				item.lbl_num:setString(ONLINE_NUM..m)
				break
			end
		end
		if not bFind then
			item.lbl_num:setString(ONLINE_NUM.. tbl[index])
		end
		--item.lbl_num:setString("")
		if roomIcon[key] then
			util.loadSprite(item.sp_head,roomIcon[key])
			item.sp_head:setPositionY(130)
		end
		--头像动画
		if info.wait then
			item.sp_wait:setVisible(true)
		end
		item.bNoVisble = info.bNoVisble
		if info.bNoVisble then
			item:setVisible(false)
		end
		item.sp_head = Animation:createMainRoomHead(item.sp_head,key)
		--util.loadButton(item.hall_btn_game,img)
		util.loadSprite(item.sp_hallSpace,img)
		util.delayCall(item,function()
			--边框动画
			local ani,suc = Animation:createRoomBorderMain()
			if suc then
				ani:moveToNode(item.sp_hallSpace,-1)
			end
		end,index)
		item.btn_game:addTouchEventListener(function(...) self:onBtnClick(...) end)
		item.btn_game.tag = {layerId = gameId_cofig.ACTIVITY , clickData = key}
		table.insert(self._ActivityRoomItems,item)
		-- if key == gameId_cofig.KANPAI then
		-- 	self._bullRoomItem = item.sp_hallSpace
		-- end
		-- if key == gameId_cofig.BAIREN then
		-- 	self._BairenRoomItem = item.sp_hallSpace
		-- end
	end
	return self._ActivityRoomItems
end

function GroundNode:updatePeopel( ... )
	if  self._ActivityRoomItems then
		local tbl =
		{
			[1] = 832,
			[2] = 170,
			[3] = 152,
			[4] = 0,
			[5] = 685,
			[6] = 22,
		}
		local m = 0
		for i,var in ipairs(self._ActivityRoomItems) do
			local bFind = false
			for k,v in pairs(self:getParent().recordPeople) do
				if var:getTag() == v.uNameID then
					bFind = true
					m = tbl[i] +  math.floor(v.uRoomPeople*1.5)
					var.lbl_num:setString(ONLINE_NUM..m)
					break
				end
			end
			if not bFind then
				var.lbl_num:setString(ONLINE_NUM.. tbl[i])
			end
		end
	end
	if self._mainRoomItems then
		local tbls =
		{
			[1] = 213,
			[2] = 213,
			[3] = 114,
			[4] = 123,
			[5] = 78,
			[6] = 0,
			[7] = 0,
		}
		local bFinds = false
		for i,var in ipairs(self._mainRoomItems) do
			for k,v in pairs(self:getParent().recordPeople) do
				if var:getTag() == v.uNameID then
					bFinds = true
					m = tbls[i] +  math.floor(v.uRoomPeople*1.5)
					var.lbl_num:setString(ONLINE_NUM..m)
					break
				elseif var:getTag() == 2  then
					bFinds = true
					m = tbls[i]
					-- m = tbls[i] + self:findRecordPeople()
					var.lbl_num:setString(ONLINE_NUM..m)
					break
				end
			end
			if not bFinds then
				trace("ERROR：未找到对应类型")
			end
		end
	end
end

function GroundNode:updateSingleGamePeople( iGameNameID )
	if iGameNameID and iGameNameID == gameId_cofig.BAIREN then
		if self._HundredRoomItems then
			for k,v in pairs(self._HundredRoomItems) do
				local iCount = self:getPeopleByLevel(v:getTag())
				v.txt_people_count:setString(iCount)
			end
		end
	end
end

function GroundNode:getPeopleByLevel(iLevel )
	if self:getParent()._bairenRoomPeople then
		for k,v in pairs(self:getParent()._bairenRoomPeople) do
			if v.iLevel == iLevel then
				return v.iPeople
			end
		end
	end
	return 0
end

function GroundNode:getGameRoomNodeByGameID( iGameID )
	for k,item in pairs(self._mainRoomItems) do
		if item:getTag() == iGameID then
			return item.sp_hallSpace
		end
	end
	return self
end

-- function GroundNode:getBullRoom()
-- 	return self._bullRoomItem
-- end

-- function GroundNode:getBaiRenRoom(...)
-- 	return self._BairenRoomItem
-- end

-- function GroundNode:getFruitRoomItem( ... )
-- 	return self._FruitRoomItem
-- end

--更新比赛场图标
function GroundNode:updateMatchItem(bItem)
	local sertime =  PlayerData:getServerTime()      --服务器时间
	local hour = os.date("%H",sertime)
	local minute = os.date("%M",sertime)
	local stime = os.date("%S",sertime)
	local time_0 = sertime - hour*3600 - minute*60 - stime
	local paixuz = 2
	local paixud = 4
	if not bItem then
		for k,v in pairsKey(matchinfoCofig) do
			if v.TypeKind == 2 then
				if (time_0+v.OpenNumTime+60*30) - sertime > 0 then
					v.iPaixu = paixuz
					paixuz = paixuz + 1
				else
					v.iPaixu = paixud
					paixud = paixud - 1
				end
			end
		end
		table.sort(matchinfoCofig,function(a,b) 
			return a.iPaixu<b.iPaixu  
		end)
	else
		for k,v in pairsKey(self._matchitems) do
			if v._iKindType == 2 then
				trace(sertime,v._iTime)
				if v._iTime - sertime > 1 then
					v.paixu = paixuz
					paixuz = paixuz + 1
				else
					v.paixu = paixud
					paixud = paixud - 1
				end
			end
		end
		table.sort(self._matchitems,function(a,b) 
			return a.paixu<b.paixu  
		end)
		if self:getParent()._iCurGameId == gameId_cofig.CONTEST_POKER or self:getParent()._iCurGameId == gameId_cofig.CONTEST_POKERS then
			self:addContainItems(self._matchitems)
		end
	end
end

--获取图标位置
function GroundNode:getItemPosInContain(tblItem,index)
	if #tblItem == 4 then
		return self.FourPoiList[index]
	elseif  #tblItem == 3 then
		return self.ThreePoiList[index]
	elseif #tblItem == 7 then
		return self.SixPoiList[index]
	elseif #tblItem == 2 then
		return self.twoPoiList[index]
	end
end

--添加内部图标
function GroundNode:addContainItems(tblItem)
	for index,item in pairsKey(tblItem) do
		local pos = self:getItemPosInContain(tblItem,index)
		item:stopAllActions()
		item:runAction(cc.FadeIn:create(0))
		item:setPosition(pos.x,pos.y)
		item:setVisible(true)
		-- util.setEnabled(item.btn,true)
	end

	self._containItems = tblItem

	self._selecTypeting = false
end

--从右部移入
function GroundNode:addContainItemFromRight(tblItem)
	local pnlContain = self:getParent().pnl_contain

	local time = 0
	local delTime = 0.1
	for index,item in pairs(tblItem) do
		local targetPos = self:getItemPosInContain(tblItem,index)
        if targetPos == nil then
            trace("未找到对应的控件 " .. index)      
        end
		local startPos = cc.p(targetPos.x+1280,targetPos.y)

		item:stopAllActions()
		item:runAction(cc.FadeIn:create(0))
		item:setPosition(cc.p(startPos.x,startPos.y))
		if item.bNoVisble then
			item:setVisible(false)
		else
			item:setVisible(true)
		end
		util.delayCall(item,function() 
			-- util.setEnabled(item.btn,true)
			item:runAction(cc.Sequence:create(
				cc.MoveBy:create(delTime,cc.p(-1280,0)),
				cc.MoveBy:create(0.03,cc.p(30,0)),
				cc.MoveBy:create(0.03,cc.p(-30,0))
				))
		end,time)
		time = time + delTime
	end
	time = time + 0.03*2
	util.delayCall(self,function()
		self._selecTypeting = false
	end)

	self._containItems = tblItem
	return time
end

--从底部移入
function GroundNode:addContainItemFromBottom(tblItem)
	local pnlContain = self:getParent().pnl_contain

	local time = 0
	local delTime = 0.2
	local addTime = 0.05
	for index,item in pairs(tblItem) do
		if not tolua.isnull(item) then
			local targetPos = self:getItemPosInContain(tblItem,index)
			local startPos = cc.p(targetPos.x,targetPos.y-720)
			item:stopAllActions()
			item:runAction(cc.FadeIn:create(0))
			item:setPosition(cc.p(startPos.x,startPos.y))
			if item.bNoVisble then
				item:setVisible(false)
			else
				item:setVisible(true)
			end
			util.delayCall(item,function() 
				-- util.setEnabled(item.btn,true)
				item:runAction(cc.Sequence:create(cc.MoveBy:create(delTime,cc.p(0,720))))
			end,time)
			time = time + addTime
		end
	end
	time = time + delTime

	util.delayCall(self,function()
		self._selecTypeting = false
	end)

	self._containItems = tblItem
	return time
end

--移动出左部
function GroundNode:delContainItemToLeft()
	local time = 0
	local delTime = 0.1
	local addTime = 0.05
	for index,item in pairs(self._containItems) do
		if not tolua.isnull(item) then
			item:stopAllActions()
			util.delayCall(item,function() 
				-- util.setEnabled(item.btn,false)
				item:runAction(cc.Sequence:create(cc.MoveBy:create(delTime,cc.p(-1280,0)),cc.CallFunc:create(function() item:setVisible(false) end)))
			end,time)
			time = time + addTime
		end
	end
	return time
end

--移动出上部
function GroundNode:delContainItemToTop()
	local time = 0
	local delTime = 0.2
	local addTime = 0.05
	for index,item in pairs(self._containItems) do
		if not tolua.isnull(item) then
			util.delayCall(item,function() 
				item:stopAllActions()
				-- util.setEnabled(item.btn,false)
				local moveTop = cc.Spawn:create(cc.MoveBy:create(delTime,cc.p(0,1000)),cc.FadeOut:create(time))
				local dispear = cc.Spawn:create(cc.CallFunc:create(function() item:setVisible(false) end),cc.FadeIn:create(0))
				item:runAction(cc.Sequence:create( moveTop,dispear))
			end,time)
			time = time + addTime
		end
	end
	return time
end

return GroundNode