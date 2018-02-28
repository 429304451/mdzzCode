--游戏宝箱任务
local gameBoxTask = class("gameBoxTask",BaseDialog)
local iAllCount = 2
local itemTbl = {
        [1]  = {piture = "jinbi4", desc="金币"},
        [2]  = {piture = "zuanshi4", desc="钻石"},
        [6]  = {piture = "menpiao1", desc="门票"},
    }
function gameBoxTask:ctor(obj,info)
    gameBoxTask.super.ctor(self,{obj = obj})
    self._info = info
    self.csNode = ui.loadCS(info.csbPath .. "boxTask")
    self:addChild(self.csNode)
    self.csNode:setPosition(WIN_center)
    ui.setNodeMap(self.csNode, self)
    self.csAction = ui.loadCSTimeline(info.csbPath .. "boxTask")
    self.csNode:runAction(self.csAction)
    self.csAction:play("open",false)
    local iView = cc.Director:getInstance():getWinSize() 
    self.img_bk:setPosition(info.posInfo.pos.x - iView.width/2, info.posInfo.pos.y - iView.height/2)

    self._boxTask = self:getRoomBoxTaskInfo(info.gameId,info.iRoomLevel)

    self:addEvents()
    -- self:initTilteInfo()
    self:initTaskItem()
    self:onUpdateFreeReceiveStatue(info.bRevce) 
end

function gameBoxTask:onUpdateFreeReceiveStatue( bEnable )
    self.btn_free_receive_1:setEnabled(bEnable)
    self.btn_free_receive_2:setEnabled(bEnable)
    if bEnable then
        util.setnoGray(self.btn_free_receive_1)
        util.setnoGray(self.btn_free_receive_2)
    else
        util.setGray(self.btn_free_receive_1)
        util.setGray(self.btn_free_receive_2)
    end
end

function gameBoxTask:getRoomBoxTaskInfo( gameId, iRoomLevel )
    local gameInfo = TemplateData:getRoom(gameId)
    return gameInfo and gameInfo[iRoomLevel] or gameInfo[1]
end


function gameBoxTask:onBtnClick(pSender, type)
    if type == ccui.TouchEventType.began then
    elseif type == ccui.TouchEventType.moved then
    elseif type == ccui.TouchEventType.ended then
        util.playSound("Common_Panel_Dialog_Pop_Sound",false)
       if self.canInCding then
            return
        end
        self:runResponseCd(0.6)
        if pSender.tag == "btn_free_receive_1" then
            self:onSendToServer(1)
        elseif pSender.tag == "btn_free_receive_2" then
            self:onSendToServer(2)
        end
    elseif type == ccui.TouchEventType.canceled then
    end
end                                                                                                                                                                                                                                                                                                   

function gameBoxTask:addEvents()
    --退出
    self.btn_free_receive_1:addTouchEventListener(function (...) self:onBtnClick(...) end)
    self.btn_free_receive_1.tag = "btn_free_receive_1"
    self.btn_free_receive_1:setZoomScale(-0.1)

    self.btn_free_receive_2:addTouchEventListener(function (...) self:onBtnClick(...) end)
    self.btn_free_receive_2.tag = "btn_free_receive_2"
    self.btn_free_receive_2:setZoomScale(-0.1)

    RoomSocket:addDataHandler(MDM_GR_TASKDAILY,ASS_GR_GAMETASK_BOX_AWARD,self,self.onGameTaskBoxAward)
    GameEvent:addEventListener(GameEvent.updateBoxTask,self,self.onUpdateBtnInfo)
end

function gameBoxTask:onCloseClient( ... )
    _uim:closeLayer(ui.gameBoxTask)
end

function gameBoxTask:onUpdateBtnInfo( ... )
    self:onUpdateFreeReceiveStatue(true)
end

function gameBoxTask:onSendToServer( index)
    self._iSelect = index
    RoomSocket:sendMsg(MDM_GR_TASKDAILY,ASS_GR_GAMETASK_BOX_AWARD,{iAwardType=index})
end

function gameBoxTask:onGameTaskBoxAward( res,uAssistantID,stateType, head )
    if head and head.uHandleCode == 0 then
        self:onUpdateFreeReceiveStatue(false)
        self:showOneReward()
        self:onCloseClient()
    elseif head and head.uHandleCode == 1 then
        Alert:showTip("今日领取次数达到上限", 3)
        self:onUpdateFreeReceiveStatue(false)
        self:onCloseClient()
    elseif head and head.uHandleCode == 3 then
        self:onUpdateFreeReceiveStatue(false)
        Alert:showTip("局数未达到", 3)
    end
end

function gameBoxTask:showOneReward( ... )
    local str = ""
    local picture = ""
    local iType = 1
    local iNum = 0
    if self._iSelect and self._iSelect == 1 then
        picture = "img2/item/" .. itemTbl[self._boxTask.rewardID1].piture
        str = str .. self._boxTask.rewardnum1 .. itemTbl[self._boxTask.rewardID1].desc
        iType = self._boxTask.rewardID1
        iNum = self._boxTask.rewardnum1
    else
        picture = "img2/item/" .. itemTbl[self._boxTask.rewardID2].piture
        str = str .. self._boxTask.rewardnum2 .. itemTbl[self._boxTask.rewardID2].desc
        iType = self._boxTask.rewardID2
        iNum = self._boxTask.rewardnum2
    end
    if iType == 1 then
        -- PlayerData:setGold(iNum, true)
    elseif iType == 6 then
        PlayerData:setGameCoin(iNum, true)
    end
    local info  = {
        picture = picture,
        desc = str,
        scale = 0.7
    }
    _uim:showLayer(ui.oneLotteryReward, info)
end

function gameBoxTask:initTilteInfo( ... )
    if self._boxTaskTitle then
        self._boxTaskTitle:removeFromParent()
    end
    self._boxTaskTitle = ccui.RichText:create()
    self._boxTaskTitle:ignoreContentAdaptWithSize(true)
    self._boxTaskTitle:setContentSize(cc.size(400, 36))
    local iFontSize = 25
    local re1 =  ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, "今日已领取：", "img2/font/MSYH.TTF", iFontSize)
    local re2 =  ccui.RichElementText:create(2, cc.c3b(246, 255, 0), 255, self._info.gameNum, "img2/font/MSYH.TTF", iFontSize)
    local re3 =  ccui.RichElementText:create(3, cc.c3b(255, 255, 255), 255, "/" .. self._boxTask.getNumber, "img2/font/MSYH.TTF", iFontSize)
    self._boxTaskTitle:pushBackElement(re1)
    self._boxTaskTitle:pushBackElement(re2)
    self._boxTaskTitle:pushBackElement(re3)
    self._boxTaskTitle:setAnchorPoint(cc.p(0.5,0.5))
    self._boxTaskTitle:setPosition(cc.p(self.img_bk:getContentSize().width/2, self.img_bk:getContentSize().height - 50))
    self.img_bk:addChild(self._boxTaskTitle)
end

function gameBoxTask:initTaskItem()
    util.loadImage(self.img_icon_1,"img2/item/" .. itemTbl[self._boxTask.rewardID1].piture)
    util.loadImage(self.img_icon_2,"img2/item/" .. itemTbl[self._boxTask.rewardID2].piture)
    for i=1,iAllCount do
        local descRich = ccui.RichText:create()
        descRich:ignoreContentAdaptWithSize(true)
        descRich:setContentSize(cc.size(200, 30))
        local iFontSize = 20
        local re1,re2
        if i == 1 then
            re1 =  ccui.RichElementText:create(1, cc.c3b(246, 255, 0), 255, self._boxTask.rewardnum1, "img2/font/MSYH.TTF", iFontSize)
            re2 =  ccui.RichElementText:create(2, cc.c3b(255, 255, 255), 255, itemTbl[self._boxTask.rewardID1].desc, "img2/font/MSYH.TTF", iFontSize)
        else
            re1 =  ccui.RichElementText:create(1, cc.c3b(246, 255, 0), 255, self._boxTask.rewardnum2, "img2/font/MSYH.TTF", iFontSize)
            re2 =  ccui.RichElementText:create(2, cc.c3b(255, 255, 255), 255, itemTbl[self._boxTask.rewardID2].desc, "img2/font/MSYH.TTF", iFontSize)
        end
        descRich:pushBackElement(re1)
        descRich:pushBackElement(re2)
        descRich:setPosition(self["pnl_bg_" .. i]:getContentSize().width/2, self["pnl_bg_" .. i]:getContentSize().height*0.33)
        self["pnl_bg_" .. i]:addChild(descRich)
    end
end

return gameBoxTask