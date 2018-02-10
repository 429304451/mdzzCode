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














return sdkManager