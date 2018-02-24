--签到功能
local sign = class("sign",BaseDialog)

local signAward = require("config.template.7Sign")
local vipAward = require("config.template.VIPPackage ")
local vipInfo = require("config.template.VIP")

function sign:ctor(obj,info)
    sign.super.ctor(self,{obj = ui.sign})
    self.csNode = ui.loadCS("csb/activity/signNode")
    self:addChild(self.csNode)
    self.csNode:setScale(_gm.bgScaleW2)
    self.csNode:setPosition(WIN_center)
    ui.setNodeMap(self.csNode, self)
    self.csAction = ui.loadCSTimeline("csb/activity/signNode")
    self.csNode:runAction(self.csAction)
    self.csAction:gotoFrameAndPlay(0,20,false)
    self:addEvents()

    self:initSignData()
    self:onUpdateVipData()
    self:onUpdateSignInfo()
    self._sortVipAward = table.copy(vipAward)
    table.sort(self._sortVipAward,function(a,b) 
        return a.VIP>b.VIP  
    end)
    self.sp_box = Animation:createBoxSignAni(self.sp_box)
    --util.addSchedulerFuns(self,function() self.sp_box = Animation:createBoxSignAni(self.sp_box) end)
end

function sign:onUpdateVipData( ... )
    if PlayerData:getPlayerInfo().bVipLevel < 10 then
        local nextRichText = ccui.RichText:create()
        nextRichText:ignoreContentAdaptWithSize(true)
        nextRichText:setContentSize(cc.size(280, 25))
        local re1 =  ccui.RichElementText:create(1, cc.c3b(31, 48, 120), 255, "升至", "", 16)
        local re2
        if PlayerData:getPlayerInfo().bVipLevel + 1 >= 10 then
            re2 =  ccui.RichElementText:create(2, cc.c3b(246, 71, 37), 255, "皇冠VIP", "", 16)
        else
            re2 =  ccui.RichElementText:create(2, cc.c3b(246, 71, 37), 255, "VIP" .. PlayerData:getPlayerInfo().bVipLevel+1, "", 16)
        end
        
        local re3 =  ccui.RichElementText:create(3, cc.c3b(31, 48, 120), 255, "每日可领取", "", 16)
        local re4 =  ccui.RichElementText:create(4, cc.c3b(246, 71, 37), 255, vipAward[PlayerData:getPlayerInfo().bVipLevel+1].num, "", 16)
        local re5 =  ccui.RichElementText:create(5, cc.c3b(31, 48, 120), 255, "金币", "", 16)
        nextRichText:pushBackElement(re1)
        nextRichText:pushBackElement(re2)
        nextRichText:pushBackElement(re3)
        nextRichText:pushBackElement(re4)
        nextRichText:pushBackElement(re5)
        nextRichText:setPosition(cc.p(120.50, 100))
        self.img_vip_info_bg:addChild(nextRichText)
        if PlayerData:getPlayerInfo().bVipLevel <= 0 then
            self.lbl_my_vip_info:setString("您还不是VIP，请先升级")
            --self.lbl_money:setString(vipAward[1].num)
            --self.lbl_vip_next:setString("VIP1")
            self.btn_shengji:setVisible(true)
            self.btn_lingqu:setVisible(false)
        else
            self.lbl_my_vip_info:setString("今日可领取" .. vipAward[PlayerData:getPlayerInfo().bVipLevel].num .. "金币")
            --self.lbl_money:setString(vipAward[PlayerData:getPlayerInfo().bVipLevel+1].num)
            --self.lbl_vip_next:setString("VIP" .. PlayerData:getPlayerInfo().bVipLevel+1)
            if not PlayerData:getPlayerInfo().bTodayVipBag then
                self.btn_shengji:setVisible(false)
                self.btn_lingqu:setVisible(true)
            else
                self.btn_shengji:setVisible(true)
                self.btn_lingqu:setVisible(false)
            end
        end
    else
        self.lbl_my_vip_info:setString("今日可领取" .. vipAward[PlayerData:getPlayerInfo().bVipLevel].num .. "金币")
        --self.sp_haixu_money:setVisible(false)
        self.btn_shengji:setVisible(false)
        self.btn_lingqu:setVisible(true)
        if not PlayerData:getPlayerInfo().bTodayVipBag then
            util.setEnabled(self.btn_lingqu,true)
            util.setnoGray(self.img_lingqu)
        else
            util.setEnabled(self.btn_lingqu,false)
            util.setGray(self.img_lingqu)
        end
    end
end

function sign:onUpdateSignInfo( ... )
    if not PlayerData:getPlayerInfo().bTodaySign then
        util.setEnabled(self.btn_sign,true)
        -- util.setnoGray(self.img_sign)
    else
        util.setEnabled(self.btn_sign,false)
        -- util.setGray(self.img_sign)
    end
    for i=1,7 do
        if i <= PlayerData:getPlayerInfo().iCSignDays then
            self["sp_yilingqu_" .. i]:setVisible(true)
        else
            self["sp_yilingqu_" .. i]:setVisible(false)
        end
    end
    --[[
    if not tolua.isnull(self._signDayRich) then
        self._signDayRich:removeFromParent()
    end
    if PlayerData:getPlayerInfo().iCSignDays >= 0 then
        self._signDayRich = ccui.RichText:create()
        self._signDayRich:ignoreContentAdaptWithSize(true)
        self._signDayRich:setContentSize(cc.size(300, 30))
        local re1 =  ccui.RichElementText:create(1, cc.c3b(147, 82, 60), 255, "已连续签到", "", 20)
        local str =  "" .. PlayerData:getPlayerInfo().iCSignDays
        local re2 =  ccui.RichElementText:create(2, cc.c3b(255, 126, 0), 255, str, "", 20)
        local re3 =  ccui.RichElementText:create(3, cc.c3b(147, 82, 60), 255, "天", "", 20)
        self._signDayRich:pushBackElement(re1)
        self._signDayRich:pushBackElement(re2)
        self._signDayRich:pushBackElement(re3)
        self._signDayRich:setPosition(cc.p(self.img_bg_zong:getContentSize().width *0.8188, self.img_bg_zong:getContentSize().height *0.8))
        self.img_bg_zong:addChild(self._signDayRich)
    end]]--
end

function sign:initSignData()
    local tbl =
    {
        [1] = "金币",
        [3] = "奖券",
        [4] = "钻石",
    }
    for k,v in pairs(signAward) do
        if v then
            if v.num > 0 and v.type > 0 then
                local lbl_coin = self["lbl_coin_".. v.day]
                if lbl_coin then
                    lbl_coin:setString(tbl[v.type] .. "x" .. v.num)
                end
            end
            if v.num1 > 0 and v.goodid > 0 then
                local lbl_coin_0 = self["lbl_coin_".. v.day .. "_0"]
                if lbl_coin_0 then
                    lbl_coin_0:setString(TemplateData:getGoodsNameById(v.goodid) .. "x" .. v.num1)
                end
                local sp_icon = self["sp_awrd_7".. v.day .. "_0"]
                if sp_icon then
                    util.loadSprite(sp_icon,TemplateData:getGoodsIconById(v.goodid))
                end
            end
        end
    end
    local iDay = PlayerData:getPlayerInfo().iCSignDays + 1
    if PlayerData:getPlayerInfo().bTodaySign then
        iDay = iDay - 1
    end
    if iDay and self["img_today_" .. iDay] then
        self["img_today_" .. iDay]:setVisible(true)
    end
end

function sign:addEvents()
    util.clickSelf(self, self.btn_return, function() 
        _uim:closeLayer(self.m_obj) 
    end)    -- 关闭
    util.clickSelf(self, self.btn_sign, self.onSendSingToSever)                    -- 签到
    util.clickSelf(self, self.btn_help, self.onSignHelp)                    -- 帮助
    util.clickSelf(self, self.btn_shengji, self.onVipShengji)                 -- 升级
    util.clickSelf(self, self.btn_lingqu, self.onSendReceiveVipDay)                 -- 领取VIP奖励
    
    GameSocket:addDataHandler(MDM_GP_SIGN,ASS_GP_SIGN,self,self.onSucSign)--签到返回
    GameSocket:addDataHandler(MDM_GP_VIP,ASS_VIP_RECEIVE_DAY_REWARD,self,self.onVipReceiveDayReward)--vip每日领取礼包
end

function sign:onSendReceiveVipDay( ... )
    GameSocket:sendMsg(MDM_GP_VIP,ASS_VIP_RECEIVE_DAY_REWARD)
end

function sign:onSendSingToSever( ... )
    GameSocket:sendMsg(MDM_GP_SIGN,ASS_GP_SIGN)
end

function sign:onSignHelp( ... )
    if not tolua.isnull(self._signExplain) then
        self._signExplain:setVisible(true)
        return
        --self._signExplain:removeFromParent()
    end
    self._signExplain = ui.createCsbItem("csb.activity.signExplain")
    util.clickSelf(self._signExplain,self._signExplain.pnl_close,function() 
        self._signExplain:setVisible(false)
        --self._signExplain:removeFromParent() 
    end)
    util.clickSelf(self._signExplain,self._signExplain.btn_return,function() 
        self._signExplain:setVisible(false)
        --self._goodView = nil
        --self._signExplain:removeFromParent() 
    end)
    util.aptNotScale(self._signExplain.img_bk,true)
    util.addToPop(self._signExplain)
    self:onShowSignExplain()
end

function sign:scrollViewDidScroll(view)
    --trace("scrollViewDidScroll")
end

function sign:scrollViewDidZoom(view)
    --trace("scrollViewDidZoom")
end

function sign:tableCellTouched(table,cell)
    --trace("cell touched at index: " .. cell:getIdx())
end

function sign:cellSizeForTable(table,idx) 
    if sdkManager:isNewCocosVersion() then
    return self._signExplain.pnl_help_vip:getContentSize().width,self._signExplain.pnl_help_vip:getContentSize().height/4
    else
    return self._signExplain.pnl_help_vip:getContentSize().height/4,self._signExplain.pnl_help_vip:getContentSize().width
    end
end

function sign:tableCellAtIndex(table, idx)
    local col = 3
    local width = 245
    local space = 0 --(self._signExplain.pnl_help_vip:getContentSize().width - width*col)/(col+1)
    local cell = table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end
    for i = 1,col do
        local index = i + idx * col
        local info = vipAward[10-index+1]
        local item = cell:getChildByTag(i)
        if info then
            if tolua.isnull(item) then
                item = self:createSignExplainItem(info)
                item:setPosition(space+(i-1)*(width+space),0)
                item:setTag(i)
                cell:addChild(item)
            else
                item = self:createSignExplainItem(info,item)
            end
        elseif not tolua.isnull(item) then
            item:removeFromParent()
        end     
    end

    return cell
end

function sign:numberOfCellsInTableView(tbl)
   return math.ceil(table.nums(vipAward)/3)
end

function sign:createSignExplainItem(info,item)
    if not item then
        item = ui.createCsbItem("csb.activity.signExplainItem")
        item:setAnchorPoint(cc.p(0.5,0))
        item.vipkuang_1:setLocalZOrder(10)
    end
    if not info then
        return item
    end
    PlayerData:setPlayerHeadIcon(item.img_head)
    util.setImg(item.sp_vip,"img2/activity/sign/VIP" .. info.VIP .. ".png")
    util.setImg(item.vipkuang_1,"img2/shop/vip/LV" .. info.VIP .. ".png")
    item.lb_exchange_price:setString(info.num .. "金币")
    return item
end

function sign:onShowSignExplain()
    if not self._goodView then
        self._goodView = util.tableView(self._signExplain.pnl_help_vip,handler(self,self.createSignExplainItem),cc.size(225,95),self._sortVipAward,4,3)
    end
    self._goodView:reloadData()
end

function sign:onVipShengji( ... )
    _uim:closeLayer(self.m_obj)
    _uim:showLayer(ui.shop,4)
end

function sign:onSucSign( res,param2,param3, head )
    if head and head.uHandleCode == 0 then
        PlayerTaskData:setCompleteCount({iGameType=0,taskType=8})
        PlayerData:getPlayerInfo().iCSignDays = PlayerData:getPlayerInfo().iCSignDays + 1
        PlayerData:getPlayerInfo().bTodaySign = 1
        self:onUpdateSignInfo()
        self:onShowAniSignSuc()
    elseif head and head.uHandleCode == 1 then
        Alert:showTip("今日已签到",2)
    elseif head and head.uHandleCode == 2 then
        Alert:showTip("签到失败",2)
    else
        Alert:showTip("未知错误",2)
    end
end

function sign:onVipReceiveDayReward( res,param2,param3, head )
    if head and head.uHandleCode == 0 then
        PlayerData:getPlayerInfo().bTodayVipBag = 1
        self:onUpdateVipData()
        self:onShowAniVipRewardDaySuc()
        Alert:showTip("领取成功",2)
    else
        Alert:showTip("未知错误",2)
    end
end

--vip升级奖励领取
function sign:onShowAniVipRewardDaySuc()
    util.playSound("getBean_success",false)
    _au:playCoinRain()
    local csNode = ui.loadCS("csb/common/getGoldNode")
    local effLayer = util.getBaseLayer("effectLayer")
    effLayer:addChild(csNode)
    csNode:setScale(_gm.bgScaleW)
    csNode:setPosition(WIN_center)
    local csdAction = ui.loadCSTimeline("csb/common/getGoldNode")
    csNode:runAction(csdAction)
    csdAction:play("play", false)
    local info = vipAward[PlayerData:getPlayerInfo().bVipLevel]
    local lbl = csNode:getChildByName("getGoldBg"):getChildByName("lbl_num")
    lbl:setString("恭喜获得 " ..info.num.. " 金币。")
    PlayerData:setGold(PlayerData:getGold() + info.num)
end

--签到获得奖励
function sign:onShowAniSignSuc()
    util.playSound("getBean_success",false)
    _au:playCoinRain()
    local csNode = ui.loadCS("csb/common/getGoldNode")
    local effLayer = util.getBaseLayer("effectLayer")
    effLayer:addChild(csNode)
    csNode:setScale(_gm.bgScaleW)
    csNode:setPosition(WIN_center)
    local csdAction = ui.loadCSTimeline("csb/common/getGoldNode")
    csNode:runAction(csdAction)
    csdAction:play("play", false)
    local info = signAward[PlayerData:getPlayerInfo().iCSignDays]
    local str = ""
    if info.goodid == 307 then
        str = "恭喜获得 " ..info.num.. " 金币, " ..info.num1.. "个福袋。"
        PlayerData:changeItemNum(info.goodid,info.num1)
    else
        str = "恭喜获得 " ..info.num.. " 金币。"
    end
    local lbl = csNode:getChildByName("getGoldBg"):getChildByName("lbl_num")
    lbl:setString(str)
    PlayerData:setGold(PlayerData:getGold() + info.num)
end

function sign:onExit()
    PlayerData:removePopSequence(ui.sign)
end

return sign