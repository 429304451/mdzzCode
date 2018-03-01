local GameSocket = class("GameSocket")
require("Common.SocketStruct")
local socket = require("socket")

local _headerSize = Struct.getSize(MSG_GAME_STRUCT.NetMessageHead)
local SOCKET_TICK_TIME = 0.2
local _noassID = "notID"
local SOCKET_RECONNECT_TIME = 3
local SOCKET_CONNECT_FAIL_TIMEOUT = 1

local isipv6_only
local addrifo = socket.dns.getaddrinfo("www.baidu.com")

if addrifo ~= nil then
    trace("lw addrifo")
    for k,v in pairs(addrifo) do  
        if v.family == "inet6" then  
            isipv6_only = true  
            break  
        end  
    end
end  



function GameSocket:ctor(map,name)
	self._map = map or {}
	self._debugName = name
	self.callBacks = {}
	self.rpcDataHandlerMap = {}
	self.isConnected = false
	self.uCheck = nil
	self._reconnectCallBack = {}
	self._disconnectCallBack = {}
	self._isReConnet = false
	self._connectTime = 0--连接成功时间
	self._connectNum = 0
end

function GameSocket:setMsgMap(map)
	self._map = map
end

--发送
--只有当发送的uMainID,uAssistantID 与收到的一致时,才会触发callBack
function GameSocket:sendMsg(uMainID,uAssistantID,tblBody,callBack)
	-- traceOnly("GameSocket:sendMsg",util.time(),self._debugName,"send",uMainID,uAssistantID)
	if callBack and type(callBack) == "function" then
		if self.callBacks[uMainID] and self.callBacks[uMainID][uAssistantID] then
			--trace(self._debugName,"sendMsg remove old msg callback",uMainID,uAssistantID)
		end
		self.callBacks[uMainID] = self.callBacks[uMainID] or {}
		self.callBacks[uMainID][uAssistantID] = callBack
	end

	--消息主体
	local body = ""
	local bodySize = 0
	local structName = ""
	if self._map[uMainID] and self._map[uMainID][uAssistantID]  then
		if  self._map[uMainID][uAssistantID].send then
			body = Struct.encode(tblBody,self._map[uMainID][uAssistantID].send)
			--bodySize = Struct.getSize(self._map[uMainID][uAssistantID].send)
			structName = Struct.getStructName(self._map[uMainID][uAssistantID].send)
		end

		local waitfor = self._map[uMainID][uAssistantID].waitfor
		if waitfor then
			if table.nums(waitfor) == 0 then
				waitfor = {self,uMainID,uAssistantID}
			else
				if type(waitfor[1]) == "number" then
					waitfor = {self,unpack(waitfor)}
				end
			end
			trace("show loading mainid,assid = ",uMainID,uAssistantID)
			GameEvent:notifyView(GameEvent.showLoading,waitfor)
		end
	elseif tblBody then
		--trace(self._debugName,"error:GameSocket:sendMsg unknow map uMainID = "..(uMainID or "nil"))
		return
	end
	bodySize = string.len(body)
	--这个消息头内容一直累加上去
	--if not (uMainID == 1 and uAssistantID == 1) then
	--end
	--消息头
	local tblHead = {
		uMessageSize = _headerSize + bodySize,--bodySize
		uMainID = uMainID,
		uAssistantID = uAssistantID,
		uHandleCode = 0,
		dwClientIP = 0,
		uCheck = self.uCheck or 0,
	}
	self.uCheck = self.uCheck and self.uCheck + 1
	if not self:isFilter(uMainID,uAssistantID) then
		trace("send---------------------------------")
		trace(self._debugName,uMainID,uAssistantID,bodySize,util.timeEx())
		traceObj(tblBody,structName)
	end
	local head = Struct.encode(tblHead,MSG_GAME_STRUCT.NetMessageHead)
	self:send(head..body)
end

--返回成功失败
function GameSocket:connect(host,port,succcallback)
	host = host or self.host
	port = port or self.port
	assert(host~=nil and port~=nil and host~="", "GameSocket:connect host or port is nil")
	if self.isConnected and (host~=self.host or port ~= self.port) then
		self:disconnect()
		self:close()
	else
		if socket.gettime() - self._connectTime<2 and self._connectNum>2 then
			trace("重连过于频繁")
			if self.connectTimeTickScheduler then 
				scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
				self.connectTimeTickScheduler = nil
			end
			self:backToLogin()
			return
		end
	end


    self.port = port
    self.host = host
	trace(self._debugName,"try connect:",host,port)
	self.succcallback = succcallback
	if isipv6_only then  
	    self._socketTcp = socket.tcp6()
        trace("lw IPV6")
	else  
	    self._socketTcp = socket.tcp()
        trace("lw IPV4")
	end
    self._socketTcp:settimeout(0.01,"r")
    self.isRetryConnect = true
	local function __checkConnect()
		local __succ = self:_connect()
		if __succ then
			self:_onConnected()
		end
		return __succ
	end

	if not __checkConnect() then
		--check whether connection is success
		--the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
		local __connectTimeTick = function ()
			if not self.isRetryConnect then--不需要重连
				if self.connectTimeTickScheduler then 
					scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
					self.connectTimeTickScheduler = nil
				end
				self.waitConnect = nil
				self:close()
				return
			end
			if self:isconnect() then --已经连上
				if self.connectTimeTickScheduler then 
					scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
					self.connectTimeTickScheduler = nil
					__checkConnect()
				end
				return 
			end
			self.waitConnect = self.waitConnect or 0
			self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
			if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
				if self.connectTimeTickScheduler then 
					scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
					self.connectTimeTickScheduler = nil
				end
				self.waitConnect = nil
				self:close()
				self:_connectFailure()
			end
			__checkConnect()
		end
		self.connectTimeTickScheduler = self.connectTimeTickScheduler or scheduler.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)
	end
end

--逻辑判断已经断线
function GameSocket:checkConnect(msg,slience)
	--traceOnly(self._debugName,"checkConnect ",msg)
	if not self.isRetryConnect then
		return true
	end
	if not self.isConnected then
		self:_reconnect(true,msg,slience)
		return false
	end
	local mainID = MDM_SOCKET_CONNECT_CHECK
	local assID = ASS_SOCKET_CONNECT_CHECK
	if self._debugName == "RoomSocket" then
		mainID = 1
		assID = 4
	end
	self:sendMsg(mainID,assID)--给服务器发,判断是否断线
	util.setTimeout(function() 
		if self._isCheckingConnect then
			self:sendMsg(mainID,assID)
		end
	end,0.5)
	util.setTimeout(function() 
		if self._isCheckingConnect then
			self:sendMsg(mainID,assID)
		end
	end,1)
	self.isConnected = false
	util.setTimeout(function() 
		if self._isCheckingConnect and self.isRetryConnect and not self.isConnected then
			self:_reconnect(true,msg,slience)
		end
	end,3)
	--self:onReconnectSuc()
	return false
end

function GameSocket:setIsChecking(flag)
	self._isCheckingConnect = flag
end

--当rpc处理数据的时候挂钩子处理对应数据
--assistantID 为nil时,则忽略assistantID
function GameSocket:addDataHandler(mainID,assistantID,obj,method)
    -- assert(obj~=nil and method~=nil and not tolua.isnull(obj), "GameSocket:addDataHandler obj or method is nil")
    mainID = mainID or _noassID
    assistantID = assistantID or _noassID
    self.rpcDataHandlerMap[mainID] = self.rpcDataHandlerMap[mainID] or {}
    self.rpcDataHandlerMap[mainID][assistantID] = self.rpcDataHandlerMap[mainID][assistantID] or {}
    self.rpcDataHandlerMap[mainID][assistantID][obj] = handler(obj,method)
end

function GameSocket:addReconnetCallback(node,func)
	self._reconnectCallBack[node] = func
end

function GameSocket:addDisconnetCallback(node,func)
	self._disconnectCallBack[node] = func
end

function GameSocket:close()
	self._socketTcp:close()
	if self.tickScheduler then 
		scheduler.unscheduleGlobal(self.tickScheduler) 
		self.tickScheduler = nil
	end
	if self.connectTimeTickScheduler then 
		scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
		self.connectTimeTickScheduler = nil
	end
end

-- disconnect on user's own initiative.
function GameSocket:disconnect()
	if self:isconnect() then
		trace(self._debugName,"主动断开Socket",self.host," ",self.port)
		self:_disconnect()
	end
	self.isRetryConnect = false -- initiative to disconnect, no reconnect.
	self._isReConnet = false
end

-- disconnect on user's own initiative.
function GameSocket:setAutoReconnect(flag)
	self.isRetryConnect = flag
end

function GameSocket:isconnect()
	return self.isConnected
end

function GameSocket:isActive()
	return self.isConnected or self.isRetryConnect
end
----------------------------------
--privete
----------------------------------

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"


function GameSocket:_connect()
	local __succ, __status = self._socketTcp:connect(self.host, self.port)
	trace("SocketTCP._connect:", __succ, __status, __succ == 1 or __status == STATUS_ALREADY_CONNECTED,self.host, self.port)
	return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end


--返回,arg3 为第一个字节内容
function GameSocket:onRecMsg(head,body,structName,arg3)
	local uMainID = head.uMainID
	local uAssistantID = head.uAssistantID
	if not self:isFilter(uMainID,uAssistantID) then
		-- trace("rec-------------------------")
		-- trace(self._debugName,uMainID,uAssistantID,head.uHandleCode,util.timeEx())
		-- traceObj(body,structName)
	end

	if self.callBacks[uMainID] and self.callBacks[uMainID][uAssistantID] then
		self.callBacks[uMainID][uAssistantID](body)
		self.callBacks[uMainID][uAssistantID] = nil
	end

	local function doHandlers(gHandlers)
		if gHandlers then 
			-- print("")
			-- traceObj(gHandlers, "gHandlers")
			-- print("wowoowowowowowowowowowowowowo")
			-- traceObj(gHandlers, "MygHandlers")
	    	for obj,handle in pairs(gHandlers) do
	    		if not tolua.isnull(obj) or (obj.type and obj.type == "logic") then
					-- print("doHandlers", uAssistantID, body, arg3, head)
					-- print("handler函数", obj, handler1)
					handle(body,uAssistantID,arg3,head)
	        	else
	        		gHandlers[obj] = nil
	        	end
	        end
	    end
	end

    local gHandlers = self.rpcDataHandlerMap[uMainID] and self.rpcDataHandlerMap[uMainID][uAssistantID]
    doHandlers(gHandlers)

    gHandlers = self.rpcDataHandlerMap[uMainID] and self.rpcDataHandlerMap[uMainID][_noassID]
    doHandlers(gHandlers)

    gHandlers = self.rpcDataHandlerMap[_noassID] and self.rpcDataHandlerMap[_noassID][_noassID]
    doHandlers(gHandlers)

    gHandlers = self.rpcDataHandlerMap[_noassID] and self.rpcDataHandlerMap[_noassID][uAssistantID]
    doHandlers(gHandlers)
end


function GameSocket:send(data)
	if not self.isConnected then
		trace(self._debugName,"send fail,not connected")
		if	self.isRetryConnect then
			self:_reconnect(nil,"发送消息失败")
		else
			trace(self._debugName,"已断开的连接,发送失败")
			--[[local __doReConnect = function ()
				self.reconnectScheduler = nil
				trace(self._debugName,"socket try reconnect")
				self:connect(nil,nil,self.succcallback)
			end
			GameEvent:notifyView(GameEvent.hideLoading)
			Alert:showCheckBox2("网络已断开，请检查网络是否断开再进入游戏",function() 
				self._disConnectTime = nil 
				self.isRetryConnect = true
				__doReConnect()
			end)]]
		end
		
		return
	end
 	--trace(self._debugName,"send:", string.byte(data,1,string.len(data)))
	local byte,res = self._socketTcp:send(data)
	--trace("self._socketTcp:send(data)",byte,res)
	if byte == nil then
		self.isConnected = false
		self:send(data)
	end
end


function GameSocket:onReceive(head,body)
	--trace(util.time(),self._debugName,"rec",head.uMainID,head.uAssistantID)
	GameEvent:notifyView(GameEvent.RecAllMsg,head)
	self.isConnected = true
 	if head.uMainID and (not body or self._map[head.uMainID] and self._map[head.uMainID][head.uAssistantID]) then
 		if self._map[head.uMainID] and self._map[head.uMainID][head.uAssistantID] and self._map[head.uMainID][head.uAssistantID].updateHandleCode then
 			self.uCheck = head.uHandleCode
 		end
 		local tbl
 		local arg3
 		local rec = self._map[head.uMainID] and self._map[head.uMainID][head.uAssistantID] and self._map[head.uMainID][head.uAssistantID].rec
 		if type(rec) == "function" then--通过结构体第一个字节来确定类型
 			arg3 = Struct.readByte(body,MSG_DATA_TYPE.BYTE)
 			rec = rec(arg3)
 		end
 		tbl = body and Struct.decode(body,rec)
 		self:onRecMsg(head,tbl,Struct.getStructName(rec),arg3)
 	else
 		trace(self._debugName,"error:onReceive unknow map uMainID = "..(head.uMainID or "nil").." uAssistantID = "..(head.uAssistantID or "nil").." size = "..(body and string.len(body) or "0"))
 	end
end


function GameSocket:onReceiveHead(data)
 	--trace("onReceiveHead:",string.len(data),string.byte(data,1,string.len(data)))
 	local tbl = Struct.decode(data,MSG_GAME_STRUCT.NetMessageHead)
 	--traceObj(tbl)
 	--没有包体
 	if tbl.uMessageSize == _headerSize then
 		self:onReceive(tbl,nil)
 		return nil
 	end
 	return tbl
end



function GameSocket:readTcp(len)
	len = math.max(len,0)
	local r ,__status = self._socketTcp:receive(len)
	--trace("__status = ",r,__status)
	if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
    	self._socketTcp:close();
    	if self.isConnected then
			--trace(self._debugName,"socket close __status = "..__status)
    		self:_onDisconnect()
    	else
    		self:_connectFailure()
    	end
    	return nil
    else
    	--self.isConnected = true
	end
	return r
end

function GameSocket:readHead()
	local temp = self:readTcp(_headerSize)
	if temp then
		local head = self:onReceiveHead(temp)
		return  head
	else
		return 
	end
end

function GameSocket:recv_package(head)
	local headSize = head.uMessageSize - _headerSize
	local body
	--repeat
		body = self:readTcp(headSize)
	--until body
	if body then
		--trace(self._debugName,"rec:mainID = "..head.uMainID.." assID = "..head.uAssistantID.." len ="..string.len(body).." size = ",headSize,"body = \n",string.byte(body,1,headSize))
		self:onReceive(head,body)
	end
end
function GameSocket:socketReceive()
	local head
	repeat
		head = self:readHead()
		if head then 
			self:recv_package(head)
		end
	until head==nil
end

-- connecte success, cancel the connection timerout timer
function GameSocket:_onConnected()
	trace(self._debugName,"socket Connected")
	self.isConnected = true
	local now = socket.gettime()
	if now - self._connectTime < 2 then
		self._connectNum = self._connectNum + 1
	else
		self._connectNum = 0
	end
	self._connectTime = now
	self._disConnectTime = nil
	if self.succcallback then
		self.succcallback()
		self.succcallback = nil
	end
	if self.connectTimeTickScheduler then 
		scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
		self.connectTimeTickScheduler = nil
	end
	if self.tickScheduler then 
		scheduler.unscheduleGlobal(self.tickScheduler) 
		self.tickScheduler = nil
	end

	if self._isReConnet then
		self:onReconnectSuc()
	end
	
	local __tick = function()
		self:socketReceive()
	end

	-- start to read TCP data
	self.tickScheduler = scheduler.scheduleGlobal(__tick, SOCKET_TICK_TIME)
end

function GameSocket:_disconnect()
	self.isConnected = false
	self._socketTcp:shutdown()
end


function GameSocket:_onDisconnect()
	self.isConnected = false
	if self.tickScheduler then 
		scheduler.unscheduleGlobal(self.tickScheduler) 
		self.tickScheduler = nil
	end

	for node,fun in pairs (self._disconnectCallBack) do
		if tolua.isnull(node) then
			self._disconnectCallBack[node] = nil
		else
			fun()
		end
	end
	self:_reconnect(nil,"失去连接");
	--trace("失去连接")
end

-- if connection is initiative, do not reconnect,slience 为后台重连,不提示
function GameSocket:_reconnect(__immediately,msg,slience)
	if not self.isRetryConnect then return end
	self._isReConnet = true
	if not slience then
		if self.connectTimeTickScheduler then
			GameEvent:notifyView(GameEvent.showLoading,{self,msg = "正在连接..."})
		else
			GameEvent:notifyView(GameEvent.showLoading,{self,msg = "正在重连..."})
		end
	end
	trace("__doReConnect msg = ",msg)
	if __immediately then
		trace(self._debugName,"socket try reconnect")
		self:connect(nil,nil,self.succcallback) 
		return 
	end
	if self.reconnectScheduler then
		return
	end
	local __doReConnect = function ()
		self.reconnectScheduler = nil
		trace(self._debugName,"socket try reconnect")
		self:connect(nil,nil,self.succcallback)
	end
	if not slience then
		self._disConnectTime = self._disConnectTime or util.time()
		if util.time() - self._disConnectTime>5 then
			self:backToLogin()
			return
		end
	end
	--self.reconnectScheduler = scheduler.performWithDelayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
	__doReConnect()
end

function GameSocket:_connectFailure()
	self:_reconnect(nil,"连接失败")
end


function GameSocket:backToLogin()
	util.postLogToServer(self._debugName.."网络断开,在房间 = "..tostring(PlayerData:getIsGame()),true)
	self.isRetryConnect = false
	GameEvent:notifyView(GameEvent.hideLoading)
	Alert:showCheckBox2("网络已断开，请检查网络是否正常再进入游戏",function() 
		--[[self._disConnectTime = nil 
		self.isRetryConnect = true
		__doReConnect()]]
		
		util.backToLogin()
	end,util.backToLogin)
end

function GameSocket:onReconnectSuc()
	trace("onReconnectSuc")
	GameEvent:notifyView(GameEvent.hideLoading)
	for node,fun in pairs (self._reconnectCallBack) do
		if tolua.isnull(node) then
			self._reconnectCallBack[node] = nil
		else
			fun()
		end
	end
end

function GameSocket:isFilter(uMainID,uAssistantID)
	return self._map and self._map[uMainID] and self._map[uMainID][uAssistantID] and self._map[uMainID][uAssistantID].filter
end

return GameSocket