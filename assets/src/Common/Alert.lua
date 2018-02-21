local Alert = class("Alert")

function Alert:ctor()
	GameEvent:addEventListener(GameEvent.showLoading,self,self.showLoading)
	GameEvent:addEventListener(GameEvent.RecAllMsg,self,self.showErrorTip)
	GameEvent:addEventListener(GameEvent.getHongbao,self,self.onRecHongbao)
end

--网络转圈
function Alert:showLoading(tbl)
	if util.isInBackGround() then
		return
	end
	util.changeUI(ui.Loading,tbl.data)
end

function Alert:showErrorTip(tbl)
	local head = tbl and tbl.data
	if not head then
		trace("error Alert:showErrorTip not head")
		traceObj(tbl)
		return
	end

	local tipConfig = require("config.errorTips")
	local uMainID = head.uMainID
	local uAssistantID = head.uAssistantID 
	local errorID = head.uHandleCode 

	local str = tipConfig and uMainID and uAssistantID and errorID and tipConfig[uMainID] and tipConfig[uMainID][uAssistantID] and tipConfig[uMainID][uAssistantID][errorID]
	if str then
		traceObj(head,"服务器提示错误")
		self:showTip(str)
	elseif errorID~=0 then
		--trace("error Alert:showErrorTip not error msg")
		--traceObj(head,"head")
	end
end

function Alert:hideTip()
	if Alert.lastTip  and not tolua.isnull(Alert.lastTip) then
        Alert.lastTip:stopAllActions()
        Alert.lastTip:removeFromParent()
        Alert.lastTip = nil
    end
end

function Alert:showTip(str,time,bHeightChange)
	self:hideTip()
    local tip = ui.createCsbItem("csb.Tips")
    tip.lbl_tips:setString(str)

    local width = util.fixLaberWidth(tip.lbl_tips,true) + 100

    Alert.lastTip = tip
    local function removeSelf()
        tip:removeFromParent()
    end
    local delay = cc.DelayTime:create(time or 3)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(removeSelf))
    tip:runAction(sequence)

    util.addToPop(tip)

    if bHeightChange then
    	local height = tip.lbl_tips:getContentSize().height + 20
    	tip.img_bg:setContentSize(cc.size(width,height))
    else
    	tip.img_bg:setContentSize(cc.size(width,tip.img_bg:getContentSize().height))
    end
    -- tip.lbl_tips:setPositionX(tip.img_bg:getContentSize().width / 2)
    return tip
end

--加钱,type=1金钱  2钻石
function Alert:addRes(type)
	local tip = ui.createCsbItem("csb.sys.addMoney")
	local function removeSelf()
        tip:removeFromParent()
    end
	util.clickSelf(tip,tip.pnl_close,removeSelf)
	util.clickSelf(tip,tip.btn_buy,function() 
		local info = {
			iUserID = PlayerData:getUserID(),
			cbType = type,
			iAmount = tonumber(tip.tf_money:getString()),
		}
		GameSocket:sendMsg(MDM_GP_LOGON,ASS_GM_MODIFY_MONEY,info)

		--reloadGame()
	end)

	util.addToModule(tip)
	return tip
end

local redString = {
	"有钱人【%s】发2000金币红包啦，大家快来抢啊！%d秒",
	"万元户【%s】发10000金币红包啦，大家快来抢啊！%d秒",
	"土豪爸爸【%s】发50000金币红包啦，大家快来抢啊！%d秒",
}

local redStringType = {
	"[系统]欢迎来到《来玩斗地主》，系统为你准备了新手红包，请笑纳，%d秒。",
	"[系统]又一波福利降临，您好运连连收到红包，请准备开抢哦，%d秒。",
	"欢迎来到《来玩斗地主》，系统为您准备了金币红包，请笑纳",
}


function Alert:createRed()
	if tolua.isnull(self._redTip) then
		self._redTip = ui.createCsbItem("csb.hongbao.recHongbao")
		self._redTip.img_frame ,self._redAniSuc= Animation:createRecHongbao(self._redTip.img_frame)
		self._redTip.img_frame:setLocalZOrder(9)
		self._redTip.lbl_gain:setLocalZOrder(10)
		util.aptNotScale(self._redTip.img_frame,true)
		util.setTextMaxWidth(self._redTip.lbl_name,110)
		util.addToPop(self._redTip)
	end
	self._redTip:setVisible(false)
	return self._redTip,self._redAniSuc
end

function Alert:onRecHongbao(info,showNow)
	self._resHongbaoList = self._resHongbaoList or {}
	if info then
		table.insert(self._resHongbaoList,info)
	end
	if self._redTip and self._isShowingRed then
		return
	end
	info = table.remove(self._resHongbaoList,1)
	if type(info) ~= "table" then
		return
	end
	info = info.data
	if not info then
		trace("error:onRecHongbao hongbao info.data = nil")
		return
	end
	local iRedID = info.iRedID --红包ID
	local nickName = info.nickName  --用户昵称
	local cbHeadID = info.cbHeadID 
	local cbRedLevel = info.cbRedLevel or 100
	local cbRedType = info.cbRedType or 0
	local headUrl = info.szHeadWeb
	if not (iRedID and nickName) then
		traceObj(info,"error:onRecHongbao hongbao info")
		return
	end
	if (cbRedType == 1 or cbRedType == 3) and not showNow then --新手红包,延迟10秒发送
		util.delayCall(info.node,function() self:onRecHongbao({data = info},true) end,10)
		return
	end
	--[[local tip = ui.createCsbItem("csb.hongbao.recHongbao")
	tip:setVisible(false)
	local suc
	tip.img_frame ,suc= Animation:createRecHongbao(tip.img_frame)
	util.aptNotScale(tip.img_frame,true)
	util.setTextMaxWidth(tip.lbl_name,110)]]
	local tip,suc = self:createRed()
	tip.lbl_name:setString(nickName)
	tip.img_frame:setEnabled(true)
	self._isShowingRed = true
	local str
	local str3
	local str2
	local str1
	local str0
	if cbRedType == 0 then-- 玩家红包
		str = redString[cbRedLevel] or "[%s]发红包了，%d 秒后开抢"
		str3 = string.format(str,nickName,3)
		str2 = string.format(str,nickName,2)
		str1 = string.format(str,nickName,1)
		str0 = string.format(str,nickName,0)
		if headUrl and string.len(headUrl)>5 then
			PlayerData:setPlayerHeadIcon(tip.img_head,headUrl,7)
		else
			R:setPlayerIcon(tip.img_head,cbHeadID)
		end
	else--系统红包
		str = redStringType[cbRedType] or "[系统]发红包了，%d 秒后开抢"
		str3 = string.format(str,3)
		str2 = string.format(str,2)
		str1 = string.format(str,1)
		str0 = string.format(str,0)
		R:setPlayerDiZhuIcon(tip.img_head,1)
	end
	PlayerData:showRedMsg(str3,true,true)
	util.delayCall(tip,function() PlayerData:showRedMsg(str2,false) end,1)
	util.delayCall(tip,function() PlayerData:showRedMsg(str1,false) end,2)
	util.delayCall(tip,function()  
		PlayerData:showRedMsg(str0,false)
		tip.img_head:setVisible(false)
		tip:setVisible(true)
		util.delayCall(tip,function()
			--PlayerData:hideGameMsg(str0)
			if not tolua.isnull(tip.img_head) then
				tip.img_head:setVisible(true)
			end
			if cbRedType == 0  and not tolua.isnull(tip.lbl_name) then
				tip.lbl_name:setVisible(true)
				util.setTextMaxWidth(tip.lbl_name)
				tip.lbl_name:setString(tip.lbl_name:getString()..":发红包了")
			end
		end,0.2)
		tip.img_frame.runAni()
		local function close()
			--tip:removeFromParent()
			tip:setVisible(false)
			self._isShowingRed = false
			self:onRecHongbao()
		end

		util.clickSelf(tip,tip.img_frame,function() 
			tip.img_frame:setEnabled(false)
			local tbl = {
		        iRedID = iRedID,
		        cbRedType = cbRedType,
		    }
			if RoomSocket:isActive() then
	    		RoomSocket:sendMsg(MDM_GR_RED,ASS_GR_RECEIVE_RED,tbl)
			else
	    		GameSocket:sendMsg(MDM_GP_RED,ASS_GP_RECEIVE_RED,tbl)
			end
			if suc then
				--金币雨
				_au:playCoinRain()
				tip.img_frame:playSequence("qiang",false)
				tip.img_frame:setLoopKey(nil)
				tip.lbl_name:setVisible(false)
				tip.img_head:setVisible(false)
			else
			end
			util.delayCall(tip,function() tip.lbl_gain:setString("领取超时") end,2)
			util.delayCall(tip,function() trace("未收到红包消息,自动关闭") close() end,3)
		end)


		function tip:onResQiang(res,param2,param3,head)
			util.removeAllSchedulerFuns(tip)
			local code = head.uHandleCode
			local str = ""
			if code == 0 then
				local gold = res.iAmount or 0
				if gold > 0 then
					str = "恭喜抢到"..gold.."金币"
					if suc then
						util.delayCall(tip,function() 
							if  not tolua.isnull(tip.img_head) then
								--tip.lbl_desc:setVisible(false)
								tip.img_head:setVisible(false)
							end
						end,0)
						util.delayCall(tip,function()
							util.playSound("showAward",false)
							if not PlayerData:getIsGame() then
								PlayerData:setGold(PlayerData:getGold() + gold)
							end
				    		PlayerData:setRedRec(gold,true)
							tip.lbl_gain:setVisible(false)
							tip.lbl_gain:setString(str)
							util.delayCall(tip.lbl_gain,function() 
								tip.lbl_gain:setVisible(true)
								util.playSound("slot_win",false)
							end,0)
							util.delayCall(tip.lbl_gain,function() tip.lbl_gain:setVisible(false) end,3.5)

							if suc then
								util.delayCall(tip,function() close() end,2.6)
							else
								close()
							end
						end,0.2)
					else
						if not PlayerData:getIsGame() then
							PlayerData:setGold(PlayerData:getGold() + gold)
						end
				    	PlayerData:setRedRec(gold,true)
						Alert:showTip(str,1)
						close()
					end
					return
				else
					str = "红包被抢光了"
				end
			elseif code == 1 then
				str = "红包被抢光了"
			elseif code == 2 then
				str = "红包已经过期"
			elseif code == 3 then
				str = "红包已经被抢光"
			elseif code == 4 then
				str = "已经领取过"
			else
				str = "领取失败"
				trace("领取失败code="..code)
			end
			close()
			Alert:showTip(str,1)
		end

	    RoomSocket:addDataHandler(MDM_GR_RED,ASS_GR_RECEIVE_RED,tip,tip.onResQiang)
	    GameSocket:addDataHandler(MDM_GP_RED,ASS_GP_RECEIVE_RED,tip,tip.onResQiang)

	    util.delayCall(tip,function() close() end,15)
	end,3)

	return tip
end

function Alert:showAllMsg( ... )
	_uim:showLayer(ui.showMsg)
end

--注册广播事件
function Alert:registerGameMsgModule(gameScene,alwayShow,iType)
	if tolua.isnull(gameScene) then
		return
	end

	if not tolua.isnull(gameScene._gameMsgTip) then
		gameScene._gameMsgTip:removeFromParent()
	end

	local tip = ui.createCsbItem("csb.tips.gameMsg")
	gameScene._gameMsgTip = tip
	gameScene:addChild(tip,10000)
	
	tip._showingLevel = nil
	util.aptsetScaleEquireXY(tip.ScrollPaper,true)
	--tip.ScrollPaper:setPositionX(CC_DESIGN_RESOLUTION.width/2)
	util.touchSelf(self,tip.btn_paper_speaker,self.showAllMsg)
	-- ui.setNodeMap(tip, tip)
	local view = gameScene:getContentSize()--cc.Director:getInstance():getOpenGLView():getFrameSize()

	--tip.ScrollPaper:setContentSize(cc.size(view.width*0.6,tip.ScrollPaper:getContentSize().height))
    --tip.pnl_clip:setContentSize(cc.size(view.width*0.6,tip.ScrollPaper:getContentSize().height))
    --tip.lb_show_laba:setPositionY(tip.ScrollPaper:getContentSize().height*0.5)
	--tip.ScrollPaper:setPositionX(view.width/2 - 170)
	--trace("广播",view.width,view.width*0.65,util.display.width,util.display.height)
	--tip.pnl_clip:setContentSize(cc.size(view.width*0.65,31))

	tip:setVisible(alwayShow)
	local posX = tip.pnl_clip:getContentSize().width
	--util.aptNotScale(tip.ScrollPaper,true)
	
	local function init()
		if not tolua.isnull(tip.lb_show_laba) and not tolua.isnull(tip.pnl_clip) then
			posX = tip.pnl_clip:getContentSize().width
			tip.lb_show_laba:setString("")
			tip.lb_show_laba:setPositionX(posX)
		end
	end   
	init()
	local tblMsg = {}
	tip.pnl_clip:setClippingEnabled(true)
	local function onShowLabaInfo( _,data )
		local function onMsgEnd()
			local data = table.remove(tblMsg,1)
			if data then
				onShowLabaInfo(nil,data)
			end
		end
		local info = data.data
		local text = info and info.text
		if not text then
			return
		end
		local refresh = info.refresh
		local immediately = info.immediately
		local hide = info.hide
		local level = info.level or 2
		local iMaqType = info.iMaqType

		if tip._showingLevel then
			if tip._showingLevel == level then
				if level ~= 1 then--不是红包才缓存
					table.insert(tblMsg,data)
					return
				end
			elseif tip._showingLevel > level then
				return
			elseif tip._showingLevel < level then
				tblMsg = {}
				refresh = true
			end
		end

		tip._showingLevel=level
		if level == 1 then
			if iType and iType == 2 then
				util.loadImage(tip.scroll_paper_speaker,R.labaRedBull) 
			else
				util.loadImage(tip.scroll_paper_speaker,R.labaRed) 
			end
		else
			if iType and iType == 2 then
				util.loadImage(tip.scroll_paper_speaker,R.labaNormalBull) 
			elseif iType and iType == 3 then
				util.loadImage(tip.scroll_paper_speaker,R.labaHallNormal) 
			else
				util.loadImage(tip.scroll_paper_speaker,R.labaNormal) 
			end
		end
		if iMaqType == 4 and not tolua.isnull(tip.lb_show_laba) then
			tip.lb_show_laba:setColor(cc.c3b(255, 239, 61))
		elseif iMaqType == 0 and not tolua.isnull(tip.lb_show_laba) then
			tip.lb_show_laba:setColor(cc.c3b(254, 253, 251))
		end

		if hide then
			if not tolua.isnull(tip.lb_show_laba) and text == tip.lb_show_laba:getString() then
				tip.lb_show_laba:setString("")
				PlayerData:setIsxianShiMsg(false)
				tip:setVisible(alwayShow)
			end
			return
		end
		if not refresh then
			PlayerData:setIsxianShiMsg(true)
			tip:setVisible(true)
			if not tolua.isnull(tip.lb_show_laba)  then
				tip.lb_show_laba:setString(text)
			end
			return
		end
		init()
		PlayerData:setIsxianShiMsg(true)
		local textW = 0
		local width = 0
		if not tolua.isnull(tip.lb_show_laba) then
			tip:setVisible(true)
			tip.lb_show_laba:setString(text)
			textW = tip.lb_show_laba:getContentSize().width
			width = posX + textW + 50
			tip.lb_show_laba:stopAllActions()
		end
	    
	    if  not tolua.isnull(tip.lb_show_laba) then
	    	tip.lb_show_laba:setPositionX(posX - textW)
	    	width = width - textW
	    end
		local time = math.max(3,width/120)
	    local moves = cc.MoveBy:create(time,cc.p(-width,0))
	    local hide = --[[cc.CallFunc:create(]]function() 
	    	PlayerData:setIsxianShiMsg(false)
	        tip:setVisible(alwayShow)        
	        -- util.loadImage(tip.scroll_paper_speaker,R.labaNormal) 
			tip._showingLevel = nil
			onMsgEnd()
	    end--)
    	--tip.lb_show_laba:runAction(cc.Sequence:create(moves,cc.DelayTime:create(0.5),hide))
    	util.removeAllSchedulerFuns(tip.lb_show_laba)
    	local timePass = 0
    	local startPosX = 0
    	if not tolua.isnull(tip.lb_show_laba) then
    		util.removeAllSchedulerFuns(tip)
    		startPosX = tip.lb_show_laba:getPositionX()
    		util.addSchedulerFuns(tip,function(dt,isEnd)
	    		timePass = timePass + dt
	    		if isEnd then
	    			hide()
	    		else
	    			tip.lb_show_laba:setPositionX(startPosX - width * timePass/time)
	    		end
	    	end,true,0,time)
    	end
	end

	tip.setPosXCenter = function(yPer)
		util.delayCall(tip,function() 
			local viewsize = cc.Director:getInstance():getWinSize()
			local y = viewsize.height-tip.ScrollPaper:getContentSize().height
			if yPer then
				y = viewsize.height*yPer
			end
			tip.ScrollPaper:setPosition(cc.p(WIN_Width/2,y))
		end)
	end
	util.delayCall(tip,function() 
		GameEvent:addEventListener(GameEvent.showgameMsg,tip,onShowLabaInfo)
	end,0.5)

	return tip
end


function Alert:showMsgFrame(title,msg)
	local tip = ui.createCsbItem("csb.setting.messageBox")
	util.clickSelf(tip,tip.pnl_close,function() tip:removeFromParent() end)
	tip.lbl_title:setString(title)
	tip.lbl_text:setString(msg)
	util.aptNotScale(tip.img_bg,true)
	util.addToPop(tip)
	return tip
end

function Alert:showCheckBox(title,okFunc,bTop,title2)
	local tip = ui.createCsbItem("csb.tips.checkBox")
	util.clickSelf(tip,tip.pnl_close,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_cancle,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_ok,function() if okFunc then okFunc() end util.hideWin(tip) end)

	tip.lbl_name:setString(title)
	util.aptNotScale(tip.img_bk,true)
	if title2 then
		tip._lbl_tips:setString(title2)
		tip._lbl_tips:setVisible(true)
	else
		tip._lbl_tips:setVisible(false)
	end
	if bTop then
	    util.addToPop(tip)
	else
		util.addToModule(tip)
	end
	return tip
end

--只有一个按钮
function Alert:showCheckBox2(title,okFunc,cancelFunc)
	self._funcCheckBox2 = self._funcCheckBox2 or {}
	self._funcCheckBox2[title] = self._funcCheckBox2[title]  or {}
	self._tips = self._tips or {}
	
	table.insert(self._funcCheckBox2[title],okFunc)

	if not tolua.isnull(self._tips[title]) then 
		return
	end
	local tip = ui.createCsbItem("csb.tips.checkBox")
	self._tips[title] = tip
	local function close( ... )
		if cancelFunc  then
			cancelFunc()
		end
		self._funcCheckBox2[title] = nil 
		util.hideWin(tip)
	end
	util.clickSelf(tip,tip.pnl_close,function() close() end)
	util.clickSelf(tip,tip.btn_cancle,function() close() end)
	util.clickSelf(tip,tip.btn_ok,function() 
		for _,func in pairs(self._funcCheckBox2[title]) do
			func()
		end
		self._funcCheckBox2[title] = nil 
		util.hideWin(tip) 
	end)

	tip.btn_ok:setPositionX(tip.btn_ok:getParent():getContentSize().width/2)
	tip.btn_cancle:setVisible(false)
	tip.lbl_name:setString(title)
	util.aptNotScale(tip.img_bk,true)
	util.addToModule(tip)
	tip.cancelFunc = cancelFunc
	return tip
end
--显示牛牛提示框
function Alert:showBullTips(title,okFunc)
	local tip = ui.createCsbItem("csb.watchbrandgame.bullTip")
	util.clickSelf(tip,tip.pnl_close,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_cancle,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_ok,function() if okFunc then okFunc() end util.hideWin(tip) end)

	tip.lbl_name:setString(title)
	util.aptNotScale(tip.img_bk,true)
	util.addToModule(tip)
	return tip
end
--显示疯狂双十提示框
function Alert:showCrazyGameTips(title,okFunc, bOnlyOne)
	local tip = ui.createCsbItem("csb.crazyGame.crazyTip")
	util.clickSelf(tip,tip.pnl_close,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_cancle,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_ok,function() if okFunc then okFunc() end util.hideWin(tip) end)

	if bOnlyOne then
		tip.btn_cancle:setVisible(false)
		tip.btn_ok:setPositionX(tip.img_bk:getContentSize().width/2)
	end
	tip.lbl_name:setString(title)
	util.aptNotScale(tip.img_bk,true)
	util.addToModule(tip)
	return tip
end
--前往
function Alert:showCheckBoxQianWang(title,okFunc,bTop)
	local tip = ui.createCsbItem("csb.tips.checkBox")
	tip.lb_ok:setString("前往")
	-- util.loadImage(tip.img_tip_ok,"img2/btn/qw.png")
	util.clickSelf(tip,tip.pnl_close,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_cancle,function() util.hideWin(tip) end)
	util.clickSelf(tip,tip.btn_ok,function() if okFunc then okFunc() end util.hideWin(tip) end)

	tip.lbl_name:setString(title)
	util.aptNotScale(tip.img_bk,true)
	if bTop then
	    util.addToPop(tip)
	else
		util.addToModule(tip)
	end
	return tip
end
--只有一个按钮
function Alert:showBullTips2(title,okFunc,cancelFunc)
	self._funcBullTips2 = self._funcBullTips2 or {}
	self._funcBullTips2[title] = self._funcBullTips2[title]  or {}
	self._tips = self._tips or {}
	
	table.insert(self._funcBullTips2[title],okFunc)

	if not tolua.isnull(self._tips[title]) then 
		return
	end
	local tip = ui.createCsbItem("csb.watchbrandgame.bullTip")
	self._tips[title] = tip
	local function close( ... )
		if cancelFunc  then
			cancelFunc()
		end
		self._funcBullTips2[title] = nil 
		util.hideWin(tip)
	end
	util.clickSelf(tip,tip.pnl_close,function() close() end)
	util.clickSelf(tip,tip.btn_cancle,function() close() end)
	util.clickSelf(tip,tip.btn_ok,function() 
		for _,func in pairs(self._funcBullTips2[title]) do
			func()
		end
		self._funcBullTips2[title] = nil 
		util.hideWin(tip) 
	end)

	tip.btn_ok:setPositionX(tip.btn_ok:getParent():getContentSize().width/2)
	tip.btn_cancle:setVisible(false)
	tip.lbl_name:setString(title)
	util.aptNotScale(tip.img_bk,true)
	util.addToModule(tip)
	tip.cancelFunc = cancelFunc
	return tip
end

--错误窗口
local _nevetShowAgain = false
function Alert:debugWin(msg)
    msg = msg.."\r\n_____________________"
    if _nevetShowAgain then
        return
    end
    if self.showingDebug then
        self.showingDebug.addDebugMsg(msg)
        return
    end
    local tip =  ui.createCsbItem("csb.tips.debugWin")
    self.showingDebug = tip
    tip.addDebugMsg = function(text)
        util.listAddBugString(tip.ls_msg,text,20,cc.c4b(0,0,0,255))
    end
    tip.addDebugMsg(msg)
    local  close = function()
        util.tryRemove(tip)
        self.showingDebug = nil
    end
    util.clickSelf(self,tip.pnl_close,function()
        close()
        --_nevetShowAgain = true
    end)

    util.clickSelf(self,tip.btn_ok,function()
        close()
        --_nevetShowAgain = true
    end)
    
    util.addToModule(tip)
    return tip
end


return Alert
