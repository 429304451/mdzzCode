local Login = class("Login",function()
    return ui.createCsb(ui.Login).root
end)
sdkManager = require("Common.sdkManager").create()
local _GameServerPort = 13026
local startPos = 0--下载前的进度条

IP_SERVER = "nbserver.36y.com"
-- IP_SERVER = "ninnerbserver.ddz.com"
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
	self._connected = true
	self._loadImged = false
	self._autoLogin = sdkManager:isAndroidOffic() or sdkManager:is_IOS_offic() or sdkManager:isTryPackage()

	util.delayCall(self,function()
		util.init()
		self:loadImg()
		
		self:resize()
		sdkManager:saveBindDatas()

		self:setPercent(0)
		self:getLocalVersion()
		PlayerData:getUsers()
		self:addEvents()
		self:checkServer()
		require("modules.login.hideModule"):create()
	end)

	-- util.delayCall(self,function()
	-- 	local userData = PlayerData:getUsers()
	-- 	for i,info in pairs(userData) do
	-- 		local name = info.name
	-- 		local pw = info.password
	-- 		local showText = name
	-- 		if name ~= PlayerData:getdefUserName() and not self:isWxAccount(name) then
	-- 			self.Image_1:setVisible(false)
	-- 			break
	-- 		end
	-- 	end
	-- end)
end

function Login:isWxAccount(name)
	return name and (string.sub(name,1,3) == "wx_")
end

function Login:onHideChild()
	self:initLoginBtns()
end
function Login:mTest()
	local data = [[local data = {
		serverstatus = 0,
		statustip1 = "服务器正在维护,预计11:00开放,请稍后登录。。。",
		statustip2 = "服务器计划11：00开始例行维护,维护时长1小时,请合理安排好游戏时间",
	}
	return data]]
	data = data and loadstring(data)()
	print("-------------------------------------------")
	print(data)
	for k,v in pairs(data) do
		print(k,v)
	end
	print("-------------------------------------------")
end

--服务器是否维护
function Login:checkServer()
	-- self:mTest()
	local url = "http://weihuServer.ddz.com/weihu.txt"
	util.get(url,function(suc,data)
		if suc then
			data = data and loadstring(data)()
			if type(data) == "table" then
				if data.serverstatus == 1 then
					local str = data.statustip1 or "服务器正在维护。。。"
					Alert:showCheckBox2(str,os.exit,os.exit)
					return
				elseif data.serverstatus == 2 then
					local str = data.statustip2 or "服务器即将维护。。。"
					local func = function() self:updateIps() end
					Alert:showCheckBox2(str,func,func)
					return
				end
			end
		end
		self:updateIps()
	end)
end
function Login:updateIps()
	if table.nums(_ipList) == 1 then
		self.ls_ip:setVisible(false)
		self.Text_1:setVisible(false)
		_GameServerIP = _ipList[1]
		self:LoginServer()
		return
	end
	self.ls_ip:setVisible(true)
	self.Text_1:setVisible(true)
	self.ls_ip:removeAllItems()
	local items = {}
	local colorSelect = cc.c3b(255,0,0)
	local colorunSelect = cc.c3b(255,255,255)
	local savedIp = util.getKey("selecIP")
	_GameServerIP = savedIp~="" and savedIp or _ipList[1]
	for i,j in pairs(_ipList) do
		local color = colorunSelect
		if j == _GameServerIP then
			color = colorSelect
		end
		local item = util.listAddString(self.ls_ip,j,28,color)
		table.insert(items,item)
		item.setFuns(function()
			_GameServerIP = _ipList[i]
			util.setKey("selecIP",_GameServerIP)
			for i,j in pairs(items)do
				j.setTextColor(colorunSelect)
			end
			item.setTextColor(colorSelect)
			--self:checkUpdate()
			self:LoginServer()
		end)
	end
end

function Login:LoginServer()
	Alert:showTip("正在登录服务器 ",2)
	if _GameServerIP and _GameServerPort then
		GameSocket:connect(_GameServerIP,_GameServerPort,function()
			trace("连上B服务器,发送",MDM_GP_REQURE_GAME_PARA,ASS_GP_REQURE_GAME_PARA)
			GameSocket:sendMsg(MDM_GP_REQURE_GAME_PARA,ASS_GP_REQURE_GAME_PARA,{iAreaID = 0,strGameSerialNO = PlayerData:getVersion()})
		end)
	end
end

function Login:addEvents()
	util.clickSelf(self,self.Btn_weChat,self.onLoginWX)
	util.clickSelf(self,self.Btn_ExitGame,self.onExitGame)
	util.clickSelf(self,self.Btn_QuickStart,self.onStartGame)
	util.clickSelf(self,self.Btn_SwitchAccount,self.onSwitchAccount)
	self.Btn_weChat.bHide = false
	self.Btn_QuickStart.bHide = false
	self.Btn_SwitchAccount.bHide = false
	GameSocket:addDataHandler(MDM_GP_REQURE_GAME_PARA,ASS_GP_REQURE_GAME_PARA,self,self.onLoginin)--登录服务器返回
	GameSocket:addDataHandler(MDM_GP_LOGON,ASS_GP_LOGON_ERROR,self,self.onPassWError)--登录错误
	GameSocket:addDataHandler(MDM_GP_LOGON,ERR_GP_MSG_SIZE_ERR,self,self.onLoginError)--登录错误
	GameSocket:addDataHandler(MDM_GP_LOGON,ASS_GP_LOGON_SUCCESS,self,self.onLoginSucc)--登录大厅成功
	GameSocket:addDataHandler(MDM_GP_LOGON,ASS_GP_LOGON_SUCCESS_ADD,self,self.onAddSuccessLogin)--登录大厅成功
	GameSocket:addDataHandler(MDM_GP_LOGON,ASS_GP_LOGON_REG,self,self.onLoginRes)--快速注册返回
	GameEvent:addEventListener(GameEvent.updateVersion,self,self.onUpdateVersion)
	util.addEventBack(self,handler(self,self.onEscKeyPressed))

	if __Platform__ == 0 then
		self:initLoginBtns()
	end
end
--三个登录按钮根据显示个数进行位置排放
function Login:initLoginBtns()
	self._posBtn = self._posBtn or {}
	local showBtn = {}
	local btns = {self.Btn_weChat,self.Btn_SwitchAccount,self.Btn_QuickStart}
	table.sort(btns,function(btn1,btn2) return btn1:getPositionX()<btn2:getPositionX() end)
	for _,btn in pairs(btns) do
		if table.nums(self._posBtn)<3 then
			table.insert(self._posBtn,btn:getPositionX())
		end
		if btn.bHide == false then
			btn:setVisible(true)
			table.insert(showBtn,btn)
		end
		-- if btn:isVisible() then
		-- 	table.insert(showBtn,btn)
		-- end
	end
	if table.nums(showBtn) == 1 then
		showBtn[1]:setPositionX(self._posBtn[2])
	elseif table.nums(showBtn) == 2 then
		showBtn[1]:setPositionX(self._posBtn[1]+80)
		showBtn[2]:setPositionX(self._posBtn[3]-80)
	end

	--按钮从手机登录改成账号登录
	if sdkManager:isThirdChannel() then
		util.loadButton(self.Btn_SwitchAccount,"img2/login/zhdl2")
	end
end

function Login:onEscKeyPressed()
	trace("Login:onEscKeyPressed")
	if self._autoLogin and PlayerData:getAutoLogin() then
		self._autoLogin = false
		Alert:showTip("取消自动登录",1)
	elseif self.node_btns:isVisible() then
		sdkManager:exitGame()
	end
end

function Login:onUpdateVersion(info)
	local ver = info.data
	self.Text_Version:setString("版本号:"..ver)
end

function Login:LoginByName()
	--账号登录
	local info = {
		zName = PlayerData:getUserName(),
		szMD5 = PlayerData:getLoginMD5(),
		--TML_SN = PlayerData:getMAC(),			
		szMD5Pass = PlayerData:getPassWord(),
		szMathineCode = PlayerData:getMAC(),
		uRoomVer = PlayerData:getRoomVer(),
		bLogonType = PlayerData:getLogonType(),
	};
	PlayerData:setIsWXAcccount(false)
	GameSocket:sendMsg(MDM_GP_LOGON,ASS_GP_LOGON_BY_NAME,info)
end
--这个返回表示注册失败,改为登录
function Login:onLoginRes(res)
	self:LoginByName()
end
function Login:onAddSuccessLogin( res )
	self:setVisible(false)
end
--登录大厅成功
function Login:onLoginSucc(res)
	-- if true then
		mlog("登录大厅成功")
	-- 	return
	-- end
	PlayerData:setPlayerData(res)
	local tbl =
	{
		iUserID = PlayerData:getUserID(),
	}
	print("onLoginSucc", tbl.iUserID)
	GameSocket:sendMsg(MDM_GP_BATTLE_MSG,ASS_GP_BATTLE_USER_SIGNUP_INFO_REQ,tbl)
	if PlayerData:getIsSendSquareRedReq() then
        GameSocket:sendMsg(MDM_GP_RED,ASS_GP_GET_PIAZZA_RED)
    end
    util.addSchedulerFuns(self,function() 
		GameSocket:sendMsg(MDM_GP_PROP,ASS_PROP_GETUSERPROP)
	end)
	util.addSchedulerFuns(self,function() 
		GameSocket:sendMsg(MDM_GP_RED,ASS_GP_MY_PIAZZA_RED_INFO)
	end)

	--心跳包
	traceObj(res)
    GameSocket:addDataHandler(MDM_SOCKET_HEARD,ASS_SOCKET_HEARD,self,function() 
        GameSocket:sendMsg(MDM_SOCKET_HEARD,ASS_SOCKET_HEARD)
    end)
    RoomSocket:addDataHandler(MDM_SOCKET_HEARD,ASS_SOCKET_HEARD,self,function()
        RoomSocket:sendMsg(MDM_SOCKET_HEARD,ASS_SOCKET_HEARD)
    end)

    --25秒不收到消息就判断为掉线
    GameSocket:addDataHandler(nil,nil,self,function() 
        self:onGetTick()
    end)
    RoomSocket:addDataHandler(nil,nil,self,function()
        self:onGetTick2()
    end)

	self._autoLogin = false
	self:setPercent(100,true)
	if sdkManager:getSDKType() == SDK_LOGIN_TYPE_WX then--其他平台不做自动登录,不记录账号数据
		PlayerData:writeUser(PlayerData:getUserName(),PlayerData:getPassWord(true))
	end
	PlayerData:setAutoLogin(true)
	PlayerData:setServerDiff(res.tmServer - util.time())
	if string.len(res.szHeadWeb)>5 then
		PlayerData:setWXHeadIcon(res.szHeadWeb)
	end

	util.changeUI(ui.SelectGame)

    sdkManager:initPromotionUrl()
	self:setVisible(false)

	-- GameSocket:addReconnetCallback(self,handler(self,self.reLogin))
	

	-- if res.bNewUser then--注册时,给后台发送数据
	-- 	trace("给后台发送数据注册")
	-- 	self:postToDandanz()
	-- end

	-- self:getModuleVers()
end

local tick = 0
--心跳包判断
function Login:onGetTick()
	tick = tick + 1
	local ticknow = tick
	--traceOnly("onGetTick",ticknow)
	GameSocket:setIsChecking(false)
	util.removeAllSchedulerFuns(self.pnl_bg)
	util.delayCall(self.pnl_bg,function()
		--traceOnly(util.time(),"GameSocket断了",ticknow)
		GameSocket:sendMsg(MDM_SOCKET_CONNECT_CHECK,ASS_SOCKET_CONNECT_CHECK)--(MDM_SOCKET_HEARD,ASS_SOCKET_HEARD)
		util.delayCall(self.pnl_bg,function()
			GameSocket:setIsChecking(true)
			GameSocket:checkConnect("大厅心跳断了",PlayerData:getIsGame())--RoomSocket:isconnect())
		end,3)
	end,PlayerData:getIsGame() and 40 or 22,true)
end

function Login:onGetTick2()
	tick = tick + 1
	local ticknow = tick
	--traceOnly("onGetTick2",ticknow)
	RoomSocket:setIsChecking(false)
	util.removeAllSchedulerFuns(self.Image_bg)
	util.delayCall(self.Image_bg,function()
		--traceOnly(util.time(),"RoomSocket断了",ticknow)
		RoomSocket:sendMsg(MDM_SOCKET_HEARD,4)
		util.delayCall(self.Image_bg,function()
			RoomSocket:setIsChecking(true)
			if RoomSocket:checkConnect("房间心跳断了") then
				util.removeAllSchedulerFuns(self.Image_bg)
				return
			end
		end,3)
	end,22,true)
end

function Login:onLoginError(res,uAssistantID,stateType, head)
	Alert:showCheckBox2("消息包大小错误，需要更新客户端!",util.backToLogin,util.backToLogin)
end
--密码错误
function Login:onPassWError(res,uAssistantID,stateType, head)
	if head and head.uHandleCode == 4 then--用户帐号禁用
    	RoomSocket:disconnect()
    	GameSocket:disconnect()
		Alert:showCheckBox2("您的帐号已被禁用!",util.backToLogin,util.backToLogin)
		return
	elseif head and head.uHandleCode == 806 then--用户版本过低
		self:onVerError()
		return
	end
	--[[local iPwdErrChance = res.iPwdErrChance --
	local szErrReason = res.szErrReason

	local str = "密码错误,剩余次数:"..iPwdErrChance
	Alert:showTip(str,3)]]
	self._autoLogin = false
	PlayerData:setAutoLogin(false)

	self.sp_loading:setVisible(false)
	self.node_btns:setVisible(true)
end
function Login:onVerError(res,uAssistantID,stateType, head)
	Alert:showCheckBox2("游戏已更新,请重新登录!",util.backToLogin,util.backToLogin)
end
--登录成功,返回服务器IP和版本
function Login:onLoginin(res)
	self._ip = res.m_strMainserverIPAddr
	self._port = res.m_iMainserverPort
	local serverVer = res.m_strGameSerialNO
	assert(self._ip~=nil and self._port~=nil and self._ip~=0, "Login:onLoginin ip or port error ip = "..(ip or ""))
	local info = require("version")
	local localVer = info and info.ver
	self:setPercent(startPos,true)
	self:checkUpdate(serverVer)
end
function Login:checkUpdate(localVer)
	GameSocket:disconnect()
	util.changeUI(ui.update,{ver = localVer,func = handler(self,self.onUpdatePercent)})
end

--更新进度
function Login:onUpdatePercent(pos,action)
	if pos == 100 then
		self:setPercent(pos)
		GameSocket:connect(self._ip,self._port,handler(self,self.onConnectServer))
	else
		local start = startPos
		local endpos = 99

		pos = start + (endpos - start)*pos/100
		self:setPercent(pos,action)
	end
end

function Login:onConnectServer()
	self._connected = true
	trace("连上游戏服务器")
	if self._loadImged then
		self:checkAutoLogin()
	end
end

function Login:onSwitchAccount()
	if sdkManager:isManwei() then
		sdkManager:loginManwei()
	elseif sdkManager:getSDKType() == SDK_LOGIN_TYPE_WX then
		_uim:showLayer(ui.selAccount)
	elseif sdkManager:getSDKType() == SDK_LOGIN_TYPE_QUICKSDK then
		sdkManager:loginQuick()
	end
end

function Login:onLoginWX()
	-- mlog("onLoginWX")
	sdkManager:LoginWX()
end
--点击退出游戏
function Login:onExitGame()
	os.exit()
end
--点击登录
function Login:onStartGame()
	self:quickLogin()
end
--快速登录
function Login:quickLogin()
	--大厅登录
	local name = PlayerData:getdefUserName()
	--local passWord = PlayerData:getPassWfromName(name)
	local passWord = PlayerData:getdefPassWord()

	PlayerData:setUserName(name)
	PlayerData:setPassWord(passWord)
    --Platefrom._VersionCode = nil
    --local _regWayTemp = Platefrom:getVersionCode()
    local strIssue = sdkManager:getBindData("issue")
    local strPCID = sdkManager:getBindData("pcid")
	local info = {
		szName = PlayerData:getUserName(),
		szMD5 = PlayerData:getRegisterMD5(),
		szMD5Pass = PlayerData:getPassWord(),
		szToken = PlayerData:getMAC(),
		iAreaID = PlayerData:getAreaID(),
		iWBFlag = PlayerData:getWBFlag(),
		nickName = util.getPhoneModel() or "",
		szHeadWeb = "",
		bRegWay = sdkManager:getRegWay(),
        iIssue = strIssue == "" and 0 or tonumber(strIssue),
        iPCID = strPCID == "" and 0 or tonumber(strPCID),
	}

	PlayerData:setIsWXAcccount(false)
	GameSocket:sendMsg(MDM_GP_LOGON,ASS_GP_LOGON_REG,info)
end


function Login:getLocalVersion()
	print("Login:getLocalVersion")
	local function getVersionData(version)
		if not version then
			return 0,0
		end
		local v1,v2 = string.match(version,"(%d+)%.(%d+)")
		return tonumber(v1) or 0,tonumber(v2) or 0
	end

	local function isVerSmaller(ver1,ver2)
		local ver1_1,ver1_2 = getVersionData(ver1)
		local ver2_1,ver2_2 = getVersionData(ver2)

		if ver1_1 ~= ver2_1 then
			return ver1_1 < ver2_1
		else
			return ver1_2 < ver2_2
		end
	end

	local fileStr = File.read(File.root.."localversion.lua")	-- 读取文件内容
	local fun = fileStr and loadstring(fileStr)
	local tbl = fun and fun() or {}
	local ver = tbl.version

	local info = require("version")
	local ver2 = info.ver

	if isVerSmaller(ver,ver2) then
		ver = ver2
	end
	print("Login:getLocalVersion")
	PlayerData:setVersion(ver)
	self.Text_Version:setString("版本号:" .. ver)
end

function Login:setPercent(pos,action)
	if pos == self._pos then
		return
	end
	local function setPercent(percent)
		self.bar_loading:setPercent(percent)
		self.sp_loading:setVisible(percent>0)
		if tolua.isnull(self._ani) then
			local suc
			self._ani,suc = Animation:createLoadingBar()
			if suc then
				self.bar_loading:addChild(self._ani)
			end
		end
		if not tolua.isnull(self._ani) then
			local x = self.bar_loading:getContentSize().width*math.min(percent,98)/100-20
			local y = self.bar_loading:getContentSize().height/2+2
			self._ani:setPosition(x,y)
			self._ani:setVisible(percent > 5)
		end
	end
	if self._pos then
		setPercent(self._pos)
	end
	self._pos = pos
	util.removeAllSchedulerFuns(self.bar_loading)
	if action then
		local time = type(action)=="number" and action or 1.5
		local useTime = 0
		local oldPos = self.bar_loading:getPercent()
		util.addSchedulerFuns(self.bar_loading,function(dt)
			useTime = useTime + dt
			useTime = math.min(time,useTime)
			setPercent(oldPos + useTime/time*(pos-oldPos)) 
		end,true,0,time)
		return
	end
	setPercent(pos)
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
	if self._autoLogin and PlayerData:getAutoLogin() and self:LoginLastAccount() then

	else
		self.sp_loading:setVisible(false)
		self.node_btns:setVisible(true)

	end
end

function Login:LoginLastAccount()
	local userData = PlayerData:getUsers()
	local lastUserData = userData[1]
	if not lastUserData then
		return false
	end
	local name = lastUserData.name
	local passWord = lastUserData.password
	local url = ""--PlayerData:readWXHeadIcon()
	PlayerData:setIsWXAcccount(string.sub(name,1,3) == "wx_")
	--PlayerData:setWXHeadIcon(url)

	if not name or not passWord then
		return false
	end

	PlayerData:setUserName(name)
	PlayerData:setPassWord(passWord)
    Platefrom._VersionCode = nil
	local info = { 
		zName = PlayerData:getUserName(),
		szMD5 = PlayerData:getLoginMD5(),
		--TML_SN = PlayerData:getMAC(),			
		szMD5Pass = PlayerData:getPassWord(),
		szMathineCode = PlayerData:getMathineCode(),
		uRoomVer = PlayerData:getRoomVer(),
		bLogonType = PlayerData:getLogonType(),
		szHeadWeb = url,
		bRegWay = sdkManager:getRegWay(),
        iIssue = sdkManager:getIssue(),
	};
	GameSocket:sendMsg(MDM_GP_LOGON,ASS_GP_LOGON_BY_NAME,info)
	trace("登录旧账号")
	return true
end

return Login