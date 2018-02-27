--疯狂双十
--玩家下注操作
local UserOperationType = 
{
    UserOperation_Type_Invalid      =   0,           --无效
    UserOperation_Type_Let          =   1,           --过牌
    UserOperation_Type_DisCard      =   2,           --弃牌
    UserOperation_Type_WithSame     =   3,           --跟注
    UserOperation_Type_AddMoney     =   4,           --加注
    UserOperation_Type_AllMoney     =   5,           --全下
}
local userBetType = {}
userBetType[UserOperationType.UserOperation_Type_DisCard] = {desc="弃牌",tag=2,path="img2/carzyRes/jettonBtn/zise", iAmount=0, color=cc.c3b(75, 53, 156)}
userBetType[UserOperationType.UserOperation_Type_Let] = {desc="让牌",tag=1,path="img2/carzyRes/jettonBtn/zise",iAmount=0, color=cc.c3b(75, 53, 156)}
userBetType[UserOperationType.UserOperation_Type_WithSame] = {desc="跟",tag=3,path="img2/carzyRes/jettonBtn/huangse",iAmount=0, color=cc.c3b(135, 65, 27)}
userBetType[UserOperationType.UserOperation_Type_AddMoney] = {desc="",tag=4,path="img2/carzyRes/jettonBtn/lanse",iAmount=0, color=cc.c3b(57, 84, 165)}
userBetType[UserOperationType.UserOperation_Type_AllMoney] = {desc="全下",tag=5,path="img2/carzyRes/jettonBtn/huangse",iAmount=0, color=cc.c3b(135, 65, 27)}
--音效
local _music = 
{
    MUSIC_COIN_STREAM               =   101,
    MUSIC_COIN_FLY_IN_SHOER         =   102,
    MUSIC_GAME_WIN                  =   103,
}

local ID_CARD_BACK = 0xDF
local INVALID_CHAIR = -1
local PLAY_COUNT = 5   --玩家个数

local cardsConfig = require("config.cards")
local crazyRoomInfo = require("config.template.CrazyTen")
local chatInfo = require("config.template.talk")
local skilltips = require("config.template.skilltips")

local smallCardsConfig = cardsConfig[2]
cardsConfig = cardsConfig[1]
local crazyLogic = require("modules.crazyGame.crazyLogic"):create()
--游戏状态
local _gameStation = 
{
    rest_time_station       =   0,          --休息时间
    game_start_station      =   1,          --游戏开始状态
    send_card_station       =   2,          --发牌状态
    game_end_station        =   3
}
--五个角色的一些节点
local _nodes = {
    pnl_Info    = {"_pnl_player_0","_pnl_player_1","_pnl_player_2","_pnl_player_3","_pnl_player_4"},    --玩家信息容器
    btn_head    = {"_btn_player_0","_btn_player_1","_btn_player_2","_btn_player_3","_btn_player_4"},    --玩家头像点击框
    img_head    = {"_img_head_0","_img_head_1","_img_head_2","_img_head_3","_img_head_4"},              --玩家头像
    img_head_vip    = {"_img_vip_0","_img_vip_1","_img_vip_2","_img_vip_3","_img_vip_4"},               --玩家vip
    lb_nickName = {"_txt_nickName_0","_txt_nickName_1","_txt_nickName_2","_txt_nickName_3","_txt_nickName_4"},  --玩家昵称
    lb_bean     = {"_txt_gold_0","_txt_gold_1","_txt_gold_2","_txt_gold_3","_txt_gold_4"},                      --玩家金币
    node_desk_Card = {"_node_desk_card_0","_node_desk_card_1","_node_desk_card_2","_node_desk_card_3","_node_desk_card_4"},     --玩家桌面牌的位置
    node_gold_end_pos = {"_node_Gold_end_0","_node_Gold_end_1","_node_Gold_end_2","_node_Gold_end_3","_node_Gold_end_4"},           --玩家结算金币漂浮的位置
    img_bet_bg = {"_img_bet_gold_bg_0","_img_bet_gold_bg_1","_img_bet_gold_bg_2","_img_bet_gold_bg_3","_img_bet_gold_bg_4"},
    img_bet_icon = {"_img_bet_gold_icon_0","_img_bet_gold_icon_1","_img_bet_gold_icon_2","_img_bet_gold_icon_3","_img_bet_gold_icon_4"},
    img_bet_ani = {"_node_bet_gold_ani_0","_node_bet_gold_ani_1","_node_bet_gold_ani_2","_node_bet_gold_ani_3","_node_bet_gold_ani_4"},
    lb_bet_gold = {"_txt_bet_gold_0","_txt_bet_gold_1","_txt_bet_gold_2","_txt_bet_gold_3","_txt_bet_gold_4"},
    img_win_mark = {"_img_win_biaoji_0","_img_win_biaoji_1","_img_win_biaoji_2","_img_win_biaoji_3","_img_win_biaoji_4"},
    chat_Info_bg = {"_pnl_chatInfo_0","_pnl_chatInfo_1","_pnl_chatInfo_2","_pnl_chatInfo_3","_pnl_chatInfo_4"},
    lb_chat_content ={"lb_chat_content_0","lb_chat_content_1","lb_chat_content_2","lb_chat_content_3","lb_chat_content_4"},
    node_pos_head ={"_node_head_pos_0","_node_head_pos_1","_node_head_pos_2","_node_head_pos_3","_node_head_pos_4"},
    node_ani_win = {"_node_win_ani_0","_node_win_ani_1","_node_win_ani_2","_node_win_ani_3","_node_win_ani_4"}
}
local _anchor = {
    Node_DeskCard = {cc.p(0,0.5),cc.p(0,0.5),cc.p(0.5,0.5),cc.p(1,0.5),cc.p(1,0.5)},
    Node_head = {cc.p(0,1),cc.p(0,0),cc.p(0,0),cc.p(1,0),cc.p(1,1)},
}

--分堆情况时各个分堆的位置
local goldPilesPos = {
    {640*_gm.bgScaleW},
    {512*_gm.bgScaleW,768*_gm.bgScaleW},--{768,512},
    {486*_gm.bgScaleW,640*_gm.bgScaleW,793*_gm.bgScaleW},--{640,486.40,793.60},
    {460*_gm.bgScaleW,582*_gm.bgScaleW,710*_gm.bgScaleW,832*_gm.bgScaleW},--{582.40,710.40,460.80,832.00},
    {435*_gm.bgScaleW,537*_gm.bgScaleW,640*_gm.bgScaleW,742*_gm.bgScaleW,844*_gm.bgScaleW},-- {640,537.60,742.40,435.20,844.80},
}

local crazyGame = class("crazyGame",BaseLayer)

function crazyGame:initData()
    util.setTextMaxWidth(self._txt_nickName_0,100)
    util.setTextMaxWidth(self._txt_nickName_1,100)
    util.setTextMaxWidth(self._txt_nickName_2,100)
    util.setTextMaxWidth(self._txt_nickName_3,100)
    util.setTextMaxWidth(self._txt_nickName_4,100)
    self._goldBatchNode = cc.SpriteBatchNode:create("img2/carzyRes/jinbi.png",1000)
    self:addChild(self._goldBatchNode)
end

function crazyGame:ctor()
    crazyGame.super.ctor(self)

    self.crazybgNode = ui.loadCS("csb/crazyGame/crazyGamefree")
    self:addChild(self.crazybgNode)
    self.crazybgNode:setScaleX(_gm.bgScaleW)
    self.crazybgNode:setPosition(WIN_center)
    ui.setNodeMap(self.crazybgNode, self)
    self.crazybgAction = ui.loadCSTimeline("csb/crazyGame/crazyGamefree")
    self.crazybgNode:runAction(self.crazybgAction)
    self.crazybgAction:play("play", false)

    self.crazyGameCommon = ui.loadCS("csb/crazyGame/crazyGameCommon")
    self:addChild(self.crazyGameCommon)
    self.crazyGameCommon:setScaleX(_gm.bgScaleW)
    self.crazyGameCommon:setPosition(WIN_center)
    ui.setNodeMap(self.crazyGameCommon, self)
    self.crazyGameComAction = ui.loadCSTimeline("csb/crazyGame/crazyGameCommon")
    self.crazyGameCommon:runAction(self.crazyGameComAction)
    self.crazyGameComAction:play("play", false)

    self.crazybgNode2 = ui.loadCS("csb/crazyGame/crazyGame_2")
    self:addChild(self.crazybgNode2)
    self.crazybgNode2:setScaleX(_gm.bgScaleW)
    self.crazybgNode2:setPosition(WIN_center)
    ui.setNodeMap(self.crazybgNode2, self)
    
    util.loadImage(self._imgRoomTitle, "img2/carzyRes/" .. crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].picture)
    --适配
    self:addEventsNew()
    self:addEvents()
    
    self:initData()
end

function crazyGame:resize()
    for i=0,PLAY_COUNT-1 do
        util.aptNotScale(self:getNode(i,"pnl_Info"),true)
    end
    util.aptNotScale(self.slider_bet,true)

    util.delayCall(self.crazybgNode,function()
        if not self.crazybgAction:isPlaying() then
            util.removeAllSchedulerFuns(self.crazybgNode)
            self.crazybgNode:setScaleX(1)
            util.aptChildren(self.crazybgNode)
            if Platefrom:isIphoneX() then
                self._btnChat:runAction(cc.MoveBy:create(0.1,cc.p(50,0)))
            end
        end
    end,0,true)
    
    util.delayCall(self.crazyGameCommon,function()
        if not self.crazyGameComAction:isPlaying() then
            util.removeAllSchedulerFuns(self.crazyGameCommon)
            self.crazyGameCommon:setScaleX(1)
            util.aptChildren(self.crazyGameCommon)
            self.crazybgNode2:setScaleX(1)
            util.aptChildren(self.crazybgNode2)
            local moveTime = 0.1
            if Platefrom:isIphoneX() then
                self._pnl_player_0:runAction(cc.MoveBy:create(moveTime,cc.p(20,0)))
                self._pnl_player_1:runAction(cc.MoveBy:create(moveTime,cc.p(20,0)))
                self._pnl_player_3:runAction(cc.MoveBy:create(moveTime,cc.p(-20,0)))
                self._pnl_player_4:runAction(cc.MoveBy:create(moveTime,cc.p(-20,0)))

                self._pnl_play_ani_0:runAction(cc.MoveBy:create(moveTime,cc.p(20,0)))
                self._pnl_play_ani_1:runAction(cc.MoveBy:create(moveTime,cc.p(20,0)))
                self._pnl_play_ani_3:runAction(cc.MoveBy:create(moveTime,cc.p(-20,0)))
                self._pnl_play_ani_4:runAction(cc.MoveBy:create(moveTime,cc.p(-20,0)))
            end
            
            util.delayCall(self,function()
                for i=1,5 do
                    local headImgNode = self:getNode(i,"img_head")
                    local headPosNode = self:getNode(i,"node_pos_head")
                    util.moveToNode(headPosNode,headImgNode)
                end
                self:moveToCenterX(self._node_desk_card_2)--自己牌
                self:moveToCenterX(self._img_bet_gold_bg_2)--自己下注
            end,moveTime + 0.1)
            
        end
    end,0,true)
end

--移动到中间
function crazyGame:moveToCenterX(node)
    if tolua.isnull(node) then
        return
    end
    local posCenter = cc.p(WIN_center.x,0)
    pos = node:getParent():convertToNodeSpace(posCenter)
    node:setPositionX(pos.x)
end

function crazyGame:initDataInfo( ... )
    --玩家自身位置
    self.bDeskStation = 0
    self._iCurBackIndex = 0
    self._publicCardItem = {}
    self.m_bGameBegin = false
    self._cardItems = {}
    self._playerCards = {}
    self._playerInfo = {}
    self._backPublicCard = {}
    self._spProgress = {}
    --初始化玩家信息
    self:intiPlayerData()
    self._curPlayerCaozuo = UserOperationType.UserOperation_Type_Invalid
    --游戏状态
    self._igameState = _gameStation.rest_time_station
    --是否退出游戏
    self._bIsQuit = false
    --每轮玩家下注数据
    self._curAmountBet = {}
    self._preGoldPiles = 1
    self._curGoldPiles = 1
    self._curRoundSelect = -1
    self._curPlayerBetAllGold = 0
    self._icurBetMaxMoney = 0
    self:hidePlayerBetGold()
    self._iUserWinInfo = {}

    --显示底分
    self._difen = crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].num2
    self._txt_lower:setString(self._difen .. "底分")

    PlayerData:setIsGame("crazyGame")
    _am:playMusic("audio/crazyGame/ingameBGMMono.mp3",true)

    self:setCardIsTouch(false)
    local tipMsg = Alert:registerGameMsgModule(self,true)
    tipMsg:setPosition(cc.p(0,0))

    tipMsg.ScrollPaper:setContentSize(cc.size(504,51))
    util.loadImage(tipMsg.ScrollPaper,"img2/carzyRes/gonggaolan.png")
    util.loadImage(tipMsg.scroll_paper_speaker,"img2/carzyRes/laba.png")
    tipMsg.scroll_paper_speaker:setPosition(tipMsg.scroll_paper_speaker:getContentSize().width/2 - 12, tipMsg.ScrollPaper:getContentSize().height/2)
    
    tipMsg.pnl_clip:setContentSize(cc.size(420,tipMsg.ScrollPaper:getContentSize().height))
    tipMsg.btn_paper_speaker:setContentSize(cc.size(485,tipMsg.ScrollPaper:getContentSize().height))
    tipMsg.pnl_touch:setContentSize(cc.size(567*1.1,tipMsg.ScrollPaper:getContentSize().height*2))
    tipMsg.pnl_clip:setPositionX(tipMsg.scroll_paper_speaker:getContentSize().width + 30)
    tipMsg.lb_show_laba:setPositionY(tipMsg.ScrollPaper:getContentSize().height/2)
    tipMsg.setPosXCenter()
    self:initGameMagAni()
end

function crazyGame:addEventsNew( ... )
    self._iStraightWins = 0
    self._allBoxNum = crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].boxNum
    self._allBoxCount = crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].getNumber
    --宝箱
    util.clickSelf(self,self.btn_box,function()
        local node = self.btn_box
        local pos = cc.p(node:getPosition())
        pos = node:getParent():convertToWorldSpace(pos)
        local info = {
            posInfo = {pos = pos,anchor = anchor},
            iRoomLevel = PlayerData:getCurRoomInfo().iRoomLevel,
            gameId = PlayerData:getCurRoomInfo().uNameID,
            csbPath = "csb/crazyGame/",
            gameNum = self._iStraightWins,
            bRevce = self._curBoxNum - self._allBoxNum >= 0
        }
        _uim:showLayer(ui.gameBoxTask,info)
    end)
end

function crazyGame:addEvents()
    self:initDataInfo()
    --退出大厅
    util.clickSelf(self,self._btnOut,function()
        self:onShowMoreFunc()
    end)
    --获取类型
    util.clickSelf(self,self._btnHelp,function()
        local info = {
            csbPath = "csb/crazyGame/"
        }
        _uim:showLayer(ui.gameHelp, info)
    end)
    --弃牌/让牌
    util.clickSelf(self,self._btn_auto_jetton_0,function()
        self:onSelectBetType(0)
    end)
    --跟任何
    util.clickSelf(self,self._btn_auto_jetton_1,function()
        self:onSelectBetType(1)
    end)
     --关闭加注
    util.clickSelf(self,self._pnl_refueling,function()
        self:hideRefueling()
    end)
    --点击加注
    util.clickSelf(self,self._btn_jetton_5,function()
        if self._pnl_refueling:isVisible() then
            self:onSendUserBetResult(UserOperationType.UserOperation_Type_AddMoney,self._iMaxBetGold)
        else
            self._pnl_refueling:setVisible(true)
            self.lb_min_addMoney:setString(self._iMinBetGold)
            self.lb_max_addMoney:setString(self._iMinBetGold)
        end
    end)

    self.slider_bet:addEventListener(function(pSender, type)
        if type == 0 then
            local percent = pSender:getPercent()
            local allGold = self:getMaxBetGold() - self._iMinBetGold
            if allGold < 0 then
                allGold = 0
            end
            self._iMaxBetGold = math.floor(allGold * percent / 100) + self._iMinBetGold
            if percent < 100 then
               local iMinGold = self:showSliderData(allGold)
               self._iMaxBetGold = self._iMaxBetGold - self._iMaxBetGold % iMinGold
               if self._iMaxBetGold < self._iMinBetGold then
                   self._iMaxBetGold = self._iMinBetGold
               end
            end
            self.lb_max_addMoney:setString(self._iMaxBetGold)
        end
    end)
    util.clickSelf(self,self._btnChat,self.onChatBtn)
    RoomSocket:addDataHandler(MDM_GM_GAME_FRAME,ASS_GM_NORMAL_TALK,self,self.onShowChatInfo)--聊天
    RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_USER_COME,self,self.onOtherPlayerChange)--其他玩家加入桌子
    RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_USER_UP,self,self.onOtherlevave)--其他玩家离开桌子
    RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_USER_STATE,self,self.onUserStateChange)--用户状态改变
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,ASS_GM_GAME_STATION,self,self.onGameStation)--游戏状态
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_GAME_FISH,self,self.onGameFish)--休闲时间
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_GAME_BEGIN,self,self.onGameBegin)--开始游戏
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_SEND_CARD_MSG,self,self.doSendCardAction)--发牌
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_SEND_BEGIN_XIAZHU,self,self.onGameJettonBegin)--开始下注
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_USER_XIAZHU_RSULT,self,self.onUserJettonResult)--玩家下注结果
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_SEND_BACKCARD,self,self.onSendBackCard)--发送底牌
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_SEND_AllBACKCARD,self,self.onSendAllBackCard)--发送所有底牌
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_CONTINUE_END,self,self.onGameEnd)--游戏正常结束
    RoomSocket:addDataHandler(MDM_GM_GAME_NOTIFY,CR_ASS_AHEAD_END,self,self.onGameAheadEnd)--游戏提前结束
    
    RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_USER_SIT,self,self.onSit)--加入桌子
    RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_QUEUE_USER_SIT,self,self.onSit)--加入桌子
    RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_SIT_ERROR,self,self.onSitError)--加入桌子失败
    --领取救济金
    RoomSocket:addDataHandler(MDM_GR_ROOM,ASS_GR_SEND_MONEY_NOTFIY,self,self.onReMoneyNotifiy)
    --金币不足
    RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_NoMoneyTickRoom,self,function ( ... )
        _uim:showLayer(ui.pochang,{iTargetofGold=crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].gold1,iTargeType=1})
        self:onCloseClient()
    end)
    --火箭公告
    GameSocket:addDataHandler(MDM_GP_MAQ_MSG,ASS_GP_MAQ_MSG_NOTIFY,self,self.onServerInfo)
    --使用道具
    RoomSocket:addDataHandler(MDM_GR_PROP,ASS_PROP_USEPROP,self,self.onResUseItem)
    RoomSocket:addDataHandler(MDM_GR_USER_REFRESH,ASS_GR_USER_MONRY_REFRESH,self,self.onRefreshUser)
    
    RoomSocket:addReconnetCallback(self,handler(self,self.reLogin))
    -- RoomSocket:addDataHandler(MDM_GR_USER_ACTION,ASS_GR_USER_AUTO_SIT,self,self.onUserAutoSit)
    -- GameEvent:addEventListener(GameEvent.updatePlayer,self,self.onUpdatePlayer)
    
    
    -- self:addCardsPnlEvent()
    GameEvent:addEventListener(GameEvent.gametoBack,self,self.onGoBack)
    GameEvent:addEventListener(GameEvent.gameBackFromGround,self,self.gameBackFromGround)

    RoomSocket:addDataHandler(MDM_GR_TASKDAILY,ASS_GR_GAMETASK_BOX_AWARD,self,self.onGameTaskBoxAward)

    self._pnl_jetton_btn:setVisible(false)
    self._pnl_cardType_tip:setVisible(false)

    self:sendToServer()
end

function crazyGame:onGameTaskBoxAward( res,uAssistantID,stateType, head )
    trace("=============1111=============")
    traceObj(res)
    if head and head.uHandleCode == 0 then
        self._iStraightWins = self._iStraightWins + 1
        self._curBoxNum = res.iPlayCount
    elseif head and head.uHandleCode == 1 then
        self._iStraightWins = self._allBoxCount
    elseif head and head.uHandleCode == 3 then
        self._curBoxNum = res.iPlayCount
    end
    self:onUpdateStraigAndBoxJushu(self._curBoxNum, false)
end

function crazyGame:showSliderData( iGlod )
    local m = 0
    if iGlod <= 1000 then
        m = 10
    elseif iGlod <= 10000 then
        m = 100
    elseif iGlod <= 100000 then
        m = 1000
    elseif iGlod <= 1000000 then
        m = 10000
    elseif iGlod <= 10000000 then
        m = 100000
    elseif iGlod > 10000000 then
        m = 500000
    end
    return m
end

function crazyGame:onCloseClient( ... )
    _uim:closeLayer(ui.crazyGame)
end

function crazyGame:sendToServer( ... )
    util.addEventBack(self,handler(self,self.onBackHall))
    -- RoomSocket:sendMsg(MDM_GR_USER_ACTION,ASS_GR_USER_AUTO_SIT,{bSitType=0})
end

function crazyGame:hideRefueling( ... )
    self._pnl_refueling:setVisible(false)
    self.slider_bet:setPercent(0)
end
function crazyGame:onSelectBetType( iRoundSelect )
    if self._curRoundSelect == iRoundSelect then
        self._curRoundSelect = -1
    else
        self._curRoundSelect = iRoundSelect
    end
    for i=0,1 do
        if i == self._curRoundSelect then
            self["img_select_" .. i]:setVisible(true)
        else
            self["img_select_" .. i]:setVisible(false)
        end
    end
end
 
function crazyGame:restSelectBetType( ... )
    self._curRoundSelect = -1
    for i=0,1 do
        self["img_select_" .. i]:setVisible(false)
    end
    -- self._pnl_auto_jetton:setVisible(false)
end

function crazyGame:onUserAutoSit( res,uAssistantID,stateType, head )
    if head.uHandleCode == 50 then
        self:clearAllData()
        self:clearGameData()
    end
end

--切后台
function crazyGame:onGoBack()
    RoomSocket:disconnect()
    _am:pauseMusic()
    self:clearAllData()
    if not self.m_bGameBegin then
        self:onCloseClient()
        return
    end
end

--前台
function crazyGame:gameBackFromGround()
    _am:resumeMusic()
    RoomSocket:connect(nil,nil,handler(self,self.reLogin))
end

function crazyGame:onReMoneyNotifiy( res )
    if res.iUserID == PlayerData:getUserID() then
        self._playerInfo[2].dwMoney = self._playerInfo[2].dwMoney + 5000
         _uim:showLayer(ui.pochang_buzhu,true)
        -- util.delayCall(self,function()
        --     self._playerInfo[2].dwMoney = self._playerInfo[2].dwMoney + 10000
        --     _uim:showLayer(ui.pochang_buzhu,true)
        -- end,6.5)
    else
        for i=0,4 do
            local viewDesk = self:SwitchViewChairID(i)
            if self._playerInfo[viewDesk] and self._playerInfo[viewDesk].dwUserID == res.iUserID then
                self._playerInfo[viewDesk].dwMoney = self._playerInfo[viewDesk].dwMoney + 5000
                local desc = util.showNumberCoinFormat(self._playerInfo[viewDesk].dwMoney)
                self:getNode(i,"lb_bean"):setString(desc)
                break
            end
        end
    end
end

function crazyGame:showExitAni( bShow )
    -- self.imgExit:stopAllActions()
    local strPath
    if bShow then
        strPath = "img2/carzyRes/xitongxiala2.png"
    else
        strPath = "img2/carzyRes/xitongxiala1.png"
        self._showMoreFunc = nil
    end
    -- local act1 = cc.RotateTo:create(0.3, rate)
    util.loadImage(self.imgExit,strPath)
    -- self.imgExit:runAction(act1)
end

function crazyGame:onShowMoreFunc( ... )
    local showMoreFunc = ui.createCsbItem("csb.crazyGame.moreFunction")
    self._showMoreFunc = showMoreFunc
    if showMoreFunc then
        util.aptNotScale(showMoreFunc.img_bk,true)
        util.aptSelf(showMoreFunc)
        util.setshakePos(showMoreFunc,cc.p(util.display.width,util.display.height))
        self:onUpdateSeatUpBtn()
        util.clickSelf(self,showMoreFunc._btnExit,function ( ... )
            showMoreFunc:removeFromParent()
            self:showExitAni(false)
            self:onBackHall()
        end)
        util.clickSelf(self,showMoreFunc._btnSetting,function ( ... )
            showMoreFunc:removeFromParent()
            self:showExitAni(false)
            self:onSetting()
        end)
        util.clickSelf(self,showMoreFunc._btnhuanzhuo,function ( ... )
            showMoreFunc:removeFromParent()
            self:showExitAni(false)
            self:onHuanZhuo()
        end)
        util.clickSelf(self,showMoreFunc._btnseatUp,function ( ... )
            showMoreFunc:removeFromParent()
            self:showExitAni(false)
            self:onSeatUp()
        end)
        util.clickSelf(self,showMoreFunc.pnl_close,function ( ... )
            self:showExitAni(false)
            showMoreFunc:removeFromParent()
        end)
        util.addToModule(showMoreFunc)
        self:showExitAni(true)
    end
end
--退出房间
function crazyGame:dispose()
    RoomSocket:sendMsg(MDM_GM_GAME_FRAME,ASS_GM_FORCE_QUIT)--通知服务器离开房间
    RoomSocket:disconnect()
    local tbl = 
    {
        [1] = ui.pochang,
        [2] = ui.wordstip,
    }
    -- GameSocket:sendMsg(MDM_GP_LIST,ASS_GP_GET_GAME_PEOPLE_COUNT)
    GameSocket:sendMsg(MDM_GP_USERREFLASH,ASS_GP_USERREFLASH)
    util.popAllModleWin(tbl)
    PlayerData:setPlayerRoomData()
    PlayerData:setIsGame(false)
    util.changeUI(ui.SelectGame)
end

--退出
function crazyGame:onBackHall()
    if self.m_bGameBegin and self:setPlayerIsPlaying(self.bDeskStation) then
        Alert:showCrazyGameTips("本局结束后，系统将自动帮您退出游戏！",function() 
            if self.m_bGameBegin == false then
                self:onCloseClient()
            end
            self._bIsQuit = true
        end)
    else
        self:onCloseClient()
    end
end

--设置
function crazyGame:onSetting()
    local info = {
        csbPath = "csb/crazyGame/"
    }
    _uim:showLayer(ui.gameSet,info)
end

function crazyGame:clearGameData( ... )
    self.bDeskStation = 0
    self:removeAllCards()
    self._playerCards = {}
    self._playerInfo = {}
    --初始化玩家信息
    for i=0,PLAY_COUNT-1 do
        self:setPlayerInfo(i)
    end
    -- self:intiPlayerData()
    --游戏状态
    self._igameState = _gameStation.rest_time_station
    -- self:onShowBullPeidui(true)
    self:setCardIsTouch(false)
end
--换桌
function crazyGame:onHuanZhuo()
    if self.m_bGameBegin and self:setPlayerIsPlaying(self.bDeskStation) then
        Alert:showCrazyGameTips("正在游戏中，无法换桌！", nil, true)
    else
        RoomSocket:sendMsg(MDM_GR_USER_ACTION,ASS_GR_USER_AUTO_SIT,{bSitType=1})
    end
end

function crazyGame:onSeatUp( ... )
    -- if self:setPlayerIsPlaying(self.bDeskStation) and (self.m_bGameBegin and self._igameState ~= _gameStation.game_end_station) then
        RoomSocket:sendMsg(MDM_GR_USER_ACTION,ASS_GR_USER_STANDUP)
    -- end
end

function crazyGame:reLogin( ... )
    RoomSocket:addDataHandler(MDM_GR_LOGON,nil,self,self.onLoginRoom)--登录房间返回,续局时要用
    RoomSocket:sendMsg(MDM_GR_LOGON,ASS_GR_LOGON_BY_ID,PlayerData:getReLoginByID())
end

function crazyGame:getDeskTbl(bDeskStation,key,tbl)
    local index = self:SwitchViewChairID(bDeskStation)
    local res =  tbl and tbl[key] and tbl[key][index+1] 
    assert(res~=nil,"error:getDeskTbl unknow node bDeskStation = "..bDeskStation.." key = "..key.." node = ")
    return res
end
function crazyGame:getNode(bDeskStation,key)
    local node = self[self:getDeskTbl(bDeskStation,key,_nodes)]
    assert(node~=nil,"error:getNode unknow node bDeskStation = "..bDeskStation.." key = "..key.." mydesk = "..self.bDeskStation)
    return node
end
function crazyGame:getAnchor(bDeskStation,key)
    return self:getDeskTbl(bDeskStation,key,_anchor)
end

function crazyGame:intiPlayerData()
    self:setPlayerInfo(self.bDeskStation,PlayerData:getPlayerRoomData())
    self._iTax = crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].num1
    if PlayerData:getPlayerRoomData() and PlayerData:getPlayerRoomData().sPlayCount then
        self._curBoxNum = PlayerData:getPlayerRoomData().sPlayCount
        self._iStraightWins = PlayerData:getPlayerRoomData().bTodayFishCount
        self:onUpdateStraigAndBoxJushu(self._curBoxNum,false)
    end
end

function crazyGame:onUpdateStraigAndBoxJushu( iBoxJu, bAdd )
    self._curBoxNum = bAdd and self._curBoxNum + iBoxJu or iBoxJu
    if not self._boxAction then
        local ani,aniAction = Animation:createCSExpressionAni(20014)
        -- ui.setNodeMap(ani, self)
        self._boxAction = aniAction
        self._boxAction:gotoFrameAndPause(0)
        self.node_box:addChild(ani)
    end
    if self._iStraightWins and self._iStraightWins >= self._allBoxCount then
        self.btn_box:setVisible(false)
        _uim:closeLayer(ui.gameBoxTask)
        self._boxAction:gotoFrameAndPause(0)
        self.lb_box_jushu:setString("明日再来")
    elseif self._iStraightWins then
        --todo
        if self._curBoxNum - self._allBoxNum >= 0 then
            self._boxAction:play("baoxiang", true)
            self.lb_box_jushu:setString("领取奖励")
            GameEvent:notifyView(GameEvent.updateBoxTask)
        else
            self._boxAction:gotoFrameAndPause(0)
            self.lb_box_jushu:setString("再胜" .. self._allBoxNum-self._curBoxNum .. "局")
        end
    end
end
function crazyGame:hidePlayerBetGold()
    for i=0,PLAY_COUNT-1 do
        self._curAmountBet[i] = 0
        self:getNode(i,"img_bet_bg"):setVisible(false)
        self:getNode(i,"lb_bet_gold"):setString(0)
        self["img_lb_bg_" .. i+1]:setVisible(false)
        self["lb_goldpiles_" .. i+1]:setString("")
    end
    for i=1,self._curGoldPiles do
        self["_imgBet_" .. i]:setPositionX(goldPilesPos[self._curGoldPiles][i])
    end
end

function crazyGame:onLoginRoom(res,uAssistantID,stateType, head)
    if uAssistantID == ASS_GR_LOGON_ERROR then
        --if head.uHandleCode == 14 then
            self:onCloseClient()
        --end
    elseif uAssistantID == ASS_GR_LOGON_SUCCESS then
        -- RoomSocket:sendMsg(MDM_GR_USER_ACTION,ASS_GR_USER_AUTO_SIT,{bSitType=0})
    end
end

function crazyGame:onSit(res)
    if res then
        for i=0,res.cbUserCount-1 do
            if res.userSitApp[i].dwUserID == PlayerData:getUserID() then
                self:clearGameData()
                self.bDeskStation = res and res.userSitApp[i].bDeskStation or 0
            end
        end
        self._bGameBegin = true
    end
end
--坐下失败
function crazyGame:onSitError( res, uAssistantID, stateType, head )
    if head and head.uHandleCode == 73 then
        self:onCloseClient()
    end
end

--头像
function crazyGame:getPlayerHead(desk)
    return self:getNode(desk,"btn_head")
end

--金币位置
function crazyGame:getPlayerBetGold( desk )
    return self:getNode(desk,"img_bet_icon")
end

function crazyGame:showGoldAni(startDesk,iAmount)
    local startNode = self:getPlayerHead(startDesk)
    local targetNode = self:getPlayerBetGold(startDesk)
    if tolua.isnull(startNode) or tolua.isnull(targetNode) or not startNode:isVisible() or not targetNode:isVisible() then
        return
    end
    local spNum = math.ceil(iAmount/self._difen)
    if spNum > 12 then
        spNum = 12
    end
    local offset1 = 35
    local offset2 = 10
    local time = 0.5

    local parent = util.getTipLayer()
    local strartPos = cc.p(startNode:getContentSize().width/2,startNode:getContentSize().height/2)
    local targetPos = cc.p(targetNode:getContentSize().width/2,targetNode:getContentSize().height/2)
    strartPos = startNode:convertToWorldSpace(strartPos)
    strartPos = parent:convertToNodeSpace(strartPos)
    targetPos = targetNode:convertToWorldSpace(targetPos)
    targetPos = parent:convertToNodeSpace(targetPos)

    for i=1,spNum do
        self:palyGoldSound()
        local sp = cc.Sprite:createWithTexture(self._goldBatchNode:getTexture())
        self._goldBatchNode:addChild(sp)
        -- local sp = cc.Sprite:create()
        -- util.loadSprite(sp,"img2/carzyRes/jinbi.png")
        sp:setVisible(false)
        -- parent:addChild(sp)
        local xoffset = math.random(-offset1,offset1)
        local yoffset = math.random(-offset1,offset1)
        sp:setPosition(cc.p(strartPos.x+xoffset,strartPos.y+yoffset))
        xoffset = math.random(-offset2,offset2)
        yoffset = math.random(-offset2,offset2)
        local pos = cc.p(targetPos.x+yoffset,targetPos.y+yoffset)
        local delay = cc.DelayTime:create(0.02*i)
        local callFunc = cc.CallFunc:create(function() 
            sp:setVisible(true)
        end)
        local move = cc.MoveTo:create(time,pos)
        local ease = cc.EaseSineInOut:create(move)
        local delay2 = cc.DelayTime:create(0.05)
        local del = cc.CallFunc:create(function() 
            sp:removeFromParent()
            if self._curAmountBet[startDesk] == -1 then
                self:getNode(startDesk,"lb_bet_gold"):setString("已全下")
            else
                 self:getNode(startDesk,"lb_bet_gold"):setString(util.showNumberCoinFormat(self._curAmountBet[startDesk]))
            end
            if i == spNum then
                self:showJettonGoldAni(startDesk)
            end
        end)
        sp:runAction(cc.Sequence:create(delay,callFunc,ease,del))
    end
end

function crazyGame:showPlayerFlyPubilc(iDesk, startDesk,iGold,bEnter)
    local startNode = self:getPlayerHead(iDesk)
    local targetNode = self["_imgBet_" .. startDesk+1]
    if tolua.isnull(targetNode) or not targetNode:isVisible() then
        return
    end
    local parent = self["_imgBet_" .. startDesk+1]--util.getTipLayer()
    local strartPos = cc.p(startNode:getContentSize().width/2,startNode:getContentSize().height/2)
    strartPos = startNode:convertToWorldSpace(strartPos)
    strartPos = parent:convertToNodeSpace(strartPos)
    local targetPos = cc.p(targetNode:getContentSize().width/2,targetNode:getContentSize().height/2)
    targetPos = targetNode:convertToWorldSpace(targetPos)
    targetPos = parent:convertToNodeSpace(targetPos)
    local spNum = 1
    if bEnter then
        self:noFlyGoldSteam(parent,spNum,targetPos,startDesk)
    else
        self:flyGoldStream(parent,spNum,targetPos,strartPos,startDesk,iGold)
    end
end

function crazyGame:noFlyGoldSteam(parent, spNum, targetPos,startDesk)
    -- local batchNode = cc.SpriteBatchNode:create("img2/carzyRes/jinbi.png",10)
    -- parent:addChild(batchNode)

    for i=1,spNum do
        local sp = cc.Sprite:create()
        util.loadSprite(sp,"img2/carzyRes/jinbi.png")
        parent:addChild(sp)
        -- local sp = cc.Sprite:createWithTexture(self._batchNodePiles[startDesk+1]:getTexture())
        -- self._batchNodePiles[startDesk+1]:addChild(sp)
        if not self._storeGoldSp then
            self._storeGoldSp = {}
        end
        if not self._storeGoldSp[startDesk] then
            self._storeGoldSp[startDesk] = {}
        end
        table.insert(self._storeGoldSp[startDesk],sp)
        local offset = 35
        local xoffset = math.random(-offset,offset)
        local yoffset = math.random(-offset,offset)
        local pos = cc.p(targetPos.x+xoffset,targetPos.y+yoffset)
        sp:setPosition(pos)
    end
    -- self["img_lb_bg_" .. startDesk+1]:setVisible(true)
    -- self["lb_goldpiles_" .. startDesk+1]:setString(util.showNumberCoinFormat(iGold))
end

function crazyGame:showRoundGoldAni(startDesk, iGold, bEnd)
    local startNode = self:getPlayerBetGold(startDesk)
    local targetNode = self["_imgBet_" .. startDesk+1]
    if tolua.isnull(targetNode) or not targetNode:isVisible() then
        return
    end

    if not self._storeGoldSp then
        self._storeGoldSp = {}
        if not self._storeGoldSp[startDesk] then
            self._storeGoldSp[startDesk] = {}
        end
    end

    local parent = self["_imgBet_" .. startDesk+1]--util.getTipLayer()
    local targetPos = cc.p(targetNode:getContentSize().width/2,targetNode:getContentSize().height/2)
    targetPos = targetNode:convertToWorldSpace(targetPos)
    targetPos = parent:convertToNodeSpace(targetPos)

    if not bEnd then
        local spNum = math.floor(iGold/self._difen)
        if spNum > 10 then
            spNum = 10
        end
        self:noFlyGoldSteam(parent,spNum,targetPos,startDesk)
        self["img_lb_bg_" .. startDesk+1]:setVisible(true)
        self["lb_goldpiles_" .. startDesk+1]:setString(util.showNumberCoinFormat(iGold))
        return
    end

    for i=0,PLAY_COUNT-1 do
        if self._curAmountBet[i] > 0 and self:setPlayerIsPlaying(i) then
            startNode = self:getPlayerBetGold(i)
            local strartPos = cc.p(startNode:getContentSize().width/2,startNode:getContentSize().height/2)
            strartPos = startNode:convertToWorldSpace(strartPos)
            strartPos = parent:convertToNodeSpace(strartPos)
            local spNum = math.floor(self._curAmountBet[i]/self._difen)
            if spNum > 10 then
                spNum = 10
            end
            self:flyGoldStream(parent,spNum,targetPos,strartPos,startDesk,iGold)
        elseif self._curAmountBet[i] > 0 and not self:setPlayerIsPlaying(i) then
            local spNum = 5
            self:noFlyGoldSteam(parent,spNum,targetPos,startDesk)
            self["img_lb_bg_" .. startDesk+1]:setVisible(true)
            self["lb_goldpiles_" .. startDesk+1]:setString(util.showNumberCoinFormat(iGold))
        end
    end
end

function crazyGame:flyGoldStream(parent, spNum,targetPos,strartPos,startDesk,iGold)
    local offset = 35
    local time = 0.5
    
    if not self._storeGoldSp then
        self._storeGoldSp = {}
    end
    if not self._storeGoldSp[startDesk] then
        self._storeGoldSp[startDesk] = {}
    end

    self:palyGoldSound()
    for i=1,spNum do
        local sp = cc.Sprite:create()
        util.loadSprite(sp,"img2/carzyRes/jinbi.png")
        parent:addChild(sp)
        -- local sp = cc.Sprite:createWithTexture(self._batchNodePiles[startDesk+1]:getTexture())
        -- self._batchNodePiles[startDesk+1]:addChild(sp)

        table.insert(self._storeGoldSp[startDesk],sp)
        sp:setPosition(strartPos)
        local xoffset = math.random(-offset,offset)
        local yoffset = math.random(-offset,offset)
        local pos = cc.p(targetPos.x+xoffset,targetPos.y+yoffset)
        local delay = cc.DelayTime:create(0.012*i)
        local move = cc.MoveTo:create(time,pos)
        local ease = cc.EaseSineInOut:create(move)
        local delay2 = cc.DelayTime:create(0.05)
        local del = cc.CallFunc:create(function() 
            if i == spNum then
                self["img_lb_bg_" .. startDesk+1]:setVisible(true)
                self["lb_goldpiles_" .. startDesk+1]:setString(util.showNumberCoinFormat(iGold))
                for j=0,PLAY_COUNT-1 do
                    if self._curAmountBet[j] > 0 or self._igameState == _gameStation.game_end_station then
                        self._curAmountBet[j] = 0
                        self:getNode(j,"img_bet_bg"):setVisible(false)
                        self:getNode(j,"lb_bet_gold"):setString(0)
                    end
                end
            end
        end)
        sp:runAction(cc.Sequence:create(delay,ease,delay2,del))
    end
end

--分堆
function crazyGame:showGoldPiles( ... )
    if self._preGoldPiles == self._curGoldPiles then
        return
    end
end

function crazyGame:isNoMoneyGotoRoom( ... )
    local iCurRoomMin = crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].gold1
    if self._playerInfo[2].dwMoney < iCurRoomMin then
        _uim:showLayer(ui.pochang,{iTargetofGold=iCurRoomMin,iTargeType=1})
        self:onCloseClient()
    else
        if self._bIsQuit == true then
            self:onCloseClient()
        end
    end
end

function crazyGame:clearAllData( ... )
    self._curSelementiMoney = nil
    self._iWinStation = -1
    self._backPublicCard = {}
    self._pnl_jetton_btn:setVisible(false)
    self:hideRefueling()
    self._icurBetMaxMoney = 0
    self._iCurBackIndex = 0
    self._publicCardItem = {}
    self._node_public_card:removeAllChildren()
    self._node_gameEnd_Ani:removeAllChildren()
    util.removeAllSchedulerFuns(self)
    self._curPlayerCaozuo = UserOperationType.UserOperation_Type_Invalid
    self:hidePlayerInfo()
    self:removeClock()
    for i=0,PLAY_COUNT-1 do
        local view = self:SwitchViewChairID(i)
        self:removeProgressTime(view)
        self:getNode(i,"node_ani_win"):removeAllChildren()
        self:getNode(i,"node_gold_end_pos"):removeAllChildren()
        self:getNode(i,"node_desk_Card"):removeAllChildren()
        if self._storeGoldSp and self._storeGoldSp[i] then
            for k,v in pairs(self._storeGoldSp[i]) do
                if not tolua.isnull(v) then
                    v:removeFromParent()
                end
            end
            self._storeGoldSp[i] = {}
        end
        self["img_lb_bg_" .. i+1]:setVisible(false)
        self["lb_goldpiles_" .. i+1]:setString("")
        self:getNode(i,"img_win_mark"):setVisible(false)
        -- self:getNode(i,"node_head_pos"):removeAllChildren()
    end
    self._pnl_cardType_tip:setVisible(false)
    self._curGoldPiles = 1
    self._preGoldPiles = 1
    self._curPlayerBetAllGold = 0
    self._pnl_auto_jetton:setVisible(false)
    self:restSelectBetType()
    self:hidePlayerBetGold()
end

function crazyGame:setPlayerInfo(bDeskStation,playerInfo)
    if playerInfo and playerInfo.dwUserID == PlayerData:getUserID() then
         self._playerInfo[2] = playerInfo
    elseif playerInfo then
        local view = self:SwitchViewChairID(bDeskStation)
        self._playerInfo[view] = playerInfo
    end
    if not playerInfo then
        local view = self:SwitchViewChairID(bDeskStation)
        self._playerInfo[view] = playerInfo
        self:getNode(bDeskStation,"pnl_Info"):setVisible(false)
        return
    end
    if not self:setPlayerIsPlaying(bDeskStation) then
        self:getNode(bDeskStation,"pnl_Info"):setOpacity(180)
    else
        self:getNode(bDeskStation,"pnl_Info"):setOpacity(255)
    end
    local nickName = playerInfo.nickName
    local bLogoID = playerInfo.bLogoID
    local dwMoney = playerInfo.dwMoney
    local desc = util.showNumberCoinFormat(dwMoney)
    -- util.setTextMaxWidth(self:getNode(bDeskStation,"lb_nickName"),100)
    self:getNode(bDeskStation,"lb_nickName"):setString(nickName)
    
    self:getNode(bDeskStation,"lb_bean"):setString(desc)
    self:getNode(bDeskStation,"pnl_Info"):setVisible(true)
    local url = playerInfo.szHeadWeb
    if url and url ~= "" then
        PlayerData:setPlayerHeadIcon(self:getNode(bDeskStation,"img_head"),url,9,bLogoID)
    elseif self.bDeskStation == bDeskStation then
        PlayerData:setPlayerHeadIcon(self:getNode(bDeskStation,"img_head"),nil,9)
    else
        R:setPlayerIcon(self:getNode(bDeskStation,"img_head"),bLogoID)
    end
    self:getNode(bDeskStation,"img_head_vip"):setLocalZOrder(10)
    PlayerData:setPlayerHeadVip(self:getNode(bDeskStation,"img_head_vip"),playerInfo.bVipLevel)

    util.clickSelf(self,self:getNode(bDeskStation,"btn_head"),self.showOtherPlayer,playerInfo)
end

function crazyGame:showOtherPlayer(playerInfo)
    self:showPlayerInfo(playerInfo,playerInfo.bDeskStation)
end

function crazyGame:showPlayerInfo(info,bDeskStation)
    if info.dwUserID == PlayerData:getUserID() then
        local anchor = cc.p(0,0)
        local node = self._btn_player_2
        pos = cc.p(node:getPosition())
        pos.x = pos.x + node:getContentSize().width/2
        -- pos = node:getParent():convertToWorldSpace(pos)
        local tbl = {}
        
        info.posInfo = {pos = pos,anchor = anchor}
        info.bull = true
        info.iTax = crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].gold1
        tbl.csbPath = "csb/crazyGame/"
        tbl.data = info
        tbl.iGold = self._playerInfo[2].dwMoney
        _uim:showLayer(ui.userInfo,tbl)
    else
        local anchor = self:getAnchor(bDeskStation,"Node_head")
        local node = self:getNode(bDeskStation,"btn_head")
        pos = cc.p(node:getPosition())
        pos = node:getParent():convertToWorldSpace(pos)
        info.posInfo = {pos = pos,anchor = anchor}
        info.bull = true
        info.iTax = crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].gold1
        local tbl = {}
        tbl.csbPath = "csb/crazyGame/"
        tbl.data = info
        tbl.iGold = self._playerInfo[2].dwMoney
        _uim:showLayer(ui.userInfo,tbl)
    end 
end

function crazyGame:setCardIsTouch( bTouch )
    -- self.Panel_myCards_no:setVisible(not bTouch)
end

--获取当前选中的卡牌
function crazyGame:getSelectCards()
    local tbl = {}
    local m = 0
    if self._cardItems then
        for _,item in pairs(self._cardItems) do
            if item.getSelected() then
                table.insert(tbl,m,item.id)
                m = m + 1
            end
        end
    end
    return tbl
end
--选中卡牌
function crazyGame:setSelectCards(tbl)
    if table.nums(self._cardItems) <= 0 then
        return
    end
    for _,item in pairs(self._cardItems) do
        local bselect = false
        for i,j in pairs(tbl) do
            if j == item.id then
                bselect = true
                break
            end
        end
        item.setSelected(bselect)
        item.setTouched(not bselect)
    end
end

--触摸点在元素里
function crazyGame:isTouchinNode(node,point)
    if tolua.isnull(node) then
        return false
    end
    local rect = node:getBoundingBox()--util.getWorldBoundingBox(node)
    point = node:getParent():convertToNodeSpace(point)
    return cc.rectContainsPoint(rect,point)
end

--创建牌
function crazyGame:createCard(id,tbl)
    tbl = tbl or self._cardItems
    local item = self:createCardItem(id)

    if not item then
        return 
    end
    self.Panel_myCards:addChild(item)
    table.insert(tbl,item)
    -- --选中上移
    -- item.setSelected = function(flag)
    --     if item._selected == flag then
    --         return
    --     end
    --     item:setPositionY(flag and 20 or 0)
    --     item._selected = flag
    -- end

    -- item.getSelected = function() return item._selected end

    -- --灰色
    -- item.setTouched = function(flag)
    --     local color = flag and cc.c4b(150,150,150,255) or cc.c4b(255,255,255,255)
    --     item.sp_bg:setColor(color)
    --     item._touched = flag
    -- end
    -- item.getTouched = function() return item._touched end
    return item
end

function crazyGame:createCardItem(cardID,scale,turnTime)
    if cardID == ID_CARD_BACK then
        turnTime = false
    end
    local config = cardsConfig
    local item = ui.createCsbItem("csb.playRoom.CardItem",true)
    item:setScale(0.6)
    if item.setTouched then
        item.setTouched(false)
    end
    item:setVisible(true)
    item:setAnchorPoint(0,0)
    item.setCard = function(id,bk) 
        local info = bk and config[ID_CARD_BACK] or config[id]
        if type(info) ~= "table" then
            return false
        else
            -- util.loadSprite(item.sp_bg,"img2/carzyRes/zm.png")
            for _,child in pairs(item.sp_bg:getChildren()) do
                if iskindof(child,"cc.Sprite") then
                    local name = child:getName()
                    local img = info[name]
                    if img and img ~= "" then
                        img = "img2/GameScene/pai/"..img
                        child:setVisible(true)
                        if scale then
                            child:setScale(child:getScale()*scale)
                        end
                        util.loadSprite(child,img)
                    else
                        child:setVisible(false)
                    end
                end
            end
            if scale then
                item.sp_huaseSmall:setPosition(38,135)
            end
        end
        item.id = id
        return true
    end
    --翻转
    item.turnToFace = function(time,time2)
        local tagID = item.id
        if tagID == ID_CARD_BACK then
            return
        end
        time2 = tonumber(time2) or 0.2
        time = tonumber(time) or 0.7
        local fun1 = cc.CallFunc:create(function() util.changeAnchor(item,cc.p(0.5,0)) end)
        local delay = cc.DelayTime:create(time)
        local action2 = cc.OrbitCamera:create(time2,0.5,0,270,90,0,0)
        local turn = cc.CallFunc:create(function() item.setCard(tagID) end)
        local action1 = cc.OrbitCamera:create(time2,0.5,0,0,90,0,0)
        local fun2 = cc.CallFunc:create(function() util.changeAnchor(item,cc.p(0,0)) end)

        item:runAction(cc.Sequence:create(fun1,delay,action1,turn,action2,fun2))
    end

    --显示特效
    item.showAni = function(bShow)
        item._node_ani:removeAllChildren()
        if not bShow then
            return
        end
        local cardAni = ui.loadCS("csb/crazyGame/effect/03kapaiguang")
        local cardAniAction = ui.loadCSTimeline("csb/crazyGame/effect/03kapaiguang")
        cardAni:runAction(cardAniAction)
        cardAniAction:play("03kapaiguang", true)
        ui.setNodeMap(cardAni, cardAni)
        -- local showType = ui.createCsbItem("csb.crazyGame.showCardType",true)
        -- cardAni:setPosition(NUtils.getCenterPoint(pnlCards,0,-pnlCards:getContentSize().height/4))
        item._node_ani:addChild(cardAni)
    end

    --选中上移
    item.setSelected = function(flag)
        if item._selected == flag then
            return
        end
        item:setPositionY(flag and 15 or 0)
        item._selected = flag
    end
    -- item.getSelected = function() return item._selected end

    --灰色
    item.setTouched = function(flag)
        local color = flag and cc.c4b(150,150,150,255) or cc.c4b(255,255,255,255)
        item.sp_bg:setColor(color)
        item._touched = flag
    end

    item.setGray = function(flag)
        local color = flag and cc.c4b(150,150,150,255) or cc.c4b(255,255,255,255)
        item.sp_bg:setColor(color)
    end

    item.showBK = function(flag)
        item.setCard(cardID,flag)
    end

    return item.setCard(cardID,turnTime) and item
end

--桌面上的小牌
function crazyGame:createsmallCards(tbl,cardType)
    local scale = 0.4
    local space = 32
    local items = {}
    local pnl = ccui.Layout:create()
    pnl.items = items
    pnl.setBorderSize = function()end
    pnl.setBgColor = function()end
    if type(tbl) ~= "table" or table.nums(tbl) < 1 then
        return pnl
    end
    for _,id in pairs(tbl) do
        if id ~=0 then    
            local item = self:createCardItem(id,1.1)
            -- if cardType == 0x00 then
            --     item.sp_bg:setColor(cc.c4b(150,150,150,255))
            -- end
            if item then
                item:setScale(scale)
                table.insert(items,item)
            end
        end
    end

    if type(items) ~= "table" or table.nums(items) < 1 then
        return pnl                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    end
 
    local w = items[1]:getContentSize().width*scale+space*(table.nums(items)-1)
    local h = items[1]:getContentSize().height*scale

    local setSize = function(x,y)
        pnl:setContentSize(x,y)
        local offsetx = (x - w) /2
        local offsetY = (y - h) /2
        for index,item in pairs(items) do
            item:setTag(item.id)
            pnl:addChild(item)
            item:setPositionX(offsetx + space*(index - 1))
            item:setPositionY(offsetY)
        end
    end
    setSize(w,h)
    pnl.setBorderSize = function(x,y)
        setSize(w+2*x,h+2*y)
    end

    pnl.setBgColor = function(color,bgOpacity)
        pnl:setBackGroundColorType(1)
        pnl:setBackGroundColor(color)
        pnl:setBackGroundColorOpacity(bgOpacity)
    end
    pnl:setAnchorPoint(cc.p(0.5,0))
    return pnl
end

function crazyGame:hidePlayerInfo()
    self:removeAllCards()
end

--游戏开始,清掉旧的牌
function crazyGame:removeAllCards()
    if table.nums(self._cardItems) <= 0  then
        return
    end
    for _,card in pairs(self._cardItems) do
        card:removeFromParent()
    end
    self._cardItems = {}
end

function crazyGame:updateCardPos(tbl,notSort,time)
    if table.nums(self._cardItems) <= 0 then
        return
    end
    tbl = tbl or self._cardItems
    local cardNum = table.nums(tbl)
    if cardNum == 0 then
        return
    end

    local pnlW = tbl[1]:getParent():getContentSize().width
    local itemW = tbl[1]:getContentSize().width
    local space = itemW*0.6 + 10
    local cardsW = space*(cardNum - 1) + itemW
    for index,item in pairs(tbl) do
        item.setSelected(false)
        if time then
            item:setPosition(pnlW/2,0)
            local move = cc.MoveTo:create(time,cc.p((pnlW - cardsW)/2 + space*(index - 1),0))
            item:runAction(move)
        else
            item:setPosition((pnlW - cardsW)/2 + space*(index - 1),0)
        end
        item:setLocalZOrder(index)
    end
end

--视觉转换
function crazyGame:SwitchViewChairID( bDeskStation )
    if INVALID_CHAIR == bDeskStation then
        return INVALID_CHAIR
    end
    local wChairCount = 5
    local meChairID = self.bDeskStation
    local wViewChairID = ((bDeskStation - meChairID) + math.floor(wChairCount/2) + wChairCount) % wChairCount
    return wViewChairID
end

function crazyGame:showDeskCards(bDeskStation,tblCards,bShow,cardType, bTexaxType)
    local nodeCardParent = self:getNode(bDeskStation,"node_desk_Card")
    local pnlCards = self:createsmallCards(tblCards)
    local anchor = self:getAnchor(bDeskStation,"Node_DeskCard")
    nodeCardParent:removeAllChildren()
    pnlCards:setTag(10)
    pnlCards:setAnchorPoint(anchor)
    
    nodeCardParent:addChild(pnlCards)
    if cardType ~= -1 and cardType ~= -2 then
        local showType 
        local showTypeAction
        if bDeskStation == self._iWinStation then
            showType = ui.loadCS("csb/crazyGame/effect/03yingjiakapai")
            showTypeAction = ui.loadCSTimeline("csb/crazyGame/effect/03yingjiakapai")
            ui.setNodeMap(showType, showType)
            util.loadSprite(showType.sp_card_type, "img2/carzyRes/type/wCardType" .. cardType .. ".png")
        else
            showType = ui.loadCS("csb/crazyGame/effect/03kapaiguang_lan")
            showTypeAction = ui.loadCSTimeline("csb/crazyGame/effect/03kapaiguang_lan")
            ui.setNodeMap(showType, showType)
            util.loadSprite(showType.sp_card_type, "img2/carzyRes/type/lCardType" .. cardType .. ".png")
        end
        showType:setPosition(NUtils.getCenterPoint(pnlCards,0,-pnlCards:getContentSize().height/4))
        showType:runAction(showTypeAction)
        showTypeAction:play("play", false)
        

        if bTexaxType <= 0 or bTexaxType >= 9 or cardType == 0 then
            showType.sp_card_type:setAnchorPoint(cc.p(0.5,0.5))
            showType.sp_card_type:setPositionX(showType._img_type_bg:getContentSize().width/2)
            showType.sp_texax_type:setVisible(false)
        else
            if bDeskStation == self._iWinStation then
                util.loadSprite(showType.sp_texax_type, "img2/carzyRes/type/wTexax" .. bTexaxType .. ".png")
            else
                util.loadSprite(showType.sp_texax_type, "img2/carzyRes/type/lTexax" .. bTexaxType .. ".png")
            end
            if (bTexaxType == 8 and cardType >= 1 and cardType <= 9) or (bTexaxType < 8 and (cardType <= 0 or cardType >9))  then
                showType.sp_card_type:setPositionX(showType._img_type_bg:getContentSize().width*0.47)
                showType.sp_texax_type:setPositionX(showType._img_type_bg:getContentSize().width*0.53)
            elseif bTexaxType == 8 and (cardType <= 0 or cardType > 9) then
                showType.sp_card_type:setPositionX(showType._img_type_bg:getContentSize().width*0.53)
                showType.sp_texax_type:setPositionX(showType._img_type_bg:getContentSize().width*0.60)
            end
        end
        pnlCards:addChild(showType)
    elseif cardType == -2 then
    else
        self:sendCardToPerson(pnlCards.items)
    end
    return pnlCards
end

--发牌动画 0.38s
function crazyGame:sendCardToPerson(cardItems,isMine)
    if type(cardItems)~="table" or tolua.isnull(cardItems[1]) then
        trace("error:sendCardToPerson cardItems is not a table or has not card")
        return
    end
    local posCenter = cc.p(self:getContentSize().width/2,self:getContentSize().height/2)
    posCenter = cardItems[1]:getParent():convertToNodeSpace(posCenter)
    local num = table.nums(cardItems)
    for i,item in pairs(cardItems) do
        if not tolua.isnull(item) then
            local oldPos = cc.p(item:getPosition())
            local oldScale = item:getScale()
            item:setPosition(posCenter.x,posCenter.y)
            item:setScale(0.3)

            local time = 0.02
            local delay1 = cc.DelayTime:create((i-1)*time)
            local move1 = cc.Spawn:create(cc.MoveTo:create(0.2,cc.p(0,0)),cc.ScaleTo:create(0.2,oldScale)) 
            local delay2 = cc.DelayTime:create(0)
            local move2 = cc.MoveTo:create(0.1,oldPos)
            if isMine then
                move2 = cc.Spawn:create(cc.MoveTo:create(0.2,oldPos),cc.Sequence:create(cc.DelayTime:create(0.12) ,cc.CallFunc:create(function() item.turnToFace(0,0.08) end)) )
            end
            item:runAction(cc.Sequence:create(delay1,move1,delay2,move2))
        end
    end
end

function crazyGame:palyGoldSound()
    local cd = 0.5
    if self._isPlayingGoldSound then
        return
    end
    self._isPlayingGoldSound = true
    util.delayCall(self,function() self._isPlayingGoldSound = false end,cd)
    self:PlayMusic(_music.MUSIC_COIN_STREAM)
end

--播放音效
function crazyGame:PlayBetMusic( iDeskStation, iUserType)
    local viewDesk = self:SwitchViewChairID(iDeskStation)
    local bLogoID = self._playerInfo[viewDesk].bBoy
    local str = "crazyGame/"
    -- 判断男女身份获取路径
    if bLogoID == true then
        str = str .. "male/"
    else
        str = str .. "female/"
    end
    if iUserType == UserOperationType.UserOperation_Type_DisCard then
        str = str .. "fold_sound"
    elseif iUserType == UserOperationType.UserOperation_Type_WithSame then
        str = str .. "call_sound"
    elseif iUserType == UserOperationType.UserOperation_Type_AddMoney then  
        str = str .. "raise_sound"
    elseif iUserType == UserOperationType.UserOperation_Type_AllMoney then
        str = str .. "allin_sound"
    else
        return
    end
    util.playSound(str,false)

end

function crazyGame:PlayMusic(playMusicID)
    local str = "crazyGame/"
    -- 判断男女身份获取路径
    if playMusicID == _music.MUSIC_COIN_FLY_IN_SHOER then
        str = str .. "coins_fly_in_short"
    elseif playMusicID == _music.MUSIC_COIN_STREAM then
        str = str .. "coinCollide"
    elseif playMusicID == _music.MUSIC_GAME_WIN then
        str = str .. "gameWin"
    else
        return
    end
    util.playSound(str,false)
end

function crazyGame:PalyStoundChat( iTag )
    local str = "bullsounds/chat/Man_Chat_" .. iTag
    util.playSound(str,false)
end

--房间消息
function crazyGame:onOtherPlayerChange(res)
    for i=0,res.cbUserCount-1 do
        local playerInfo = res.userCome[i]
        if playerInfo and playerInfo.bDeskStation then
            local bDeskStation = playerInfo.bDeskStation
            if playerInfo.dwUserID == PlayerData:getUserID() then
                self.bDeskStation = playerInfo.bDeskStation or 0
            end
            self:setPlayerInfo(bDeskStation,playerInfo)
        end
    end
end

function crazyGame:onOtherlevave(res)
    if res then
         for i=0,res.cbUserCount-1 do
            local playerInfo = res.userSitApp[i]
            if playerInfo and playerInfo.bDeskStation then
                self:setPlayerInfo(playerInfo.bDeskStation)
            end
        end
    end
    if table.nums(self._playerInfo) <= 1 then
        self:removeClock()
        self:showCurBetMaxInfo("请等待其他玩家...", true)
        -- self:showClock(-1,"等待其他玩家", 0 and function() end)
    end
end

function crazyGame:showCurBetMaxInfo( str, bForver)
    self.lb_tax_tip:setString(str)
    self.lb_tax_tip:setAnchorPoint(cc.p(0.5,0.5))
    local width = util.fixLaberWidth(self.lb_tax_tip,true) + 60
    self.img_tax_tip:setContentSize(cc.size(width,self.img_tax_tip:getContentSize().height))
    self.img_tax_tip:setVisible(true)
    self.lb_tax_tip:setPositionX(self.img_tax_tip:getContentSize().width/2)
    if not bForver then
        util.delayCall(self.img_tax_tip,function() 
            self.img_tax_tip:setVisible(false)
        end,2)
    end
    
end
-------------------------------------服务器消息--------------------------------------------------
--[[
CR_GS_WAIT_WAITE                =   30
CR_GS_GAME_BEGIN                =   31
CR_GS_XIAZHU                    =   32
CR_GS_SEANDBACKCARD             =   33
CR_GS_GAMEEND                   =   34
--]]
function crazyGame:onGameStation( res,_,stateType )
    -- trace("+===========服务器消息===========",stateType)
    self:clearAllData()
    if stateType == CR_GS_WAIT_WAITE or not self:setPlayerIsPlaying(self.bDeskStation) then
        self.m_bGameBegin = false
    else
        self.m_bGameBegin = true
    end
    if stateType == CR_GS_WAIT_WAITE and self._playerInfo and table.nums(self._playerInfo) <= 1 then
        self:removeClock()
        self:showCurBetMaxInfo("请等待其他玩家...",true)
    elseif (stateType == CR_GS_WAIT_WAITE or stateType == CR_GS_GAMEEND) and res and res.iLeaveTime > 0 then
        self:showClock(math.floor(res.iLeaveTime/1000),"游戏即将开始:", 0 and function() end)
    elseif not self:setPlayerIsPlaying(self.bDeskStation) and stateType > CR_GS_WAIT_WAITE then
       self:showCurBetMaxInfo("本局游戏正在进行中，请等待下一局开始...",true)
    end
    if res and res.iMaxUserBet then
        self._iUserBetMax = res.iMaxUserBet
        if self:setPlayerIsPlaying(self.bDeskStation) then
            self:showCurBetMaxInfo("本局下注金币上限" .. self._iUserBetMax .. "金币")
        end
    end
    if stateType == CR_GS_XIAZHU or stateType == CR_GS_SEANDBACKCARD or stateType == CR_GS_GAME_BEGIN then
        --发牌
        local tbl = {}
        tbl.bCard = table.copy(res.iUserCardList)
        self:sendNoAction(tbl)

        if res.arrXiaZhuInfo then
            self._icurBetMaxMoney = res.arrXiaZhuInfo[0].iNowBetMoney
            for k,v in pairs(res.arrXiaZhuInfo) do
                if res.arrXiaZhuInfo[k].iUserHandleType ~= 2 and  res.arrXiaZhuInfo[k].iUserHandleType > 0 and self:setPlayerIsPlaying(k) and res.arrXiaZhuInfo[k].iNowBetMoney > 0 then
                    self._curPlayerCaozuo = res.arrXiaZhuInfo[k].iUserHandleType
                    self._curAmountBet[k] = res.arrXiaZhuInfo[k].iNowBetMoney
                    self:getNode(k,"img_bet_bg"):setVisible(true)
                    self:getNode(k,"lb_bet_gold"):setString(self._curAmountBet[k])
                    -- self:showUserJettonResult(k,res.arrXiaZhuInfo[k].iUserHandleType,res.arrXiaZhuInfo[k].iNowBetMoney)
                    -- if self._icurBetMaxMoney < res.arrXiaZhuInfo[k].iNowBetMoney then
                    --     self._icurBetMaxMoney = res.arrXiaZhuInfo[k].iNowBetMoney
                    -- end
                elseif res.arrXiaZhuInfo[k].iUserHandleType == UserOperationType.UserOperation_Type_DisCard and self:setPlayerIsPlaying(k) then
                    self:showUserJettonResult(k,res.arrXiaZhuInfo[k].iUserHandleType,res.arrXiaZhuInfo[k].iNowBetMoney)
                end
            end
        end

        local iCount = 0
        for i=0,PLAY_COUNT-1 do
            local view = self:SwitchViewChairID(i)
            if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(i) then
                iCount = iCount + 1
            end
        end
        -- for i=0,PLAY_COUNT-1 do
        --     local view = self:SwitchViewChairID(i)
        --     if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(i) then
        --         self:showPlayerFlyPubilc(i,0,iCount*self._difen,true)
        --     end
        -- end

        if res.iMoneyDiaspark then
            self._curGoldPiles = 0
            for i=PLAY_COUNT-1,0,-1 do
                if res.iMoneyDiaspark[i] > 0 then
                    self._curGoldPiles = i + 1
                    break
                end
            end
            for i=1,self._curGoldPiles do
                self["_imgBet_" .. i]:setPositionX(goldPilesPos[self._curGoldPiles][i])
            end
            for i=0,PLAY_COUNT-1 do
                -- if res.iMoneyDiaspark[0] <= iCount*self._difen then
                --     break
                -- end
                if res.iMoneyDiaspark[i] > 0 then
                    self["_imgBet_" .. i+1]:setVisible(true)
                    self:showRoundGoldAni(i, res.iMoneyDiaspark[i],false)
                end
            end 
        end
        
        --当前玩家下注
        if res.iNowBetPostion and res.iNowBetPostion >= 0 then
            self:onGameJettonBegin({uDeskStation=res.iNowBetPostion, iAntesMoney = res.iAntesMoney, iTime=math.floor(res.iLeaveTime/1000)})
        end

        
    end
    --底牌
    if res and res.iBackCard then
        self._backPublicCard = {}
        for k,v in pairs(res.iBackCard) do
            if v > 0 then
                table.insert(self._backPublicCard, v)
                self._iCurBackIndex = table.nums(self._backPublicCard)
                -- local tbl = {ID_CARD_BACK}
                -- table.insert(tbl, v)
                self:showPublicCard({ID_CARD_BACK}, true, {v})
            end
        end
        self:showPlayerMaxCardType()
    end
    -- if res and res.iUserTotalBetMoney then
    --     for i=0,PLAY_COUNT-1 do
    --         if self:setPlayerIsPlaying(i) then
    --             self:onUpdatePlayerGoldInfo(i, res.iUserTotalBetMoney[i]+self._iTax)
    --         end
    --     end
    -- end
end

--修改玩家状态
function crazyGame:onUserStateChange( res )
    local viewDesk = self:SwitchViewChairID(res.bDeskStation)
    if self._playerInfo[viewDesk] then
       self._playerInfo[viewDesk].bUserState = res.bUserState
       if self:setPlayerIsPlaying(res.bDeskStation) then
            self:getNode(res.bDeskStation,"pnl_Info"):setOpacity(255)
        else
            self:getNode(res.bDeskStation,"pnl_Info"):setOpacity(180)
            if res.bDeskStation == self.bDeskStation then
                self:hidePlayerInfo()
                self:hideRefueling()
                self._pnl_jetton_btn:setVisible(false)
                self._pnl_auto_jetton:setVisible(false)
            end
            self:hidePlayerCurInfo(res.bDeskStation)
        end
    end
end

function crazyGame:hidePlayerCurInfo(bDeskStation)
    self:getNode(bDeskStation,"node_desk_Card"):removeAllChildren()
    self:getNode(bDeskStation,"img_bet_bg"):setVisible(false)
    self:getNode(bDeskStation,"lb_bet_gold"):setString(0)
    local view = self:SwitchViewChairID(bDeskStation)
    self:removeProgressTime(view)
    
end

function crazyGame:onUpdatePlayerGoldInfo( iDesk, iUseGold, addGold)
    local view = self:SwitchViewChairID(iDesk)
    if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(iDesk) then
        if not addGold then
            self._playerInfo[view].dwMoney = self._playerInfo[view].dwMoney - iUseGold
        else
            self._playerInfo[view].dwMoney = self._playerInfo[view].dwMoney + iUseGold
        end
        
        local desc = util.showNumberCoinFormat(self._playerInfo[view].dwMoney)
        self:getNode(iDesk,"lb_bean"):setString(desc)
    end
end

--休闲时间
function crazyGame:onGameFish( ... )
    self:clearAllData()
    -- if self._addJushu then
    --     self:onUpdateStraigAndBoxJushu(1,true)
    -- end
    -- self._addJushu = false
    self._igameState = _gameStation.rest_time_station
    self.m_bGameBegin = false
    self:showClock(4,"游戏即将开始:", 0 and function() end)
    if self._bIsQuit == true then
        self:onCloseClient()
    end
end

--游戏开始通知
function crazyGame:onGameBegin( res )
    self._igameState = _gameStation.game_start_station
    self.img_tax_tip:setVisible(false)
    self:clearAllData()
    self.m_bGameBegin = true
    self:onUpdateSeatUpBtn()
    self._iUserBetMax = 0
    self._icurBetMaxMoney = 0
    if res and res.iUserBetMax then
        self._iUserBetMax = res.iUserBetMax  --用户的下注最大金额
    end
    local iCount = 0
    for i=0,PLAY_COUNT-1 do
        local view = self:SwitchViewChairID(i)
        if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(i) then
            self:onUpdatePlayerGoldInfo(i,self._iTax)
            iCount = iCount + 1
        end
    end
    for i=0,PLAY_COUNT-1 do
        local view = self:SwitchViewChairID(i)
        if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(i) then
            self:onUpdatePlayerGoldInfo(i, self._difen)
            self:showPlayerFlyPubilc(i,0,iCount*self._difen,false)
        end
    end
    self:showCurBetMaxInfo("本局下注金币上限" .. self._iUserBetMax .. "金币")
end

function crazyGame:sendNoAction( res )
    self._igameState = _gameStation.send_card_station
    self.m_bGameBegin = true
    local index = 0
    self._playerCards[2] = res.bCard
    self:removeAllCards()
    if self:setPlayerIsPlaying(self.bDeskStation) then
        if res.bCard then
            for i,j in pairs(self._playerCards[2]) do
                if j~=0 then
                    local item = self:createCard(j)
                end
            end
            self:updateCardPos()
        end
    end
    self:initPalyerCardInfo()
    for i=0,4 do
        local viewDesk = self:SwitchViewChairID(i)
        if viewDesk ~= 2 and self._playerInfo[viewDesk] and self:setPlayerIsPlaying(i) then
            self:showDeskCards(i,self._playerCards[viewDesk],false,-2)
        end
    end
end

--发牌带动作
function crazyGame:doSendCardAction( res )
    self._igameState = _gameStation.send_card_station
    self.m_bGameBegin = true
    local index = 0
    self._playerCards[2] = res.bCard
    self:removeAllCards()
    local sound = util.playSound("Special_Dispatch",false)
    if self:setPlayerIsPlaying(self.bDeskStation) then
        if res.bCard then
            for i,j in pairs(self._playerCards[2]) do
                if j~=0 then
                    local item = self:createCard(j)
                    item.showBK(true)
                end
            end
            self:updateCardPos()
        end
        self:sendCardToPerson(self._cardItems,true)
    end

    self:initPalyerCardInfo()
    local time = 0.2
    local iAllTime = 0.2 + 0.3*(table.nums(self._playerInfo)-1) + 0.48
    util.delayCall(self,function()
        util.stopSound(sound)
    end,iAllTime)

    for i=0,4 do
        local viewDesk = self:SwitchViewChairID(i)
        if viewDesk ~= 2 and self._playerInfo[viewDesk] and self:setPlayerIsPlaying(i) then
            time = time + 0.3
            util.delayCall(self,function()
                if self:setPlayerIsPlaying(i) then
                    self:showDeskCards(i,self._playerCards[viewDesk],false,-1)
                end
            end,time)
        end
    end
end
--开始下注消息
function crazyGame:onGameJettonBegin( res )
    local time = 10
    if res and res.iTime then
        time = res.iTime
    end
    self:hideRefueling()
    self:crateProgressTime(res.uDeskStation, time)
    if res and res.uDeskStation == self.bDeskStation and self:setPlayerIsPlaying(self.bDeskStation) then
        self._iMinBetGold = res.iAntesMoney
        self._iMaxBetGold = res.iAntesMoney
        self._pnl_auto_jetton:setVisible(false)
        self._iAntesMoney = res.iAntesMoney
        self:showJettonInfo(res.iAntesMoney)
    else
        if not self._pnl_auto_jetton:isVisible() and self:setPlayerIsPlaying(self.bDeskStation) and (self._curPlayerCaozuo ~= UserOperationType.UserOperation_Type_DisCard and self._curPlayerCaozuo ~= UserOperationType.UserOperation_Type_AllMoney)  then
            self._pnl_auto_jetton:setVisible(true)
        end
    end
end
--玩家下注结果
function crazyGame:onUserJettonResult( res )
    self._pnl_jetton_btn:setVisible(false)
    self:hideRefueling()
    if res then
        local uDeskStation = self:SwitchViewChairID(res.uDeskStation)
        self:removeProgressTime(uDeskStation)
        self:showUserJettonResult(res.uDeskStation, res.UserXiaZhuType, res.iAmount)
        if res.uDeskStation == self.bDeskStation then
            self._curPlayerCaozuo = res.UserXiaZhuType
            self._curPlayerBetAllGold = self._curPlayerBetAllGold + res.iAmount
            self._pnl_auto_jetton:setVisible(false)
            self:restSelectBetType()
        end
    end
end

function crazyGame:onSendBackCard( res )
    self:removeAllProgressTime()
    self._icurBetMaxMoney = 0
    self:restSelectBetType()
    if not self._iCurBackIndex or self._iCurBackIndex <= 0 then
       self._iCurBackIndex = 1
    else
        self._iCurBackIndex = 2
    end
    table.insert(self._backPublicCard,self._iCurBackIndex, res.bBackCard)
    for i=PLAY_COUNT-1,0,-1 do
        if res.SelementiMoney[i] > 0 then
            self._curGoldPiles = i + 1
            break
        end
    end
    for i=1,self._curGoldPiles do
        self["_imgBet_" .. i]:setPositionX(goldPilesPos[self._curGoldPiles][i])
    end
    for i=0,PLAY_COUNT-1 do
        if res.SelementiMoney[i] > 0  then
            if not self._curSelementiMoney or (self._curSelementiMoney and self._curSelementiMoney[i] < res.SelementiMoney[i]) then
                self["_imgBet_" .. i+1]:setVisible(true)
                self:showRoundGoldAni(i, res.SelementiMoney[i],true)
            end
        end
    end 
    util.delayCall(self,function()
        self._curSelementiMoney = table.copy(res.SelementiMoney)
        self:showPublicCard({ID_CARD_BACK}, true, {res.bBackCard})
        self:showPlayerMaxCardType()
    end,0.7)
end

function crazyGame:onSendAllBackCard( res )
    self:removeAllProgressTime()
    self._backPublicCard = {}
    for i=0,1 do
        table.insert(self._backPublicCard,i+1,res.bBackCard[i])
    end
    self._icurBetMaxMoney = 0
    for k,v in pairs(self._backPublicCard) do
        self._iCurBackIndex = k
        self:showPublicCard({ID_CARD_BACK}, true, {v})
    end
end

function crazyGame:onGameEnd( res )
    traceObj(res)
    self:removeAllProgressTime()
    self._igameState = _gameStation.game_end_station
    self:onUpdateSeatUpBtn()
    self:hideRefueling()
    self._pnl_jetton_btn:setVisible(false)
    self._pnl_auto_jetton:setVisible(false)
    for i=0,PLAY_COUNT-1 do
        local view = self:SwitchViewChairID(i)
        if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(i) then
            self._playerInfo[view].dwMoney = res.iUserNowMoney[i]
        end
    end
    self:showGameEndInfo(res)
    -- self._addJushu = false
    if res.iUserPoint[self.bDeskStation]>0 then
        self:onUpdateStraigAndBoxJushu(1,true)
        -- self._addJushu = true
    end
    self:onUpdateFinshCount( res.iUserPoint and res.iUserPoint[self.bDeskStation] and res.iUserPoint[self.bDeskStation]>0)
end

function crazyGame:onUpdateFinshCount(bWinGame)
    PlayerTaskData:setCompleteCount({iGameType=5,bWin=bWinGame})
end

function crazyGame:onGameAheadEnd( res )
    self:removeAllProgressTime()
    self._igameState = _gameStation.game_end_station
    self:onUpdateSeatUpBtn()
    self:hideRefueling()
    self._pnl_jetton_btn:setVisible(false)
    self._pnl_auto_jetton:setVisible(false)
    for i=0,PLAY_COUNT-1 do
        local view = self:SwitchViewChairID(i)
        if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(i) then
            self._playerInfo[view].dwMoney = res.iUserNowMoney[i]
        end
    end
    self:showEarlyGameEndInfo(res)
    -- self._addJushu = false
    if res.iWinStation == self.bDeskStation then
        self:onUpdateStraigAndBoxJushu(1,true)
        -- self._addJushu = true
    end
    self:onUpdateFinshCount(res.iWinStation==self.bDeskStation)
end

----------------------------------------客户端向服务器发送消息---------------------------------------
--发送下注结果
function crazyGame:onSendUserBetResult(iUserBetType,iAmount)
    if  (iUserBetType == UserOperationType.UserOperation_Type_AddMoney or iUserBetType == UserOperationType.UserOperation_Type_WithSame) and self._playerInfo[2].dwMoney == iAmount then
        iUserBetType = UserOperationType.UserOperation_Type_AllMoney
    end
    local tbl = 
    {
            UserXiaZhuType     = iUserBetType,
            iAmount            = iAmount,               
    }
    -- self._pnl_jetton_btn:setVisible(false)
    self:hideRefueling()
    self:removeProgressTime(2)
    RoomSocket:sendMsg(MDM_GM_GAME_NOTIFY,CR_ASS_USER_XIAZHU_RSULT,tbl)
end
--------------------------------------------------------------------------
function crazyGame:setPlayerIsPlaying( bDesk )
    local bView = self:SwitchViewChairID(bDesk)
    if self._playerInfo and self._playerInfo[bView] and (self._playerInfo[bView].bUserState == 4 or self._playerInfo[bView].bUserState == 6 or self._playerInfo[bView].bUserState == 7) then
        return false
    end
    return true
end

function crazyGame:showPlayerMaxCardType( ... )
    if self:setPlayerIsPlaying(self.bDeskStation) then
        local tblCards = {}
        local getCards = {}
        tblCards = table.copy(self._playerCards[2])
        for k,v in pairs(self._backPublicCard) do
            table.insert(tblCards, v)
        end
        if table.nums(tblCards) == 6 then
            getCards = crazyLogic:TheBestCard(tblCards, table.nums(tblCards))
            tblCards = table.copy(getCards)
        end
        local typeCard = crazyLogic:GetCardShape(tblCards, table.nums(tblCards))
        local typeTexas = crazyLogic:GetTexasCardType(tblCards, table.nums(tblCards))
        local typeCardStr = crazyLogic:GetCardShapeStr(typeCard)
        local typeTexasStr = crazyLogic:GetTexasCardDesc(typeTexas)
        if typeTexasStr == "" or typeCard <= 0 then
            self._txt_card_type:setString(typeCardStr)
        else
            self._txt_card_type:setString(typeCardStr .. "(" ..  typeTexasStr .. ")")
        end
        self._pnl_cardType_tip:setVisible(true)
    end
end

function crazyGame:showJettonInfo( iAmout )
    local iMaxGold = self:getMaxBetGold()
    local tbl = {}
    tbl[0] = table.copy(userBetType[UserOperationType.UserOperation_Type_DisCard])
    local iIndex = 1
    if self._icurBetMaxMoney <= 0 then
        tbl[1] = table.copy(userBetType[UserOperationType.UserOperation_Type_Let])
        iIndex = iIndex + 1
    end
    for i=iIndex,4 do
        if i == iIndex then
            if self._playerInfo[2].dwMoney <= iAmout then
                tbl[i] = table.copy(userBetType[UserOperationType.UserOperation_Type_AllMoney])
                tbl[i].iAmount = self._playerInfo[2].dwMoney
            else
                tbl[i] = table.copy(userBetType[UserOperationType.UserOperation_Type_WithSame])
                tbl[i].iAmount = iAmout*(i- iIndex + 1)
                if self._icurBetMaxMoney <= 0 then
                    tbl[i].desc = ""
                end
                tbl[i].desc = tbl[i].desc .. util.showNumberCoinFormat(tbl[i].iAmount)
            end
        else
            tbl[i] = table.copy(userBetType[UserOperationType.UserOperation_Type_AddMoney])
            tbl[i].iAmount = iAmout*(i- iIndex + 1)
            tbl[i].desc = tbl[i].desc .. util.showNumberCoinFormat(tbl[i].iAmount)
        end
    end

    if self._curRoundSelect == 0 then
        if self._icurBetMaxMoney <= 0 then
            self:onSendUserBetResult(tbl[1].tag,tbl[1].iAmount)
        else
            self:onSendUserBetResult(tbl[0].tag,tbl[0].iAmount)
        end
        return
    elseif self._curRoundSelect == 1 then
        self:onSendUserBetResult(tbl[1].tag,tbl[1].iAmount)
        return
    end
    for i=0,4 do
        util.loadButton(self["_btn_jetton_" .. i], tbl[i].path)
        self["_txt_jetton_" .. i]:setString(tbl[i].desc)
        self["_txt_jetton_" .. i]:enableOutline(tbl[i].color,2)
        if iMaxGold < tbl[i].iAmount and tbl[i].tag == UserOperationType.UserOperation_Type_AddMoney then
            self["_btn_jetton_" .. i]:setEnabled(false)
            self["_btn_jetton_" .. i]:setOpacity(125)
        else
            self["_btn_jetton_" .. i]:setEnabled(true)
            self["_btn_jetton_" .. i]:setOpacity(255)
        end
        util.clickSelf(self,self["_btn_jetton_" .. i],function()
            self:onSendUserBetResult(tbl[i].tag,tbl[i].iAmount)
        end)
    end
    if self:getMaxBetGold() <= self._iMinBetGold then
        self._btn_jetton_5:setEnabled(false)
        self._btn_jetton_5:setOpacity(125)
    else
        self._btn_jetton_5:setEnabled(true)
        self._btn_jetton_5:setOpacity(255)
    end
    self._pnl_jetton_btn:setVisible(true)
end

function crazyGame:showUserJettonResult( uDeskStation, bBetType, iAmount)
    self:PlayBetMusic(uDeskStation, bBetType)
    if bBetType ~= UserOperationType.UserOperation_Type_DisCard and UserOperationType.UserOperation_Type_Let ~= bBetType  then
        self._icurBetMaxMoney = iAmount
        self:getNode(uDeskStation,"img_bet_bg"):setVisible(true)
        local iView = self:SwitchViewChairID(uDeskStation)
        if bBetType == UserOperationType.UserOperation_Type_AllMoney then
            self._curAmountBet[uDeskStation] = -1
        else
            self._curAmountBet[uDeskStation] = self._curAmountBet[uDeskStation] + iAmount
        end
        self:showGoldAni(uDeskStation,iAmount)
        self:onUpdatePlayerGoldInfo(uDeskStation, iAmount)
    elseif bBetType == UserOperationType.UserOperation_Type_DisCard then
        -- self:showDeskCards(uDeskStation,self._playerCards[uDeskStation],false,-1)
        if uDeskStation == self.bDeskStation then
            self:hidePlayerInfo()
            local tbl = {ID_CARD_BACK,ID_CARD_BACK,ID_CARD_BACK,ID_CARD_BACK}
            self:showDeskCards(uDeskStation,tbl,false,-2)
        end
        local parent = self:getNode(uDeskStation,"node_desk_Card"):getChildByTag(10)
        if tolua.isnull(parent) then
            local tbl = {ID_CARD_BACK,ID_CARD_BACK,ID_CARD_BACK,ID_CARD_BACK}
            self:showDeskCards(uDeskStation,tbl,false,-2)
            parent = self:getNode(uDeskStation,"node_desk_Card"):getChildByTag(10)
        end

        local showType = ui.loadCS("csb/crazyGame/effect/03kapaiguang_lan")
        local showTypeAction = ui.loadCSTimeline("csb/crazyGame/effect/03kapaiguang_lan")
        showType:runAction(showTypeAction)
        showTypeAction:play("play", false)
        ui.setNodeMap(showType, showType)
        showType:setPosition(NUtils.getCenterPoint(parent,0,-parent:getContentSize().height/4))
        util.loadSprite(showType.sp_card_type, "img2/carzyRes/type/qipai.png")
        showType.sp_card_type:setAnchorPoint(cc.p(0.5,0.5))
        showType.sp_card_type:setPositionX(showType._img_type_bg:getContentSize().width/2)
        showType.sp_texax_type:setVisible(false)
        -- local showType = ui.createCsbItem("csb.crazyGame.showCardType",true)
        -- util.loadSprite(showType.sp_card_type, "img2/carzyRes/type/qipai.png")
        -- showType:setPosition(NUtils.getCenterPoint(parent,0,-parent:getContentSize().height/4))
        -- showType.sp_card_type:setAnchorPoint(cc.p(0.5,0.5))
        -- showType.sp_card_type:setPositionX(showType._img_type_bg:getContentSize().width/2)
        -- showType.sp_texax_type:setVisible(false)
        parent:addChild(showType)
    end
end

function crazyGame:showJettonGoldAni(uDeskStation)
    local showType = ui.loadCS("csb/crazyGame/effect/02xiazhukuang")
    local showTypeAction = ui.loadCSTimeline("csb/crazyGame/effect/02xiazhukuang")
    showType:runAction(showTypeAction)
    showTypeAction:play("02xiazhukuang", false)
    ui.setNodeMap(showType, showType)
    local parent = self:getNode(uDeskStation,"img_bet_ani")
    -- showType:setPosition(parent:getContentSize().width/2, parent:getContentSize().height/2)
    parent:addChild(showType)
    util.delayCall(self,function()
        showType:removeFromParent()
    end,1)
end

function crazyGame:showPublicCard(tblCards, bAddCard, value)
    local space = 10
    local nodeCardParent = self._node_public_card
    local pnlCards = self:createsmallPublicCards(tblCards)

    for k,v in pairs(pnlCards.items) do
        v.id = value[k]
    end
    -- if not bAddCard then
    --     nodeCardParent:removeAllChildren()
    -- end
    pnlCards:setAnchorPoint(cc.p(0.5,0.5))
    if self._iCurBackIndex == 1 or self._iCurBackIndex == 2 then
        if self._iCurBackIndex == 1 then
            pnlCards:setPositionX(-pnlCards:getContentSize().width / 2 - space)
        else
            pnlCards:setPositionX(pnlCards:getContentSize().width / 2 + space)
        end
    end
    -- pnlCards:setTag(self._iCurBackIndex)
    table.insert(self._publicCardItem, pnlCards)
    
    nodeCardParent:addChild(pnlCards)
    if bAddCard then
        self:sendCardToPerson(pnlCards.items, false)
    end
    util.delayCall(self,function() 
        for k,v in pairs(pnlCards.items) do
            v.turnToFace(0,0.1)
        end
    end,0.5)
    return pnlCards
end

function crazyGame:createsmallPublicCards(tbl)
    local scale = 0.55
    local space = 30
    local items = {}
    local pnl = ccui.Layout:create()
    pnl.items = items
    pnl.setBorderSize = function()end
    pnl.setBgColor = function()end
    if type(tbl) ~= "table" or table.nums(tbl) < 1 then
        return pnl
    end
    for _,id in pairs(tbl) do
        if id ~=0 then    
            local item = self:createCardItem(id,1.1)
            if cardType == 0x00 then
                item.sp_bg:setColor(cc.c4b(150,150,150,255))
            end
            if item then
                item:setScale(scale)
                table.insert(items,item)
            end
        end
    end

    if type(items) ~= "table" or table.nums(items) < 1 then
        return pnl                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    end
    
    local w = items[1]:getContentSize().width*scale
    local h = items[1]:getContentSize().height*scale

    local setSize = function(x,y)
        pnl:setContentSize(x,y)
        local offsetx = (x - w) /2
        local offsetY = (y - h) /2
        for index,item in pairs(items) do
            pnl:addChild(item)
            item:setPositionX(offsetx)
            item:setPositionY(offsetY)
            w = - w
        end
    end
    setSize(w,h)
    pnl.setBorderSize = function(x,y)
        setSize(w+2*x,h+2*y)
    end

    pnl.setBgColor = function(color,bgOpacity)
        pnl:setBackGroundColorType(1)
        pnl:setBackGroundColor(color)
        pnl:setBackGroundColorOpacity(bgOpacity)
    end
    pnl:setAnchorPoint(cc.p(0.5,0))
    return pnl
end

function crazyGame:showGameEndInfo( res )
    local tblGetCard = {}
    self._iWinStation = res.iWinStation

    for i=PLAY_COUNT-1,0,-1 do
        if res.SelementiMoney[i] > 0 then
            self._curGoldPiles = i + 1
            break
        end
    end
    for i=1,self._curGoldPiles do
        self["_imgBet_" .. i]:setPositionX(goldPilesPos[self._curGoldPiles][i])
    end
    for i=0,PLAY_COUNT-1 do
        if res.SelementiMoney[i] > 0 then
            if not self._curSelementiMoney or (self._curSelementiMoney and self._curSelementiMoney[i] < res.SelementiMoney[i]) then
                self["_imgBet_" .. i+1]:setVisible(true)
                self:showRoundGoldAni(i, res.SelementiMoney[i],true)
            end
        end
    end 
    util.delayCall(self,function() 
        if res and res.iUserCardData then
            for i=0,4 do
                local tblCards = {}
                if res.iUserCardData[i][0] > 0 then
                    if i == self.bDeskStation then
                        self:hidePlayerInfo()
                    end
                    tblCards = table.copy(res.iUserCardData[i])
                    for k,v in pairs(self._backPublicCard) do
                        table.insert(tblCards, v)
                    end
                    tblGetCard = crazyLogic:TheBestCard(tblCards, table.nums(tblCards))
                    self:setSelectCards(tblGetCard)
                    local typeCard = crazyLogic:GetCardShape(tblGetCard, table.nums(tblGetCard))
                    local typeTexas = crazyLogic:GetTexasCardType(tblGetCard, table.nums(tblGetCard))
                    self:getNode(i,"node_desk_Card"):removeAllChildren()
                    local pnlCard = self:showDeskCards(i, res.iUserCardData[i],false,typeCard,typeTexas)
                    -- if self._iWinStation == i then
                    self:showGameEndCardLightUp(pnlCard,res.iWinUserCardData,i)
                    -- end
                end
            end
        end
    end,1)
    util.delayCall(self,function() 
        self:goldPolesFlyPlayer(res.bSeleMoneyToUserIndex, res.iUserWinMoney, res.iUserPoint[self.bDeskStation] > 0)
        -- self:showWinPlayerInfo(res.iWinStation, res.iUserWinMoney[res.iWinStation])
    end,2)
end

function crazyGame:showGameEndCardLightUp( pnlCard, iWinUserCardData, iDesk)
    if iDesk == self._iWinStation then
        for k,v in pairs(pnlCard.items) do
            local bFind = false
            for key,val in pairs(iWinUserCardData) do
                if v.id == val  then
                    bFind = true
                    v.setSelected(true)
                    v.showAni(true)
                end
            end
            if not bFind then
                v.setGray(true)
            end
        end
    else
        for k,v in pairs(pnlCard.items) do
            v.setGray(true)
        end
    end

    for k,v in pairs(self._publicCardItem) do
        for key,val in pairs(v.items) do
            local bFind = false
            for key1,val1 in pairs(iWinUserCardData) do
                if val.id == val1  then
                    bFind = true
                    val.showAni(true)
                end
            end
            if not bFind then
                val.setGray(true)
            end
        end
    end
end

--提前结束
function crazyGame:showEarlyGameEndInfo( res )
    traceObj(res)
    self._iWinStation = res.iWinStation
    if res.iUserWinMoney and res.iUserWinMoney > 0 then
        self._imgBet_1:setVisible(true)
        self:showRoundGoldAni(0, res.iUserWinMoney, true)
    end
    util.delayCall(self,function() 
        local pnlCard
        if res.iWinStation == self.bDeskStation then
            self:hidePlayerInfo()
        end
        if res.iGameEarlyFlag == 1 then
            pnlCard =self:showDeskCards(res.iWinStation, res.iUserCardData, false, -2)
            self:showGameEndCardLightUp(pnlCard,res.iUserCardData,res.iWinStation)
        elseif res.iGameEarlyFlag == 2 then
            local tblCards = {}
            tblCards = table.copy(res.iUserCardData)
            for k,v in pairs(self._backPublicCard) do
                table.insert(tblCards, v)
            end
            local typeCard = crazyLogic:GetCardShape(tblCards, table.nums(tblCards))
            local typeTexas = crazyLogic:GetTexasCardType(tblCards, table.nums(tblCards))
            pnlCard = self:showDeskCards(res.iWinStation, res.iUserCardData, false, typeCard, typeTexas)
            self:showGameEndCardLightUp(pnlCard,res.iWinUserCardData,res.iWinStation)
        elseif res.iGameEarlyFlag == 3 then
            local tblCards = {}
            local tblGetCard = {}
            tblCards = table.copy(res.iUserCardData)
            for k,v in pairs(self._backPublicCard) do
                table.insert(tblCards, v)
            end
            tblGetCard = crazyLogic:TheBestCard(tblCards, table.nums(tblCards))
            local typeCard = crazyLogic:GetCardShape(tblGetCard, table.nums(tblGetCard))
            local typeTexas = crazyLogic:GetTexasCardType(tblGetCard, table.nums(tblGetCard))
            pnlCard = self:showDeskCards(res.iWinStation, res.iUserCardData, false, typeCard, typeTexas)
            self:showGameEndCardLightUp(pnlCard,res.iWinUserCardData,res.iWinStation)
        end
    end,0.1)
    util.delayCall(self,function() 
        self:goldPolesFlyEndEalry(res.iWinStation, res.iUserWinMoney, res.iWinStation == self.bDeskStation)
        -- self:showWinPlayerInfo(res.iWinStation, res.iUserWinMoney)
    end,2)
end

function crazyGame:goldPolesFlyPlayer(bSeleMoneyToUserIndex, iUserWinMoney, bPlayerWin)
    local offset = 35
    local time = 0.5
    local maxTime = time + 0.2
    if self._storeGoldSp and self._storeGoldSp[0] then
        maxTime = maxTime + table.nums(self._storeGoldSp[0])*0.012 
    end

    util.delayCall(self,function() 
        for k,v in pairs(iUserWinMoney) do
            if v > 0 then
                self:showWinPlayerInfo(k, v, bPlayerWin)
            end
        end
    end,maxTime)

    self:palyGoldSound()
    for i=0,#bSeleMoneyToUserIndex-1 do
        local targetNode = self:getPlayerHead(bSeleMoneyToUserIndex[i])
        if tolua.isnull(targetNode) or not targetNode:isVisible() or bSeleMoneyToUserIndex[i] == 255 then
            return
        end
        local parent = self["_imgBet_" .. i+1]
        local targetPos = cc.p(targetNode:getContentSize().width/2,targetNode:getContentSize().height/2)
        targetPos = targetNode:convertToWorldSpace(targetPos)
        targetPos = parent:convertToNodeSpace(targetPos)
        self["img_lb_bg_" .. i+1]:setVisible(false)
        if self._storeGoldSp and self._storeGoldSp[i] then
            for k,v in pairs(self._storeGoldSp[i]) do
                local xoffset = math.random(-offset,offset)
                local yoffset = math.random(-offset,offset)
                local pos = cc.p(targetPos.x+xoffset,targetPos.y+xoffset)
                local delay = cc.DelayTime:create(0.012*k)
                local move = cc.MoveTo:create(time,pos)
                local ease = cc.EaseSineInOut:create(move)
                local delay2 = cc.DelayTime:create(0.05)
                local del = cc.CallFunc:create(function() 
                    v:removeFromParent()
                end)
                v:runAction(cc.Sequence:create(delay,ease,delay2,del))
            end
        end
    end
end

function crazyGame:goldPolesFlyEndEalry(iWinStation,iUserWinMoney,bPlayerWin)
    local offset = 35
    local time = 0.5
    local maxTime = time + 0.5
    if self._storeGoldSp and self._storeGoldSp[0] then
        maxTime = maxTime + table.nums(self._storeGoldSp[0])*0.012 
    end
    local targetNode = self:getPlayerHead(iWinStation)
    local parent = self["_imgBet_" .. 1]
    local targetPos = cc.p(targetNode:getContentSize().width/2,targetNode:getContentSize().height/2)
    targetPos = targetNode:convertToWorldSpace(targetPos)
    targetPos = parent:convertToNodeSpace(targetPos)
    self.img_lb_bg_1:setVisible(false)
    self:palyGoldSound()
    if self._storeGoldSp and self._storeGoldSp[0] then
        for k,v in pairs(self._storeGoldSp[0]) do
            if not tolua.isnull(v) then
                local xoffset = math.random(-offset,offset)
                local yoffset = math.random(-offset,offset)
                local pos = cc.p(targetPos.x+xoffset,targetPos.y+xoffset)
                local delay = cc.DelayTime:create(0.012*k)
                local move = cc.MoveTo:create(time,pos)
                local ease = cc.EaseSineInOut:create(move)
                local delay2 = cc.DelayTime:create(0.05)
                local del = cc.CallFunc:create(function() 
                    v:removeFromParent()
                end)
                v:runAction(cc.Sequence:create(delay,ease,delay2,del))
            end
        end
    end
    util.delayCall(self,function() 
        self:showWinPlayerInfo(iWinStation, iUserWinMoney,bPlayerWin)
    end,maxTime)
end

function crazyGame:showWinPlayerInfo( bWinDesk, userWinMoney, bPlayerWin)
    for i=0,PLAY_COUNT-1 do
        self._pnl_cardType_tip:setVisible(false)
        self:getNode(i,"node_desk_Card"):removeAllChildren()
        self:getNode(i,"img_bet_bg"):setVisible(false)
        local view = self:SwitchViewChairID(i)
        if self._playerInfo and self._playerInfo[view] and self:setPlayerIsPlaying(i) then
            -- self._playerInfo[view].dwMoney = self._iUserNoeMoney[i]
            local desc = util.showNumberCoinFormat(self._playerInfo[view].dwMoney)
            self:getNode(i,"lb_bean"):setString(desc)
        end
    end
    self._node_public_card:removeAllChildren()
    local headAni
    local headAniAction
    if bWinDesk == self.bDeskStation then
        headAni = ui.loadCS("csb/crazyGame/effect/04touxiangtexiao_heng")
        headAniAction = ui.loadCSTimeline("csb/crazyGame/effect/04touxiangtexiao_heng")
    else
        headAni = ui.loadCS("csb/crazyGame/effect/04touxiangtexiao")
        headAniAction = ui.loadCSTimeline("csb/crazyGame/effect/04touxiangtexiao")
    end
    headAni:runAction(headAniAction)
    headAniAction:play("play", false)

    local parent = self:getNode(bWinDesk,"node_ani_win")
    headAni:setPosition(parent:getContentSize().width/2, parent:getContentSize().height/2)
    parent:addChild(headAni)

    local item 
    local item = ui.createCsbItem("csb.crazyGame.showWinLose")
    local desc = util.showNumberCoinFormat(userWinMoney)
    desc = "+" .. desc
    item.lb_fwin:setString(desc)
    local yoffset = 20
    self:getNode(bWinDesk,"node_gold_end_pos"):setLocalZOrder(20)
    local parent = self:getNode(bWinDesk,"node_gold_end_pos")
    local actionDelay = cc.DelayTime:create(0.5)
    local actionMove = cc.MoveBy:create(1,cc.p(0,yoffset))
    local actionFadeOut = cc.FadeOut:create(0.5)
    item:runAction(cc.Sequence:create(actionMove,actionDelay))
    parent:addChild(item)
    self:getNode(bWinDesk,"img_win_mark"):setVisible(true)

    util.delayCall(self,function() 
        if bWinDesk == self.bDeskStation and bPlayerWin then
            self:PlayMusic(_music.MUSIC_GAME_WIN)
            local showGameEnd = ui.loadCS("csb/crazyGame/effect/05shengli")
            local showGameEndAction = ui.loadCSTimeline("csb/crazyGame/effect/05shengli")
            showGameEnd:runAction(showGameEndAction)
            showGameEndAction:play("05shengli", false)
            self._node_gameEnd_Ani:addChild(showGameEnd, 100)
        end
    end,1)
    -- self:onUpdatePlayerGoldInfo(bWinDesk, userWinMoney, true)
    util.delayCall(self,function() 
        self:getNode(bWinDesk,"img_win_mark"):setVisible(false)
        self._node_gameEnd_Ani:removeAllChildren()
        headAni:removeFromParent()
        util.tryRemove(item) 
        -- self:isNoMoneyGotoRoom()
    end,3.5)
                
end

function crazyGame:initPalyerCardInfo( ... )
    for i=0,PLAY_COUNT-1 do
        if i ~= 2 then
            for j=0,3 do
                if not self._playerCards[i] or self._playerCards[i] == nil then
                    self._playerCards[i] = {}
                end
                self._playerCards[i][j] = ID_CARD_BACK
            end
        end
    end
end

--显示倒计时,参数:时间,描述，时间到后自动执行的内容
function crazyGame:showClock(time,strs,callback)
    self:removeClock()
    self._pnl_scene_tip:setVisible(true)
    self._txt_scene_desc:setString(strs)
    if time >= 0 then
        self._txt_clock_time:setVisible(true)
        ExTimeLable.extend(self._txt_clock_time)
        self._txt_clock_time:setTime(time,nil,nil,function()
            if callback then
                callback()
            end
            self:removeClock()
        end)
        -- self._txt_clock_time:setPositionX(self._txt_scene_desc:getPositionX() + self._txt_scene_desc:getContentSize().width/2 + 5)
    else
        ExTimeLable.extend(self._txt_clock_time)
        self._txt_clock_time:setTime(0,nil,nil,function()
            -- self:removeClock()
            self._txt_clock_time:setString("")
        end)
        self._pnl_scene_tip:setVisible(true)
        self._txt_scene_desc:setString(strs)
        -- self._txt_clock_time:setVisible(false)
        -- self._pnl_scene_tip:setVisible(true)
        -- self._txt_scene_desc:setString(strs)
    end
end

--移除计时
function crazyGame:removeClock()
    self._pnl_scene_tip:setVisible(false)
    self._txt_scene_desc:setString("")
    self._txt_clock_time:setString("")
    -- self._txt_clock_time:reset()
    util.removeAllSchedulerFuns(self._txt_clock_time)
end
--聊天系统
function crazyGame:onChatBtn()
    local info = {}
    local anchor = cc.p(1,0)
    local node = self._btnChat
    pos = cc.p(node:getPosition())
    info.posInfo = {pos = pos,anchor = anchor}
    info.bDeskStation = self.bDeskStation
    -- info.game = 2
    info.parent = self
    info.csbPath = "csb/crazyGame/"
    info.bDeskStation = self.bDeskStation
    _uim:showLayer(ui.gameChat,info)
end

function crazyGame:onShowChatInfo( res )
    local iSeatNo = res.bDeskStation
    function removeSelf()
        if iSeatNo >= 0 and iSeatNo <= 4 then
            self:getNode(iSeatNo,"chat_Info_bg"):setVisible(false)
            self:getNode(iSeatNo,"lb_chat_content"):setString("")
            self:getNode(iSeatNo,"node_pos_head"):removeAllChildren()
        end
    end

    if iSeatNo >= 0 and iSeatNo <= 4 then
        removeSelf()
        local str = res.szMessage
        if res.iChatType == 1 then         --表情
            local ani = Animation:createCSExpressionAni(res.iChatIndex+10100)
            self:getNode(iSeatNo,"node_pos_head"):addChild(ani)
            local delay = cc.DelayTime:create(2)
            function removeBiaoqingItem()
                ani:removeFromParent()
            end
            local sequence = cc.Sequence:create(delay, cc.CallFunc:create(removeBiaoqingItem))
            ani:runAction(sequence)
            return
        elseif res.iChatType == 2 then
            str = chatInfo[res.iChatIndex].gold1
            self:getNode(iSeatNo,"lb_chat_content"):setString(str)
        else
            return
        end
        self:getNode(iSeatNo,"chat_Info_bg"):setVisible(true)
        local delay = cc.DelayTime:create(3)
        local sequence = cc.Sequence:create(delay, cc.CallFunc:create(removeSelf))
        self:getNode(iSeatNo,"chat_Info_bg"):stopAllActions()
        self:getNode(iSeatNo,"chat_Info_bg"):runAction(sequence)
    end
end

function crazyGame:onResUseItem(res,param2,param3,head)
    if head and head.uHandleCode == 0 then
        local userID = res.dwUserID
        local tagID = res.dwTargetUserID
        local itemID = res.nPropID
        local userDesk,targetDesk

        for desk,info in pairs(self._playerInfo) do
            if info.dwUserID == userID then
                userDesk = info.bDeskStation
            elseif info.dwUserID == tagID then
                targetDesk = info.bDeskStation
            end
        end
        if not (userDesk and targetDesk) then
            -- traceObj(res)
            return
        end

        local userNode = self:getNode(userDesk,"node_pos_head")
        local targetNode = self:getNode(targetDesk,"node_pos_head")

        Animation:createDaoju(itemID,userNode,targetNode)
    elseif head and head.uHandleCode == 60 then
        if res.dwUserID == PlayerData:getUserID() then
            Alert:showTip("购买后金币低于" .. crazyRoomInfo[PlayerData:getCurRoomInfo().iRoomLevel].gold1 .. "，无法购买",2)
        end
    else
        if res.dwUserID == PlayerData:getUserID() then
            Alert:showTip("使用道具失败",2)
        end
    end
end

function crazyGame:onRefreshUser(res)
    local desk = res and res.cbDeskStation
    local viewDesk = self:SwitchViewChairID(desk)
    if viewDesk and self._playerInfo and self._playerInfo[viewDesk] then
        self._playerInfo[viewDesk].dwMoney = res.iUserMoney
        local desc = util.showNumberCoinFormat(res.iUserMoney)
        self:getNode(desk,"lb_bean"):setString(desc)
        if viewDesk == 2 and self._pnl_jetton_btn:isVisible() then
            self:showJettonInfo(self._iAntesMoney)
        end
    end
end

--创建圆形进度条
function crazyGame:crateProgressTime(uDesk, time)
    -- traceOnly("crateProgressTime",os.clock(),uDesk, time)
    local uDeskStation = self:SwitchViewChairID(uDesk)
    self:removeProgressTime(uDeskStation)
    local maxTime = time
    if tolua.isnull(self._spProgress[uDeskStation]) then
        local sp = cc.Sprite:create()
        if uDeskStation == 2 then
            util.loadSprite(sp,"img2/carzyRes/jindutiaoziji.png")
        else
            util.loadSprite(sp,"img2/carzyRes/jindutiaobieren.png")
        end
        self._spProgress[uDeskStation] = cc.ProgressTimer:create(sp)
        self._spProgress[uDeskStation]:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        self._spProgress[uDeskStation]:setReverseDirection(true)
        self._spProgress[uDeskStation]:setPercentage(100)
        local parentNode = self:getNode(uDesk,"pnl_Info")
        self._spProgress[uDeskStation]:setPosition(parentNode:getContentSize().width/2,parentNode:getContentSize().height/2)
        parentNode:addChild(self._spProgress[uDeskStation])
        -- self._spProgress[uDeskStation]:setVisible(false)
    end
    if not tolua.isnull(self._spProgress[uDeskStation]) then
        self._spProgress[uDeskStation]:setVisible(true)
        self._spProgress[uDeskStation]:setPercentage(100)
    end
    util.delayCall(self._spProgress[uDeskStation],function(dt)
        time = time - dt
        if not tolua.isnull(self._spProgress[uDeskStation]) then
            self._spProgress[uDeskStation]:setPercentage(time/maxTime*100)
            -- traceOnly("setPercentage",os.clock(),uDesk, time/maxTime*100)
        end
        if time <= 0 or time/maxTime*100 <= 0 then
            self:removeProgressTime(uDeskStation)
        end
    end,0,true)
end

function crazyGame:removeProgressTime( uDesk )
    if self._spProgress and self._spProgress[uDesk] then
        self._spProgress[uDesk]:setVisible(false)
        util.removeAllSchedulerFuns(self._spProgress[uDesk])
    end
end

function crazyGame:removeAllProgressTime( ... )
    for i=0,4 do
        local view = self:SwitchViewChairID(i)
        self:removeProgressTime(view)
    end
end

function crazyGame:getMaxBetGold( ... )
    local maxGold = 0
    if  self._iCurBackIndex == 0 then
        if self._playerInfo[2].dwMoney > self._iUserBetMax*0.2 then
            return self._iUserBetMax*0.2 - self._curPlayerBetAllGold
        else
            return self._playerInfo[2].dwMoney
        end
    elseif self._iCurBackIndex == 1 then
        if self._playerInfo[2].dwMoney > self._iUserBetMax*0.5 - self._curPlayerBetAllGold then
            return self._iUserBetMax*0.5 - self._curPlayerBetAllGold
        else
            return self._playerInfo[2].dwMoney
        end
    elseif self._iCurBackIndex == 2 then
        if self._playerInfo[2].dwMoney > self._iUserBetMax - self._curPlayerBetAllGold then
            return self._iUserBetMax - self._curPlayerBetAllGold
        else
            return self._playerInfo[2].dwMoney
        end
    end
end

function crazyGame:onUpdateSeatUpBtn()
    if self:setPlayerIsPlaying(self.bDeskStation) and not tolua.isnull(self._showMoreFunc) and (self.m_bGameBegin and self._igameState ~= _gameStation.game_end_station) then
        if self._curPlayerCaozuo == UserOperationType.UserOperation_Type_AllMoney then
            util.setEnabled(self._showMoreFunc._btnseatUp, false)
        else
            util.setEnabled(self._showMoreFunc._btnseatUp, true)
        end
    elseif not tolua.isnull(self._showMoreFunc) then
        util.setEnabled(self._showMoreFunc._btnseatUp, false)
    end
end

--火箭公告
function crazyGame:initGameMagAni( ... )
    self.gameMsgAni = ui.loadCS("csb/common/gameMagAni")
    local viewsize = cc.Director:getInstance():getWinSize()
    self.gameMsgAni:setPosition(viewsize.width/2, viewsize.height*3/4+10)
    self:addChild(self.gameMsgAni,10001)
    ui.setNodeMap(self.gameMsgAni, self.gameMsgAni)
    self.gameMsgAniAction = ui.loadCSTimeline("csb/common/gameMagAni")
    self.gameMsgAni:runAction(self.gameMsgAniAction)
    local ani = Animation:createGrabredAni(10007)
    self.gameMsgAni.node_air_ani:addChild(ani)
    self.gameMsgAni:setVisible(false)
end
function crazyGame:onServerInfo( res )
    if res then
        if res.bMaqType ~= 3 then
            return
        end
        if not self._maqMsgRockets then
            self._maqMsgRockets = {}
        end
        table.insert(self._maqMsgRockets,res)
        if not self._bMaqMsgRockets then
            self:showRocketsMaqMsg()
        end
    end
end
function crazyGame:showRocketsMaqMsg( ... )
    if self._maqMsgRockets and self._maqMsgRockets[1] and self._maqMsgRockets[1].szMsgContent then
        self.gameMsgAni:setVisible(true)
        self._bMaqMsgRockets = true
        self.gameMsgAni.lb_show_laba:setString(self._maqMsgRockets[1].szMsgContent)
        self.gameMsgAniAction:play("animation0",false)
        util.delayCall(self.gameMsgAni,function()
            self.gameMsgAni:setVisible(false)
            self._bMaqMsgRockets = false
            table.remove(self._maqMsgRockets,1)
            self:showRocketsMaqMsg()
        end,6.6)
    end
end

return crazyGame
































