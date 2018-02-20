local sdkManager = class("sdkManager")

FIRST_CHARGE_ID = 3007
FIRST_CHARGE_PRICE = 6

--sdk类型
SDK_LOGIN_TYPE_WX = 1	--原始包,只有默认的微信和支付宝SDK(包括蛋蛋赚这种不接SDK的渠道包)
SDK_LOGIN_TYPE_QUICKSDK = 2 --quickSdk

CHANNEL_PPY = 269

local def_channel = CHANNEL_PPY
local def_SDK = SDK_LOGIN_TYPE_WX

local _channel_type
local _sdk_type
local localpayFilePath = File.root.."localpay.lua"
--账号渠道,默认为0,
local _quickRegWay = {
    [CHANNEL_PPY] = 150,--啪啪游
    [265] = 151,--乐飞
    [69] = 152,--咪咕
    [229] = 153,--天天游戏中心
    [12] = 154,--360
    [4] = 155,--当乐
    --[14] = 156,--百度
    [15] = 157,--小米
    [17] = 158,--vivo
    [24] = 159,--华为
    [9] = 160,--uc
    [23] = 161,--oppo
    [26] = 162,--金立
    [29] = 163,--联想
    [70] = 164,--魅族
    --[32] = 165,--应用宝
}
--key为getVersionCode,value为regWay
local thridRegWay = {
    [-2] = 0,--官网
    [-1] = 0,--官网测试包
    [11] = 20, --酷划2
    [14] = 13,--聚印像
}
-- require("Common.sdkManager").create() 就会来调用这里的ctor
function sdkManager:ctor()
	print("sdkManager ctor")
    -- self.payItems = {}
    -- self:checkRegWay()
    -- self:getIssue()--大于255的期号,把期号存在PlayerData:setAreaID(id)里面
    -- self:initLogToServer()
    -- self:reloadData()
end

function sdkManager:reloadData()
    self._shareUrl = nil
    self._QRUrl = nil
    self._QRimgPath = nil
    self._isJumping = nil--正在跳转
end

function sdkManager:isThirdChannel()--第三方,(把手机登录改为账号登录)
    return self:isQuickPackage() or self:isBaidu() or self:isManwei()
end

function sdkManager:isAndroidOffic()--官方安卓包(pc版)
    if  __Platform__ == 3 then
        return Platefrom:getLocalIpAddress() == "0.0.0.0" or Platefrom:getVersionCode() == -2 or self:isDebugPackage()
    end
    return __Platform__ == 0 --(pc版)
end

--安卓试玩站,包是用官方一样的,只有VerstionCode不一样
function sdkManager:isAndroidTry()
    return self:isKPZS() or self:isBengbeng() or self:isXianwan() or self:isDandanzPackage() or self:isKuhua()
end

--表示测试包
function sdkManager:isDebugPackage()
    return Platefrom:getVersionCode() == -1
end

--表示试玩站
function sdkManager:isTryPackage()
    return Platefrom:getVersionCode() == 1
end

function sdkManager:isDandanzPackage()--蛋蛋赚
    --只有这个包才有getIMEI 和getSIMID 这两个接口
    return Platefrom:getLocalIpAddress() == "0.0.0.2" or Platefrom:getVersionCode() == 3
end

function sdkManager:isQuickPackage()--Quick
    --只有这个包才有getSDKType getChannelType 这两个接口
    return Platefrom:getLocalIpAddress() == "0.0.0.1" or Platefrom:getVersionCode() == 2
end

--靠谱助手,除了VersionCode以外,其他跟官方一样
function sdkManager:isKPZS()
    return Platefrom:getVersionCode() == 4
end

--百度平台只有支付,没有登录,需要隐藏微信登录
function sdkManager:isBaidu()
    return Platefrom:getVersionCode() == 5
end

--应用宝,隐藏支付宝
function sdkManager:isYSDK()
    return Platefrom:getVersionCode() == 6
end

--蹦蹦网
function sdkManager:isBengbeng()
    return Platefrom:getVersionCode() == 7
end

--闲玩
function sdkManager:isXianwan()
    return Platefrom:getVersionCode() == 8
end


--ios官方
function sdkManager:is_IOS_offic()
    return Platefrom:getVersionCode() == 0
end
function sdkManager:isNewCocosVersion()
    if self:is_IOS() or __Platform__ == 0 then
        return true;
    else
        if Platefrom:getVersionName() >= 1.124 then
            return true;
        end
    end

    return false
end
function sdkManager:is_IOS()
    return __Platform__ == 4 or __Platform__ == 5
end

--漫维
function sdkManager:isManwei()
    return Platefrom:getVersionCode() == 9
end

function sdkManager:isKuhua()
    return Platefrom:getVersionCode() == 11
end

function sdkManager:isHuawei()
    return Platefrom:getVersionCode() == 15
end


--配置目录(显示隐藏及整包更新的目录)
function sdkManager:getConfingPath()
    if self:isQuickPackage() then
        return self:getChannelType()
    elseif self:is_IOS() then
        local path = Platefrom:getVersionCode()+1000
        --local ver = Platefrom:getIOSVersionCode()
        --if ver then
        --    path = path.."/"..ver
        --end
        return path
    else
        return Platefrom:getVersionCode()+1000
    end
end

function sdkManager:getSDKType()
	if _sdk_type then
		return _sdk_type
	end
    if self:isAndroidOffic() then
        _sdk_type = SDK_LOGIN_TYPE_WX
        return _sdk_type
    end
	if  __Platform__ == 3 and self:isQuickPackage() then
        local args = {}
        local sigs = "()I"
        local funName = "getSDKType"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            _sdk_type = ret
            return _sdk_type
        end
    else
    end

    _sdk_type = def_SDK
    return _sdk_type
end

--有可能保存不成功,需要再次保存
function sdkManager:saveBindDatas()
	local keys = {
		"utype",
		"pcid",
		"issue",
	}
	local hasSaved = util.getKey(keys[1]) and util.getKey(keys[1])~="" and util.getKey(keys[1])~="0"
    if hasSaved then
        trace("saveBindDatas hasSave")
		return
	end
	for index,key in pairs(keys) do
		local value = Platefrom:getBindData(key)
        trace("saveBindDatas setKey",key,value)
		util.setKey(key,value)
	end
end

--从配置中优化获取,取不到再去原生中获取
function sdkManager:getBindData(param)
    local value = util.getKey(param)
    if value~="" and value~="0" then
        trace("getBinddataFromdata",param,value)
        return value
    end
    local data =  Platefrom:getBindData(param)
    util.setKey(param,data)
    return data
end

--渠道类型,与安卓上getChannelType标的一致
function sdkManager:getChannelType()
    if _channel_type then
        return _channel_type
    end
    if  __Platform__ == 3 then
        local args = {}
        local sigs = "()I"
        local funName = "getChannelType"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            _channel_type = ret
            return _channel_type
        end
    else
    end
  
    _channel_type = def_channel
    return _channel_type
end

function sdkManager:getRegWay()

    return self._regWay or 0
end

--期号,原始包是0,quick为1
function sdkManager:getIssue()
    local value = 1
    if self:isDandanzPackage() then
        value = 1002
    end
    if self:isAndroidOffic() then
        value = 0
    end
    if self:isBengbeng() then
        value = 14066
    end
    if self:isXianwan() then
        value = 1600
    end
    if value > 255 then
        --PlayerData:setAreaID(value)
        value = 255
    end

    return value
end

function sdkManager:exitGame()
    if self:isQuickPackage() and Platefrom:quickSDKhasExitFunc() then
        local args = {}
        local sigs = "()V"
        local funName = "quickExitGame"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return
        end
    elseif self:isBaidu() then
        local args = {}
        local sigs = "()V"
        local funName = "baiduExitGame"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    else
        if PlayerData:getBindingTelNum() == "" then
            PlayerData:setExitHall( true )
            _uim:showLayer(ui.BindPhoneTip)
        else
            Alert:showCheckBox([[您今日还有机会领取红包哦，
真的要离开吗？]],function() os.exit() end)
        end

    end    
end

-----------------------------
--private
-----------------------------

    
function sdkManager:checkRegWay()
    self._regWay = 0
    if self:isAndroidOffic() or self:is_IOS_offic() then
        self._regWay = 0
    elseif self:isQuickPackage() then
        local channel = self:getChannelType()
        self._regWay =  _quickRegWay[channel]
        trace("quickSDK",channel,self._regWay)
    else
        local key = tonumber(self:getBindData("utype")) or Platefrom:getVersionCode()
        self._regWay = thridRegWay[key] or key
    end
end
-------------------- wx
function sdkManager:LoginWX()
    --local strIssue = self:getBindData("issue")
    --local strPCID = self:getBindData("pcid")
    --trace("lw LoginWX " .. strIssue .. " " .. strPCID)

    Platefrom._VersionCode = nil
    self:checkRegWay()
    if  __Platform__ == 3 then
        local args = {handler(self,self.wx_loginResCallback)}
        local sigs = "(I)V"
        local funName = "loginWX"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    elseif self:is_IOS() then
        local suc,str = LuaObjcBridge.callStaticMethod("AppController", "sendAuthRequest",{callback = handler(self,self.wx_loginResCallback)})
        if not suc then
            trace("sdkManager:wx_loginResCallback fail res = ",str)
        end
    end
end

function sdkManager:wx_loginResCallback(res)
    PlayerData:setIsWXAcccount(true)

    res = string.gsub(res,"\\","")
    local output = json.decode(res)
    local nickName = output.nickname
    local szHeadWeb = output.headimgurl
    local uid = output.unionid
    traceObj(output,"微信返回~~~~~~~~~~~~~~~~~~~~~~~~~~")

    local name = "wx_"..uid
    PlayerData:setUserName(name)
    local passWord = PlayerData:getPassWfromName(name)
    PlayerData:setPassWord(passWord)

    local strIssue = self:getBindData("issue")
    local strPCID = self:getBindData("pcid")
    --Alert:showTip("wx_loginResCallback " .. self:getRegWay(),4) 
    local info = {
        szName = PlayerData:getUserName(),
        szMD5 = PlayerData:getRegisterMD5(),
        szMD5Pass = PlayerData:getPassWord(),
        szToken = PlayerData:getMAC(),
        iAreaID = PlayerData:getAreaID(),
        iWBFlag = PlayerData:getWBFlag(),
        szHeadWeb = szHeadWeb,
        nickName = nickName,
        bRegWay = self:getRegWay(),
        iIssue = strIssue == "" and 0 or tonumber(strIssue),
        iPCID = strPCID == "" and 0 or tonumber(strPCID),
    }

    --PlayerData:setWXHeadIcon(szHeadWeb)
    GameSocket:sendMsg(MDM_GP_LOGON,ASS_GP_LOGON_REG,info)
end

-------------------- quickSDK
function sdkManager:loginQuick()
    Platefrom._VersionCode = nil
    self:checkRegWay()
    trace(LuaJavaBridge)
    traceObj(LuaJavaBridge,"LuaJavaBridge")

    if  __Platform__ == 3 then
        local args = {handler(self,self.Quick_loginResCallback),handler(self,self.Quick_logoutResCallback)}
        local sigs = "(II)V"
        local funName = "loginQuick"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    else
        --local str = "{\"openid\":\"o78L5wCRGG5k-t9OWLa0vW6EQF8k\",\"nickname\":\"暗影飘零\",\"sex\":1,\"language\":\"zh_CN\",\"city\":\"Fuzhou\",\"province\":\"Fujian\",\"country\":\"CN\",\"headimgurl\":\"http://wx.qlogo.cn/mmopen/PiajxSqBRaEL6MU3oKibNM2rpFFw56ldGuF3lFNlYFkwQ1ibqclXDzXT8DuN8JEdzjHYzODD6x0Fvsnc0LXyF6Qmg/0\",\"privilege\":[],\"unionid\":\"oic0_wGwCrNQO5fv21lHWloAJYrs2\"}"
        --self:wx_loginResCallback(str)
    end
end

-------------------- manweiSDK
function sdkManager:loginManwei()
    trace(LuaJavaBridge)
    traceObj(LuaJavaBridge,"LuaJavaBridge")

    if  __Platform__ == 3 then
        local args = {handler(self,self.Manwei_loginResCallback),handler(self,self.Quick_logoutResCallback)}
        local sigs = "(II)V"
        local funName = "loginManwei"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)
        

        if state then
            return 
        end
    else
        --local str = "{\"openid\":\"o78L5wCRGG5k-t9OWLa0vW6EQF8k\",\"nickname\":\"暗影飘零\",\"sex\":1,\"language\":\"zh_CN\",\"city\":\"Fuzhou\",\"province\":\"Fujian\",\"country\":\"CN\",\"headimgurl\":\"http://wx.qlogo.cn/mmopen/PiajxSqBRaEL6MU3oKibNM2rpFFw56ldGuF3lFNlYFkwQ1ibqclXDzXT8DuN8JEdzjHYzODD6x0Fvsnc0LXyF6Qmg/0\",\"privilege\":[],\"unionid\":\"oic0_wGwCrNQO5fv21lHWloAJYrs2\"}"
        --self:wx_loginResCallback(str)
    end
end


function sdkManager:loginIOSManwei()
    if  __Platform__ == 4 or __Platform__ == 5 then
        local suc,str = LuaObjcBridge.callStaticMethod("AppController", "loginManwei",{callback = handler(self,self.Manwei_loginResCallback)})
        if not suc then
            trace("sdkManager:loginIOSManwei fail res = ",str)
        end
    else
    end   
end

function sdkManager:loginYSDK(_callback)
    trace(LuaJavaBridge)
    traceObj(LuaJavaBridge,"LuaJavaBridge")

    if  __Platform__ == 3 then
        local args = {_callback}
        local sigs = "(I)V"
        local funName = "loginYSDK"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    else
        --local str = "{\"openid\":\"o78L5wCRGG5k-t9OWLa0vW6EQF8k\",\"nickname\":\"暗影飘零\",\"sex\":1,\"language\":\"zh_CN\",\"city\":\"Fuzhou\",\"province\":\"Fujian\",\"country\":\"CN\",\"headimgurl\":\"http://wx.qlogo.cn/mmopen/PiajxSqBRaEL6MU3oKibNM2rpFFw56ldGuF3lFNlYFkwQ1ibqclXDzXT8DuN8JEdzjHYzODD6x0Fvsnc0LXyF6Qmg/0\",\"privilege\":[],\"unionid\":\"oic0_wGwCrNQO5fv21lHWloAJYrs2\"}"
        --self:wx_loginResCallback(str)
    end
end

function sdkManager:loginHuawei()
    trace(LuaJavaBridge)
    traceObj(LuaJavaBridge,"LuaJavaBridge")

    if  __Platform__ == 3 then
        local args = {handler(self,self.Huawei_loginResCallback)}
        local sigs = "(I)V"
        local funName = "loginHuawei"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if not suc then
            trace("sdkManager:loginHuawei fail res = ",str)
        end
    else
        --local str = "{\"openid\":\"o78L5wCRGG5k-t9OWLa0vW6EQF8k\",\"nickname\":\"暗影飘零\",\"sex\":1,\"language\":\"zh_CN\",\"city\":\"Fuzhou\",\"province\":\"Fujian\",\"country\":\"CN\",\"headimgurl\":\"http://wx.qlogo.cn/mmopen/PiajxSqBRaEL6MU3oKibNM2rpFFw56ldGuF3lFNlYFkwQ1ibqclXDzXT8DuN8JEdzjHYzODD6x0Fvsnc0LXyF6Qmg/0\",\"privilege\":[],\"unionid\":\"oic0_wGwCrNQO5fv21lHWloAJYrs2\"}"
        --self:wx_loginResCallback(str)
    end
end

function sdkManager:Quick_logoutResCallback()
    util.backToLogin()
end

local chackAccountUrl = "http://520."..util.curDomainName() .. "/Handler/Common.ashx"

function sdkManager:Quick_loginResCallback(res)
    res = string.gsub(res,"\\","")
    local output = json.decode(res)
    local nickName = output.nickname
    local uid = output.unionid
    local token = output.token

    local arg = {
        action = "trytoken",
        uid = uid,
        token = token,
    }
    util.postJson(chackAccountUrl,arg,function(suc,value)
        if suc and value and value.code == 1000 then
            if nickName == "" then
                nickName = util.getPhoneModel() or ""
            end
            
            local name = self:getChannelType().."_"..uid
            PlayerData:setUserName(name)
            local passWord = PlayerData:getPassWfromName(name)
            PlayerData:setPassWord(passWord)
            Platefrom._VersionCode = nil
            self._regWay = Platefrom:getVersionCode()
            local info = {
                szName = PlayerData:getUserName(),
                szMD5 = PlayerData:getRegisterMD5(),
                szMD5Pass = PlayerData:getPassWord(),
                szToken = PlayerData:getMAC(),
                iAreaID = PlayerData:getAreaID(),
                iWBFlag = PlayerData:getWBFlag(),
                nickName = nickName,
                bRegWay = self:getRegWay(),
                iIssue = self:getIssue(),
            }

            GameSocket:sendMsg(MDM_GP_LOGON,ASS_GP_LOGON_REG,info)
        else
            traceObj(value,"Quick_loginResCallback fail")
        end
    end)
end

function sdkManager:Manwei_loginResCallback(res)
    res = string.gsub(res,"\\","")
    local output = json.decode(res)
    local nickName = output.nickname
    local uid = output.unionid
    local token = output.token
    local imei = output.imei
    
    PlayerData:setUserName(self:getRegWay().."_"..uid)
    local name = self:getChannelType().."_"..uid
    local passWord = PlayerData:getPassWfromName(name)
    PlayerData:setPassWord(passWord)
    
    local arg = {
        action = "clientregsign",
        username = imei,
        userpwd = PlayerData:getPassWord(true),
        usertype = self:getRegWay(),
        issue = self:getIssue(),
        pcid = uid,
        token = token
    }

    local url = "http://verifywww." .. util.curDomainName() .. "/Handler/Common.ashx"
    if IP_SERVER == _GameServerIP then
        url = chackAccountUrl
    end
    
    
    util.postJson(url, arg, function(suc,value)
        if suc and value and value.code == 1000 then
            if nickName == "" then
                nickName = util.getPhoneModel() or ""
            end
            Platefrom._VersionCode = nil
            self._regWay = Platefrom:getVersionCode()
            local info = {
                szName = PlayerData:getUserName(),
                szMD5 = PlayerData:getRegisterMD5(),
                szMD5Pass = PlayerData:getPassWord(),
                szToken = PlayerData:getMAC(),
                iAreaID = PlayerData:getAreaID(),
                iWBFlag = PlayerData:getWBFlag(),
                nickName = nickName,
                bRegWay = self:getRegWay(),
                iIssue = self:getIssue(),
            }
         
            GameSocket:sendMsg(MDM_GP_LOGON,ASS_GP_LOGON_REG,info)
        else
            traceObj(value,"Manwei_loginResCallback fail")
        end
    end)
end

--调用支付
--id为商品ID
--type为购买获得类型,0为钻石,100为金币

function sdkManager:Pay(id,type)
    if self:is_IOS() then
        if not util.isExamine() then
            self:showCharge(id,type)
            return
        end
        self:iosPay(id,type)
    elseif self:getSDKType() == SDK_LOGIN_TYPE_QUICKSDK then
        self:QuickPay(id,type)
    elseif self:isBaidu() then
        self:baiduPay(id,type)
    elseif self:isYSDK() then
        local args = {}
        local sigs = "()V"

        local funName = "ysdkPay"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"

        trace("sdkManagerysdkPay= ", ysdkPay)
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)


        if state then
            return 
        end 
    else
        self:showCharge(id,type)
    end
end

--显示支付提示框
function sdkManager:showCharge(id,type)
    local info = {id=id,itype=type}
    _uim:showLayer(ui.charge,info)
end

--ios 支付开始
local iosVer = Platefrom:getIOSVersionCodeNum()
if iosVer<1.126 then
    function sdkManager:iosPay(id,type)
        if  __Platform__ == 4 or __Platform__ == 5 then
            local total = TemplateData:getGoodsPrice(id)

            local strIOSID = ""
            -- if id == FIRST_CHARGE_ID and type == 100 then
                -- total = FIRST_CHARGE_PRICE
                -- strIOSID = string.format("com.36y.farmerddz.%d",total)
            -- else
                strIOSID = string.format("com.36y.farmerddz.%s%d",type == 100 and "gold." or "",total)
            -- end

            local userid = tostring(PlayerData:getUserID())
            if PlayerData:getUserID() == 100217418 then
                Alert:showTip("正在准备提交订单。。。" .. strIOSID,5)
            else
                Alert:showTip("正在准备提交订单。。。",5)
            end

            --_uim:showLayer(ui.paytip)
            local arg = {productId=strIOSID,money=total,userid = userid,paytype=type, callback = handler(self,self.iosPayCallback)}
            local suc,str = LuaObjcBridge.callStaticMethod("AppController", "Charge",arg)
            if not suc then
                trace("sdkManager:Pay fail res = ",str)
            end
        end    
    end
    --ios 支付恢复游戏中的订单
    function sdkManager:iosPayResume(Dict,pid)
        trace("lw 恢复游戏中的订单 " .. Dict.sign)
        local args =
        {
            userid = Dict.userid,
            totalmoney = Dict.totalmoney,
            extype = Dict.extype,
            sign = Dict.sign,
            transaction = Dict.transaction,
            time = Dict.time
        }

        trace("-----lw util.postJson begin -------")
        util.postJson("http://520." .. util.curDomainName() .. "/Pay/IOSPayToken.aspx",args,function(...) self:iosPayWebCallback(Dict.userid,Dict.sign,pid,Dict.extype,...) end)
        trace("-----lw util.postJson end -------")
    end
    --ios 支付苹果返回
    function sdkManager:iosPayCallback(Dict)

        --event strGoodIDparam,useridparam,totalmoneyparam,formparam,transactionparam
        --trace("----lw iosPayCallback --------")
        --traceObj(Dict)
        if Dict.event == 1 and Dict.pid ~= nil then
            Alert:showTip("订单支付完成，提交游戏服务器。。。",3)
            local curtime =util.time()
            trace("-----lw curtime-------" .. curtime)
            local str = string.format("%d%d%d%diospay$$ddz##mly",Dict.userid,Dict.money,Dict.paytype,util.time())
            --trace("-----lw util.postJson md5 begin-------" .. str)
            local strMd5 =util.md5(str)
            --trace("-----lw util.postJson md5 -------" .. strMd5)
            local args =
            {
                userid = Dict.userid,
                totalmoney = Dict.money,
                extype = Dict.paytype,
                sign = strMd5,
                transaction = Dict.urlsign,
                time = curtime
            }

            trace("path " .. localpayFilePath)

            --if File.exists(localpayFilePath) then
            --    File.removeFile(localpayFilePath)
            --end
            local tablePay = {}
            if File.exists(localpayFilePath) then
                tablePay  = File.unserialize(File.read(localpayFilePath))
            end

            table.insert(tablePay,{
                md5 = strMd5,
                args = args,
                pid = Dict.pid,
                })

            --traceObj(tablePay,"---lw tablePay0----")
            File.save(localpayFilePath, File.serialize(tablePay), "w")

            trace("-----lw util.postJson begin -------")
            util.postJson("http://520." .. util.curDomainName() .. "/Pay/IOSPayToken.aspx",args,function(...) self:iosPayWebCallback(Dict.userid,strMd5,Dict.pid,Dict.paytype,...) end)
            trace("-----lw util.postJson end -------")
        end
        if Dict.event == 4 then
            --_uim:closeLayer(ui.paytip)
        end

    end
    --ios 支付web服务器返回
    function sdkManager:iosPayWebCallback(userid, md5sign, strGoodIDparam, paytype, suc, res)
        trace("ios 支付web服务器返回 " .. strGoodIDparam)
        if not suc then
            trace("iosPayWebCallback suc = false")
            Alert:showTip("支付失败 code 1",1)
            return
        end
        local code = res and res.code
        if not code == 1000 then
            traceObj(res,"iosPayWebCallback")
            Alert:showTip("支付失败 code 2",1)
            return
        end

        if File.exists(localpayFilePath) then
            local tablePay = File.unserialize(File.read(localpayFilePath))
            if tablePay then
                local i = 1
                while i <= #tablePay do
                    trace(tablePay[i].md5 .. " " .. md5sign,"---md5----")
                    if tablePay[i].md5 == md5sign then
                        trace("删除操作、值："..tablePay[i].md5)
                        table.remove(tablePay,i)
                        break
                    else
                        i=i+1
                    end
                end
                traceObj(tablePay,"---lw tablePay1----")
                File.save(localpayFilePath, File.serialize(tablePay), "w")
            end
        end
        self:onIosPayRes(strGoodIDparam, paytype)
        traceObj(res,"支付详情")
    end
    --
    function sdkManager:onIosPayRes(strGoodID,paytype)
        if not (strGoodID and string.find(strGoodID,"com.36y.farmerddz")) then
            local str = strGoodID or "充值出错,请联系客服!"
            Alert:showTip(str,2)
            return
        end
        local id = TemplateData:getGoodIdFromeIOSID(strGoodID)
        if not id then
            trace("ERROR 错误，IOS支付返回未找到对应的记录 " .. strGoodID)
        end
        -- if id == 208 and paytype == 100 then
        --     id = FIRST_CHARGE_ID
        -- end
        trace("买到物品id=",id)
        if id then
            self:buyItem(id)
            Alert:showTip("充值到账",2)
        end
    end

    function sdkManager:initIosPay()
        if  __Platform__ == 4 or __Platform__ == 5 then
            local userid = tostring(PlayerData:getUserID())
            --恢复ios中的订单
            local arg = {userid = userid,callBack = handler(self,self.iosPayCallback)}
            local suc,str = LuaObjcBridge.callStaticMethod("AppController", "initIpa",arg)
            if not suc then
                trace("sdkManager:initIpa fail res = ",str)
            end
            --恢复游戏中的订单
            trace("lw 当前登录的玩家id " .. userid)
            if File.exists(localpayFilePath) then
                local tablePay = File.unserialize(File.read(localpayFilePath))
                if tablePay then
                    for key, value in pairs(tablePay) do
                        trace("lw 订单 " .. value.args.sign .. " userid " .. value.args.userid)
                        if value.args.userid == PlayerData:getUserID() then
                            trace("lw 恢复游戏中的订单0 ")
                            sdkManager:iosPayResume(value.args,value.pid)
                        end
                    end
                end
            end
        end    
    end
else
    --ios 支付开始
    function sdkManager:iosPay(id,type)
        if  __Platform__ == 4 or __Platform__ == 5 then
            local total = TemplateData:getGoodsPrice(id)

            local strIOSID = ""
            -- if id == FIRST_CHARGE_ID and type == 100 then
                -- total = FIRST_CHARGE_PRICE
                -- strIOSID = string.format("com.36y.farmerddz.gold.%d",total)
            -- else
                strIOSID = string.format("com.36y.farmerddz.%s%d",type == 100 and "gold." or "",total)
            -- end

            local userid = tostring(PlayerData:getUserID())
            if PlayerData:getUserID() == 100217418 then
                Alert:showTip("正在提交订单。。。" .. strIOSID,5)
            else
                Alert:showTip("正在提交订单。。。",5)
            end

            --_uim:showLayer(ui.paytip)
            local arg = {productId=strIOSID}
            local suc,str = LuaObjcBridge.callStaticMethod("AppController", "Charge",arg)
            if not suc then
                trace("sdkManager:Pay fail res = ",str)
            end
        end    
    end

    --ios 支付苹果返回
    function sdkManager:iosPayCallback(Dict)
        trace("transaction = ",transaction)
        local pid = Dict.pid
        if pid ~= nil then
            Alert:showTip("订单支付完成，提交游戏服务器。。。",3)
            local money,paytype = TemplateData:getMoneyandTypeFromeIOSID(pid)
            local userid = PlayerData:getUserID()

            local curtime =util.time()
            local str = string.format("%d%d%d%diospay$$ddz##mly",userid,money,paytype,util.time())
            local strMd5 =util.md5(str)
            local args =
            {
                userid = userid,
                totalmoney = money,
                extype = paytype,
                sign = strMd5,
                transaction = Dict.receiptJsonString,
                time = curtime
            }

            util.postJson("http://520." .. util.curDomainName() .. "/Pay/IOSPayToken.aspx",args,function(...) self:iosPayWebCallback(userid,strMd5,pid,paytype,...) end)
        end


    end
    --ios 支付web服务器返回
    function sdkManager:iosPayWebCallback(userid, md5sign, strGoodIDparam, paytype, suc, res)
        trace("ios 支付web服务器返回 " .. strGoodIDparam)
        if not suc then
            trace("iosPayWebCallback suc = false")
            Alert:showTip("支付失败 code 1",1)
            return
        end
        local code = res and res.code
        if not (code == 1000) then
            traceObj(res,"iosPayWebCallback")
            Alert:showTip("支付失败 code 2",1)
            return
        end
        traceObj(res,"支付详情")
        for index,info in pairs(res.data) do
            local ispay = info.ispay
            if ispay == "0" then--只关闭订单
                Alert:showTip("重复的订单",2)
                self:closeTransaction(info.transaction_id)
            elseif ispay == "1"then
                self:onIosPayRes(strGoodIDparam, paytype)
                self:closeTransaction(info.transaction_id)
            else
                Alert:showTip("充值出错,请联系客服!",2)
            end
        end
    end
    --
    function sdkManager:onIosPayRes(strGoodID,paytype)
        if not (strGoodID and string.find(strGoodID,"com.36y.farmerddz")) then
            local str = strGoodID or "充值出错,请联系客服!"
            Alert:showTip(str,2)
            return
        end
        local id = TemplateData:getGoodIdFromeIOSID(strGoodID)
        if not id then
            trace("ERROR 错误，IOS支付返回未找到对应的记录 " .. strGoodID)
        end
        trace("买到物品id=",id)
        if id then
            self:buyItem(id)
            Alert:showTip("充值到账",2)
        end
    end

    --关闭订单
    function sdkManager:closeTransaction(transaction)
        if  __Platform__ == 4 or __Platform__ == 5 then
            local arg = {transaction = transaction}
            local suc,str = LuaObjcBridge.callStaticMethod("AppController", "closeTransaction",arg)
            if not suc then
                trace("sdkManager:closeTransaction fail res = ",str)
            end
        end    
    end

    --登录切换账号后,调用初始化支付
    function sdkManager:initIosPay()
        if  __Platform__ == 4 or __Platform__ == 5 then
            local userid = tostring(PlayerData:getUserID())
            --恢复ios中的订单
            local arg = {callBack = handler(self,self.iosPayCallback)}
            local suc,str = LuaObjcBridge.callStaticMethod("AppController", "initIpa",arg)
            if not suc then
                trace("sdkManager:initIpa fail res = ",str)
            end
        end    
    end
end
--充值
--向Web提出订单
function sdkManager:QuickPay(id,type)
    --[[userid   用户ID
totalmoney   充值总金额
clientip   用户IP
channel   渠道ID]]
    local userid = PlayerData:getUserID()
    local channel = self:getChannelType()
    local total = TemplateData:getGoodsPrice(id) --FIRST_CHARGE_ID and FIRST_CHARGE_PRICE or TemplateData:getGoodsPrice(id)
    local args = {
    userid = userid,
    total = total,
    channel = channel,
    sign = util.md5(userid .. channel .. "ddzmly2016!@#$%^&*()quick"),
    extype = type,
    }
    util.postJson("http://520." .. util.curDomainName() .. "/Pay/QuickSendOrder.aspx",args,function(...) self:onQuickPayRes(id,total,...) end)
end

function sdkManager:baiduPay(id,type)
    local userid = PlayerData:getUserID()
    local channel = self:getChannelType()
    local total = TemplateData:getGoodsPrice(id)--FIRST_CHARGE_ID and FIRST_CHARGE_PRICE or TemplateData:getGoodsPrice(id)
    local args = {
        userid = userid,
        totalmoney = total,
        extype = type,
    }
    local url = "http://verifywww." .. util.curDomainName() .. "/Pay/BaiDuPaySend.aspx"
    if IP_SERVER == _GameServerIP then
        url = "http://520." .. util.curDomainName() .. "/Pay/BaiDuPaySend.aspx"
    end
    util.postJson(url,args,function(...) self:onBaiduPayRes(id,type,total,...) end)
end

function sdkManager:manweiPay(id,type)
    local userid = PlayerData:getUserID()
    local channel = self:getChannelType()
    local total = TemplateData:getGoodsPrice(id)--FIRST_CHARGE_ID and FIRST_CHARGE_PRICE or TemplateData:getGoodsPrice(id)
    local args = {
        userid = userid,
        totalmoney = total,
        extype = type,
    }
    local url = "http://verifywww." .. util.curDomainName() .. "/pay/ManWeiPaySend.aspx"
    if IP_SERVER == _GameServerIP then
        url = "http://520." .. util.curDomainName() .. "/pay/ManWeiPayNotify.aspx"
    end
    util.postJson(url,args,function(...) self:onManweiPayRes(id,type,total,...) end)
end

--web返回订单号
function sdkManager:onQuickPayRes(id,total,suc,res)
    if not suc then
        trace("onQuickPayRes suc = false")
        Alert:showTip("支付失败 code 3",1)
        return
    end
    local code = res and res.code
    if not code == 1000 or not res.data then
        traceObj(res,"onQuickPayRes")
        Alert:showTip("支付失败  code 4",1)
        return
    end
    self:quickSDKPay(res,total,id)
    traceObj(res,"支付详情")
end

function sdkManager:onBaiduPayRes(id, type, total, suc, res)
    if not suc then
        trace("onBaiduPayRes suc = false")
        Alert:showTip("支付失败  code 5",1)
        return
    end
    local code = res and res.code
    if not code == 1000 then
        traceObj(res,"onBaiduPayRes")
        Alert:showTip("支付失败 code 6",1)
        return
    end
    
    self:baiduSDKPay(res,total,id, type)
    traceObj(res,"支付详情")
end

function sdkManager:onManweiPayRes(id, type, total, suc, res)
    if not suc then
        trace("onManweiPayRes suc = false")
        Alert:showTip("支付失败 code 7",1)
        return
    end
    local code = res and res.code
    if not code == 1000 then
        traceObj(res,"onManweiPayRes")
        Alert:showTip("支付失败 code 8",1)
        return
    end
    
    self:manweiSDKPay(res,total,id, type)
    traceObj(res,"支付详情")
end

function sdkManager:quickSDKPay(res,total,id)
    if  __Platform__ == 3 then
        local uuid = res.data
        self.payItems[uuid] = id
        local args = {uuid,total,PlayerData:getUserID(),handler(self,self.onQuickPaySDKRes)}
        local sigs = "(Ljava/lang/String;III)V"
        local funName = "QuickPay"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    else
    end    
end

function sdkManager:baiduSDKPay(res,total,id, goodtype)
    if  __Platform__ == 3 then
        if not (type(res.data) =="table") then
            trace("baiduSDKPay error res")
            traceObj(res,"res")
            return
        end
        local uuid = res.data.orderno
        -- trace("baiduSDKPay = ", uuid)
        self.payItems[uuid] = id

        local args = {uuid,tostring(total),goodtype,PlayerData:getUserID(),id,handler(self,self.onQuickPaySDKRes)}
        local sigs = "(Ljava/lang/String;Ljava/lang/String;IIII)V"

        local funName = "baiduPay"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)


        if state then
            return 
        end 
    else
    end
end

function sdkManager:manweiSDKPay(res,total,id, goodtype)
    if not (type(res) == "table") then
        trace("manweiSDKPay error res = ",res)
        return
    end
    if  __Platform__ == 3 then
        if not (type(res.data) =="table") then
            trace("manweiSDKPay error res")
            traceObj(res,"res")
            return
        end
        local uuid = res.data.orderno
        self.payItems[uuid] = id
        local args = {uuid,total,goodtype,PlayerData:getUserID(),id,handler(self,self.onQuickPaySDKRes)}
        local sigs = "(Ljava/lang/String;IIIII)V"

        local funName = "manweiPay"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    elseif __Platform__ == 4 or __Platform__ == 5  then
        local userid = tostring(PlayerData:getUserID())
        local uuid = res.data.orderno
        local strIOSID = string.format("com.36y.36y.manwei.%s%d",goodtype == 100 and "gold." or "",total)
        local arg = {
            money = total,
            productId = strIOSID,
            productName = TemplateData:getShopGooldInfo(id,"name"),
            productDesc = TemplateData:getShopGooldInfo(id,"gongneng"),
            roleId = userid,
            roleName = PlayerData:getNickName(),
            serverId = "1",
            serverName = "1",
            extension = uuid,
            callback = handler(self,self.onQuickPaySDKRes),
        }
        local suc,str = LuaObjcBridge.callStaticMethod("AppController", "manweiPay",arg)
        if not suc then
            trace("sdkManager:manweiPay fail res = ",str)
        end
    end
end



function sdkManager:onQuickPaySDKRes(uuid)
    tance("onQuickPaySDKRes  = ", uuid)
    local id = self.payItems[uuid]
    self.payItems[uuid] = nil
    self:buyItem(id)
end

--购买成功后获取物品
function sdkManager:buyItem(id)
    PlayerData:onItemBuySucc(id,1)
end

--获取IOS设备电量,0-100
function sdkManager:getIosPower()
    local value = 0
    if  __Platform__ == 4 or __Platform__ == 5 then
        local arg = {}
        local suc,power = LuaObjcBridge.callStaticMethod("AppController", "getPower",nil)
        if not suc then
            trace("sdkManager:getIosPower fail res = ",value)
        end
        value = power
    else
    end    
    value = tonumber(value) or 0
    value = math.abs(value)
    value = value*100
    return value
end

--更新电量
function sdkManager:updatePower(pro_power,stopUpdata)
    if tolua.isnull(pro_power) then
        return
    end
    if  __Platform__ == 3 then    --安卓平台
        local function onPowerChange(strValue)
            local value = tonumber(strValue)
                trace("power = ",value)
            if value then
                pro_power:setPercent(value)
            end
        end
        local args = {stopUpdata and 0 or onPowerChange}
        local sigs = "(I)I"
        local funName = "onPowerChange"


        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)
        if state then
            onPowerChange(ret)
        end
    elseif __Platform__ == 4 or __Platform__ == 5 then
        local update = function() 
            local value = self:getIosPower()
            if value then
                pro_power:setPercent(value)
            end
        end
        update()
        util.delayCall(pro_power,update,10,true)
    end
end


--更新电量
function sdkManager:updateWifi(sp_wifi)
    if tolua.isnull(sp_wifi) then
        return
    end
    local getWifiLevel
    local getWifiType

    if  __Platform__ == 3 then    --安卓平台
        getWifiLevel = function()
            local args = {}
            local sigs = "()I"
            local funName = "getWifiLevel"

            local luaj = require "cocos.cocos2d.luaj"
            local className = util.getAndroidPackPath().."AppActivity"
            local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

            if state then
                local level
                if ret <=0 and ret>= -50 then
                    level = 3
                elseif ret>= -80 then
                    level = 2
                elseif ret>= -100 then
                    level = 1
                else
                end
                return level
            end
        end

        getWifiType = function ()
            local args = {}
            local sigs = "()Ljava/lang/String;"
            local funName = "getCurrentNetworkType"

            local luaj = require "cocos.cocos2d.luaj"
            local className = util.getAndroidPackPath().."AppActivity"
            local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

            if state then
                return ret
            end
        end
    elseif __Platform__ == 4 or __Platform__ == 5 then
        getWifiType = function ()
            local arg = {}
            local suc,signType = LuaObjcBridge.callStaticMethod("AppController", "getSignalType",nil)
            if not suc then
                trace("sdkManager:getWifiType fail res = ",signType)
            else
                trace("wifiType = ",signType)
                return signType
            end
        end

        getWifiLevel = function ()
            local arg = {}
            local suc,signStrength = LuaObjcBridge.callStaticMethod("AppController", "getSignalStrength",nil)
            if not suc then
                trace("sdkManager:getWifiLevel fail res = ",signStrength)
            else
                trace("getWifiLevel = ",signStrength)
                if signStrength>3 then
                    signStrength = 3
                elseif signStrength<1 then
                    signStrength = 1
                end
                return signStrength
            end
        end
    end
    if getWifiLevel and getWifiType then
        local fun = function()
            local img
            local netType = getWifiType()
            if netType == "2G" then
                img = R.Wifi[4]
            elseif netType == "3G" then
                img = R.Wifi[5]
            elseif netType == "4G" then
                img = R.Wifi[6]
            elseif netType == "Wi-Fi" then
                local level = getWifiLevel()
                if level then
                    img = R.Wifi[level]
                end
            end
            if img then
                util.loadSprite(sp_wifi,img)
                sp_wifi:setVisible(true)
            else
                sp_wifi:setVisible(false)
            end
        end
        fun()
        util.delayCall(sp_wifi,fun,5,true)
    else
        util.loadSprite(sp_wifi,R.Wifi[1])
        sp_wifi:setVisible(true)
    end

end


--微信登录,自动登录后绑定 都会发消息
function sdkManager:postToXianwan()
    local   merid = PlayerData:getUserID()
    local   mername = PlayerData:getUserName()
    local   devid = util.getIMEI() or ""
    local   simid = util.getSIMID() or ""

    local tbl = {
        fid = 8,
        deviceid = devid,
        simid = simid,
        userid = merid,
        name = mername,
        adid = "jdFlJOFzFnQ="
    }

    util.postJson("http://520." .. util.curDomainName() .. "/Handler/ReLogin.ashx",tbl,function(suc,res)
        trace("postToXianwan suc res = ",suc,res)
        traceObj(res,"return xianwan")
    end)
end

--发送LOG到服务器,
function sdkManager:initLogToServer()
    if  __Platform__ == 3 then    --安卓平台
        if Platefrom:getVersionName()>1.127 then
            local args = {util.postLogToServer}
            local sigs = "(I)V"
            local funName = "initSendLog"

            local luaj = require "cocos.cocos2d.luaj"
            local className = util.getAndroidPackPath().."AppActivity"
            local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

            if state then
                return ret
            end
        end
    end
end

--微信分享链接
--参数:标题,文字,链接,分享类型(0 = 好友列表 1 = 朋友圈 2 = 收藏),分享回调
function sdkManager:wxShare(sharUrl,title,msg,shareType,callback)
    Alert:showTip("正在跳转,请稍后")
    if self._isJumping then
        return
    end
    self._isJumping = true
    util.setTimeout(function()
        self._isJumping = false
    end,2)
    callback = callback or function(suc) 
        --这里加个定时,确保是在opengl线程中调用,避免提示文字黑框
        util.setTimeout(function() 
            if suc then
                Alert:showTip("分享成功")
            else
                Alert:showTip("分享失败")
            end
        end,0)
        self._isJumping = false
    end

    if  __Platform__ == 3 then    --安卓平台
        local args = {title,msg,sharUrl}
        local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
        local funName = "sendMsgtoWx"

        if Platefrom:getVersionName()>=1.134 then
            args = {title,msg,sharUrl,shareType,function(res) callback(res=="suc") end}
            sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)V"
        elseif shareType == 1 then
            local title = "该功能需要新版本,是否更新?"
            util.changeUI(ui.inGameUpdate,title)
            return
        end
        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    elseif self:is_IOS() then
        local args = {
            title = title,
            desc = msg,
            url = sharUrl,
            shareType = shareType,
            callback = callback,--只有在1.134才有
        }
        local suc,str = LuaObjcBridge.callStaticMethod("AppController", "shareToWx",args)
        if not suc then
            trace("wxShare fail res = ",str)
            Alert:showTip("分享失败")
        else
            --小于1.34的版本,默认2秒后分享成功
            if Platefrom:getVersionName()<1.134 then
                util.setTimeout(function()
                    callback(true)
                end,2)
            end
        end
    end
end

--微信分享图片
--qrUrl 二维码地址
--imgUrl 图片链接地址(不包括文件名)
--msg 分享内容
--shareType 分享类型
function sdkManager:wxShareImg(jsonnconfig,qrUrl,imgUrl,msg,shareType,callback,onlyOnePic)
    Alert:showTip("正在跳转,请稍后")
    if self._isJumping then
        return
    end
    self._isJumping = true
    util.setTimeout(function()
        self._isJumping = false
    end,2)
    callback = callback or function(suc)
        if suc then
            Alert:showTip("分享成功")
        else
            Alert:showTip("分享失败")
        end
        self._isJumping = false
    end
    local sharecallback = function(suc) 
        --这里加个定时,确保是在opengl线程中调用,避免提示文字黑框
        util.setTimeout(function()
            callback(suc)
        end,0)
    end

    if  __Platform__ == 3 then    --安卓平台
        local args = {jsonnconfig,qrUrl,imgUrl,msg,shareType,function(res) sharecallback(res=="suc") end}
        local sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)V"
        local funName = "wxShareImg"
        if onlyOnePic then
            if Platefrom:getVersionName() < 1.138 then
                local title = "该功能需要新版本,是否更新?"
                util.changeUI(ui.inGameUpdate,title)
                return
            end
            local title = "来玩斗地主"
            args = {jsonnconfig,qrUrl,imgUrl,title,msg,shareType,function(res) sharecallback(res=="suc") end}
            sigs = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)V"
            funName = "wxShareOneImg"
        end

        if Platefrom:getVersionName() < 1.136 then
            local title = "该功能需要新版本,是否更新?"
            util.changeUI(ui.inGameUpdate,title)
            return
        end
        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return 
        end
    elseif self:is_IOS() then
        if Platefrom:getVersionName() < 1.138 then
            local title = "该功能需要新版本,是否更新?"
            util.changeUI(ui.inGameUpdate,title)
            return
        end
        local args = {
            jsonnconfig = jsonnconfig,
            qrUrl = qrUrl,
            imgUrl = imgUrl,
            msg = msg,
            shareType = shareType,
            callback = sharecallback,
            onlyOnePic = onlyOnePic,
        }
        local funName = "wxShareImg"
        if onlyOnePic then
            funName = "wxShareOneImg"
        end
        local suc,str = LuaObjcBridge.callStaticMethod("AppController", funName,args)
        if suc then
            trace("shareImgWidthQR")
        else
            sharecallback(false)
        end
    end
end

--游戏推广初始化链接
function sdkManager:initPromotionUrl()
    if self._shareUrl then
        return
    end
    local url = "http://wx.36y.com/Client/prourl.txt"
    local strUtype = "999"
    local userID = PlayerData:getUserID()
    util.get(url,function(suc,res)
        if suc then
            self._shareUrl = string.format("http://%s/try/tryindex?utype=%s&pcid=%d",res,strUtype,userID)
        else
            util.get(url,function(suc2,res2)
                if suc2 then
                    self._shareUrl = string.format("http://%s/try/tryindex?utype=%s&pcid=%d",res,strUtype,userID)
                else
                    trace("分享链接获取失败")
                end
            end)
        end
    end)
end

--游戏推广
function sdkManager:getPromotionUrl()
    if self._shareUrl then
        return self._shareUrl
    end
    local strUtype = 999
    local userID = PlayerData:getUserID()
    local sharUrl = string.format("http://try.%s/try/tryindex?utype=%s&pcid=%d",util.curDomainName(),strUtype,userID)
    return sharUrl
end

--这种推广可能朋友圈别人看不到
function sdkManager:gamePromotion(shareType,callback)
    local sharUrl = self:getPromotionUrl()

    self:wxShare(sharUrl,"[新手福利,最高11元]斗地主比赛","新用户立即领取1元荭包，七天领取10元。斗地主比赛场,一局一荭包,最高35元,打完就领！",shareType,callback)
end


--获取二维码
function sdkManager:getQRimg(callback)
    if self._QRimgPath then
        if callback then
            callback()
        end
        return
    end
    local url = string.format("http://wx.%s/Client/ClientHandler.ashx",util.curDomainName())
    local arg = {
        action = "clientgener",
        pcid = PlayerData:getUserID()
    }
    util.postJson(url,arg,function(suc,res)
        if suc then
            if res.code == 1000 then
                local imgUrl = res.data
                --二维码图片存放地址
                self._QRUrl = imgUrl
                util.loadWebImg(imgUrl,false,function(suc,path)
                    if suc then
                        --二维码图片本地保存的地址
                        self._QRimgPath = path
                        if callback then
                            callback()
                        end
                    end
                end)
            else
                Alert:showTip("二维码获取失败!")
                trace("error:getQRimg")
            end
        end
    end)
end

--二维码图片本地保存的地址
function sdkManager:getQMPath()
    return self._QRimgPath
end

--分享三张大图,并上二维码
--这里的callback 在安卓多图时无法获取回调
function sdkManager:shareImgWidthQR(imgPath,callback,onlyOnePic)
    if __Platform__ == 0 then
        return
    end

    if Platefrom:getVersionName()<1.136 then
        local title = "该功能需要新版本,是否更新?"
        util.changeUI(ui.inGameUpdate,title)
        return
    end

    local doShare = function()
        local configUrl = imgPath.."config.txt"
        util.get(configUrl,function(suc,res)
            if suc then
                local data = res
                local qrUrl = self._QRUrl
                local imgUrl = imgPath
                local msg = "发现一款很新颖的斗地主，每打1局就领1荭包，最高35元，打完就领。新玩家还可立即领取1元，七天领取10元。"
                self:wxShareImg(data,qrUrl,imgUrl,msg,1,callback,onlyOnePic)
            else
                Alert:showTip("分享失败获取配置失败")
            end
        end)
    end

    if not self._QRUrl then
        self:getQRimg(function()
            doShare()
        end)
        return
    end
    doShare()
end

--分享任务
function sdkManager:doShareTask(callback)
    -- if not PlayerData:hasShareTask() then
    --     Alert:showTip("没有此任务,分享失败")
    --     return
    -- end

    if __Platform__ == 0 then
        util.setTimeout(function() 
            if callback then
                callback()
            else
                self:onFinshShareTask()
            end
        end,2)
        return
    elseif __Platform__ == 3 or sdkManager:is_IOS() then
        local configPath = "http://ndownload.36y.com/share/task/"
        if sdkManager:is_IOS() then
            configPath = "http://ndownload.36y.com/share/ios/"
        end
        self:shareImgWidthQR(configPath,function(suc)
            if suc then
                if callback then
                    callback()
                else
                    self:onFinshShareTask()
                end
            else
                Alert:showTip("分享失败")
            end
        end,true)
    --[[elseif sdkManager:is_IOS() then
        self:gamePromotion(0,function(suc)
            if suc then
                if callback then
                    callback()
                else
                    self:onFinshShareTask()
                end
            else
                Alert:showTip("分享失败")
            end
        end)]]
    end
end

--转盘兑换分享成功发给服务器
function sdkManager:onFinshShareTask()
    GameSocket:sendMsg(MDM_GP_TASK,ASS_GP_TASK_WX_SHARE,{iTaskType = 1})
end

function sdkManager:copyToClipboard(text)
    if  __Platform__ == 0 then
        Alert:showTip("桌面端无此功能")
        return
    end
    if Platefrom:getVersionName()<1.134 then
        local title = "该功能需要新版本,是否更新?"
        util.changeUI(ui.inGameUpdate,title)
        return
    end
    if  __Platform__ == 3 then    --安卓平台
        local args = {text}
        local sigs = "(Ljava/lang/String;)I"
        local funName = "copyToClipboard"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state and ret == 0 then
            Alert:showTip("复制成功")
            return 
        end
    elseif self:is_IOS() then
        local args = {
            text = text,
        }
        local suc,str = LuaObjcBridge.callStaticMethod("AppController", "copyToClipboard",args)
        if suc then
            Alert:showTip("复制成功")
        end
    end

end




return sdkManager