local Platefrom = class("Platefrom")

function Platefrom:ctor()
    self._VersionCode = nil
end

function Platefrom:intallAPK(path)
	if  __Platform__ == 3 then
        local args = {path}
        local sigs = "(Ljava/lang/String;)V"
        local funName = "intallAPK"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return ret
        end
    else
        trace("安装apk失败,不是安卓平台",path)
    end
end
--判断app是否安装
function Platefrom:isAppInstalled(uri)
    if  __Platform__ == 3 then
        if self:getVersionName()<1.141 then
            return false
        end
        local args = {uri}
        local sigs = "(Ljava/lang/String;)Z"
        local funName = "isAppInstalled"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            return ret
        end
    end

    return false
end

function Platefrom:getVersionName()
	if  __Platform__ == 3 then
        local args = {}
        local sigs = "()Ljava/lang/String;"
        local funName = "getVersionName"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            --如果版本号是3段的,取前面两段
            local find = string.find( ret,".",3,true)
            if find then
                ret = string.sub(ret,0,find - 1)
            end
            return tonumber(ret) or 0
        end
    elseif __Platform__ == 4 or __Platform__ == 5 then
        return self:getIOSVersionCodeNum()
    end
    return 10000
end
--ios中的版本
function Platefrom:getIOSVersionCode()
    if __Platform__ == 4 or __Platform__ == 5 then
        local suc,code = LuaObjcBridge.callStaticMethod("AppController", "getIOSVersionCode",nil)
        if not suc then
            trace("latefrom:getIOSVersionCode fail res = ",code)
        else
            return code
        end
    end

    return 0
end

function Platefrom:getIOSVersionCodeNum()
    local ret = self:getIOSVersionCode()
    --如果版本号是3段的,取前面两段
    local find = string.find( ret,".",3,true)
    if find then
        ret = string.sub(ret,0,find - 1)
    end
    return tonumber(ret) or 0
end
--获取客户端版本标识,以区分是哪个来源的包,
function Platefrom:getVersionCode()
    if self._VersionCode then
        return self._VersionCode
    end
    if  __Platform__ == 3 then
        local code = tonumber(self:getBindData("utype"))
        if code and code ~= 0 then
            self._VersionCode = code
            trace("Platefrom:getVersionCode2 = ",self._VersionCode)
        else
            --这里面也是从getBindData里面获取值,但如果获取不到,会默认取mainifest 中的versionCode
            local args = {}
            local sigs = "()Ljava/lang/String;"
            local funName = "getVersionCode"

            local luaj = require "cocos.cocos2d.luaj"
            local className = util.getAndroidPackPath().."AppActivity"
            local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

            if state then
                self._VersionCode = tonumber(ret) or 0
            else
                self._VersionCode = 0
            end
        end
    elseif __Platform__ == 4 or __Platform__ == 5 then
        local suc,code = LuaObjcBridge.callStaticMethod("AppController", "getVersionCode",nil)
        if not suc then
            trace("latefrom:getVersionCode fail res = ",code)
        else
            self._VersionCode = code
        end
    end

    return self._VersionCode or 1
end
function Platefrom:getBindData(param)
    if self._bindData then
        return self._bindData[param]
    end
	if  __Platform__ == 3 then    --安卓平台
        local args = {param,1}

        local sigs = "(Ljava/lang/String;I)Ljava/lang/String;"
        local funName = "getBindData"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)
    
        if state then
            if string.find(ret,"-") then
                self._bindData = util.splitStringByKey(ret,"_","-")
                print("getBindData ",param,self._bindData[param])
                return self._bindData[param]
            end
            return ret;--tonumber(ret) or 0 
        end
    elseif  __Platform__ == 4 or __Platform__ == 5 then
        local suc,str = LuaObjcBridge.callStaticMethod("AppController", "getBindData",{param = param , data=1})
        if suc then
            print("lw getBindData return " .. str)
            return str;
        end
    end 
    return "0"
end

function Platefrom:getLocalIpAddress()
    if self._ipAddress then
        return self._ipAddress
    end
    if  __Platform__ == 3 then
        local args = {}
        local sigs = "()Ljava/lang/String;"
        local funName = "getLocalIpAddress"

        local luaj = require "cocos.cocos2d.luaj"
        local className = util.getAndroidPackPath().."AppActivity"
        local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

        if state then
            self._ipAddress = ret
            return ret
        end
    end
end
--有相册,自动安装包,相关功能
function Platefrom:hasPhoneFunc()
	if  __Platform__ == 3 then
		local hasPhone = self:getVersionName() > 1.106
        trace("hasPhone = ",hasPhone,self:getVersionName())
        return hasPhone
	end

	return true
end
--有退出回调
function Platefrom:quickSDKhasExitFunc()
    if  __Platform__ == 3 then
        local hasPhone = self:getVersionName() >= 1.109
        trace("hasPhone = ",hasPhone,self:getVersionName())
        return hasPhone
    end

    return true
end
function Platefrom:hasModuleDownload()
    if  __Platform__ == 0 then
        return false
    end
    return true
end
function Platefrom:hasIMEI()
    if  __Platform__ == 3 then
        local has = self:getVersionName() >= 1.113 or sdkManager:isBengbeng() or sdkManager:isXianwan()
        return has and (util.getIMEI() ~= "")
    end

    return false
end

function Platefrom:clearLogo()
    if  __Platform__ == 3 then
        if has then
            local args = {}
            local sigs = "()V"
            local funName = "clearLogo"

            local luaj = require "cocos.cocos2d.luaj"
            local className = util.getAndroidPackPath().."AppActivity"
            local state, ret = luaj.callStaticMethod(className,funName,args,sigs)

            if state then
                return ret
            end
        end
    end

    return false
end

function Platefrom:isIphoneX()
    if  WIN_Width>1550 then
        return true
    end

    return false
end

return Platefrom