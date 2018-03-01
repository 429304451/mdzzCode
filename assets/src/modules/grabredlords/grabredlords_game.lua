--千人抢红包斗地主
local TIME_CallRobNt = 15
local TIME_OutCard = 15
--音效
local _music =
{
    MUSIC_BU_JIAO = 100,
    MUSIC_JIAO_DIZHU = 101,
    MUSIC_BU_YAO = 106,
    MUSIC_GAME_LOSE = 109,
    MUSIC_GAME_WIN = 110,
    MUSIC_CHUN_TIAN = 111,
    MUSIC_FAN_CHUN = 112,
}
local CARDS_COUNT_NORMAL = 17
local CARDS_COUNT_BACK = 3
local ID_CARD_BACK = 0xFF
-- local INVALID_CHAIR = -1
local PLAY_COUNT = 3
--游戏状态
local _gameStation = 
{
    rest_time_station       =   0,
    game_start_station      =   1,
    send_card_station       =   2,
    call_lord               =   3,
    deter_lord              =   4,
    game_play               =   5,
    game_end_station        =   6,
}
--六个角色的一些节点
local _nodes = {
    clockParent = {"Node_upClock","Node_myClock","Node_nextClock"},
    pnl_Info = {"Panel_up_info","Panel_myInfo","Panel_next_info"},
    btn_head = {"btn_up_head","btn_my_head","btn_next_head",},
    img_head = {"img_up_head","img_my_head","img_next_head",},
    img_head_bg = {"img_up_head_bg","img_my_head_bg","img_next_head_bg",},
    img_head_vip = {"img_up_vip_head","img_my_vip_head","img_next_vip_head",},
    lb_nickName = {"lb_up_nickname","","lb_next_nickname",},
    img_bujiao = {"bujiao_label_25","bujiao_label_18","bujiao_label_33",},
    img_jiaodizhu = {"jiaodizhu_label_27","jiaodizhu_label_20","jiaodizhu_label_35",},
    img_buchu = {"buchu_label_24","buchu_label_17","buchu_label_32",},
    -- img_farmer = {"img_up_farmer","img_my_farmer","img_next_farmer",},
    img_lord = {"img_up_lord","img_my_lord","img_next_lord",},
    Node_DeskCard = {"Node_upperDeskCard","Node_myDeskCard","Node_nextDeskCard",},
    Node_OverCard = {"Node_upperOverCard","","Node_nextOverCard",},
    --牌数
    sp_Paishu = {"paishu_41","","paishu_40",},
    lb_paishu = {"lb_up_paishu","","lb_next_paishu",},
    sp_num2 = {"num3_43","","num3_44",},
    sp_num1 = {"num1_44","","num1_45",},
    Node_smoke = {"Node_up_smoke","Node_my_smoke","Node_next_smoke"},
}
--加倍
local multKey = {}
    multKey[1] = "iBombNum"
local m_iView = cc.Director:getInstance():getWinSize()
local _anchor = {
    Node_DeskCard = {cc.p(0,0.5),cc.p(0.5,0.5),cc.p(1,0.5)},
    Node_head = {cc.p(0,1),cc.p(0,0),cc.p(1,1)},
    Node_GameEnd = {cc.p(0,0.5),cc.p(0,0.5),cc.p(1,0.5)}
}
--cc.c3b(0,255,252),cc.c3b(122,251,65)
local MaqNotifyColor = {cc.c3b(252,255,11),cc.c3b(255,162,0),cc.c3b(255,162,0),cc.c3b(214,136,255),cc.c3b(214,136,255)}

local m_bGameBegin = false --游戏开始标记
local m_bBigCard = {}
local m_bOutCard = false
local m_bBigCardCount = 0
local m_bIsAutoOutCard = {}
local m_bNowOutCardPeople = PLAY_COUNT
local m_bLastOneCard = false
local m_iOverOutCardCount = 0
local m_iLordIndex = -1
local m_bSingleCard = false
-- 这个好像是通用的cards
local cardsConfig = require("config.cards")
local smallCardsConfig = cardsConfig[2] -- 大小鬼
cardsConfig = cardsConfig[1]

local UpGradeLogic = require("Common.UpGradeLogic"):create()  -- 选牌类型? 游戏逻辑？ 应该怎样选牌估计是

local grabredlords_game = class("grabredlords_game",BaseLayer)

function grabredlords_game:ctor()
    grabredlords_game.super.ctor(self)

    self.grabredBgNode = ui.loadCS("csb/grabredlords_game/grabredlordsbgNode")
    self:addChild(self.grabredBgNode)
    self.grabredBgNode:setScaleX(_gm.bgScaleW)
    self.grabredBgNode:setPosition(WIN_center)
    ui.setNodeMap(self.grabredBgNode, self)

    self.grabredFrontNode = ui.loadCS("csb/grabredlords_game/grabredlordsFrontNode")
    self:addChild(self.grabredFrontNode)
    self.grabredFrontNode:setScale(_gm.bgScaleW)
    self.grabredFrontNode:setPosition(WIN_center)
    ui.setNodeMap(self.grabredFrontNode, self)

    self.grabredDownNode = ui.loadCS("csb/grabredlords_game/grabredlordsDown")
    self:addChild(self.grabredDownNode)
    --self.grabredDownNode:setScale(_gm.bgScaleW)
    self.grabredDownNode:setPosition(WIN_down_center)
    ui.setNodeMap(self.grabredDownNode, self)

    self.grabredUpNode = ui.loadCS("csb/grabredlords_game/grabredlordsUp")
    self:addChild(self.grabredUpNode)
    --self.grabredUpNode:setScale(_gm.bgScaleW)
    self.grabredUpNode:setPosition(WIN_up_center)
    ui.setNodeMap(self.grabredUpNode, self)

    self:initGameDataInfo()
end

function grabredlords_game:initGameDataInfo( ... )
    self._cardItems = {}
    self._showCardCount = true
    self._tblCardCounts = {}--剩余牌数
    self._playerInfo = {}
    self._oldHeadIndex = {}
    self._gameStation = _gameStation.rest_time_station
    m_iLordIndex = -1
    self.bDeskStation = 0
    m_bBigCard = {}
    m_bBigCardCount = 0
    m_bGameBegin = false
    m_bOutCard = false
    self._bFirstTip = true
    self._bIsOverTime = {}
     for i=0,PLAY_COUNT-1 do
        m_bIsAutoOutCard[i] = false
        self._bIsOverTime[i] = false
    end
    self:getCurRoomInfo()
    self:initRoomLevelInfo()
    -- self:intiPlayerData()
    -- self:InitCalcToolCards()
    -- self:initMessageInfo()
    -- self:initCallBtnInfo()

    -- util.setTextMaxWidth(self.lb_up_nickname,130)
    -- util.setTextMaxWidth(self.lb_next_nickname,130)
    -- if self.panel_deposit_cancle then
    --     self.panel_deposit_cancle:setVisible(false)
    -- end
    -- self.btn_tool_deposit:setEnabled(false)
    -- PlayerData:setIsGame("grabredlords_game")
    -- _am:playMusic("audio/playing_game_bg.mp3" ,true)
    -- self._oldMultiple = self._oldMultiple or cc.p(m_iView.width*0.5,m_iView.height*0.6)

    -- util.delayCall(self,function()
    --     local child = self.Node_backCards:getChildren()
    --     if table.nums(child) == 0 then
    --         self:showBackCards({}) 
    --     end
    -- end,0.5)
    -- self:updateWifi()
    -- self:updatePower()
    -- self:upDateSeverTime()
    -- self:showServerTime()

    -- self._bTouchFirst = true
    -- local bFirst = util.getKey("bShowYaosi")
    -- self:showPlayYaosiAni(bFirst)

    -- self.touchedBtn = {btn = nil,scale = 1,inUse = false}
    -- self:addEvents()
    -- self:addEventsAdd()
end

--初始化房间等级相关信息
function grabredlords_game:initRoomLevelInfo( ... )
    if self._grabredRoomInfo then
        util.loadSprite(self.ing_bk, self._grabredRoomInfo.background)
        util.loadSprite(self.sp_title_bg, self._grabredRoomInfo.title)
        self.lb_base_all_score:setString(self._grabredRoomInfo.iAllInnings)
        self._allbaseiBasePoint = self._grabredRoomInfo.num2
        self.lb_menpiao_sign:setString(self._grabredRoomInfo.registration)
    end
    self:onMultipleChange()
end

--获取当前的房间信息
function grabredlords_game:getCurRoomInfo( ... )
    local icurRoomInfo = PlayerData:getCurRoomInfo()
    local grabredRoomInfo = TemplateData:getRoom(icurRoomInfo.uNameID)
    local info = {}
    for k,v in pairs(grabredRoomInfo) do
        if v.iRoomLevel == icurRoomInfo.iRoomLevel then
            self._grabredRoomInfo = v
            break
        end
    end
end





