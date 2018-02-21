--分包下载,下载子游戏资源
--2018.2.6 新增下载其他apk功能
local downLoadModule = class("downLoadModule")
local _verstionFile = "ver.txt"
local _maxFailTime = 5
local _versionFilePath = File.root.._verstionFile
local _branceDir = require("version").dir or "trunk"
local _downloadUrl = "http://ndownload." .. util.curDomainName() .. "/".._branceDir.."/"

MODULE_KANPAI = {
	{
		url = "modules/watchbrandgame/img/",
		path = "res/img2/watchbrandgame/",
	},
	{
		url = "modules/watchbrandgame/sound/",
		path = "res/audio/bullsounds/",
	},
	{
		url = "modules/gaf/bairenandwuren/",
		path = "res/img2/gaf/bairenandwuren/",
	},
}

MODULE_BAIREN = {
	{
		url = "modules/hundredniuniu/img/",
		path = "res/img2/hundredniuniu/",
	},
	{
		url = "modules/hundredniuniu/sound/",
		path = "res/audio/hundredsounds/",
	},
	{
		url = "modules/gaf/bairenandwuren/",
		path = "res/img2/gaf/bairenandwuren/",
	},
}

MODULE_FRIUTMAC = {
	{
		url = "modules/fruits/img/",
		path = "res/img2/fruits/",
	},
	{
		url = "modules/fruits/sound/",
		path = "res/audio/fruit/",
	},
}

MODULE_CARZY = {
	{
		url = "modules/carzy/img/",
		path = "res/img2/carzyRes/",
	},
	{
		url = "modules/carzy/sound/",
		path = "res/audio/crazyGame/",
	},
}

local _downloadedModule = {
	
}

local _down_node
local _hasDownloadVer = false

local _allModule = {
	[MODULE_KANPAI] = 0,--下载解压数
	[MODULE_BAIREN] = 0,
	[MODULE_FRIUTMAC] = 0,
	[MODULE_CARZY] = 0,
}

function downLoadModule:ctor(parent)
	if not Platefrom:hasModuleDownload() then
		--return
	end
	self.tempVersionDirName = "historyVersionDir/"
	self.tempVersionDirPath = File.root..self.tempVersionDirName
	self.tempPackageDirPath = self.tempVersionDirPath.."apk/"
	self._updateMaxIndex = 0
	self._scaleCirle = 1

	self._module = nil
	self._parentNode = parent
	self._FailTime = _maxFailTime
	self._vers = {}
end

--预下载所有版本号
function downLoadModule:downLoadVersions(callBack)
	if not Platefrom:hasModuleDownload() or _hasDownloadVer then
		if callBack then
			callBack()
		end
		return
	end
	--assert(tolua.isnull(_down_node),"downLoadModule has already a download thread")
	_down_node = cc.Node:create()
	_down_node:retain()

	self._co = coroutine.create(function()
		for _module in pairs(_allModule) do
			local updateNum = 0
			for index,info in pairs(_module) do
				local url = info.url
				local path = info.path
				local verList = {}
				local localVer = self:getVerByPath(self.tempVersionDirName..path)

				--self:download(url,_verstionFile)
				--local serverVer,size = self:getServerVer()
				self:get(url.._verstionFile)
				local serverVer,size = self:getServerVer(url.._verstionFile)
				info.serverVer = serverVer
				info.size = localVer == serverVer and 0 or size
				local num = localVer == 0 and 1 or (serverVer - localVer)
				updateNum = updateNum + num*2
			end
			_allModule[_module] = updateNum
		end
		_hasDownloadVer = true
		_down_node:release()
		if callBack then
			callBack()
		end
	end)
	coroutine.resume(self._co)
end

--module 为MODULE_KANPAI
function downLoadModule:downLoadMod(module,func)
	self:downLoadVersions(function()
		if not tolua.isnull(_down_node) then
			Alert:showTip("正在下载其他游戏,清稍后再试!")
			trace("hasDownLoadver = ",_hasDownloadVer)
			traceObj(self._module,"module")
			trace(tolua.isnull(self._parentNode))
			return
		end

		if not Platefrom:hasModuleDownload() then
			if func then
				func()
			end
			return
		end

		self._module = module
		assert(type(module)=="table","downLoadModule:downLoadMod error module")
		self._callBack = func

		if _downloadedModule[self._module] then
			self:onDownloadFinish()
			return
		end
		local size = self:getDownLoadSize()
		if size>0 then
			local str = string.format("本次下载大小：%s，建议在WIFI环境下载，确定下载？",util.numberFormat( size*1000))
			Alert:showCheckBox(str,function() self:start() end)
		else
			self:onDownloadFinish()
		end
	end)
end

function downLoadModule:close()
	if not tolua.isnull(_down_node) then
		_down_node:release()
	end
	if not tolua.isnull(self._downloadNode) then
    	self._downloadNode:setStencil(nil)
		util.tryRemove(self._downloadNode)
	end
	if not tolua.isnull(self._parentNode) and self._parentNode.setEnabled then
		trace("downLoadModule 关闭")
		self._parentNode:setEnabled(true)
	end

	GameEvent:notifyView(GameEvent.hideLoading)
end
-----------------------------
--private
-----------------------------

function downLoadModule:addPercent()
	local parent = self._parentNode
	if tolua.isnull(parent) then
		trace("downLoadModule addPercent ,parent is nil")
		self:close()
		return
	end
	--按钮做遮罩有问题?
	local clippingNode = cc.ClippingNode:create()
	self._downloadNode = clippingNode
    parent:getParent():addChild(clippingNode,1000)
    clippingNode:setAlphaThreshold(0.2)
    clippingNode:setStencil(parent)

	local grayLayout = ccui.Layout:create()
	grayLayout:setPosition(-1000,-1000)
	grayLayout:setContentSize(cc.size(2000,2000))
	grayLayout:setBackGroundColor(cc.c4b(0, 0, 0, 255))
	grayLayout:setBackGroundColorType(1)
	grayLayout:setBackGroundColorOpacity(120)

	clippingNode:addChild(grayLayout)

	if parent.setEnabled then
		parent:setEnabled(false)
	end

	local circleBk = cc.Sprite:create()
	util.loadSprite(circleBk,"img2/tongyong/2.png")
	clippingNode:addChild(circleBk)
	util.moveToNode(circleBk,parent)


    local sp = cc.Sprite:create()
    util.loadSprite(sp,"img2/tongyong/1.png")
    self.spProgress = cc.ProgressTimer:create(sp)
    self.spProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.spProgress:setPercentage(0)
    --self.spProgress:setReverseDirection(true)
	clippingNode:addChild(self.spProgress)
	util.moveToNode(self.spProgress,parent)

	local text = ccui.Text:create()
	clippingNode:addChild(text)
	util.moveToNode(text,parent)
	text:setFontName("img2/font/MSYH.TTF")
	text:setFontSize(32)
	text:setTextHorizontalAlignment(1)
	self._lblPercent = text

	circleBk:setScale(self._scaleCirle or 1)
	text:setScale(self._scaleCirle or 1)
	self.spProgress:setScale(self._scaleCirle or 1)
end

function downLoadModule:setPercent(pos)
	if self._updateMaxIndex == 0 then
		return
	end
	if tolua.isnull(self.spProgress) then
		self:addPercent()
		return
	end
	pos = pos/self._updateMaxIndex
	pos = pos + (self._currIndex-1)/self._updateMaxIndex * 100
	--trace("setPercent",pos,self._updateMaxIndex,self._currIndex)
	pos = math.max(pos,self.spProgress:getPercentage())
	self.spProgress:setPercentage(pos)
	local lb_info = math.floor(pos)
	if lb_info > 100 then
		lb_info = 100
	end
	self._lblPercent:setString(lb_info .."%")
end


--fileName 只有整包下载才有
function downLoadModule:onDownloadFinish(fileName)
	self:close()
	if not tolua.isnull(self._parentNode) and self._callBack then
		self._callBack(fileName)
	end
	_downloadedModule[self._module] = true
end

function downLoadModule:onDownloadFail()
	if not tolua.isnull(self._parentNode) then
		Alert:showTip("下载失败,请稍后再试",2)
	end
	self:close()
end

function downLoadModule:getDownLoadSize()
	local totalsize = 0
	for index,info in pairs(self._module) do
		local url = info.url
		local path = info.path
		local verList = {}
		local localVer = self:getVerByPath(self.tempVersionDirName..path)
		local serverVer = info.serverVer
		local size = info.size
		if size == nil then 
			--self:download(url,_verstionFile)
			--serverVer,size = self:getServerVer()
			self:get(url.._verstionFile)
			serverVer,size = self:getServerVer(url.._verstionFile)
			if localVer == serverVer then
				size = 0
			end
		end
		totalsize = totalsize + (size or 0)
	end
	return totalsize
end

--开始分包下载
function downLoadModule:start()
	--assert(tolua.isnull(_down_node),"downLoadModule has already a download thread")
	
	_down_node = cc.Node:create()
	_down_node:retain()
	self._updateMaxIndex = _allModule[self._module]--0
	self._currIndex = 0
	self._co = coroutine.create(function()
		for index,info in pairs(self._module) do
			local url = info.url
			local path = info.path
			local verList = {}
			local localVer = self:getVerByPath(self.tempVersionDirName..path)
			local serverVer = info.serverVer
			if serverVer == nil then 
				--self:download(url,_verstionFile)
				--serverVer = self:getServerVer()
				self:get(url.._verstionFile)
				serverVer = self:getServerVer(url.._verstionFile)
			end
			if serverVer ~= 0 then
				if localVer == 0 or serverVer < localVer then
					local ver = 0
					self._currIndex = self._currIndex + 1
					--self._updateMaxIndex = self._updateMaxIndex + 2
					self:download(url,ver..".zip")
					self._currIndex = self._currIndex + 1
					self:unpickPackage(File.root..ver..".zip",path)
				else
					if serverVer > localVer then
						--self._updateMaxIndex = self._updateMaxIndex + (serverVer - localVer)*2
						for ver = localVer+1,serverVer do
							self._currIndex = self._currIndex + 1
							self:download(url,ver..".zip")
							self._currIndex = self._currIndex + 1
							self:unpickPackage(File.root..ver..".zip",path)
						end
					end
				end
			end

		end
		self._currIndex = self._currIndex + 1
		self:setPercent(100)
		util.delayCall(_down_node,function() self:onDownloadFinish() end)
	end)
	coroutine.resume(self._co)
end

-- 删除目录并且重建目录
function downLoadModule:createDir(path)
	if not File.isDirExist(path) then
		File.createDir(path)
	end
end


function downLoadModule:unpickPackage(file,path)
	local function unpackFileCallback(result)
		if result.state == "completed" then -- 解压完成
			if result.msg == "ok" then
				trace("解压完成"..path)
				self:setPercent(100)
				-- 删除下载包
				if File.exists(file) then
					File.removeFile(file)
				end
				coroutine.resume(self._co)
			else
				trace("解压失败",result.msg)
				Alert:showTip("解压失败",2)
				self:onDownloadFail()
			end
		else
			--trace("解压中:"..result.m_cur.."/"..result.m_max)
			self:setPercent(result.m_cur/result.m_max * 100)
		end			
	end
	path = self.tempVersionDirPath..path
	self:createDir(path)
	AsynZip:unpack(unpackFileCallback, file, path)
	coroutine.yield()
end


function downLoadModule:getServerVer(url)
	--return self:getVerByPath("")
	local info = self._vers[url]
	return type(info)=="table" and info.ver or 0,type(info)=="table" and info.size or 0
end

function downLoadModule:getVerByPath(path)
	path = File.root..path.._verstionFile
	local fileStr = File.read(path)
	local info = fileStr and loadstring(fileStr)()

	return type(info)=="table" and info.ver or 0,type(info)=="table" and info.size or 0
end

function downLoadModule:get(url)
	util.get(_downloadUrl..url,function(suc,data)
		if suc then
			local info = data and loadstring(data)()
			self._vers[url] = info
		end

		coroutine.resume(self._co)
	end)

	coroutine.yield()
end
--url为下载的全路径或_downloadUrl之后的相对路径,file为文件名
function downLoadModule:download(url,file,continue)
	if not continue and File.exists(File.root..file) then
		trace("移除文件"..file)
		File.removeFile(File.root..file)
	end
	local function downCallback(result)
		if tolua.isnull(_down_node) then
			return
		end
		--trace("result.state",result.state)
		if result.state == 0 then
		elseif result.state == 1 then
		elseif result.state == 2 then -- 下载中 更新显示
			self:setPercent(result.gprogress)
		elseif result.state == 3 then -- 下载完成
			util.delayCall(_down_node,function()
				--trace("下载完成",url,file)
				--util.traceTime("下载完成")
				self:setPercent(100)
				coroutine.resume(self._co)
			end)
		elseif result.state == 4 then
			trace("下载失败"..file)
			self._FailTime = self._FailTime - 1 
			if self._FailTime<=0 then
				self:onDownloadFail()
				trace("下载失败,结束下载")
				return
			end
			util.removeAllSchedulerFuns(_down_node)
			util.delayCall(_down_node,function()
				self:download(url,file,true)
			end,1)

		else
			trace("下载异常"..file)
		end
	end

	trace("开始下载"..file)
	if IP_SERVER ~= _GameServerIP then
		_downloadUrl = "http://ndownload.ddz.com/".. _branceDir.. "/"
	end
	if not string.find(url,"http://") then
		url = _downloadUrl..url
	end
	Loader:shared():setRemotePath(url)
	Loader:shared():load(file,downCallback)
	if not continue then
		coroutine.yield()
	end
end

---------------
--
--复活下载安装包
--
--url 为下载链接 
local _apkPath = File.root.."temddz.apk"

function downLoadModule:downLoadApk(url)
	local host,file = string.match(url,"(.-)([^/]+%.apk)")
	if not (url and file) then
		trace("downLoadApk",url)
		Alert:showTip("下载失败")
		return
	end
	if not tolua.isnull(_down_node) then
		Alert:showTip("正在下载中!")
		return
	end

	if  __Platform__ ~= 3 then
		Alert:showTip("只有安卓平台才能下载!")
		return
	end
	self._callBack = handler(self,self.installAPK)

	_down_node = cc.Node:create()
	_down_node:retain()
	self._module = url
	self._updateMaxIndex = 1
	self._currIndex = 1
	self._scaleCirle = 0.7
	local path = self.tempPackageDirPath
	self._co = coroutine.create(function()
		self:download(host,file)
		self:setPercent(100)
		util.delayCall(_down_node,function() 
			self:onDownloadFinish(file)
		end)
	end)
	coroutine.resume(self._co)
end

function downLoadModule:installAPK(fileName)
	trace("安装APK")
	local path = File.root..fileName
	
	File.removeFile(_apkPath)
	File.moveFile(path,_apkPath)
	Platefrom:intallAPK(_apkPath)
end

return downLoadModule