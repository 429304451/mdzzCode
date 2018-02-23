local PlayerData = class("PlayerData")
    
function PlayerData.create()
    local data = PlayerData.new()
    return data
end

function PlayerData:ctor()
    self:initData()
end


function PlayerData:getVersion()
    print("getVersion")
    return self.version or ""
end

function PlayerData:setVersion(ver)
    print("setVersion", ver)
    if self.version == ver then
        return
    end
    self.version  = ver

    GameEvent:notifyView(GameEvent.updateVersion,self.version)
end

function PlayerData:initData()
    self._playerRoomInfo = nil
    self.version = self.version or nil
    self.iBasePoint = nil
    self._curRoomInfo = nil
    self._reLoginByID = nil
    self._taskData = nil
    self._wxHeadUrl = nil
    self._usersDatas = nil
    self._bCreateFriRoom = nil
    self._enableSound = nil
    self._enableMusic = nil
    self._isWXAcccount = nil
    self._temHeadIcon = nil
    --self._areaID = nil

    self._player = {}
    self._items = {}

    self._mailData = {}
    self._myTblRedSquare = {}
    self._bIsFirstCreateOrJiaru = false
    self._bSendSquareRedReq = false
    self._bSendMyRedReq = false
    self._bNewMyRedRecore = false
    self._lastSendMagTime = 0
    self._bSendMsgPochang = false
    self._luckyRecord = nil
    self._lotteryNum = nil
    self._ResurrectionType = nil
end

function PlayerData:setPlayerData(res)
    if res then
        self._player = res
        self._popSeq = {}
        if not util.isExamine() then
            if not self._player.bTodaySign and self._player.iCutRoomID == 0 then
                self:setPopSequence(ui.sign)
            end
        end
        GameEvent:notifyView(GameEvent.updatePlayer)
    end
end

function PlayerData:getPlayerInfo()
    return self._player
end

function PlayerData:setPlayerIdentity(bCertify)
    self._player.bCertification = bCertify
    GameEvent:notifyView(GameEvent.updateCertifiy)
end

function PlayerData:setPlayerInfoAdd( res )
    self._playerAdd = res
    traceObj(res)
    if res and res.iNewTaskID and (res.iNewTaskID > 0 and res.iNewTaskID < 7) or (res.iNewTaskID == 7 and res.iNewTaskValue < 2)  then
        self:setPopSequence(ui.loginWelfare)
        PlayerTaskData:set7SignTaskCurDay({iNewTaskID=res.iNewTaskID,iNewTaskValue=res.iNewTaskValue,iNewFinishCount=res.iNewFinishCount,bTodayCanRecive=res.bTodayCanRecive})
        GameEvent:notifyView(GameEvent.updateShow7TaskSign) -- 通知显示新手7天签到任务
    end
end

--距离注册时间
function PlayerData:getDifferRegDate( ... )
    return self:getServerTime() - self._player.tmRegDate
end

--微信分享任务
function PlayerData:hasShareTask()
    if not self._playerAdd then
        trace("error:PlayerData:hasShareTask not _playerAdd")
        return
    end
    if self._playerAdd.bWXShare then
        sdkManager:getQRimg()
    end
    return self._playerAdd.bWXShare
end

--微信分享任务
function PlayerData:setShareTaskValue(bShared)
    if not self._playerAdd then
        trace("error:PlayerData:hasShareTask not _playerAdd")
        return
    end
    self._playerAdd.bWXShare = bShared
end

--推广转盘数
function PlayerData:getPromoTurnCount()
    if not self._playerAdd then
        trace("error:PlayerData:getPromoTurnCount not _playerAdd")
        return 0
    end
    return self._playerAdd.iPromoTurnCount  or 0
end

function PlayerData:setPromoTurnCount(num)
    self._playerAdd.iPromoTurnCount = num
end

function PlayerData:getPlayerInfoAdd( ... )
    return self._playerAdd
end

function PlayerData:setPlayerResurrect(time)
    self._playerAdd.tmResurrectionTM = time
    GameEvent:notifyView(GameEvent.updateResurrectionTM)
end

function PlayerData:setDDzSignUpRoomLevel( iRoomLevel )
    self._playerAdd.iDDZSignUpLevel = iRoomLevel
    GameEvent:notifyView(GameEvent.updateDDZSignUpInfo)
end

function PlayerData:getBindingTelNum()
    return self._player.szPhoneNumber
end

function PlayerData:setBindingTelNum(num)
    self._player.szPhoneNumber = num
    self:ModifyTaskData( MOBILE_PHONE_TASK, 1)
    GameEvent:notifyView(GameEvent.updatePlayer)
end

function PlayerData:setWeekCardTime( inValiTime )
    local time
    if self._player.tWeekCardTime - self:getServerTime() < 0 then
        time = self:getServerTime()
    else
        time = self._player.tWeekCardTime
    end
    self._player.tWeekCardTime = time + inValiTime
    GameEvent:notifyView(GameEvent.updateCardInfo,WEEKS_CARD_ID)
end

function PlayerData:setMonthCardTime( inValiTime )
    local time
    if self._player.tMonthCardTime - self:getServerTime() < 0 then
        time = self:getServerTime()
    else
        time = self._player.tMonthCardTime
    end
    self._player.tMonthCardTime = time + inValiTime
    GameEvent:notifyView(GameEvent.updateCardInfo,MONTH_CARD_ID)
end

function PlayerData:setPlayerRoomData(res)
    self._playerRoomInfo = res
    if self._playerRoomInfo then
         self._playerRoomInfo.bVipLevel = self._player.bVipLevel
    end
    --GameEvent:notifyView(GameEvent.updateUserRoominfo)
end

function PlayerData:setPlayerRoomMoney(money)
    if self._playerRoomInfo then
        self._playerRoomInfo.dwMoney = money
    end
end

function PlayerData:getPlayerRoomData()
    return self._playerRoomInfo
end

function PlayerData:getPlayerRoomiLessPoint()
    return self.iLessPoint
end

function PlayerData:setPlayerRoomiLessPoint(v)
    self.iLessPoint = v
end

function PlayerData:getPlayerRoomiBasePoint()
    return self.iBasePoint
end

function PlayerData:setPlayerRoomiBasePoint(v)
    self.iBasePoint = v
end


function PlayerData:getNickName()
    return self._player.nickName
end

--是否 已经首充过了
function PlayerData:hasFirstCharged()
    return self._player.bIsFirstPay
end


function PlayerData:setFirstCharged(iType, bFirst)
    if iType == 1 then
        self._player.bIsFirstPay = bFirst
        GameEvent:notifyView(GameEvent.updateBoolFirst)
    -- elseif iType == 2 then
        -- self._playerAdd.bIsTodayFirstPay = bFirst
        -- GameEvent:notifyView(GameEvent.updateBoolFirst)
    end
end

function PlayerData:hasModifyPsw()
    return self._player.bIsModifyPsw
end


function PlayerData:setModifyPsw()
    self._player.bIsModifyPsw = true
end



function PlayerData:setNickName(name)
    if name == self._player.nickName or type(name) ~= "string" then
        return
    end
    self._player.nickName = name
    self:ModifyTaskData( MODIFIED_NICKNAME_TASK, 1)
    GameEvent:notifyView(GameEvent.updatePlayer)
end

function PlayerData:getUserID()
    return self._player.dwUserID or ""
end

--是否是男孩
function PlayerData:getIsBoy()
    return self._player.bBoy
end

function PlayerData:setIsBoy(bIsBoy)
    if type(bIsBoy) == "number" then
        bIsBoy = bIsBoy == 1
    end
    self._player.bBoy = bIsBoy
    GameEvent:notifyView(GameEvent.updatePlayer)
end

--获取用户金币
function PlayerData:getGold()
    return self._player.dwMoney
end

function PlayerData:setGold( iMoney ,isAdd)
    iMoney = isAdd and self._player.dwMoney + iMoney or iMoney
    self._player.dwMoney = iMoney
    self:setPlayerRoomMoney(iMoney)
    GameEvent:notifyView(GameEvent.updatePlayer)
end

--获取奖券
function PlayerData:getVoucher()
    return self._player.iVoucher
end

function PlayerData:setVoucher( iVoucher ,isAdd)
    iVoucher = isAdd and self._player.iVoucher + iVoucher or iVoucher
    self._player.iVoucher = iVoucher
    GameEvent:notifyView(GameEvent.updatePlayer)
end
--获取门票
function PlayerData:getGameCoin()
    return self._player.iGameCoin
end
function PlayerData:setGameCoin( iGameCoin ,isAdd)
    iGameCoin = isAdd and self._player.iGameCoin + iGameCoin or iGameCoin
    self._player.iGameCoin = iGameCoin
    GameEvent:notifyView(GameEvent.updatePlayer)
end
--获取现金红包
function PlayerData:getRedMoney()
    return self._player.iRedMoney
end
function PlayerData:setRedMoney( iMoney ,isAdd)
    local iRedMoney = isAdd and self._player.iRedMoney + iMoney or iMoney
    self._player.iRedMoney = iRedMoney
    GameEvent:notifyView(GameEvent.updateRedMoney)
end

--获取用户y元宝
function PlayerData:getTreasure()
    return self._player.dwTreasure
end
function PlayerData:setTreasure(iTreasure,isAdd)
    self._player.dwTreasure = isAdd and self._player.dwTreasure + iTreasure or iTreasure
    GameEvent:notifyView(GameEvent.updatePlayer)
end

--头像ID
function PlayerData:bLogoID()
    return self._player.bLogoID or 0
end

function PlayerData:setLogoID(id)
    --if type(id) == "number" and id ~= self._player.bLogoID then
        self:setTemHeadIcon()
        self:setWXHeadIcon()
        self._player.bLogoID = id
        GameEvent:notifyView(GameEvent.updatePlayer)
    --end
end

--红包
function PlayerData:getRedSend()-- 发送红包总数
    return self._player.iRedSendAmount or 0
end

function PlayerData:setRedSend(num,isAdd)
    if isAdd then
        num = self:getRedSend() + num
    end
    if  num ~= self:getRedSend() then
        self._player.iRedSendAmount = num
        GameEvent:notifyView(GameEvent.updatePlayer)
    end
end
function PlayerData:getRedRec()-- 收红包总数
    return self._player.iRedReceiveAmount or 0
end

function PlayerData:setRedRec(num,isAdd)
    if isAdd then
        num = self:getRedRec() + num
    end
    if  num ~= self:getRedRec() then
        self._player.iRedReceiveAmount = num
        GameEvent:notifyView(GameEvent.updatePlayer)
    end
end

--登录名

--这里要获取设备ID只在安卓下才生效
function PlayerData:getdefUserName()
    local driverID
    if sdkManager:isBengbeng() or sdkManager:isXianwan() then
        driverID = util.getIMEI()
    else
        driverID = util.getDriverID()
    end
    return driverID or os.getenv("USERNAME")--"qwertyuiopqwertyuiopqwertyuiopqwertyui"
end

function PlayerData:getUserName()
    local name = self._playerName or self:getdefUserName()
    return name
end

function PlayerData:setUserName(name)
    self._playerName = name
end


--注册MD5
function PlayerData:getRegisterMD5()
    local str = string.format("7%s8%s0%d",self:getUserName(),self:getMAC(),self:getWBFlag())
    return util.md5(str)
end

function PlayerData:getLoginMD5()
    local str = string.format("a%sb%sc%sd%d",self:getUserName(),self:getPassWord(),self:getMathineCode(),self:getRoomVer())
    return util.md5(str)
end
--房间登录MD5
function PlayerData:getLoginRoomMD5(iGameID)
    local str = string.format("d%dd%sz%s",iGameID,self:getPassWord(),self:getMAC())
    return util.md5(str)
end


--MAC(手机imei值)
function PlayerData:getMAC()
    local mac = Platefrom:hasIMEI() and util.getIMEI() or util.getMac()--getMac可能导致部分机子崩溃
    --local mac = "1234567890123456789"
    return string.sub(mac,1,32)
end

--机器码
function PlayerData:getMathineCode()
    return self:getMAC()--Platefrom:hasIMEI() and util.getIMEI() or  (util.getDriverID() and util.md5(util.getDriverID())) or self:getMAC()
end

--pw
function PlayerData:getdefPassWord()
    if (sdkManager:getSDKType() == SDK_LOGIN_TYPE_QUICKSDK) or self:isWXAcccount() then
        return util.md5(self:getUserName())
    end
    local pw = (util.getDriverID() and util.md5(util.getDriverID())) or "123456"
    return pw
end

function PlayerData:encodePW(passWord)
    return util.md5((util.md5(passWord).."110"))
end

--获得密码,默认为Md5
function PlayerData:getPassWord( isnotMd5)
    local pw = self._password or self:getdefPassWord()
    return isnotMd5 and pw or self:encodePW(pw)
    --return isnotMd5 and pw or util.md5(pw)
end

--[[function PlayerData:hasPassWordChanged()
    return self:getPassWord( true) ~= self:getdefPassWord()
end]]

--设置密码,(原码)
function PlayerData:setPassWord(value)
    self:ModifyTaskData(MODIFY_PASSWORD_TASK, 1)
    self._password = value
end

--现在这里传客户端版本号
function PlayerData:getAreaID()

    return self:getRoomVer()--self._areaID or 4
end

--[[function PlayerData:setAreaID(id)
    self._areaID = id
end]]

function PlayerData:getWBFlag()
    return 1
end

--现在这里传客户端版本号
function PlayerData:getRoomVer()
    local ver = self:getVersion() or 0
    if type(ver) == "string" then
        return 1000
    end
    return ver*1000--1
    -- return 1000
end

function PlayerData:getLogonType()
    local name = self:getUserName()
    if tonumber(name) and string.len(name) == 11 then--手机号
        return 3
    end
    return 1
end


function PlayerData:getIsFirstLogin()
    return 1
end

function PlayerData:getGameVer()
    return 1
end

function PlayerData:getArrShowID()
    return self._player.arrShowID
end

function PlayerData:setCurRoomInfo( tbl )
    self._curRoomInfo = tbl
end

function PlayerData:getCurRoomInfo(  )
    return self._curRoomInfo
end

function PlayerData:setFriendRoomInfo( tbl )
    self._friendRoomInfo =  tbl
end
function PlayerData:getFriendRoomInfo( ... )
    return self._friendRoomInfo
end

function PlayerData:setServerDiff(time)
    self._timeDiff = time
end

function PlayerData:getServerDiff( )
    return self._timeDiff
end


function PlayerData:getServerTime()
    return util.time() + (self._timeDiff or 0)
end

--存储玩家报名信息
function PlayerData:setUserMatchInfo( res )
   self._matchInfo = res
   -- GameEvent:notifyView(GameEvent.updateMatchInfo)
end
function PlayerData:isSignMatch( ... )
    if self._matchInfo then
        for i,v in pairsKey(self._matchInfo) do
            if v.bSignUp == true and v.iMatchID == 30 then
                return true
            end
        end
    end
    return false
end

function PlayerData:getUserMatchInfo( ... )
    return self._matchInfo
end

function PlayerData:setCurMatchID( iMatchID,iTypeKind )
    self._iCurMatchID = iMatchID
    self._iTypeKind = iTypeKind
end

function PlayerData:getCurMatchID( ... )
    return self._iCurMatchID
end

function PlayerData:getCurMatchTypeKind( ... )
    return self._iTypeKind
end
function PlayerData:setSignupUserCnt( iSignupCount )
    self._iSignupUserCnt = iSignupCount
    GameEvent:notifyView(GameEvent.signupUserCnt)
end
function PlayerData:getSignupUserCnt( ... )
    return self._iSignupUserCnt
end

--isGame 为false不在房间,否则为房间名字
function PlayerData:setIsGame( isGame )
    self._isGame = isGame
    GameEvent:notifyView(GameEvent.isGame)
end
function PlayerData:getIsGame( ... )
    return self._isGame
end

--购买物品
function PlayerData:sendbuyItem(id)
    -- local goodInfo = TemplateData:getGoodsById(id)
    -- if not goodInfo then
    --     trace("error:onItemBuySucc unknow item,id = ",id)
    --     return
    -- end
    -- local classify = goodInfo.classify
    -- local addGold = TemplateData:getGoodsValue(id)
    -- if classify == 1 then
    --     if self:getGold() < addGold  then
    --         Alert:showTip("金币不足",1)
    --         return
    --     end
    -- elseif classify == 2 then
    --     if self:getGold() < addGold  then
    --         Alert:showTip("金币不足",1)
    --         return
    --     end
    -- end
    local tbl = {
        --dwUserID = self:getUserID(),
        nPropID = id,
    }
    if self:getIsGame() then
        RoomSocket:sendMsg(MDM_GR_PROP,ASS_PROP_BUYGOLD,tbl)
    else
        GameSocket:sendMsg(MDM_GP_PROP,ASS_PROP_BUY,tbl)
    end
end

--购买
function PlayerData:onItemBuySucc(id,num)
    local goodInfo = TemplateData:getGoodsById(id)
    if not goodInfo then
        trace("error:onItemBuySucc unknow item,id = ",id)
        return
    end
    local _,_,totalmoney = TemplateData:getGoodsPriceEx(id)
    local classify = goodInfo.classify
    -- if id == FIRST_CHARGE_ID then
        -- self:setFirstCharged(1,true)
        -- self:setGameCoin(33 ,true)
        -- self:setGold(20000 ,true)
        -- totalmoney = FIRST_CHARGE_PRICE
    if classify == 8 then
        --1元2元复活
        GameEvent:notifyView(GameEvent.aliveChargeSuc)
    elseif classify == 7 then
        self:setFirstCharged(1,true)
        local addGameCoin,addGold = TemplateData:getGoodsValueFirstCharge(id)
        addGameCoin = addGameCoin * num
        addGold = addGold*num
        self:setGameCoin(self:getGameCoin() + addGameCoin)
        self:setGold(self:getGold() + addGold)
    elseif classify == 1 then
        self:onGoldChange(id,num)
    elseif classify == 5 then
        --需要通知服务器
        RoomSocket:sendMsg(MDM_GP_USERREFLASH,ASS_GP_USERREFLASH)
        --self:onGoldChange(id,num)
    elseif classify == 2 then
        self:onTreasureChange(id,num)
    elseif classify == 4 then
        self:onWeekandMonthCard(id,num)
    elseif classify == 6 then
        self:onGameGoldChange(id,num)
    else
        self:changeItemNum(id,num)
    end
    trace("=========充值金额==========",totalmoney)
    self:setChargeAmount(totalmoney,true)
        
    self:PayItem(id,num)
end

function PlayerData:onGameGoldChange(id,num)
    local goodInfo = TemplateData:getGoodsById(id)
    if not goodInfo then
        trace("error:onGoldChange unknow item,id = ",id)
        return
    end
    local addGold = TemplateData:getGoodsValue(id)
    addGold = addGold*num
    self:setGameCoin(self:getGameCoin() + addGold)
    trace(self:getGameCoin())
end

function PlayerData:onWeekandMonthCard( id,num )
    local addTime = TemplateData:getGoodsTimeById(id)*num
    local addGold
    if id == WEEKS_CARD_ID or id == WEEKS_CARD_ID_GOLD then
        addGold = 80000
        self:setWeekCardTime(addTime)
    elseif id == MONTH_CARD_ID then
        addGold = 500000
        self:setMonthCardTime(addTime)
    end
    addGold = addGold*num
    self:setGold(self:getGold() + addGold)
end

--金币加
function PlayerData:onGoldChange(id,num)
    local goodInfo = TemplateData:getGoodsById(id)
    if not goodInfo then
        trace("error:onGoldChange unknow item,id = ",id)
        return
    end

    local addGold = TemplateData:getGoodsValue(id)
    addGold = addGold*num
    self:setGold(self:getGold() + addGold)
end

function PlayerData:onTreasureChange(id,num)
    local goodInfo = TemplateData:getGoodsById(id)
    if not goodInfo then
        trace("error:onTreasureChange unknow item,id = ",id)
        return
    end

    local add = TemplateData:getGoodsValue(id)
    add = add*num
    self:setTreasure(add,true)
end


function PlayerData:PayItem(id,num)
    local goodInfo = TemplateData:getGoodsById(id)
    if not goodInfo then
        trace("error:PayItem unknow item,id = ",id)
        return
    end

    local addGold,delTreasure = TemplateData:getGoodsPriceEx(id)
    delTreasure = -delTreasure*num
    self:setTreasure(self:getTreasure() + delTreasure)

    addGold = -addGold*num
    self:setGold(self:getGold() + addGold)
    trace("支付物品,",delTreasure,addGold)
end

function PlayerData:checkEnoughGold(gold)
    return self:getGold()>= gold
end


function PlayerData:checkEnoughTreasure(value)
    return self:getTreasure()>= value
end

function PlayerData:canBuyItem(id,num)
    local priceType = TemplateData:getPriceType(id)
    local price = TemplateData:getGoodsPrice(id) * num
    local canBuy = true
    if priceType == PRICETYPE_GOLD then
        canBuy = self:checkEnoughGold(price)
    elseif priceType == PRICETYPE_TREA then
        canBuy = self:checkEnoughTreasure(price)
    end

    return canBuy,priceType
end

--背物品
function PlayerData:getItems()
    return self._items
end

function PlayerData:getItembyId(id)
    for i,j in pairs(self._items)do
        if j.nPropID == id then
            return j
        end
    end
end

function PlayerData:getItemNumbyId(id)
    for i,j in pairs(self._items)do
        if j.nPropID == id then
            return j and j.nHoldCount
        end
    end
    return 0
end


function PlayerData:getItemInvalidTime(id)
    local time = 0
    if id == WEEKS_CARD_ID then
        time = self._player.tWeekCardTime - self:getServerTime() 
    elseif id == MONTH_CARD_ID then
        time = self._player.tMonthCardTime - self:getServerTime() 
    else
        time = self:getItemTime(id) - self:getServerTime() 
    end
    if time < 0 then
        time = 0
    end
    return time
end


function PlayerData:setItems(v)
    self._items = v
    GameEvent:notifyView(GameEvent.updateItem)
end


function PlayerData:getItemTime(id)
    for i,j in pairs(self._items)do
        if j.nPropID == id then
            return j.tmInvalid
        end
    end
    return 0
end

function PlayerData:changeItemNum(id,numchange)
    local hasItem = false
    trace("道具个数",numchange, id)
    for i,j in pairs(self._items)do
        if j.nPropID == id then
            hasItem = true
            self._items[i].nHoldCount = self._items[i].nHoldCount or 0
            self._items[i].nHoldCount = self._items[i].nHoldCount + numchange
            if self._items[i].nHoldCount< 0 then
                self._items[i].nHoldCount = 0
            end
            local addTime = TemplateData:getGoodsTimeById(id)*numchange
            self._items[i].tmInvalid = self._items[i].tmInvalid + addTime
            if TemplateData:getGoodsTimeById(id) == 0  then
                if  self._items[i].nHoldCount == 0 then
                    table.remove(self._items,i)
                end
            elseif self._items[i].tmInvalid <= 0 then
                table.remove(self._items,i)
            end
            break
        end
    end
    if not hasItem then
        local time = TemplateData:getGoodsTimeById(id)*numchange
        time = time == 0 and 0 or time + self:getServerTime()
        table.insert(self._items,{nHoldCount = numchange,nPropID = id,tmInvalid = time})
    end
    GameEvent:notifyView(GameEvent.updateItem)
end

--消耗物品,有物品直接消耗,没有则先买后用
function PlayerData:useItem(id,num)
    if not (id and num) then
        return
    end
    local hasitemNum = self:getItemNumbyId(id)
    local useNum = math.min(hasitemNum,num)
    local buyNum = num - hasitemNum
    if useNum>0 then
        self:changeItemNum(id,-useNum)
    end
    if buyNum>0 then
        self:PayItem(id,buyNum)
    end
end


--账号保存
local keyUserInfo = "UserInfo"
local split = "@_5^;"

function PlayerData:writeUser(useName,password)
    if not self._usersDatas then
        self:getUsers()
    end
    local function saveUser(index,name,password)
        util.setKey(keyUserInfo..index,name..split..password)
    end

    local index = 2
    for i,j in pairs(self._usersDatas) do
        if j.name ~= useName and j.name and j.password then
            saveUser(index,j.name,j.password)
            index = index + 1
        end
    end

    index = 1
    saveUser(index,useName,password)
end

--
function PlayerData:getUsers()
    if self._usersDatas then
        return self._usersDatas
    end
    self._usersDatas = {}
    local index = 1
    while(true) do
        local key = keyUserInfo..index
        local info = util.getKey(key)
        index = index + 1
        if not info or info == "" then
            break
        else
            local name,pw = string.match(info,"(.*)"..split.."(.*)")
            if name and pw --[[and name ~= self:getdefUserName()]] then
                table.insert(self._usersDatas,{name = name,password = pw})
            end
        end
    end
    print("getUsers 这里是获取我本地有没有记录之前的用户名密码")
    if (self._usersDatas[1]) then
        for k,v in pairs(self._usersDatas[1]) do
            print(k,v)
        end
    end

    return self._usersDatas
end

--
local keyAutoLogin = "autoLogin"
function PlayerData:getAutoLogin()
    return util.getKey(keyAutoLogin)
end

function PlayerData:setAutoLogin(flag)
    return util.setKey(keyAutoLogin,flag)
end


function PlayerData:getPassWfromName(name)
    if self._usersDatas then
        for i,j in pairs(self._usersDatas) do
            if j.name == name then
                return j.password
            end
        end
    end

    return util.md5(self:getUserName())--self:getdefPassWord()
end

function PlayerData:getMailData()
    return self._mailData
end

function PlayerData:setMailData(data)
    self._mailData = data
    GameEvent:notifyView(GameEvent.updateMail)
end

function PlayerData:getMailNum()
    return table.nums(self._mailData)
end

function PlayerData:getReadMailData()
    if not self._mailReadData then
        self._mailReadData = {}
    end
    return self._mailReadData
end

function PlayerData:setIsSendQuqReadMail( bSend )
    self._bSendQuqReadMail = bSend
end

function PlayerData:getIsSendQuqReadMail( )
    return self._bSendQuqReadMail
end

function PlayerData:setReadMailData(data)
    self._mailReadData = data
end

function PlayerData:inerstReadMailData(data)
    if not self._mailReadData then
        self._mailReadData = {}
    end
    table.insert(self._mailReadData,data)
    table.sort(self._mailReadData,function(a,b) return a.tmMailTime>b.tmMailTime end)
end

function PlayerData:getReadMailNum()
    if not self._mailReadData then
       return 0
    end
    return table.nums(self._mailReadData)
end


function PlayerData:delMail(id)
    for i,j in pairs(self._mailData) do
        if j.uMsgID == id then
            self:inerstReadMailData(j)
            table.remove(self._mailData,i)
            GameEvent:notifyView(GameEvent.updateMail)
            return
        end
    end
end

--绑定手机CD时间,(time 下次可用时间)
function PlayerData:setMobieBingCdTime(time)
    self._MobieBingCdTime  = self:getServerTime() + time
end

function PlayerData:getMobieBingCdTime()
    return self._MobieBingCdTime and self._MobieBingCdTime - self:getServerTime()
end

--是否创建过好友房
function PlayerData:setCreateFriRoom( tbl )
    self._bCreateFriRoom = tbl
    GameEvent:notifyView(GameEvent.updatefriRoominfo)
end

function PlayerData:getCreateFriRoom( ... )
    return self._bCreateFriRoom
end
function PlayerData:setIsFirstCreateOrJiaru( bFind )
    self._bIsFirstCreateOrJiaru = bFind
end

function PlayerData:getIsFirstCreateOrJiaru( ... )
    return self._bIsFirstCreateOrJiaru
end


--
function PlayerData:isWXAcccount()
    return self._isWXAcccount
end

function PlayerData:setIsWXAcccount(flag)
    self._isWXAcccount = flag
end


function PlayerData:setWXHeadIcon(url)
    self._wxHeadUrl = url
end

function PlayerData:getWXHeadIcon()
    --trace(self._wxHeadUrl )
    --lw trace(debug.traceback())
    return self._wxHeadUrl or ""
    --return "http://wx.qlogo.cn/mmopen/PiajxSqBRaEL6MU3oKibNM2rpFFw56ldGuF3lFNlYFkwQ1ibqclXDzXT8DuN8JEdzjHYzODD6x0Fvsnc0LXyF6Qmg/0"
    --return "http://520." .. util.curDomainName() .. "/file/tx/131321304056801716.jpg"
end

--[[微信账号,把头像保存到本地
function PlayerData:saveWXHeadIcon()
    local url = self:getWXHeadIcon()
    local id = self:getUserID()
    if id and url~="" then
        util.setKey("wxHeadUrl"..id,url)
    end
end


--读取保存的微信头像
function PlayerData:readWXHeadIcon()
    if self:getWXHeadIcon() ~="" then
        return
    end
    local id = self:getUserID()
    if id then
        local url = util.getKey("wxHeadUrl"..id)
        self:setWXHeadIcon(url)
    end
end]]

--设置本地图片为头像
function PlayerData:setTemHeadIcon(path)
    self._temHeadIcon = path
    self:setWXHeadIcon()
    GameEvent:notifyView(GameEvent.updatePlayer)
end

--设置头像
--url:头像链接地址,url为空时,为默认自己的头像,spaceIndex为头像形状key,详见R.imgHeadSpace
function PlayerData:setPlayerHeadIcon(node,url,spaceIndex,bLogoID)
    local bIsWx = false
    url = url or self:getWXHeadIcon()
    if tolua.isnull(node) then
        return url and url ~= ""
    end
    local shape = node._shape
    if tolua.isnull(shape) then
        local parent = node:getParent()
        shape = parent:getChildByName("sp_shape")
    end
    if url and url ~= "" and not tolua.isnull(node) then
        --util.setWebImg(node,url)
        util.loadWebImg(url,false,function(suc,path) 
            if suc then
                util.loadImage(node,path) 
                R:showSpace(node,spaceIndex)
            else
                if not tolua.isnull(shape) then
                    shape:setVisible(false)
                end
                if bLogoID and bLogoID >= 0 and bLogoID <= 7 then
                    R:setPlayerIcon(node,bLogoID)
                else
                    R:setPlayerIcon(node,self:bLogoID())
                end
                --R:setPlayerIcon(node,self:bLogoID())
                trace("头像下载失败:",url)
            end 
        end)
        
        bIsWx = string.find(url,"http://wx.qlogo.cn")
    elseif self._temHeadIcon then
        util.setImg(node,self._temHeadIcon) 
        R:showSpace(node,spaceIndex)
    else
        if not tolua.isnull(shape) then
            shape:setVisible(false)
        end
        R:setPlayerIcon(node,self:bLogoID())
    end

    return bIsWx
end
--显示vip头像框
function PlayerData:setPlayerHeadVip(node,vipLevel,nameNode,clolor)
    if tolua.isnull(node) then
        return
    end
    if not vipLevel or vipLevel <= 0 or vipLevel > 10 then
        node:setVisible(false)
        if not tolua.isnull(nameNode) then
            nameNode:setColor(clolor)
        end
    else
        node:setVisible(true)
        util.setImg(node,"img2/shop/vip/LV" .. vipLevel .. ".png") 
        if not tolua.isnull(nameNode) then
            nameNode:setColor(cc.c3b(251, 40, 29))
        end
    end
    return
end

function PlayerData:getGameMsgInfo( ... )
    if not self._showGameMsginfo then
        return {}
    end
    return self._showGameMsginfo
end
function PlayerData:setGameMsg( res )
    if not self._showGameMsginfo then
        self._showGameMsginfo = {}
    end
    if table.nums(self._showGameMsginfo) >= 20 then
        table.remove(self._showGameMsginfo,1)
    end
    table.insert(self._showGameMsginfo,res)
    GameEvent:notifyView(GameEvent.updateChatInfo)
end

--显示游戏通知消息,text 消息内容,refersh是否刷新,immediately为立即显示一出来就显示全部文字
function PlayerData:showGameMsg(res,refresh,immediately)
    GameEvent:notifyView(GameEvent.showgameMsg,{text = res.str,refresh = refresh,immediately =immediately,level = 2,iMaqType=res.bMaqType})
end

--显示红包信息,level为优先级
function PlayerData:showRedMsg(text,refresh,immediately)
    GameEvent:notifyView(GameEvent.showgameMsg,{text = text,refresh = refresh,immediately =immediately,level = 1})
end

function PlayerData:hideGameMsg(text)
    GameEvent:notifyView(GameEvent.showgameMsg,{text = text,hide = true})
end


--任务系统
function PlayerData:getTaskData()
    return self._taskData
end

function PlayerData:setTaskData(data)
    self._taskData = data
    self._finshgame = 0
    if self._taskData then
        for k,v in pairs(self._taskData.TaskInfo) do
            if v.iTaskID == 405 then
                self._finshgame = v.cbTaskFinishValue
            elseif v.iTaskID == 502 then
               self._finshbull = v.cbTaskFinishValue
            elseif v.iTaskID == 506 then
                self._finshBairen = v.cbTaskFinishValue
            end
        end
    end
    --GameEvent:notifyView(GameEvent.updateMail)
end

function PlayerData:setIsFirstWin( bWin )
    self:ModifyTaskData(301,1)
end

function PlayerData:setCurFinshGame( cbTaskFinishValue )
    if cbTaskFinishValue then
        if not self._finshgame then
            self._finshgame = 0
        end
        self._finshgame = self._finshgame + cbTaskFinishValue
        if self._finshgame == 5 then
            self:ModifyTaskData(401,1)
        --elseif self._finshgame == 10 then
            --self:ModifyTaskData(402,1)
        --elseif self._finshgame == 20 then
            --self:ModifyTaskData(403,1)
        elseif self._finshgame == 50 then
            self:ModifyTaskData(404,1)
        elseif self._finshgame == 100 then
            self:ModifyTaskData(405,1)
        else
            self:ModifyTaskData(405,0)
        end
    end
end
function PlayerData:setCurFinshBullBull( cbTaskFinishValue )
    if cbTaskFinishValue then
        if not self._finshbull then
            self._finshbull = 0
        end
        self._finshbull = self._finshbull + cbTaskFinishValue
        if self._finshbull >= 5000000 then
            self:ModifyTaskData(502,1)
        end
        if self._finshbull >= 1000000 then
            self:ModifyTaskData(501,1)
        end
    end
end
function PlayerData:getCurFinshBullBull( ... )
    return self._finshbull
end

function PlayerData:setCurFinshBairen( cbTaskFinishValue )
    if cbTaskFinishValue then
        if not self._finshBairen then
            self._finshBairen = 0
        end
        self._finshBairen = self._finshBairen + cbTaskFinishValue
        if self._finshBairen >= 500000 then
            self:ModifyTaskData(503,1)
        end
        if self._finshBairen >= 5000000 then
            self:ModifyTaskData(504,1)
        end
        if self._finshBairen >= 50000000 then
            self:ModifyTaskData(505,1)
        end
        if self._finshBairen >= 100000000 then
            self:ModifyTaskData(506,1)
        end
    end
end

function PlayerData:getCurFinshBairen( ... )
    return self._finshBairen
end


function PlayerData:getCurFinshGame( ... )
    return self._finshgame
end

function PlayerData:setFishBairenCount(iBetGold)
    --未达到复活时间
    -- if self:getForTurnTime() - (self:getServerTime() - self._playerAdd.tmResurrectionTM) > 0 then
    --     return
    -- end
    -- local info = TemplateData:getResureTypeByType(self._playerAdd.bUserBrnnResureType)
    -- if self._player.iResurrection < info.iFinshCount and iBetGold >= info.iBetGold then
    --     self._player.iResurrection = self._player.iResurrection + 1
    -- end
end

function PlayerData:getTaskIDInfo( iTaskID )
    if self._taskData then
        for k,v in pairs(self._taskData.TaskInfo) do
            if v.iTaskID == iTaskID then
                return v.cbTaskFinishValue
            end
        end
    end
    return 0
end

function PlayerData:ModifyTaskData( iTaskID, iTaskValue,butongzhi)
    if self._taskData then
        for k,v in pairs(self._taskData.TaskInfo) do
            if v.iTaskID == iTaskID and v.cbTaskValue < iTaskValue then
                v.cbTaskValue = iTaskValue
                v.cbTaskFinishValue = v.cbTaskFinishValue + 1
                if butongzhi then
                else
                    GameEvent:notifyView(GameEvent.updateTaskInfo,v.iTaskID)
                end
                break
            elseif v.cbTaskValue == iTaskValue and v.iTaskID == iTaskID  then
                GameEvent:notifyView(GameEvent.updateTaskInfo,v.iTaskID)
                break
            elseif iTaskID == v.iTaskID  then
                break
            end
        end
    end
end

function PlayerData:ModifyTaskDataValue( iTaskID, cbTaskFinishValue)
    if self._taskData then
        for k,v in pairs(self._taskData.TaskInfo) do
            if v.iTaskID == iTaskID  then
                v.cbTaskFinishValue = cbTaskFinishValue
                GameEvent:notifyView(GameEvent.updateTaskInfo,v.iTaskID)
                break
            end
        end
    end
end

function PlayerData:isLocalVer()
    local info = require("version")
    return info.bLocal
end

function PlayerData:setReLoginByID( res )
    self._reLoginByID = res
end

function PlayerData:getReLoginByID( )
    return self._reLoginByID
end

function PlayerData:setIsxianShiMsg( bMsg )
    self._bMsg = bMsg
    GameEvent:notifyView(GameEvent.bshowMsgInfo)
end

function PlayerData:getShowMsg( )
    return self._bMsg
end

--设置快速开始的下标
function PlayerData:setQuickStartIndex( index )
   self._iQuickStartIndex = index
   if self._iQuickStartIndex and self._iQuickStartIndex ~= nil then
       GameEvent:notifyView(GameEvent.startGame)
   end
end

function PlayerData:getQuickStartIndex( ... )
    return self._iQuickStartIndex
end

--红包广场
function PlayerData:setIsSendSquareRedReq( bSend )
    self._bSendSquareRedReq = bSend
end
function PlayerData:getIsSendSquareRedReq()
    return self._bSendSquareRedReq
end
function PlayerData:setTblSquareRed( tbl )
    if not tbl then
        self._tblSquareRed = {}
        return
    end
    self._tblSquareRed = tbl
end
function PlayerData:getTblSquareRed()
    if not self._tblSquareRed then
        self._tblSquareRed = {}
    end
    return self._tblSquareRed
end
function PlayerData:getItemSquareRed(iID)
    for i,j in pairs(self._tblSquareRed)do
        if j.iID == iID then
            return j
        end
    end
    return nil
end
function PlayerData:delItemSquareRed(iID)
    if self._bSendSquareRedReq and self._tblSquareRed then
        for i,j in pairs(self._tblSquareRed)do
            if j.iID == iID then
                table.remove(self._tblSquareRed,i)
                GameEvent:notifyView(GameEvent.updateRedSquare)
                return
            end
        end
    end
end
function PlayerData:checkMyRedCount()
    if self._bSendSquareRedReq and self._tblSquareRed then
        local nCount = 0
        for i,j in pairs(self._tblSquareRed)do
            if j.iUserID == self:getUserID() then
                nCount = nCount + 1
            end
        end
        return nCount
    end
    return 0
end
--我的广场红包信息
function PlayerData:setIsSendMySquareRedReq( bSend )
    self._bSendMyRedReq = bSend
end
function PlayerData:getIsSendMySquareRedReq()
    return self._bSendMyRedReq
end
function PlayerData:setMyTblRedSquare( tbl )
    if not tbl then
        self._myTblRedSquare = {}
        return
    end
    self._myTblRedSquare = tbl
end
function PlayerData:ModifyStateMyRed( res )
    if not self._myTblRedSquare then
        self._myTblRedSquare = {}
    end
    if res.iType == enRED_TYPE.RED_TYPE_SEND or res.iType == enRED_TYPE.RED_TYPE_WAIT_OTHER then
        table.insert(self._myTblRedSquare,res)
        table.sort(self._myTblRedSquare,function(a,b) return a.tCreateTime>b.tCreateTime end)
        GameEvent:notifyView(GameEvent.updateMyRedSquare)
        return
    end
    for i,v in ipairs(self._myTblRedSquare) do
        if v.iID == res.iID and v.iType ~= res.iType then
            if string.len(res.nickName) > 0 then
                v.nickName = res.nickName
            end
            v.iType = res.iType
            v.tCreateTime = self:getServerTime()
            table.sort(self._myTblRedSquare,function(a,b) return a.tCreateTime>b.tCreateTime end)
            GameEvent:notifyView(GameEvent.updateMyRedSquare)
            break
        end
    end
end
function PlayerData:getMyRedByType( iType )
    if not self._myTblRedSquare then
        return false
    end
    for i,v in ipairs(self._myTblRedSquare) do
        if v.iType == iType then
            return true
        end
    end
    return false
end
function PlayerData:getMyRedById( iRedID )
    if not self._myTblRedSquare then
        return {}
    end
    for i,v in ipairs(self._myTblRedSquare) do
        if v.iID == iRedID then
            return v
        end
    end
    return {}
end

function PlayerData:getMyTblRedSquare()
    if not self._myTblRedSquare then
        return {}
    end
    return self._myTblRedSquare
end
--判断我的广场红包是否有可操作的红包
function PlayerData:getMyTblRedIsOperable()
    if not self._myTblRedSquare then
        return false
    end
    for k,v in pairs(self._myTblRedSquare) do
        if v.iType == 4 then
            return true
        end
    end
    return false
end
function PlayerData:setIsNewMyRedRecore( bNew )
    self._bNewMyRedRecore = bNew
end
function PlayerData:getIsNewMyRedRecore()
    return self._bNewMyRedRecore
end
--系统广播发送剩余时间
function PlayerData:setSendLastMagTime( iTime )
    self._lastSendMagTime = iTime
end

function PlayerData:getSendLastMagTime( ... )
    return self._lastSendMagTime
end

--设置弹窗体过程
function PlayerData:setPopSequence( str, data, index)
    if not self._popSeq then
        self._popSeq = {}
    end
    local tbl = {}
    tbl.str = str
    if data then
        tbl.data = data
    end
    -- local bFind = false
    if index then
        table.insert(self._popSeq,index,tbl)
    else
        table.insert(self._popSeq,tbl)
    end
    -- for k,v in pairs(self._popSeq) do
    --     if str == v.str then
    --         v.data = data
    --         bFind = true
    --         break
    --     end
    -- end
    -- if not bFind then
    --     if index then
    --         table.insert(self._popSeq,index,tbl)
    --     else
    --         table.insert(self._popSeq,tbl)
    --     end
    -- end
end

function PlayerData:getPopSequence()
    if not self._popSeq then
        return {}
    end
    return self._popSeq
end

function PlayerData:removePopSequence( str, bNoContinue)
    if not self._popSeq and table.nums(self._popSeq) <= 0 then
        return
    end
    local num = table.nums(self._popSeq)
    if self._popSeq then
        for k,v in pairs(self._popSeq) do
            if v.str == str then
                table.remove(self._popSeq,k)
                if table.nums(self._popSeq) == num and num == 1 then
                    self._popSeq = {}
                end
                break
            end
        end
    end
    if table.nums(self._popSeq) > 0 and not bNoContinue then
        for k,v in pairs(self._popSeq) do
            _uim:showLayer(v.str,v.data)
            break
        end
    elseif not bNoContinue then
        self._popSeq = {}
        if self:getGold() < 1000 and self:getTaskIDInfo(101) < TemplateData:getPalyerTaskCount(101) and self:getIsGame() == false then
			GameSocket:sendMsg(MDM_GP_TASK,ASS_GP_TASK_RECEIVE_REWARD,{iTaskID=101,iSign=1})
		end
         self._bSendMsgPochang = true
    end
end

function PlayerData:getSendMsgPochang( ... )
    return self._bSendMsgPochang
end

function PlayerData:setChargeAmount( iMoney ,isAdd)
    local iCurMoney = iMoney
    iMoney = isAdd and self._player.iRechangeCount + iMoney or iMoney
    self._player.iRechangeCount = iMoney
    local viplevel =  TemplateData:getVipLevel(self._player.iRechangeCount)
    if self._player.bVipLevel ~= viplevel then
        self._player.bVipLevel = viplevel
    end
    if iCurMoney > 0 then
        if iCurMoney >= 6 then
            PlayerTaskData:setCompleteCount({iGameType=0,taskType=7})
            --刷新幸运玩家邮件
            if self:getActivityInfoByID(105) then
                util.delayCall(self,function()
                    GameEvent:notifyView(GameEvent.bNewMail)
                end,2)
                self:ModifyActivityInfo(105,false)
            end
        end
        --金牛
        self:sendWebForTune()
        GameEvent:notifyView(GameEvent.upGradeVip,iMoney)
    end
end

function PlayerData:setCurSelectChouMa( iSelect )
    self._BRSelectChouMa = iSelect
end

function PlayerData:getCurSelectChouMa( ... )
    if self._BRSelectChouMa then
        return self._BRSelectChouMa
    end
    return 0
end

--存储百人牛牛玩家列表
function PlayerData:setStoragePlayerList(tbl)
    self._playerList = tbl
end

function PlayerData:getStoragePlayerList(...)
    return self._playerList
end

--存储玩家排行帮助信息
function PlayerData:setBairenRankHelp(str)
    self._BairenRabkHelp =  str
end

function PlayerData:getBairenRankHelp()
    return self._BairenRabkHelp
end

--是否是游戏中退出来
function PlayerData:setNoMenPiaoGame( bGame )
    self._noMenPiaoGame = bGame
end

function PlayerData:getNoMenPiaoGame( ... )
    return self._noMenPiaoGamesss
end

--是否是点击退出游戏
function PlayerData:setExitHall( bExit )
    self._bExitHall = bExit
end
function PlayerData:getExitHall( )
    return self._bExitHall
end
--是否是点击切换账号
function PlayerData:setChangeAccount( bChange )
    self._bChangeAccount = bChange
end
function PlayerData:getChangeAccount( )
    return self._bChangeAccount
end

--存储转盘记录
function PlayerData:setLuckyRecord( bTab )
    self._luckyRecord = bTab
end

function PlayerData:getLuckyRecord( ... )
    return self._luckyRecord
end

function PlayerData:setLimitActivity(bDue)
    GameEvent:notifyView(GameEvent.updateLimitActivity,bDue)
end

function PlayerData:setActiveList( bTab )
    self._activeList = bTab
    if not self._activeList then
        return
    end
    local bFind = false
    local info = {}
    for k,v in pairs(self._activeList) do
        if v.iID == 1 then
            bFind = true
            info = v
            local preTime = util.getKey("limitActivity")
            if not util.checkSameDay(preTime,util.time()) then
                self:setPopSequence(ui.goldDraw)
                util.setKey("limitActivity",util.time())
            end
        elseif v.iID == 3 then
            self._ResurrectionType = 2
        end
    end
    if not bFind then
        self:setLimitActivity(false)
    elseif info.tEndTime <= self:getServerTime() then
        self:setLimitActivity(false)
    else
        self:setLimitActivity(true)
    end
end

function PlayerData:getAcitiveListInfoById( id )
    if not self._activeList then
       return {}
    end
    for k,v in pairs(self._activeList) do
        if v.iID == id then
            return v
        end
    end
    return {}
end

function PlayerData:getResurrectionType()
    return self._ResurrectionType
end

function PlayerData:setOpenbCertifiyIdentity( bOpen )
    self._bCertifiyIdentity = bOpen
end

function PlayerData:getOpenbCertifiyIdentity()
    return self._bCertifiyIdentity
end

--存储活动信息
function PlayerData:setStorageActivityInfo( res )
    self._storActivityInfo = {}
    for k,v in pairs(res.data) do
        v.btime = tonumber(v.btime)
        v.etime = tonumber(v.etime)
        v.bShow = true
        
        if v.ID == 108 then
            self:setOpenbCertifiyIdentity(true)
        else
            if v.cur == 1 then
                self:setPopSequence(ui.activityMain,{type=1,btnSelect=v.ID})
            end
            table.insert(self._storActivityInfo, v)
        end
        
    end
    table.sort(self._storActivityInfo,function(a,b)  return tonumber(a.esc) > tonumber(b.esc) end)
    traceObj(self._storActivityInfo)
    if self:getBindingTelNum() == "" then
        self:setPopSequence(ui.BindPhoneTip)
    end
end

function PlayerData:getActivityInfoByID( activeID )
   if self._storActivityInfo then
       for i,v in ipairs(self._storActivityInfo) do
           if v.ID == activeID and v.bShow then
               return true
           end
       end
   end
   return false
end

function PlayerData:ModifyActivityInfo( activeID,bShow )
    if self._storActivityInfo then
        for k,v in pairs(self._storActivityInfo) do
            if v.ID == activeID then
                v.bShow = bShow
                if activeID == 105 then
                    GameEvent:notifyView(GameEvent.updateLunckyUser)
                end
                break
            end
        end
    end
end

function PlayerData:getStorageActivityInfo( ... )
    return self._storActivityInfo or {}
end

--存储公告内容
function PlayerData:setStorageNoticeInfo( res )
    self._storNoticeInfo = {}
    for k,v in pairs(res.data) do
        v.Pdate = tonumber(v.Pdate)
        v.Content = tostring(v.Content)
        v.bShow = false
        if self:getServerTime() >= v.Pdate then
            v.bShow = true
        end
        if v.Cur == 1 and v.bShow then
            local info = util.getKey("NoticeInfo_" .. v.ID)
            if not info or info == "" or tonumber(info) < v.Pdate then
                self:setPopSequence(ui.activityMain,{type=2,btnSelect=k})
                util.setKey("NoticeInfo_" .. v.ID, self:getServerTime())
            end
        end
        table.insert(self._storNoticeInfo, v)
    end
    table.sort(self._storNoticeInfo,function(a,b)  return tonumber(a.Sort) > tonumber(b.Sort) end)
end

function PlayerData:getStorageNoticeInfo( ... )
    return self._storNoticeInfo or {}
end

function PlayerData:sendWebForTune( ... )
    local _host = "http://wx." .. util.curDomainName() .. "/Handler/Common.ashx"
    local str = self:getUserID() .. "886727f2c39a11d08c5a"
    local args = {
        action = "luckcowcx",
        userid = self:getUserID(),
        sign = util.md5(str)
    }
    util.postJson(_host,args,function(suc, res)
        if suc and res and res.code and res.code == 1000 then
            self:setFortuneData(res.data)
        end
    end)
end

function PlayerData:getForTurnTime( ... )
    return 20*3600
end

--存储招财进宝数据
function PlayerData:setFortuneData( data )
    util.removeAllSchedulerFuns(self)
    self._fortuneData = {}
    for k,v in pairs(data) do
        v.LastDate = tonumber(v.LastDate)
        self._fortuneData = v
    end
    if self._fortuneData.CowLevel > 0 and self._fortuneData.State == 0 then --可招财可领取
        GameEvent:notifyView(GameEvent.updateFortuneAni, true)
    elseif self._fortuneData.CowLevel > 0 and self._fortuneData.State == 1 then --可招财已领取
        GameEvent:notifyView(GameEvent.updateFortuneAni, false)
        local shengyuTime = self:getForTurnTime() - (self:getServerTime() - self._fortuneData.LastDate)
        util.delayCall(self,function()
            self._fortuneData.State = 0
            GameEvent:notifyView(GameEvent.updateFortuneAni, true)
        end,shengyuTime)
    else
        GameEvent:notifyView(GameEvent.updateFortuneAni, false)
    end
end

function PlayerData:getFortuneData( ... )
    return self._fortuneData or {}
end

function PlayerData:sendToServerUserReflash( ... )
    if self:getIsGame() then
        RoomSocket:sendMsg(MDM_GP_USERREFLASH,ASS_GP_USERREFLASH)
    end
end

-- function PlayerData:setLotteryNum( iCountLottery )
--     self._lotteryNum = iCountLottery
-- end

-- function PlayerData:getLotteryNum( ... )
--     return self._lotteryNum
-- end

-- function PlayerData:addLotteryNum( iMoney )
--     if not self._lotteryNum then
--         return
--     end
--     if self._storActivityInfo then
--         for k,v in pairs(self._storActivityInfo) do
--             if v and v.ID and v.ID == 104 and v.etime and self:getServerTime() > v.etime then
--                 return
--             end
--         end
--     end
    
--     if iMoney == 12 then
--         self._lotteryNum = self._lotteryNum + 1
--     elseif iMoney == 68 then
--         self._lotteryNum = self._lotteryNum + 6
--     elseif iMoney == 128 then
--         self._lotteryNum = self._lotteryNum + 12
--     elseif iMoney == 298 then
--         self._lotteryNum = self._lotteryNum + 30
--     elseif iMoney == 998 then
--         self._lotteryNum = self._lotteryNum + 100
--     end
-- end

--分享物品获得
function PlayerData:addShareReward(ids)
    for index,id in pairs(ids) do
        local type = TemplateData:getRewardType(id)
        local num = TemplateData:getRewardNum(id)
        if type == 5 then
            local gooldID = TemplateData:getRewardGoodsID(id)
            self:changeItemNum(gooldID,num)
        elseif type == 6 then
            self:setGameCoin(num,true)
        elseif type == 7 then
            self:setRedMoney(num*10,true)
        end
    end
end



return PlayerData