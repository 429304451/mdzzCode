--点击头像弹出的用户信息
local userInformation = class("userInformation",BaseDialog)

function userInformation:ctor(obj,info)

    userInformation.super.ctor(self,{obj = obj})
    self.mask:setBackGroundColorOpacity(0)
    self._csbPath = info.csbPath
    self.csNode = ui.loadCS(info.csbPath .. "userInfo")
    self:addChild(self.csNode)
    -- info.parent:addChild(self,100)
    -- self.csNode:setScale(_gm.bgScaleW)
    -- self.csNode:setPosition(WIN_center)
    ui.setNodeMap(self.csNode, self)
    self.csAction = ui.loadCSTimeline(info.csbPath .. "userInfo")
    self.csNode:runAction(self.csAction)
    self.csAction:gotoFrameAndPlay(0,20,false)
    -- util.aptNotScale(self.img_frame,true)
    self._iGold = info.iGold
    self._daoju = {}
    self._info = info.data
    if self._info then
        self:initUserInfo(self._info)
        if self._info.iTax then
            self._iMinLimt = self._info.iTax
        end
        if self._info._xiazhu then
            self._iXiazhu = self._info._xiazhu
        end
    else
        
    end
    self:addEvents()
end

function userInformation:addEvents()
    util.clickSelf(self, self.pnl_close, function()
        _uim:closeLayer(ui.userInfo,0.01)
    end)
    RoomSocket:addDataHandler(MDM_GR_PROP,ASS_PROP_USEPROP,self,self.onResUseItem)
    GameEvent:addEventListener(GameEvent.updateItem,self,self.updateDaojuList)
end

function userInformation:initUserInfo(info)
    self._dwUserID = info.dwUserID
    if info.bMatchInfo then
        self._bMatchInfo = true
    else
        self._bMatchInfo = false
    end
    self:updateDaojuList()

    local desc = "互动道具每使用一次扣费30金币"
    if self._dwUserID == PlayerData:getUserID() then
        desc = "您不能对自己使用道具"
    else
        if info.bMatchInfo then
            desc = "比赛中不能使用道具"
        end
    end
    self.lbl_desc:setString(desc)
    PlayerData:setPlayerHeadVip(self.img_head_vip,info.bVipLevel)
    self.lbl_name:setString(info.nickName or "")
    self.lbl_call:setString(info.call or "称号:无")
    local dwMoney = util.showNumberCoinFormat(info.dwMoney)
    self.lbl_bean:setString(dwMoney or "")
    self.lbl_pos:setString(info.pos or "地区保密")
    --self.lbl_winPer:setString(winPercent or "")
    --self.lbl_total:setString(totaCound or "")
    self._framepos = info.posInfo
    local url = info.szHeadWeb
    local bLogoID = info.bLogoID
    if url and url ~= "" then
        PlayerData:setPlayerHeadIcon(self.img_head,url,4)
    elseif self._dwUserID == PlayerData:getUserID() then
        PlayerData:setPlayerHeadIcon(self.img_head,nil,4)
    else
        R:setPlayerIcon(self.img_head,bLogoID)
    end
end

function userInformation:updateDaojuList()
    local daoju = {303,304,305,306}
    for _,id in pairs(daoju) do
        local item = self._daoju[id] 
        if item == nil then
            item = ui.createCsbItem(self._csbPath .. "playerInfo_Daoju")
            util.loadImage(item.sp_icon,TemplateData:getGoodsIconById(id))
            if self._dwUserID == PlayerData:getUserID() or self._bMatchInfo == true then
                util.setGray(item.sp_icon)
                util.setEnabled(item.btn_bg)
            end
            util.clickSelf(self,item.btn_bg,self.useItem,id)
            util.listAddItem(self.ls_daoju,item)
            self._daoju[id] = item
        end
        local num = PlayerData:getItemNumbyId(id)
        if num>0 then
            item.sp_num:setVisible(true)
            item.lbl_num:setString(num)
        else
            item.sp_num:setVisible(false)
        end
    end
end


function userInformation:useItem(id)
    if not self._dwUserID then
        trace("error:userInformation:useItem _dwUserID = nil")
        return
    end
    local addGold = TemplateData:getGoodsPriceEx(id)
    if PlayerData:getItemNumbyId(id) <= 0 and self._iMinLimt and self._iGold - addGold < self._iMinLimt then
        Alert:showTip("购买后金币低于" .. self._iMinLimt .. "，无法购买",2)
        _uim:closeLayer(ui.userInfo,0.01)
        return
    end
    if self._iXiazhu and addGold + self._iXiazhu*3 > self._iGold then
        Alert:showTip("费用不足，无法使用道具",2)
        _uim:closeLayer(ui.userInfo,0.01)
        return
    end
    if self._iGold < addGold then
        Alert:showTip("金币不足，无法使用道具",2)
        _uim:closeLayer(ui.userInfo,0.01)
        return
    end
    self._usingItemID = id
    local tbl = {   
        dwUserID = PlayerData:getUserID(),
        dwTargetUserID = self._dwUserID,
        nPropID = id,
    }
    RoomSocket:sendMsg(MDM_GR_PROP,ASS_PROP_USEPROP,tbl)
end

function userInformation:onResUseItem(res,param2,param3,head)
    if head and head.uHandleCode == 0 then
        local userID = res.dwUserID
         trace("使用道具",userID)
        if userID == PlayerData:getUserID() then
            trace("使用道具")
            PlayerData:useItem(self._usingItemID,1)
            _uim:closeLayer(ui.userInfo,0.01)
        end
    else
        trace("道具使用失败uHandleCode = ",head.uHandleCode)
        Alert:showTip("使用失败")
    end
    --_uim:closeLayer(ui.userInformation,0.01)
end

function userInformation:setFramePos(anchorPos,pos)
    self.img_frame:setAnchorPoint(anchorPos)
    self.img_frame:setPosition(pos.x,pos.y)

    util.setshakePos(self,pos)
end

function userInformation:resize()
    self.pnl_close:setContentSize(WIN_SIZE)
    if self._framepos then
        local pos = self._framepos.pos
        local anchor = self._framepos.anchor
        if pos and anchor then
            self:setFramePos(anchor,pos)
        end
    end
end

return userInformation