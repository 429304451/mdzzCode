local _downloadUrl = "http://ndownload." .. util.curDomainName() .. "/"--"192.168.0.111:8088/"--
local _verFile = "version.txt"
local _apkPath = File.root.."temddz.apk"

local DEF_VERSION = "1.0"
local MAX_FAIL_TIME = 5

local update = class("update",function()
    return ui.createCsb(ui.update).root
end)

function update.create(...)
    local node = update.new(...)
    return node
end

function update:ctor(info)
	if info then
		self._verBserver = info.ver--B服务器版本号
		self:setPercentCallBack(info.func)
	end
	self:init()

	Alert:showTip("正在检测更新...",1)
	self:clearDownLoadLocalVersion()

	PlayerData:setVersion(self.localInfo.version)

	self:checkUpdate()
end

function update:init()
	self._localVersion = nil--当前更新到的版本号
	self._serverData = nil
	self._targetVersion = nil
	self._finalVersion = nil
	self.hasCheck = nil
	self._updateList = {}
	self._hasDown = {}
	self._downloadDir = nil
	self._currUpdate = 0-- 当前更新的文件,更新+1,解压+1
	self._updateNum = 0--需要更新的总文件*2
	self._apk = nil
	self._pos = 0
	self._failTime = 0

	self.tempVersionDirName = "tempVersionDir"
	self.versionFilePath = File.root.._verFile
	self.localversionFilePath = File.root.."localversion.lua"
	self.tempVersionDirPath = File.root..self.tempVersionDirName
	--缓存文件版本号
	self.localInfo = self:getVersion(self.localversionFilePath)
	--与安装包中版本号对比,获取更大的一个
	self.localInfo = self:getLocalVersion(self.localInfo)
	util.aptNotScale(self.img_bg,true)
end

function update:checkUpdate()
	--[[if _Platform__ == 4 or __Platform__ == 5 then
		Alert:showTip("正在登录游戏...",0.5)
		self:onPercent(100)
		return
	end]]
	trace("检测更新:bser,localver =",self._verBserver , self.localInfo.version,self._verBserver==self.localInfo.version)
	if self._verBserver == self.localInfo.version then
		Alert:showTip("正在登录游戏...",0.5)
		self:onPercent(100)
	else
		self:downLoadversion()
	end
end


function update:clearDownLoadLocalVersion()
	File.removeFile(self.tempVersionDirPath.."/src/version.lua")
	File.removeFile(self.tempVersionDirPath.."/src/version.luac")
	--这里的删除只有下次打开才会生效.
end
--[[登录
function update:LoginServer()
	Alert:showTip("正在登录服务器",1)
	if _GameServerIP and _GameServerPort then
		GameSocket:connect(_GameServerIP,_GameServerPort,function()
			util.popWin({self})
			trace("连上B服务器,发送",MDM_GP_REQURE_GAME_PARA,ASS_GP_REQURE_GAME_PARA)
			GameSocket:sendMsg(MDM_GP_REQURE_GAME_PARA,ASS_GP_REQURE_GAME_PARA,nil)
		end)
	end
end]]

function update:addEvents()
	util.clickSelf(self,self.btn_exit,self.onExitGame)
end

--点击退出游戏
function update:onExitGame()
	os.exit()
end

function update:cancelUpdate()
	self.img_bg:setVisible(false)
	Alert:showTip("正在登录游戏...",0.5)
	if self._percentCallback then
		self._percentCallback(100)
	else
		self.pro_download:setPercent(pos)
	end
	util.popWin({self})
end

--可以跳过更新
function update:setCanSkipUpate()
	R:setBtnCancel(self.btn_exit)
	util.clickSelf(self,self.btn_exit,self.cancelUpdate)
end

function update:downLoadversion()
	trace("下载版本文件")
	File.removeFile(self.versionFilePath)
	util.addSchedulerFuns(self,function()
		self.hasCheck = false
		self:downLoad(_verFile,handler(self, self.onDownLoadVersion))
	end)
end


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

local __lt = function(a,b)
 	return isVerSmaller(a.version,b.version)  
end
local __eq = function(a,b)
 	return a.version == b.version
end


function update:getVersion(path)
	local fileStr = File.read(path)	-- 读取文件内容
	local fun = fileStr and loadstring(fileStr)
	local tbl = fun and fun() or {}

	return setmetatable(tbl,{__index = {version = DEF_VERSION},__lt = __lt,__eq = __eq}) 
end

--需要下载整包
function update:needDownLoad()
	return false
end

--版本对比
function update:checkVersion()
	if self.hasCheck then
		return
	end
	self.hasCheck = true
	if not File.exists(self.versionFilePath)  then
		trace("找不到文件,重下载")
		self:downLoadversion()
		return
	end
	Alert:hideTip()
	trace("版本对比")
	local serInfo =	self:getVersion(self.versionFilePath)

	local verServer,minVer = self:getServerVersion(serInfo)
	if not (verServer and minVer) then
		trace(verServer,minVer)
		self:onUpdateFail(1)
		return
	end

	--这里是游戏内更新
	if self:needDownLoad() then
		totalSize = serInfo.totalSize or ""
		self._updateNum = 1
		self._currUpdate = self._currUpdate + 1
		self._apk = serInfo.fullPackage
		util.clickSelf(self,self.btn_update,self.downLoadAPK)
		return
	end
	local needFullUpdate = self:needFullUpdate(serInfo)
	local localInfo = self.localInfo
	if not (localInfo < serInfo) and not needFullUpdate then
		trace("已是最新版本")
		self:onPercent(100)
		return
	end
	-- --可选升级
	-- if mushUpdateVer and isVerSmaller(mushUpdateVer,localInfo.version) then
	-- 	self:setCanSkipUpate()
	-- end

	if needFullUpdate or isVerSmaller(localInfo.version , minVer) then
		trace("需要重新下载")
		totalSize = serInfo.totalSize or ""
		self.lbl_tip:setString(string.format("本次更新: %s\r\n需要重新下载安装包",totalSize))
		self.img_bg:setVisible(true)
		self._updateNum = 1
		self._currUpdate = self._currUpdate + 1
		self._apk = serInfo.fullPackage
		util.clickSelf(self,self.btn_update,self.downLoadAPK)
	else
		trace("需要更新")
		--需要清除数据
		--[[local clearVer = serInfo.clear
		if clearVer then
			if isVerSmaller(localInfo.version , clearVer) then
				self:clearCatch()
				reloadGame()
				return
			end
		end]]

		self._updateList = serInfo.package
		self._localVersion = localInfo.version
		self._finalVersion = serInfo.version
		util.clickSelf(self,self.btn_update,self.beginUpdate)

		local totalSize = 0
		for i,j in pairsKey(self._updateList) do
			if isVerSmaller(self._localVersion,i) then
				totalSize = totalSize + j
				self._updateNum = self._updateNum + 2
			end
			if self._verBserver == i then
				break
			end
		end
		if self._updateNum == 0 then
			self:onPercent(100)
			return
		end
		totalSize = util.numberFormat( totalSize*1000)
		self.lbl_tip:setString(string.format("本次更新: %s\r\n需要更新才可进入游戏",totalSize))
		self.img_bg:setVisible(true)
	end

	return 
end

--需要整包更新
function update:needFullUpdate(serInfo)
	local iosVer = tonumber(serInfo.iosMinVer) or 0
	local androidVer = tonumber(serInfo.androidMinVer) or 0

	local needUpdate = false
	local verName = Platefrom:getVersionName()
	if __Platform__ == 3 then
		needUpdate = verName<androidVer
	elseif __Platform__ == 4 or __Platform__ == 5 then
		needUpdate = verName<iosVer
	end

	return needUpdate
end

--获取本地版本(安装包跟缓存文件两个中更大的一个)
function update:getLocalVersion(version)
	local info = require("version")
	assert(type(info) == "table" and info.ver and info.dir,"local version error")
	local GAME_VERSION = info.ver
	local lastDir = util.getKey("verDir")
	local bLocal = info.bLocal
	if bLocal then
		_downloadUrl = "192.168.0.111:8088/"
	end
	if (lastDir and lastDir ~= "" and lastDir ~= info.dir) then
		self:clearCatch()
	end
	util.setKey("verDir",info.dir)
	self._downloadDir = info.dir.."/"
	
	--version文件是的版本号可能不是最终更新的版本号(因为上次更新可能是按B服务器版本号来更新的,所以读取本地配置的版本号)
	local lastUpdateVer = util.getKey("Ver")
	if lastUpdateVer and lastUpdateVer ~= "" then
		version.version = lastUpdateVer
	end

	if isVerSmaller(version.version,GAME_VERSION) then--缓存文件中的版本号小于当前包内的版本号
		self:clearCatch()
		util.setKey("Ver",GAME_VERSION)
		if version.version ~= DEF_VERSION then
			util.delayCall(self,function() 
		    	trace("reloadGame1")
		    	reloadGame()
		    end,0.1)
		end
		version.version = GAME_VERSION
	end
	return version
end

--更新成功写版本号
function update:onUpdateVer()
	local newVer
	local lastVer = util.getKey("Ver")
	if not lastVer or lastVer ~= self._localVersion then
		newVer = self._localVersion
		util.setKey("Ver",newVer)
	end
end


--清除缓存数据
function update:clearCatch()
	trace("清除旧版本数据")
	self:reCreateDir(self.tempVersionDirPath)
	--self:reCreateDir(_apkPath)
	File.removeFile(_apkPath)
	File.removeFile(self.localversionFilePath)
end

--获取服务器版本
--返回:服务器当前版本,更新最低版本
function update:getServerVersion(serverData)

	return serverData and serverData.version,serverData and serverData.minVer
end


--开始更新
function update:beginUpdate()
	self.img_bg:setVisible(false)
	self.btn_update:setVisible(false)
	self.btn_exit:setVisible(false)
	if (self._localVersion == self._verBserver) or (self._localVersion == self._finalVersion) then
		self:onUpdateFinish()
		return
	end
	self._targetVersion = nil
	for ver in pairsKey(self._updateList) do
		if ver ~= self._localVersion and isVerSmaller(self._localVersion,ver) then
			self._targetVersion = ver
			break
		end
	end
	
	if self._targetVersion then
		self._currUpdate = self._currUpdate + 1
		self:onPercent(1,self._currUpdate)
		self:downLoad(self._targetVersion..".zip")
	else
		trace("更新失败,找不到版本")
	end
end

--开始更新
function update:onUpdateSuccess()
	self._localVersion = self._targetVersion
	self:beginUpdate()
end

--打开下载地址
function update:openDownloadUrl()
	--[[local url = _downloadUrl..self._downloadDir..self._apk
	if not string.find(url,"http") then
		url = "http://"..url
	end]]
	local url = "http://wx." .. util.curDomainName() .. "/weixin/download.aspx"
	if not sdkManager:isAndroidOffic() then
		url = _downloadUrl.."channel/"..sdkManager:getConfingPath().."ddz.apk"
	end
	
	if url then
		local app = cc.Application:getInstance()
		trace("下载APK",url)
		app:openURL(url)
	else
		Alert:showTip("下载安装包失败",1)
	end
end

function update:downLoadAPK()
	if sdkManager:is_IOS() then
		local url = "https://itunes.apple.com/cn/app/%E6%9D%A5%E7%8E%A9%E6%96%97%E5%9C%B0%E4%B8%BB-%E7%BB%8F%E5%85%B8%E6%A3%8B%E7%89%8C/id1311268079?l=zh&ls=1&mt=8"
		local app = cc.Application:getInstance()
		app:openURL(url)
		return
	end
	if not Platefrom:hasPhoneFunc() then
		self:openDownloadUrl()
		return
	end
	if not sdkManager:isAndroidOffic() then
		self._downloadDir = "channel/"..sdkManager:getConfingPath().."/"
	end
	self.img_bg:setVisible(false)
	self.btn_update:setVisible(false)
	self.btn_exit:setVisible(false)
	if self._apk then
		self:onPercent(10,self._currUpdate,10)
		self:downLoad(self._apk,handler(self, self.downApkCallback))
	else
		Alert:showTip("下载安装包失败",1)
	end
end

function update:installAPK()
	trace("安装APK")
	local path = File.root..self._apk
	local newPath = _apkPath
	
	File.moveFile(path,newPath)
	Platefrom:intallAPK(newPath)
end

function update:downLoad(file,callback)
	trace("开始下载".._downloadUrl..self._downloadDir..file)
	--File.removeFile(File.root..file)
	util.delayCall(self.img_bg,function() 		
		Loader:shared():setRemotePath(_downloadUrl..self._downloadDir)
		Loader:shared():load(file,callback or handler(self, self.downCallback))
	end)
end

function update:onDownLoadVersion(result)
	if tolua.isnull(self) then
		return
	end
	if result.state == 0 then
	elseif result.state == 1 then
	elseif result.state == 2 then
	elseif result.state == 3 then -- 下载完成
		self:checkVersion()
	elseif result.state == 4 then
		self:onUpdateFail(2)
	else
		self:onUpdateFail(3)
	end
end

function update:downApkCallback(result)
	if tolua.isnull(self) then
		return
	end
	--self.downSize = result.downsize
	--self.totalSize = result.totalsize
	--self.gprogress = result.gprogress
	if result.state == 0 then
	elseif result.state == 1 then
	elseif result.state == 2 then -- 下载中 更新显示
		self._failTime = 0
		trace("已下载："..result.gprogress)
		self:onPercent(math.max(result.gprogress,10),self._currUpdate,1)
		self.lbl_updateNode:setString("正在下载版本 "..self._apk)
		GameEvent:notifyView(GameEvent.hideLoading)
	elseif result.state == 3 then -- 下载完成
		self._failTime = 0
		if not self._hasDown[self._apk] then
			self._hasDown[self._apk] = true
			trace("下载完成"..self._apk)
			-- 解压文件
			self:onPercent(99,self._currUpdate)
			util.addSchedulerFuns(self,function() self:installAPK() end)
		end
		GameEvent:notifyView(GameEvent.hideLoading)
	elseif result.state == 4 then
		--Alert:showTip("下载失败,正在重新下载...",1)
		util.removeAllSchedulerFuns(self.img_bg)
		if self._failTime > MAX_FAIL_TIME then
			self._failTime = 0
			GameEvent:notifyView(GameEvent.hideLoading)
			self:onUpdateFail(4)
			return
		end
		GameEvent:notifyView(GameEvent.showLoading)
		util.delayCall(self.img_bg,function(dt) 
			trace("下载失败"..self._apk)		
			self:downLoadAPK()
			self._failTime = self._failTime + 1
		end,1)

	else
		trace("下载异常",self._targetVersion)
	end
end


function update:downCallback(result)
	if tolua.isnull(self) then
		return
	end
	--self.downSize = result.downsize
	--self.totalSize = result.totalsize
	--self.gprogress = result.gprogress
	if result.state == 0 then
	elseif result.state == 1 then
	elseif result.state == 2 then -- 下载中 更新显示
		self._failTime = 0
		trace("已下载："..result.gprogress)
		self:onPercent(result.gprogress,self._currUpdate)
		self.lbl_updateNode:setString("正在下载版本 "..self._targetVersion)
		GameEvent:notifyView(GameEvent.hideLoading)
	elseif result.state == 3 then -- 下载完成
		self._failTime = 0
		if not self._hasDown[self._targetVersion] then
			self._hasDown[self._targetVersion] = true
			trace("下载完成",self._targetVersion)
			-- 解压文件
			self:onPercent(100,self._currUpdate)
			util.addSchedulerFuns(self,function() self:unpackFile() end)
		end
		GameEvent:notifyView(GameEvent.hideLoading)
	elseif result.state == 4 then
		util.removeAllSchedulerFuns(self.img_bg)
		if self._failTime > MAX_FAIL_TIME then
			self._failTime = 0
			GameEvent:notifyView(GameEvent.hideLoading)
			self:onUpdateFail(4)
			return
		end
		GameEvent:notifyView(GameEvent.showLoading)
		util.delayCall(self.img_bg,function(dt) 		
			trace("下载失败",self._targetVersion)
			self._currUpdate = self._currUpdate - 1
			self:beginUpdate()
			self._failTime = self._failTime + 1
		end,1)

	else
		trace("下载异常",self._targetVersion)
	end
end

-- 删除目录并且重建目录
function update:reCreateDir(path)
	if File.isDirExist(path) then
		-- trace("delete exist path:", path)
		File.removeDir(path)
	else
		-- trace("no exist path:", path)
	end
	File.createDir(path)
end

-- 解压文件到temp文件夹
function update:unpackFile()
	self._currUpdate = self._currUpdate + 1
	trace("解压开始",self._targetVersion)
	self.lbl_updateNode:setString("正在解压版本 "..self._targetVersion)
	self.localZipPath = File.root..self._targetVersion..".zip"
	AsynZip:unpack(handler(self, self.unpackFileCallback), self.localZipPath, self.tempVersionDirPath.."/")
end

-- 解压文件回调
function update:unpackFileCallback(result)
	--traceObj(result)
	if result.state == "completed" then -- 解压完成
		if result.msg == "ok" then
			trace("解压完成",self._targetVersion)
			-- 删除下载包
			if File.exists(self.localZipPath) then
				File.removeFile(self.localZipPath)
			end
			self:onPercent(100,self._currUpdate)
			self:onUpdateSuccess()
		else
			trace("解压失败:",self._targetVersion,result.msg)
			Alert:showTip("解压失败",1)
			self._currUpdate = self._currUpdate - 2
			self:beginUpdate()
		end
	else
		--trace("解压中:"..result.m_cur.."/"..result.m_max)
		self:onPercent(result.m_cur/result.m_max*100,self._currUpdate)
	end			
end


function update:onUpdateFail(id)
	Alert:showTip("更新失败",5)
	trace("更新失败 errorID = "..id)
	--File.removeFile(self.versionFilePath)
	--util.delayCall(self,function() self:LoginServer() end,1)
end

function update:onUpdateFinish()
	File.copyFile(self.versionFilePath,self.localversionFilePath)
	--File.removeFile(self.versionFilePath)
	Alert:showTip("更新完成",1)
	self.lbl_updateNode:setString("更新完成")
	self:onUpdateVer()
	util.delayCall(self,function() 
		trace("reloadGame2")
		if RoomSocket then
			RoomSocket:disconnect()
		end
		if GameSocket then
			GameSocket:disconnect()
		end
		reloadGame() 
	end)
end

function update:setPercentCallBack(func)
	self._percentCallback = func
end

function update:onPercent(pos,index,action)
	if index then
		pos = 100*(index-1)/self._updateNum + pos/self._updateNum
	end
	pos = math.max(self._pos,pos)
	self._pos = pos
	trace("update:onPercent",pos,index)
	if self._percentCallback then
		self._percentCallback(pos,action)
	else
		self.sp_barbg:setVisible(true)
		self.pro_download:setPercent(pos)
	end
end


return update
