local R = class("R")

R.icon = {}
R.icon[0] = "img2/userhead/touxiang001"
R.icon[1] = "img2/userhead/touxiang002"
R.icon[2] = "img2/userhead/touxiang003"
R.icon[3] = "img2/userhead/touxiang004"
R.icon[4] = "img2/userhead/touxiang005"
R.icon[5] = "img2/userhead/touxiang006"
R.icon[6] = "img2/userhead/touxiang007"
R.icon[7] = "img2/userhead/touxiang008"
R.icon[8] = "img2/hundredniuniu/zj"         --百人大战庄家头像

R.lord = {}
R.lord[0] = "img2/grabredlords/head_farmer_man"
R.lord[1] = "img2/grabredlords/head_lord_man"
R.lord[2] = "img2/userhead/robot_head"
R.lord[3] = "img2/Animation/zadan/boom_head"

R.Wifi = {}
R.Wifi[1] = "img2/grabredlords/TopMenu/wifi2"
R.Wifi[2] = "img2/grabredlords/TopMenu/wifi1"
R.Wifi[3] = "img2/grabredlords/TopMenu/wifi"--满格
R.Wifi[4] = "img2/grabredlords/TopMenu/2g"
R.Wifi[5] = "img2/grabredlords/TopMenu/3g"
R.Wifi[6] = "img2/grabredlords/TopMenu/4g"

--R.shopTab = {}
--R.shopTab[1] = "金币"
--R.shopTab[2] = "钻石"
--R.shopTab[3] = "道具"
--R.shopTab[4] = "月卡"

R.tabBtn = {}
R.tabBtn[1] = {img_1 = "img2/shop/_0006_jinbi",    img_2 = "img2/shop/_0008_jinbi1",   }
R.tabBtn[2] = {img_1 = "img2/shop/_0005_zuanshi",  img_2 = "img2/shop/_0011_zuanshi-1", }
R.tabBtn[3] = {img_1 = "img2/shop/_00041_menpiao",    img_2 = "img2/shop/_00091_menp1",   }
R.tabBtn[4] = {img_1 = "img2/shop/vip/vip_2",    img_2 = "img2/shop/vip/vip_1",   }
R.tabBtn[5] = {img_1 = "img2/shop/_0003_yueka",    img_2 = "img2/shop/_0010_yueka1",   }


R.tabWinBtn = {}
R.tabWinBtn[1] = {img_2 = "img2/GameScene/winStreak/xscp",    img_1 = "img2/GameScene/winStreak/xsc",   }
R.tabWinBtn[2] = {img_2 = "img2/GameScene/winStreak/zjcp",    img_1 = "img2/GameScene/winStreak/zjc", }
R.tabWinBtn[3] = {img_2 = "img2/GameScene/winStreak/gjcp",    img_1 = "img2/GameScene/winStreak/gjc",   }
R.tabWinBtn[4] = {img_2 = "img2/GameScene/winStreak/dscp",    img_1 = "img2/GameScene/winStreak/dsc",   }

R.tabExchangeBtn = {}
R.tabExchangeBtn[1] = {img_2 = "img2/exchange/swjp",    img_1 = "img2/exchange/swjp1",   }
R.tabExchangeBtn[2] = {img_2 = "img2/exchange/dhjl",    img_1 = "img2/exchange/dhjl1", }
--R.tabExchangeBtn[3] = {img_2 = "img2/exchange/jqhq",    img_1 = "img2/exchange/jqhq1",   }
--R.tabExchangeBtn[4] = {img_2 = "img2/exchange/swjp",    img_1 = "img2/exchange/swjp1",   }
--广场红包按钮
R.tabRedSquareBtn = {}
R.tabRedSquareBtn[1] = {img_2 = "img2/hongbao/hongbaogc/hbgc1",    img_1 = "img2/hongbao/hongbaogc/hbgc",   }
R.tabRedSquareBtn[2] = {img_2 = "img2/hongbao/hongbaogc/wdhb1",    img_1 = "img2/hongbao/hongbaogc/wdhb", }
R.tabRedSquareBtn[3] = {img_2 = "img2/hongbao/hongbaogc/hqfd1",    img_1 = "img2/hongbao/hongbaogc/hqfd",   }
R.tabRedSquareBtn[4] = {img_2 = "img2/hongbao/hongbaogc/fshb1",    img_1 = "img2/hongbao/hongbaogc/fshb",   }

--聊天选择类型按钮
R.tabChatSelectBtn = {}
R.tabChatSelectBtn[1] = {img_1 = "img2/chat/x2",    img_2 = "img2/chat/x1",}
R.tabChatSelectBtn[2] = {img_1 = "img2/chat/y2",    img_2 = "img2/chat/y1",}
R.tabChatSelectBtn[3] = {img_1 = "img2/chat/s2",    img_2 = "img2/chat/s1",}


PRICETYPE_GOLD = 1
PRICETYPE_TREA = 4
PRICETYPE_MONEY = 2
PRICETYPE_GAME_GOLD = 6

R.moneyIcon = {}
R.moneyIcon[PRICETYPE_GOLD] = "img2/hall/_0021_jinbi"
R.moneyIcon[PRICETYPE_TREA] = "img2/hall/_0018_zuanshi"
R.moneyIcon[PRICETYPE_MONEY] = "img2/hall/yuan"

R.shopItemName = {}
R.shopItemName[1] = "img2/shop/w"
R.shopItemName[2] = "img2/shop/z"
R.shopItemName[301] = "img2/shop/jpqyc"--记牌器(1次)
R.shopItemName[302] = "img2/shop/jpqqt"--记牌器（7天）
R.shopItemName[303] = "img2/shop/fw"--飞吻
R.shopItemName[304] = "img2/shop/xhs"--西红柿
R.shopItemName[305] = "img2/shop/jd"--鸡蛋
R.shopItemName[306] = "img2/shop/mgh"--鲜花
R.shopItemName[307] = "img2/shop/fd"--福卡
R.shopItemName[308] = "img2/shop/lb"--喇叭
R.shopItemName[401] = "img2/shop/tyk"--体验卡
R.shopItemName[402] = "img2/shop/lk"--蓝卡
R.shopItemName[403] = "img2/shop/hk"--红卡

R.imgHeadSpace = {
    {img = "img2/shape/3.png",border = 7},--大厅
    {img = "img2/grabredlords/playerInfo_propBg.png",border = 10},--游戏中
    {img = "",border = 19},--个人信息
    {img = "",border = 12},--游戏中个人详情
    {img = "",border = 18},--{img = "img2/hall/bbb.png",border = 16},--上传头像
    {img = "img2/hongbao/hongbaogc/txk.png",border = 8},--?
    {img = "img2/playerInfo/_0021_yaun.png",border = 110},--发红包
    {img = "",border = 12},--排行榜
    {img = "img2/shape/1.png",border = 10},--游戏中
    {img = "img2/shape/5.png",border = 14},--百人牛牛庄家
    {img = "img2/shape/5.png",border = 4},--百人牛牛庄家
    {img = "",border = 8},--游戏中
}
R.labaRed = "img2/hall/hb.png"
R.labaNormal = "img2/hall/_0001_laba_game.png"
R.labaHallNormal = "img2/hall/_0001_laba.png"
R.labaRedBull = "img2/watchbrandgame/hb.png"
R.labaNormalBull = "img2/watchbrandgame/lb.png"

R.rank = {}
R.rank[0] = "img2/rank/qq.png"
R.rank[1] = "img2/rank/1.png"
R.rank[2] = "img2/rank/2.png"
R.rank[3] = "img2/rank/3.png"

function R:ctor()
end

function R:hideSpace(node)
    if not tolua.isnull(node and node._shape) then
        node._shape:setVisible(false)
        util.changeParent(node,node._clippingNode:getParent())
        util.showWith(node,node._shape,true)
    end
    if node._oldSpaceScale then
        node:setScale(node._oldSpaceScale)
    end
end

function R:showSpace(node,spaceIndex)
    if tolua.isnull(node) then
        return
    end
    local shape = node._shape
    if tolua.isnull(shape) then
        spaceIndex = spaceIndex or 1
        local img = R.imgHeadSpace[spaceIndex].img
        local border = R.imgHeadSpace[spaceIndex].border
        if string.len(img) <= 0 then
            local scale1 = (node:getParent():getContentSize().width-border)/node:getParent():getContentSize().width
            node._oldSpaceScale = node._oldSpaceScale or node:getScale()
            node:setScale(scale1)
            return
        end
        local parent=node:getParent()
        shape = cc.Sprite:create()
        util.loadSprite(shape,img)
        local scale = (node:getParent():getContentSize().width-border)/shape:getContentSize().width
        shape:setScale(scale)
        node:getParent():addChild(shape)
        --shape:setAnchorPoint(cc.p(0.5,0.5))
        --shape:setPosition(node:getParent():getContentSize().width*node:getParent():getScaleX()/2,node:getParent():getContentSize().height*node:getParent():getScaleY()/2)
        shape:setAnchorPoint(cc.p(node:getAnchorPoint()))
        shape:setPosition(cc.p(node:getPosition()))
        local clippingNode = cc.ClippingNode:create()
        node._clippingNode = clippingNode
        parent:addChild(clippingNode,node:getLocalZOrder())
        clippingNode:setAlphaThreshold(0.2)
        clippingNode:setContentSize(cc.size(parent:getContentSize().width,parent:getContentSize().height))
        clippingNode:setStencil(shape)
    end
    if not tolua.isnull(shape) then
        util.changeParent(node,node._clippingNode)
        node._shape = shape
        shape:setVisible(true)
    end
    util.showWith(node,shape)
end

function R:setPlayerIcon(node,bLogoID)
    local icon = R.icon[bLogoID]
    self:hideSpace(node)
    util.setImg(node,icon)
end

function R:setPlayerDiZhuIcon(node,bLord)
    local icon = R.lord[bLord]
    self:hideSpace(node)
    util.setImg(node,icon)
end
--设置托管形象
function R:setPlayerAutoIcon(node)
    local icon = R.lord[2]
    self:hideSpace(node)
    util.setImg(node,icon)
end

--设置按钮成取消
function R:setBtnCancel(node)
    util.loadButton(node,"img2/btn/_0003_anniulan")
    node:removeAllChildren()
    local img = ccui.ImageView:create()
    node:addChild(img,9)
    util.loadImage(img,"img2/btn/quxiao.png")
    img:setContentSize(cc.size(64,34))
    img:setAnchorPoint(cc.p(0.5,0.5))
    img:setPosition(node:getContentSize().width/2,node:getContentSize().height/2+3)
end


return R