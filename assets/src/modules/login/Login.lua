local Login = class("Login",function()
    return ui.createCsb(ui.Login).root
end)
sdkManager = require("Common.sdkManager").create()
local _GameServerPort = 13026
local startPos = 0--下载前的进度条

IP_SERVER = "nbserver.36y.com"
local _ipList = {
	--"ninnerbserver.ddz.com",
	IP_SERVER,
	--"192.168.1.80",
	-- "192.168.1.110",
	--"45.126.120.91",
	--"login.36y.com",
}

function Login:ctor(_, bIsReload)
	util.setLayout(ui.Login, self)
	self._connected = false
	self._loadImged = false
	self._autoLogin = sdkManager:isAndroidOffic() or sdkManager:is_IOS_offic() or sdkManager:isTryPackage()

	util.delayCall(self,function()
		self:loadImg()
		util.init()
		self:resize()
	end)
	-- self:mTest()
end

function Login:mTest()
	-- body
	local obj = {1,2,3,4,5, me = {44}}
	local me = File.serialize(obj)
	print("me------", me)
end


function Login:loadImg()
	self:loadImgFinish()
end
function Login:resize()
	util.aptSelf(self)
	-- local loading_huojian = Animation:createSpeciallyEffect("csb/effect/loading_huojian", 0, 460, true);
	-- self.Image_bg:addChild(loading_huojian);
    -- local loadingbg = Animation:createSpeciallyEffect("csb/effect/loading", 0, 360, true);
	-- self.Image_bg:addChild(loadingbg);
    -- loading_huojian:setPosition(WIN_center);
    -- loadingbg:setPosition(WIN_center);
	-- self:setPercent(startPos,true)
end

function Login:loadImgFinish()
	self._loadImged = true

	if self._connected then
		self:checkAutoLogin()
	end
end

function Login:checkAutoLogin()
	print("checkAutoLogin")
	-- if self._autoLogin and PlayerData:getAutoLogin() and self:LoginLastAccount() then

	-- else
	-- 	self.sp_loading:setVisible(false)
	-- 	self.node_btns:setVisible(true)
	-- end
end

return Login