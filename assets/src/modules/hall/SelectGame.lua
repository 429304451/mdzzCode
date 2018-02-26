
-- local gameId_cofig = require("Common.gameID")
local GroundNode = require("modules.hall.GroundNode")
local game_level_kind = 4

local SelectGame = class("SelectGame",BaseLayer)

function SelectGame:ctor(data)
	-- print("---------data", data)
	SelectGame.super.ctor(self, data)
	_gm.mainLayer = self
	self._bdelay = true
	self._bShowRule = false;
	--背景
	self.csBgNode = Animation:createSpeciallyEffect("csb/effect/01wutai", 0, 162, true)
	self:addChild(self.csBgNode,-1)
	_gm.bgScaleW2 = _gm.bgScaleW2 or _gm.bgScaleW>1 and 1 or _gm.bgScaleW
	self.csBgNode:setScale(_gm.bgScaleW,1)
	self.csBgNode:setPosition(WIN_center)
	ui.setNodeMap(self.csBgNode, self)

	--主界面选场节点
	self.groundNode = GroundNode.new()
	self.groundNode:setPosition(WIN_center)
	self.groundNode:setScale(_gm.bgScaleW2)
	self:addChild(self.groundNode)
	--左部节点
    self.csLeftNode = ui.loadCS("csb/hall/hallLeftNode")
	self:addChild(self.csLeftNode)
	self.csLeftNode:setScale(_gm.bgScaleW2)
	self.csLeftNode:setPosition(-200,-200)
    self.csLeftNode.tag = "csLeftNode";
	ui.setNodeMap(self.csLeftNode, self)
	--上部节点
	self.csUpNode = ui.loadCS("csb/hall/hallUpNode")
	self:addChild(self.csUpNode)
	self.csUpNode:setScale(_gm.bgScaleW)
	self.csUpNode:setPosition(WIN_up_center)
	ui.setNodeMap(self.csUpNode, self)
	util.setTextMaxWidth(self.lbl_name,130)
	--快速开始
	self.csstartGameNode = ui.loadCS("csb/hall/startGameNode")
	self:addChild(self.csstartGameNode)
	self.csstartGameNode:setScale(_gm.bgScaleW)
	self.csstartGameNode:setPosition(NUtils.getDeviationPoint(WIN_down_center,cc.p(0,70)))
	ui.setNodeMap(self.csstartGameNode, self)
	--下部节点
	self.csDownNode = ui.loadCS("csb/hall/hallDownNode")
	self:addChild(self.csDownNode)
	self.csDownNode:setScale(_gm.bgScaleW)
	self.csDownNode:setPosition(WIN_left_down.x, WIN_left_down.y)
    trace("X " .. WIN_left_down.x .. " Y " .. WIN_left_down.y + 80)
	ui.setNodeMap(self.csDownNode, self)

	self.recordPeople = {}
	self._iCurStartRoom = 1
	self._iMatchInfo = {}
	self._bMatchIng = {}

	--更新主界面玩家信息
	self:intiPlayerData()
	--获取玩家数据
	self:initItemData()
	--主界面走马灯
	self.notice = Alert:registerGameMsgModule(self,true,3)
    self.notice.ScrollPaper:setPositionY(WIN_Height - self.notice.ScrollPaper:getContentSize().height - self.img_hall_frame_top:getContentSize().height*_gm.bgScaleW)
	--刷新vip数据
	self:updateVipInfo()
	--预加载其他页面资源
	util.delayCall(self,function() self:loadImg() end,2)

	--初始化IOS支付
	sdkManager:initIosPay()
	-- self:wocaoocaocaoco()
	-- resize-aptSelf addEvents refresh pnl_close
end


--按钮点击响应
function SelectGame:onBtnClick(pSender, type)
	local function clearTouchedBtn()
		if self.touchedBtn.inUse then
			self.touchedBtn.btn:getChildByName("img"):setScale(self.touchedBtn.scale)
			self.touchedBtn = {btn = nil,scale = 1,inUse = false}
		end
	end
	if type == ccui.TouchEventType.began then
		local scaleImage = pSender:getChildByName("img")
		if scaleImage then
			self.touchedBtn = {btn = pSender,scale = pSender:getScale(),inUse = true}
			scaleImage:setScale(self.touchedBtn.scale*0.9)
		end
	elseif type == ccui.TouchEventType.moved then
	elseif type == ccui.TouchEventType.ended then
		clearTouchedBtn()
		util.playSound("Common_Panel_Dialog_Pop_Sound",false)
		if self.canInCding then
			return
		end
		self:runResponseCd(0.5)
		mlog(pSender.tag)

		if pSender.tag == "btn_startGame" then
			-- self:onStartGame(_,true)
			-- mlog("快速开始")
		elseif pSender.tag == "btn_shangcheng" then
			-- _uim:showLayer(ui.shop)
			-- mlog("商城")
		elseif pSender.tag == "btn_huodong" then
			-- _uim:showLayer(ui.activityMain)
			-- mlog("活动")
		elseif pSender.tag == "btn_renwu" then
			-- _uim:showLayer(ui.task)
			-- mlog("任务")
		elseif pSender.tag == "btn_exchange" then
			-- mlog("btn_exchange")
		elseif pSender.tag == "btn_hongbao" then
			-- _uim:showLayer(ui.loginWelfare)
		elseif pSender.tag == "btn_goldAdd" then
			-- _uim:showLayer(ui.shop,1)
		elseif pSender.tag == "btn_voucherAdd" then
			-- _uim:showLayer(ui.shop,3)
		elseif pSender.tag == "btn_mail" then
			-- _uim:showLayer(ui.mail)
		elseif pSender.tag == "btn_setting" then
			-- _uim:showLayer(ui.settingFrame)
		elseif pSender.tag == "btn_my_info" then
			-- _uim:showLayer(ui.PersonalInfo)
		elseif pSender.tag == "btn_hall_back" then
			self:onBackHall()
		elseif pSender.tag == "btn_firstCharge" then
			_uim:showLayer(ui.firstCharge)
		elseif pSender.tag == "btn_lucky" then
			_uim:showLayer(ui.lottery)
		elseif pSender.tag == "btn_goldDraw" then
			_uim:showLayer(ui.shareMain)
		elseif pSender.tag == "btn_fortune" then
			_uim:showLayer(ui.fortune)
		end
	elseif type == ccui.TouchEventType.canceled then
		clearTouchedBtn()
	end
end

function SelectGame:addEvents()
	--注册按钮相应
	self.touchedBtn = {btn = nil,scale = 1,inUse = false}
	self.btn_startGame:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_startGame.tag = "btn_startGame"
	self.btn_shangcheng:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_shangcheng.tag = "btn_shangcheng"
	self.btn_huodong:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_huodong.tag = "btn_huodong"
	self.btn_renwu:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_renwu.tag = "btn_renwu"
	self.btn_exchange:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_exchange.tag = "btn_exchange"
	self.btn_hongbao:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_hongbao.tag = "btn_hongbao"
	self.btn_goldAdd:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_goldAdd.tag = "btn_goldAdd"
	self.btn_voucherAdd:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_voucherAdd.tag = "btn_voucherAdd"

	self.btn_mail:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_mail.tag = "btn_mail"
	self.btn_setting:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_setting.tag = "btn_setting"
	self.btn_my_info:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_my_info.tag = "btn_my_info"
	self.btn_hall_back:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_hall_back.tag = "btn_hall_back"

	self.btn_goldDraw:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_goldDraw.tag = "btn_goldDraw"

	self.btn_fortune:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_fortune.tag = "btn_fortune"

	if not util.isExamine() then 
    	self.btn_Active_01:addTouchEventListener(function (...) self:onBtnClick(...) end)
		self.btn_Active_01.tag = "btn_Active_01"
     	self.btn_Active_02:addTouchEventListener(function (...) self:onBtnClick(...) end)
		self.btn_Active_02.tag = "btn_Active_02"
		self.btn_Active_03:addTouchEventListener(function (...) self:onBtnClick(...) end)
		self.btn_Active_03.tag = "btn_Active_03"
	else
		self.btn_Active_01:loadTextureNormal("img2/hall/menpiaodafangsong.jpg", 0)
		self.btn_Active_01:loadTexturePressed("img2/hall/menpiaodafangsong.jpg", 0)
		self.btn_Active_01:loadTextureDisabled("img2/hall/menpiaodafangsong.jpg", 0)
		self._img_ative_tip_01:hide()
		self._img_ative_tip_02:hide()
    end
    self.btn_firstCharge:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_firstCharge.tag = "btn_firstCharge"
	self.btn_lucky:addTouchEventListener(function (...) self:onBtnClick(...) end)
	self.btn_lucky.tag = "btn_lucky"
	--按钮特效
	Animation:createKuaisu(self.btn_startGame:getChildByName("img"):getChildByName("eff"))
    self.btn_startGame:setVisible(false)

    local ani = Animation:createCSExpressionAni(20000)
    self.btn_shangcheng:addChild(ani)
    ani:setPosition(100,30)
    --每日首冲
    self:showBtnFirstChargeAni()
    --幸运转盘
    local aniLucky = Animation:createCSExpressionAni(20006)
    self.btn_lucky:addChild(aniLucky,-1)
    aniLucky:setPosition(cc.p(self.btn_lucky:getContentSize().width/2, 40))
    --金币抽奖
    local aniGoldDraw = Animation:createCSExpressionAni(20013)
    self.btn_goldDraw:addChild(aniGoldDraw,-1)
    aniGoldDraw:setPosition(cc.p(self.btn_goldDraw:getContentSize().width/2, 40))
    --招财特效
    local aniFortune,aniForTuneAction = Animation:createForTuneAni()
    self._aniForTuneAction = aniForTuneAction
    self.btn_fortune:addChild(aniFortune,-1)
    aniFortune:setPosition(cc.p(self.btn_fortune:getContentSize().width/2, 43))
    Animation:createGold(self.sp_gold)
	Animation:createQuan(self.sp_voucher)

	GameSocket:addDataHandler(MDM_GP_LIST,nil,self,self.onGetRoomInfo)--获取房间返回
	GameSocket:addDataHandler(MDM_GP_LIST,ASS_GP_GET_GAMELEVEL_PEOPLE_COUNT,self,self.onShowSingleGamePeople)--显示某个游戏以及房间人数
	-- GameSocket:addDataHandler(MDM_GP_LIST,ASS_GP_GET_GAME_PEOPLE_COUNT,self,self.onShowAllGamePeople)--显示游戏以及房间人数
	RoomSocket:addDataHandler(MDM_GR_LOGON,nil,self,self.onLoginRoom)--登录房间返回
	-- RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_NoMoneyTickRoom,self,self.onNotEnoughGold)

	GameSocket:addDataHandler(MDM_GP_BATTLE_MSG,ASS_GP_BATTLE_USER_SIGNUP_INFO_REQ,self,self.onBattleSignUpReq)--玩家报名信息
	GameSocket:addDataHandler(MDM_GP_BATTLE_MSG,ASS_BATTLE_MATCH_WILL_BEGIN_NOTIFY,self,self.onMatchNoticeStart)--即时赛比赛即将开赛通知
	--RoomSocket:addDataHandler(MDM_GR_BATTLE_MSG,ASS_GR_MATCH_BEGIN,self,self.onMatchBegin)--即时赛比赛即将开赛通知
	GameSocket:addDataHandler(MDM_GP_PROP,ASS_PROP_GETUSERPROP,self,self.onUpdateItem)--道具
	GameSocket:addDataHandler(MDM_GP_MAIL,ASS_GP_MAIL_NEW,self,self.onResNewMail)--新邮件通知
	GameSocket:addDataHandler(MDM_GP_MAIL,ASS_GP_MAIL_ALL,self,self.onRecMailData) --获取所有邮件
	GameSocket:addDataHandler(MDM_GP_MAIL,ASS_GP_MALL_REQ_NEW,self,self.onRecNewMailData)--获取新增邮件
	--GameSocket:addDataHandler(MDM_GP_MAIL,ASS_GP_MAIL_ALL,self,self.onRecMailData)
	util.addSchedulerFuns(self,function() GameSocket:sendMsg(MDM_GP_MAIL,ASS_GP_MAIL_ALL) end)
	GameSocket:sendMsg(MDM_GP_TASK,ASS_GP_TASKLIST)
	GameSocket:addDataHandler(MDM_GP_TASK,ASS_GP_TASKLIST,self,self.onRecTakData)
	GameSocket:addDataHandler(MDM_GP_TASK,ASS_GP_TASK_FINISH_NOTICE,self,self.onFinshTaskData)

	--好友房消息
	GameSocket:addDataHandler(MDM_GP_VIP_LOGE,ASS_GP_HAS_CREATE_FRIEND_ROOM,self,self.onUpdateCreateFriendRoom)
	
	GameSocket:addDataHandler(MDM_GP_VIP_LOGE,ASS_GP_JOIN_FRIEND_ROOM,self,self.onJoinFriendRoom)
	GameSocket:addDataHandler(MDM_GP_LIST,ASS_GP_GET_ROOM_BY_ID,self,self.onGetRoomInfos)--获取房间返回
	GameSocket:addDataHandler(MDM_GP_VIP_LOGE,ASS_GP_CREATE_FRIEND_ROOM,self,self.onCreateFriendRoomSuc)--创建房间回包
	-- RoomSocket:addDataHandler(MDM_GR_VIP_LOGE,ASS_GR_VIP_ROOM_OWNER_DISSOLVED,self,self.onDissolvedFriendRoom)--房主解散房间
	GameSocket:addDataHandler(MDM_GP_VIP_LOGE,ASS_GP_DISSOLVED_FRIEND_ROOM,self,self.onDissolvedFriendRoom)

	GameEvent:addEventListener(GameEvent.updatePlayer,self,self.onUpdatePlayer)
	GameEvent:addEventListener(GameEvent.updateBoolFirst,self,self.showBtnFirstChargeAni) --刷新首充
	GameEvent:addEventListener(GameEvent.updateRedMoney,self,self.onUpdateRedMoney)
	GameEvent:addEventListener(GameEvent.startGame,self,self.onStartGame)
	GameEvent:addEventListener(GameEvent.isGame,self,self.onIsGame)
	GameEvent:addEventListener(GameEvent.updateFortuneAni,self,self.onUpdateFortuneAni) -- 刷新招财进宝特效
	GameEvent:addEventListener(GameEvent.updateMail,self,self.onUpdateMail)
   	GameEvent:addEventListener(GameEvent.updateTaskInfo,self,self.UpdateTaskFinshInfo)
	GameEvent:addEventListener(GameEvent.updatefriRoominfo,self,self.onUpdateFriendRoom)
	GameEvent:addEventListener(GameEvent.bNewMail,self,self.onResNewMail)--新邮件通知
	GameEvent:addEventListener(GameEvent.updateResurrectionTM,self,self.updateResurrectionTM)
	-- GameEvent:addEventListener(GameEvent.updateLimitActivity,self,self.updateLimitActivity)--限时活动窗口
	GameEvent:addEventListener(GameEvent.upGradeVip,self,self.updateVipInfo)
	GameEvent:addEventListener(GameEvent.updateDDZSignUpInfo,self,self.onUpdateDDZSignUpInfo)
	GameEvent:addEventListener(GameEvent.updateShow7TaskSign,self,self.onUpdateShow7TaskSign) --通知显示新手7天签到任务
	PlayerData:setIsGame(false)

	util.addEventBack(self,handler(self,self.onBackKeyPressed))
	GameSocket:addDataHandler(MDM_GP_RED,ASS_GP_ACCEPT_RED,self,self.onRecHongbao)--收到红包
	GameSocket:addDataHandler(MDM_GP_BATTLE_MSG,ASS_GP_BATTLE_USER_SIGNUP_REFRESH,self,self.onUpdateUserSignUp)--更新用户报名人数
	GameSocket:addDataHandler(MDM_GP_BATTLE_MSG,ASS_GP_BATTLE_USER_SIGN_UP_REQ,self,self.onBattleSignUp)--即时赛报名

	GameSocket:addDataHandler(MDM_GR_SOCKET_CLOSE,ASS_GR_ZSERVER_RELOG_KICK,self,self.onKick)--登录服务器返回
	RoomSocket:addDataHandler(MDM_GR_SOCKET_CLOSE,ASS_GR_ROOM,self,self.onKickToHall)--登录服务器返回
	GameSocket:addDataHandler(MDM_WEB_MAIN_ID,ASS_WEB_MSG_FORBID_USER,self,self.onKick)--登录服务器返回

	GameSocket:addDataHandler(MDM_WEB_MAIN_ID,ASS_WEB_MSG_FOLLOW_WECHAR,self,self.onWebFollowWechar)--关注微信完成
	GameSocket:addDataHandler(MDM_WEB_MAIN_ID,ASS_WEB_MSG_RECEIVE_WECHAR_PRIZE,self,self.onResNewMail)--微信关注邮件奖励
	GameSocket:addDataHandler(MDM_WEB_MAIN_ID,ASS_WEB_MSG_HEAD_VERIFY_FAIL,self,self.onHeadReset)--还原默认头像

	-- GameSocket:addDataHandler(MDM_GP_LOGON,ASS_GP_LOGON_SUCCESS,self,self.onSuccessLogin)--登录大厅成功
	GameSocket:addDataHandler(MDM_GP_LOGON,ASS_GP_LOGON_SUCCESS_ADD,self,self.onAddSuccessLogin)--登录大厅成功
	GameSocket:addDataHandler(MDM_GP_USERREFLASH,ASS_GP_USERREFLASH,self,self.onUpdateUserCoin)
	GameSocket:addDataHandler(MDM_GP_USERREFLASH,ASS_GP_USERREFLASH_NOTICE,self,self.onNoticeUserReflash)

	GameSocket:addDataHandler(MDM_GP_RED,ASS_GP_GET_PIAZZA_RED,self,self.onGetSquareRedInfo)--获取广场红包
	GameSocket:addDataHandler(MDM_GP_RED,ASS_GP_NEW_PIAZZA_RED,self,self.onNewPiazzaRed)--收到新的广场红包
	GameSocket:addDataHandler(MDM_GP_RED,ASS_GP_DEL_PIAZZA_RED,self,self.onDelPiazzaRed)--红包下架
	GameSocket:addDataHandler(MDM_GP_RED,ASS_GP_PIZZA_RED_INFO,self,self.onPlayerRedStation)--玩家玩家红包信息
	GameSocket:addDataHandler(MDM_GP_RED,ASS_GP_MY_PIAZZA_RED_INFO,self,self.onGetMyRecordInfo)--获取玩家红包信息

	GameSocket:addDataHandler(MDM_GP_MAQ_MSG,ASS_GP_MAQ_MSG_NOTIFY,self,self.onServerInfo)
	GameSocket:addDataHandler(MDM_GP_ACTIVE,ASS_ACTIVELIST,self,self.onActiveList)
	--切换到主界面
	print("gameId_cofig wocaoocaocaocoaocao")
	-- self:wocoaocaocaoco()
	-- mlog("gameId_cofig.MAIN wwwwwwwwwwww", gameId_cofig.MAIN)
	-- print("gameId_cofig.MAIN", gameId_cofig.MAIN)
	-- self:onSelectGameType(gameId_cofig.MAIN)
	--异步创建二级界面图标
	-- self.groundNode:initListItems()

	-- RoomSocket:addDataHandler(MDM_GR_PROP,ASS_PROP_BUYGOLD,self,self.onRoomPropBuyGold)--房间购买金币
	-- --收到领取任务信息
	-- GameSocket:addDataHandler(MDM_GP_TASK,ASS_GP_TASK_RECEIVE_REWARD,self,self.onReceiveAward)
	-- --七天任务之分享
	-- GameSocket:addDataHandler(MDM_GP_TASK,ASS_GP_TASK_WX_SHARE,self,self.onReceiveShare)
	-- GameEvent:addEventListener(GameEvent.gameBackFromGround,self,self.gameBackFromGround)

	-- self._bPositive = 1
	-- self._curPositive = 1
	-- if not util.isExamine() then 
 --    	util.delayCall(self.btn_Active_01,function()
	-- 		self:showActiveAni(true)
	-- 	end,7,true)
 --    end
	
	-- self:initWebData()
end

function SelectGame:showActiveAni( bPositive )
	if self._isAning then
		return
	end
	
	self._isAning = true
	local width = self.btn_Active_01:getParent():getContentSize().width / 2
	-- self._bShowRule = not self._bShowRule
	local this = self
	if bPositive then
		if self._bPositive >= 2 then
			self._bPositive = 1
		else
			self._bPositive = self._bPositive + 1
		end
	else
		if self._bPositive <= 1 then
			self._bPositive = 2
		else
			self._bPositive = self._bPositive - 1
		end
	end

	local moveTo1
	if bPositive then
		self["btn_Active_0" .. self._bPositive]:setPositionX(-width)
		moveTo1 = cc.MoveTo:create(0.7,cc.p(width*3,0))
	else 
		self["btn_Active_0" .. self._bPositive]:setPositionX(width*3)
		moveTo1 = cc.MoveTo:create(0.7,cc.p(-width,0))
	end 
	local callFunc1 = cc.CallFunc:create(function() 
		self._curPositive = self._bPositive
		for i=1,2 do
			if i == self._curPositive then
				util.loadImage(this["_img_ative_tip_0" .. i],"img2/hall/y1.png")
			else
				util.loadImage(this["_img_ative_tip_0" .. i],"img2/hall/y2.png")
			end
		end
		
		this._isAning = false 
	end)
	self["btn_Active_0" .. self._curPositive]:runAction(cc.Sequence:create(moveTo1, callFunc1))
	local moveTo2 = cc.MoveTo:create(0.7,cc.p(width,0))
	self["btn_Active_0" .. self._bPositive]:runAction(cc.Sequence:create(moveTo2))
end

function SelectGame:gameBackFromGround(info)
	local timeDiff = info.data
	if timeDiff and timeDiff>20 and GameSocket:isconnect() then
		GameEvent:notifyView(GameEvent.showLoading,{GameSocket})
		GameSocket:setIsChecking(true)
		GameSocket:checkConnect("后台切回来")
	end
end

function SelectGame:onReceiveShare(res, uAssistantID, stateType, head)
	if not head then
		Alert:showTip("任务完成失败")
		return
	end
	if head.uHandleCode == 0 then
		if res.iTaskType == 0 then
			PlayerTaskData:setCompleteCount({iGameType=0,taskType=10})
			Alert:showTip("分享成功", 3)
		elseif res.iTaskType == 1 then
			Alert:showTip("分享成功", 3)
			_uim:closeLayer(ui.oneLotteryReward)
			_uim:closeLayer(ui.tenLotteryReward)
		elseif res.iTaskType == 2 then
			PlayerData:setGameCoin(30,false)
        	PlayerData:setPlayerResurrect(PlayerData:getServerTime())
			Alert:showTip("分享成功，已复活", 3)
			_uim:closeLayer(ui.noMenpiaoRevive)
		end
	elseif  head.uHandleCode == 1 then
		Alert:showTip("分享任务，领取次数已达上限")
	elseif  head.uHandleCode == 2 then
		Alert:showTip("分享任务，不满足领取时间")
	else
		Alert:showTip("任务完成失败")
		trace("error:分享任务完成失败,uHandleCode = ",head and head.uHandleCode or "nil")
	end
end

function SelectGame:onReceiveAward(res, uAssistantID, stateType, head)
	if head and head.uHandleCode == 0 then
		if res and res.iTaskID and res.iTaskID == 101 and res.iSign == 1 then
			_uim:showLayer(ui.pochang_buzhu,false)
		end
	elseif head and head.uHandleCode == 3 then
		if res and res.iTaskID and res.iTaskID == 101 then
			PlayerData:ModifyTaskDataValue(res.iTaskID, TemplateData:getPalyerTaskCount(res.iTaskID))
		elseif  res and res.iTaskID then
			PlayerData:ModifyTaskDataValue(res.iTaskID, TemplateData:getPalyerTaskCount(res.iTaskID))
		end
	end
end

function SelectGame:onRoomPropBuyGold(res, uAssistantID, stateType, head)
	if head and head.uHandleCode == 0 then
		Alert:showTip("购买成功",2)
		PlayerData:onItemBuySucc(res.nPropID,1)
	else
		Alert:showTip("购买失败",2)
	end
end

function SelectGame:initWebData( ... )
	local _host = "http://wx." .. util.curDomainName() .. "/Handler/Common.ashx?"
	util.delayCall(self,function()
		util.postJson(_host .. "action=actlist",{userid=PlayerData:getUserID()},function(suc, res)
			if suc then
				PlayerData:setStorageActivityInfo(res)
			end
		end)
	end,0.1)
	util.delayCall(self,function()
		util.postJson(_host .. "action=gamenatice",{},function(suc, res)
			if suc then
				PlayerData:setStorageNoticeInfo(res)
			end
		end)
	end,0.5)
	PlayerData:sendWebForTune()
end

function SelectGame:onActiveList( res )
	local tbl = {}
	if res and res.iCount then
		for i=0,res.iCount-1 do
			table.insert(tbl,res.activeInfo[i])
		end
	end
	PlayerData:setActiveList(tbl)
end

function SelectGame:onServerInfo( res )
	if res then
		local str = ""
		if res.bMaqType == 3 then
			return
		elseif res.bMaqType == 0 then
			str = res.NickName .. "："  .. res.szMsgContent
		elseif res.bMaqType == 4 then
			str = "【系统】"  .. res.szMsgContent
		else
			str = res.szMsgContent
		end
		res.iTime = PlayerData:getServerTime()
		PlayerData:setGameMsg(res)
		res.str = str
		PlayerData:showGameMsg(res,true)
	end
end

function SelectGame:onGetMyRecordInfo( res )
	if res.iSendFlag == 0 or res.iSendFlag == 1 then
		PlayerData:setMyTblRedSquare({})
	end

	local data = PlayerData:getMyTblRedSquare()
	if res.iSendCount and res.info then
		for i=0,res.iSendCount-1 do
			table.insert(data,res.info[i])
		end
	end
	table.sort(data,function(a,b) return a.tCreateTime>b.tCreateTime end)
	PlayerData:setMyTblRedSquare(data)
	--GameEvent:notifyView(GameEvent.updateMyRedSquare)
end

function SelectGame:onPlayerRedStation( res,param2,param3,head)
	if res then
		PlayerData:setIsNewMyRedRecore(true)
		PlayerData:ModifyStateMyRed(res)
		local tbl = PlayerData:getMyRedById(res.iID)
		if tbl and tbl.iID then
			if not tbl.szRemark or string.len(tbl.szRemark) <= 0 then
				tbl.szRemark = "恭喜发财 大吉大利"
			end
			if res.iType == 0 then
				--Alert:showTip("您成功发送了红包“" .. tbl.szRemark .. "”，金额为" .. tbl.iRedAmount .. "金币。",2)
			elseif res.iType == 1 then
				Alert:showTip("红包已到期，金额请通过邮件领取",2)
				--Alert:showTip("您的红包“" .. tbl.szRemark .. "”已到期，" .. tbl.iRedAmount .. "金币已退回，请通过邮件领取。",2)
			elseif res.iType == 2 then
				Alert:showTip("红包已回收，金额请通过邮件领取",2)
				--Alert:showTip("您的红包“" .. tbl.szRemark .. "已下架，" .. tbl.iRedAmount .. "金币已退回，请通过邮件领取。",2)
			elseif res.iType == 3 then
				Alert:showTip("您的红包“" .. tbl.szRemark .. "”被" .. tbl.nickName .. "猜中了。",2)
			elseif res.iType == 4 then
				Alert:showTip("您已同意" .. tbl.nickName .. "猜红包的奖励请求。",2)
			elseif res.iType == 5 then
				Alert:showTip("您已拒绝" .. tbl.nickName .. "猜红包的奖励请求。",2)
			elseif res.iType == 6 then
				Alert:showTip("恭喜您猜对了" .. tbl.nickName .. "的红包，请等待发送方确认",2)
			elseif res.iType == 7 then
				Alert:showTip(tbl.nickName .. "已通过了您的红包请求，获得" .. tbl.iRedAmount .. "金币奖励。",2)
			elseif res.iType == 8 then
				Alert:showTip(tbl.nickName .. "已拒绝了您的红包请求。",2)
			end
		end
	end
end

function SelectGame:onDelPiazzaRed( res )
	if res then
		PlayerData:delItemSquareRed(res.iRedNo)
	end
end

function SelectGame:onNewPiazzaRed( res )
	if PlayerData:getIsSendSquareRedReq() then
		local data = PlayerData:getTblSquareRed()
		table.insert(data,res)
		table.sort(data,function(a,b) 
			if a.tCreateTime ~= b.tCreateTime then
				return a.tCreateTime>b.tCreateTime
			else
				return a.iID>b.iID
			end
		end)
		PlayerData:setTblSquareRed(data)
		GameEvent:notifyView(GameEvent.updateRedSquare)
	end
end

function SelectGame:onGetSquareRedInfo( res )
	if res.iSendFlag == 0 or res.iSendFlag == 1 then
		PlayerData:setTblSquareRed({})
	end

	local data = PlayerData:getTblSquareRed()
	if res.iSendCount and res.info then
		for i=0,res.iSendCount-1 do
			table.insert(data,res.info[i])
		end
	end
	table.sort(data,function(a,b)
		if a.tCreateTime ~= b.tCreateTime then
			return a.tCreateTime>b.tCreateTime
		else
			return a.iID>b.iID
		end
	end)
	PlayerData:setTblSquareRed(data)
	if res.iSendFlag == 0 or res.iSendFlag == 3 then
		GameEvent:notifyView(GameEvent.updateRedSquare)
	end
end

function SelectGame:onNoticeUserReflash( res )
	GameSocket:sendMsg(MDM_GP_USERREFLASH,ASS_GP_USERREFLASH)
end

function SelectGame:onUpdateUserSignUp( res )
	if res then
		 PlayerData:setSignupUserCnt(res.iSignupUserCnt)
	end
end

function SelectGame:onUpdateUserSignUp( res )
	if res then
		PlayerData:setSignupUserCnt(res.iSignupUserCnt)
	end
end

function SelectGame:onRecHongbao(res)
	res.node = self
	GameEvent:notifyView(GameEvent.getHongbao,res)
end

--切换到主界面
function SelectGame:onSelectGameType(data)
	-- self.groundNode:onSelectGameType(data)
end

function SelectGame:onBackKeyPressed()
	if self._gameId == gameId_cofig.MAIN then
		sdkManager:exitGame()
	else
		self:onSelectGameType()
	end
end

function SelectGame:onUpdateShow7TaskSign( ... )
	if self.btn_hongbao:isVisible() then
		return
	end
	--显示新手7天任务按钮
	self.btn_hongbao:setVisible(true)
	local ani = Animation:createCSExpressionAni(20012)
    self.btn_hongbao:addChild(ani)
    ani:setPosition(110,40)
end

function SelectGame:onUpdateDDZSignUpInfo( ... )
	self.groundNode:onUpdateDDZSignUpInfo()
end

function SelectGame:onUpdateFriendRoom( ... )
	-- trace("=============解散房间成功呢=============")
	if PlayerData:getCreateFriRoom() then
		if PlayerData:getCreateFriRoom().bHasCreate then
			self.groundNode:onShowCreateIcon(PlayerData:getCreateFriRoom().iRoomLevel)
		else
			self.groundNode:onShowCreateIcon(-1)
		end
	else
		self.groundNode:onShowCreateIcon(-1)
	end
end

function SelectGame:UpdateTaskFinshInfo( ... )
	if PlayerData:getTaskData() then
		local bFind = false
		for k,v in pairs(PlayerData:getTaskData().TaskInfo) do
			if v.cbTaskValue == 1 and v.iTaskID ~= 101 and v.iTaskID ~= 102 then
				bFind = true
				self.sp_new_task:setVisible(true)
				break
			 end
		end
		if bFind == false then
			self.sp_new_task:setVisible(false)
		end
	end
end

function SelectGame:onUpdateMail()
	if PlayerData:getMailNum() <= 0 then
		self.sp_newMail:setVisible(false)
		self._hasNewMail = false
	else
		self.sp_newMail:setVisible(true)
	end
end

function SelectGame:onUpdateFortuneAni(info)
	if info.data then
		self._aniForTuneAction:play("zhaocaijinbao", true)
	else
		self._aniForTuneAction:gotoFrameAndPause(1)
	end
end

function SelectGame:onIsGame( )
	if not PlayerData:getIsGame() then
		_am:playMusic("audio/hall_background_music.mp3" ,true)
	elseif PlayerData:getIsGame() then
		util.stopMusic()
	end
end

function SelectGame:onUpdateRedMoney( ... )
	self.sp_new_redMoney:setVisible(true)
end

function SelectGame:onUpdatePlayer()
	if not self or not self:intiPlayerData() then
		return
	end
	self:intiPlayerData()
	self:UpdateTaskFinshInfo()
end

function SelectGame:onDissolvedFriendRoom( res )
	Alert:showTip("该房间已被解散",2)
	PlayerData:setCreateFriRoom({bHasCreate=false,iRoomID=0})
end

function SelectGame:onCreateFriendRoomSuc( res, uAssistantID, stateType, head  )
	traceObj(res)
	if head and head.uHandleCode == 0 or head and head.uHandleCode == 0x09 then
		local roomInfo =
		{
			bHasCreate = true,
			iRoomID = res.iRoomID,
			iRoomLevel = res.iRoomLevel,
			iGameNameID = res.iGameNameID,
		}
		local tbl = {}
		tbl.cbSitFlag = 0
		if res.iRoomID and res.iRoomID > 0 then
			tbl.szPassword = res.iRoomPwd
		end
		traceObj(tbl)
		PlayerData:setFriendRoomInfo(tbl)

		self._iCurGameId = res.iGameNameID
		PlayerData:setCreateFriRoom(roomInfo)
		self:onCreateRoom(roomInfo)
	elseif head and head.uHandleCode == 0x02 then
		Alert:showTip("金币不足", 3)
	elseif head and head.uHandleCode == 0x10 then
		if res and res.iRoomLevel and res.iRoomLevel > 4 and res.iRoomLevel < 8 then
			Alert:showTip("【" .. crazyRoomInfo[res.iRoomLevel].name .. "】VIP房间已满", 3)
		else
			Alert:showTip("创建房间失败", 3)
		end
	elseif head and head.uHandleCode == 0x13 then
		Alert:showTip("已加入好友房", 3)
	elseif head and head.uHandleCode == 0x14 then
		Alert:showTip("周卡月卡失效", 3)
	elseif head and head.uHandleCode == 0x15 then
		Alert:showTip("正在其他游戏房间", 3)
	else
		Alert:showTip("创建房间失败", 3)
	end
end

function SelectGame:onGetRoomInfos( res,uAssistantID )
	traceObj(res)
	if res then
		local roomIP = res.szProxySrvIP
		local roomProt = res.szProxySrvPort
		if roomIP == "" then
			roomIP = util.numtoIp(res.szServiceIP)
		end
		if roomProt == 0 then
			roomProt = res.uServicePort
		end
		trace(roomIP,roomProt)
		if RoomSocket:isconnect() then
			RoomSocket:disconnect()
		end

		local tbl = {
			uNameID     = self._iCurGameId,                 --名字 ID
			dwUserID    = PlayerData:getUserID(),                   --用户 ID
			uRoomVer    = 1,                    --大厅版本， 此字段以前没有实际的应用，现在被改为手机与pc客户端的标志. 0 为PC客户端 1为手机
			uGameVer    = PlayerData:getUserID(),               --游戏版本
			szMD5Pass   = PlayerData:getPassWord(),                 --加密密码
			nTokenID    = PlayerData:getMAC(),                  --MAC地址
			szSign = PlayerData:getLoginRoomMD5(self._iCurGameId),
		}

		RoomSocket:connect(roomIP,roomProt,function()
			traceObj(tbl)
			PlayerData:setReLoginByID(tbl)
			RoomSocket:sendMsg(MDM_GR_LOGON,ASS_GR_LOGON_BY_ID,tbl)
		end)
	end
end

function SelectGame:onJoinFriendRoom( res, uAssistantID, stateType, head )
	traceObj(res)
	if head and head.uHandleCode == 0  then
		if res then
			local tbls = 
			{
				uNameID = res.iGameNameID,
				iRoomLevel = res.iRoomLevel,
				uKindID = 2
			}
			PlayerData:setCurRoomInfo(tbls)

			local tbl = {}
			tbl.cbSitFlag = 1
			if res.iRoomID and res.iRoomID > 0 then
				tbl.szPassword = res.iRoomPwd
			end
			PlayerData:setFriendRoomInfo(tbl)
			local roomInfo =
			{
				bHasCreate = false,
				iRoomID = res.iRoomID,
				iRoomLevel = res.iRoomLevel,
				iGameNameID = res.iGameNameID,
				iRoomPwd = res.iRoomPwd,
			}
			PlayerData:setCreateFriRoom(roomInfo)
			GameSocket:sendMsg(MDM_GP_LIST,ASS_GP_GET_ROOM_BY_ID,{uRoomID = res.iRoomID})
		end
	end
end

function SelectGame:onUpdateCreateFriendRoom( res )
	if res and res.iRoomID > 0 then
		local roomInfo =
		{
			bHasCreate = res.bHasCreate,
			iRoomID = res.iRoomID,
			iRoomLevel = res.iRoomLevel,
			iGameNameID = res.iGameNameID,
			iRoomPwd = res.iRoomPwd
		}
		local tbl = {}
		if res.bHasCreate then
			tbl.cbSitFlag = 0
		else
			tbl.cbSitFlag  = 1
		end
		if res.iRoomID and res.iRoomID > 0 then
			tbl.szPassword = res.iRoomPwd
		end
		traceObj(tbl)
		PlayerData:setFriendRoomInfo(tbl)
		PlayerData:setCreateFriRoom(roomInfo)
		self._iCurGameId = res.iGameNameID
		self:onCreateRoom(roomInfo)
	end
end

function SelectGame:onFinshTaskData( res )
	if res and res.iTaskID then
		PlayerData:ModifyTaskData(res.iTaskID, 1)
	end
end

function SelectGame:UpdateTaskFinshInfo( ... )
	if PlayerData:getTaskData() then
		local bFind = false
		for k,v in pairs(PlayerData:getTaskData().TaskInfo) do
			if v.cbTaskValue == 1 and v.iTaskID ~= 101 and v.iTaskID ~= 102 then
				bFind = true
				self.sp_new_task:setVisible(true)
				break
			 end
		end
		if bFind == false then
			self.sp_new_task:setVisible(false)
		end
	end
end

function SelectGame:onRecTakData( res )
	if res then
		local data = res.TaskInfo
		TemplateData:sortTask(res.TaskInfo)
		PlayerData:setTaskData(res)
		self:UpdateTaskFinshInfo()
		self._bIsTaskInfo = true
	end
end

function SelectGame:onRecNewMailData( res )
	local data = PlayerData:getMailData()
	if res.iSendCount and res.mailInfo then
		for i=0,res.iSendCount-1 do
			table.insert(data,res.mailInfo[i])
		end
	end
	table.sort(data,function(a,b) return a.tmMailTime>b.tmMailTime end)
	PlayerData:setMailData(data)
end

function SelectGame:onRecMailData(res)
	if res.iSendFlag == 0 or res.iSendFlag == 1 then
		PlayerData:setMailData({})
	end

	local data = PlayerData:getMailData()
	if res.iSendCount and res.mailInfo then
		for i=0,res.iSendCount-1 do
			table.insert(data,res.mailInfo[i])
		end
	end
	table.sort(data,function(a,b) return a.tmMailTime>b.tmMailTime end)
	PlayerData:setMailData(data)
end

function SelectGame:onResNewMail()
	self.sp_newMail:setVisible(true)
	GameSocket:sendMsg(MDM_GP_MAIL,ASS_GP_MALL_REQ_NEW)
end

function SelectGame:onUpdateItem(res)
	local iSendCount = res.iSendCount
	local data = res.msgPropGet
	local result = {}
	for i=0,iSendCount -1 do
		result[i] = data[i]
	end
	PlayerData:setItems(result)
end

function SelectGame:onMatchNoticeStart( res )
	RoomSocket:addReconnetCallback(self,handler(self,self.reLogin))
	if res then
		local iMatchInfo = table.copy(PlayerData:getUserMatchInfo())
		if iMatchInfo then
			for k,v in pairsKey(iMatchInfo) do
				if v.iMatchID == res.iMatchID then
					v.bSignUp = false
					break
				end
			end
			PlayerData:setUserMatchInfo(iMatchInfo)
		end
		PlayerData:setSignupUserCnt(0)
		PlayerData:setCurMatchID(res.iMatchID,1)
		util.popAllModleWin()
		_lym:cleanLayerMap()
		_uim:showLayer(ui.match_game)
	end
end

function SelectGame:onBattleSignUpReq( res )
	if res then
		local signupReq = {}

		for i=0,res.iMatchCount-1 do
			if res.info[i] then
				table.insert(signupReq, res.info[i])
			end
		end
		PlayerData:setUserMatchInfo(signupReq)
	end
end

function SelectGame:onLoginRoom(res,uAssistantID,stateType, head)
	if uAssistantID == ASS_GR_LOGON_ERROR then
		if head.uHandleCode == 8 then
			local roomName = res and res.szRoomName
			if roomName and roomName~="" then
				_uim:showLayer(ui.wordstip,"正在"..roomName.."中...")
			end
			Alert:showCheckBoxQianWang("正在"..roomName.."中",function() 
				self._iCurGameId = res and res.iGameNameID
				local tbl = 
				{
					uRoomID = res and res.iRoomID
				}
				local tbls = 
				{
					uNameID = self._iCurGameId,
					iRoomLevel = res and res.iRoomLevel,
					uKindID = 1
				}

				if res.iRoomPwd and res.iRoomPwd > 0 then
					local tbl = {}
					tbl.cbSitFlag = 0
					tbl.szPassword = res.iRoomPwd
					PlayerData:setFriendRoomInfo(tbl)
					local roomInfo =
					{
						bHasCreate = true,
						iRoomID = res.iRoomID,
						iRoomLevel = res.iRoomLevel,
						iGameNameID = res.iGameNameID,
						iRoomPwd = res.iRoomPwd,
					}
					PlayerData:setCreateFriRoom(roomInfo)
				end
				
				PlayerData:setCurRoomInfo(tbls)
				GameSocket:sendMsg(MDM_GP_LIST,ASS_GP_GET_ROOM_BY_ID,tbl)
			end)
		elseif head and head.uHandleCode == 14 then
			GameSocket:sendMsg(MDM_GP_USERREFLASH,ASS_GP_USERREFLASH)
			Alert:showTip("金币不足",2)
		elseif head and head.uHandleCode == 22 then
			if res.iGameNameID == gameId_cofig.GRABRED_LOARDS then
				local info = self:getGrabreRoomInfo({uNameID = res.iGameNameID,iRoomLevel= res.iRoomLevel})
				if PlayerData:getForTurnTime() - (PlayerData:getServerTime() - PlayerData:getPlayerInfoAdd().tmResurrectionTM) <= 0 and iRoomLevel == 1 then
					_uim:showLayer(ui.resurreMole)
				else
					_uim:showLayer(ui.noMenpiaoRevive, {ibResToday = res.iRoomLevel == 1,iTargeGameCoin=info.gold1})
				end
			end
		end
	elseif uAssistantID == ASS_GR_LOGON_SUCCESS then
		PlayerData:setPlayerRoomData(res.pUserInfoStructApp)
		_lym:cleanLayerMap()
		--加入
		if self._iCurGameId == gameId_cofig.CONTEST_POKER then
			_uim:showLayer(ui.match_game)
			return
		end
		if self._iCurGameId == gameId_cofig.CONTEST_POKERS then
			if self._bIsGameRoom then
				_uim:showLayer(ui.match_game)
				self._bIsGameRoom = false
				self:setVisible(false)
			end
			return
		end
		if PlayerData:getCurRoomInfo() then
			local tbl = PlayerData:getCurRoomInfo()
			--if tbl.uNameID == gameId_cofig.HAPPY_POKER then
			if tbl.uNameID == gameId_cofig.GRABRED_LOARDS then
				_uim:showLayer(ui.grabredlords_game)
			elseif tbl.uNameID == gameId_cofig.KANPAI then
				_uim:showLayer(ui.watchbrand_game)
			elseif tbl.uNameID == gameId_cofig.BAIREN then
				_uim:showLayer(ui.hundredniuniu_game)
			elseif tbl.uNameID == gameId_cofig.PKSC then
				_uim:showLayer(ui.pksaiche_game)
			elseif tbl.uNameID == gameId_cofig.Friend_POKER then
				RoomSocket:sendMsg(MDM_GR_USER_ACTION,ASS_GR_FRIEND_USER_SIT,PlayerData:getFriendRoomInfo())
				_uim:showLayer(ui.friend_game)
			elseif tbl.uNameID == gameId_cofig.SHUIGUO then
				_uim:showLayer(ui.fruits_game)
			elseif tbl.uNameID == gameId_cofig.HUANLEBIPAI then
				_uim:showLayer(ui.crazyGame)
			elseif tbl.uNameID == gameId_cofig.CRAZY_FRIEND_GAME then
				RoomSocket:sendMsg(MDM_GR_USER_ACTION,ASS_GR_FRIEND_USER_SIT,PlayerData:getFriendRoomInfo())
				_uim:showLayer(ui.crazyGameFriend)
			end
			self:setVisible(false)
		end
		self._iCurGameId = self._gameId
	else
		trace("登录房间未知结果uAssistantID = ",uAssistantID)
	end
end

function SelectGame:onGetRoomInfo(res,uAssistantID,stateType, head)
	if uAssistantID == ASS_GP_GET_ROOM_ERROR then
		trace("房间消息获取失败")
		GameEvent:notifyView(GameEvent.hideLoading)
	elseif uAssistantID == ASS_GP_GET_ROOM_TIME_ERROR then
		traceObj(res)
		Alert:showTip(res.szRemark, 3)
		GameEvent:notifyView(GameEvent.hideLoading)
	elseif uAssistantID == ASS_GP_GET_ROOM then
		trace("收到获取房间消息成功,",PlayerData:getServerTime())
		local tbl = {
			uNameID		= self._iCurGameId,					--名字 ID
			dwUserID	= PlayerData:getUserID(),					--用户 ID
			uRoomVer	= 1,					--大厅版本， 此字段以前没有实际的应用，现在被改为手机与pc客户端的标志. 0 为PC客户端 1为手机
			uGameVer	= PlayerData:getUserID(),				--游戏版本
			szMD5Pass	= PlayerData:getPassWord(),					--加密密码
			nTokenID	= PlayerData:getMAC(),					--MAC地址
			szSign 		= PlayerData:getLoginRoomMD5(self._iCurGameId),
		}
		local roomIP = res.szProxySrvIP
		local roomProt = res.szProxySrvPort
		if roomIP == "" then
			roomIP = util.numtoIp(res.szServiceIP)
		end
		if roomProt == 0 then
			roomProt = res.uServicePort
		end

		trace(roomIP,roomProt)

		if RoomSocket:isconnect() then
			RoomSocket:disconnect()
		end
		RoomSocket:connect(roomIP,roomProt,function()
			PlayerData:setPlayerRoomiBasePoint(res.iBasePoint)
			PlayerData:setPlayerRoomiLessPoint(res.iLessPoint)
			PlayerData:setReLoginByID(tbl)
			trace("发送登录房间消息,",PlayerData:getServerTime())
			RoomSocket:sendMsg(MDM_GR_LOGON,ASS_GR_LOGON_BY_ID,tbl)
		end)
		
	end
end

function SelectGame:onShowSingleGamePeople( res )
	if res and res.iGameNameID and res.iGameNameID == gameId_cofig.BAIREN then
		self._bairenRoomPeople = {}
		for i=0,res.iGameLevelCount-1 do
			table.insert(self._bairenRoomPeople,res.gameLevelPeople[i])
		end
		self.groundNode:updateSingleGamePeople(res.iGameNameID)
	end
end

function SelectGame:showBtnFirstChargeAni( ... )
	if PlayerData:hasFirstCharged() then
		self.btn_firstCharge:getChildByName("img"):setVisible(true)
		local aniFirst = self.btn_firstCharge:getChildByTag(10)
		if not tolua.isnull(aniFirst) then
			aniFirst:removeFromParent()
		end
	else
		self.btn_firstCharge:getChildByName("img"):setVisible(false)
		local aniFirst = Animation:createCSExpressionAni(20001)
		aniFirst:setTag(10)
		aniFirst:setLocalZOrder(-1)
	    self.btn_firstCharge:addChild(aniFirst)
	    aniFirst:setPosition(self.btn_firstCharge:getContentSize().width/2,self.btn_firstCharge:getContentSize().height/2)
	end
end

--快速开始
---1、千人抢红包 2、水果机 3、看牌抢庄 4、百人 5、疯狂双十
function SelectGame:onStartGame(res, bTouchStart)
	mlog("SelectGame:onStartGame")
end

function SelectGame:resize()
	if Platefrom:isIphoneX() then
		self.btn_my_info:runAction(cc.MoveBy:create(0,cc.p(25,0)))
		self.btn_voucherAdd:runAction(cc.MoveBy:create(0,cc.p(10,0)))
	end
end

function SelectGame:loadImg()
	util.perLoadImg("img2/shop")
	util.perLoadImg("img2/playerInfo")
	util.perLoadImg("img2/GameScene")
end

function SelectGame:updateVipInfo()
	PlayerData:setPlayerHeadVip(self.Img_head_vip,PlayerData:getPlayerInfo().bVipLevel,_,self.Img_head_bg,1)
	self.Img_head_vip:setLocalZOrder(10)
end

function SelectGame:initItemData()
	util.addSchedulerFuns(self,function() 
		GameSocket:sendMsg(MDM_GP_PROP,ASS_PROP_GETUSERPROP)
		--GameSocket:sendMsg(MDM_GP_PROP,ASS_PROP_GETUSERPROP,{dwUserID = PlayerData:getUserID()})
	end)
end

function SelectGame:intiPlayerData()
	self.lbl_name:setString(PlayerData:getNickName())
	local dwMoney = util.showNumberCoinFormat(PlayerData:getGold())
	self.lbl_gold:setString(dwMoney)
	PlayerData:setPlayerHeadIcon(self.Img_head)
	local iGameCoin = util.showNumberCoinFormat(PlayerData:getGameCoin())
	self.lbl_voucher:setString(iGameCoin)
	if self._bdelay then
		util.delayCall(self,function()
			self._bdelay = false
		end,3,false)
	else
		if PlayerData:getSendMsgPochang() and PlayerData:getGold() < 2000 and PlayerData:getTaskIDInfo(101) < TemplateData:getPalyerTaskCount(101) and PlayerData:getIsGame() == false and self._bIsTaskInfo then
			GameSocket:sendMsg(MDM_GP_TASK,ASS_GP_TASK_RECEIVE_REWARD,{iTaskID=101,iSign=1})
		end
	end
end


return SelectGame

