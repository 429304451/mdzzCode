--网络模块基类
BaseNetHandle = class(...)

function BaseNetHandle:ctor(sId)
	_nhm:fun_Add(sId, self)
	self.m_sId = sId
	self.callbackPool = {}
	self.netDebugLog = false
end

--注册网络监听
function BaseNetHandle:fun_RegCallback(pNotifyName,pActionName,pLogicObj,pCallbackFun)
	for name, event in pairs(self.callbackPool) do
		if name == pActionName then
			print( "模块回调监听已注册。name:"..pActionName)
			self.callbackPool[pActionName] = {pLogicObj,pCallbackFun}
			return
		end
	end
	self.callbackPool[pActionName] = {pLogicObj,pCallbackFun}
	local function dataBackFun( ... )
		self:fun_Notify( ... )
	end
	RoomSocket:addDataHandler(pNotifyName, pActionName, pLogicObj, dataBackFun)
end

--网络返回逻辑层回调
function BaseNetHandle:fun_ExecCallbackDelegate(pActionName,pDelegateData)
	local poolVal = self.callbackPool[pActionName]
	if poolVal then
		poolVal[2](poolVal[1],pDelegateData)
	else
		print("未查找到注册的模块动作监听,action name:"..pActionName)
	end
end

--请求网络数据
function BaseNetHandle:fun_Request(pNotifyName, pActionName, pRequestData)
	local responseData = self:fun_RequestFilter(pActionName, pRequestData)
	if responseData then
		if self.netDebugLog then
			print("请求数据本地已存在,action name:"..pActionName)
		end
		self:fun_ExecCallbackDelegate(pActionName,responseData)
	else
		if self.netDebugLog then
			print("发送请求:"..pActionName)
			traceObj(pRequestData,"pRequestData:")
		end
		RoomSocket:sendMsg(pNotifyName, pActionName, pRequestData)
	end
end

--网络回调响应
function BaseNetHandle:fun_Notify(event1,event2,event3,event4,event5)

	-- traceObj(event1,"event1:")
	-- traceObj(event2,"event2:")
	-- trace("------event3----",event3)
	-- trace("------event4----",event4)
	-- traceObj(event5,"event5:")

	local responseData = event2

	-- local actionName = event3
	local actionName = event5.uAssistantID
	local uHandleCode = event5.uHandleCode

	if self.netDebugLog then
		print("网络回调:"..actionName)
		traceObj(responseData,"responseData:")
	end
	if not event2 then
		return
	end
	--网络返回错误检测及处理
	self:fun_OnError(responseData)
	if not responseData.nErrCode or responseData.nErrCode == 0 then
		responseData = self:fun_ResponseHandle(actionName,responseData)
		if not responseData then
			return
		end
		self:fun_ExecCallbackDelegate(actionName,responseData)
	end
end

--请求数据过滤
function BaseNetHandle:fun_RequestFilter(pActionName, pRequestData)
end

--响应数据处理
function BaseNetHandle:fun_ResponseHandle(pActionName, pResponseData)
	return pResponseData
end

--网络返回错误处理
function BaseNetHandle:fun_OnError(pResponseData)
	if pResponseData and pResponseData.nErrCode and pResponseData.nErrCode ~= 0 then
		trace("-----网络返回错误处理----- nErrCode :",pResponseData.nErrCode)
		local errStr = ""
		if pResponseData.nErrCode == 101 then
			errStr = "金币不足。"
			_uim:showLayer(ui.quickBuyGold)
		end
		Alert:showTip(errStr,2)
	end
end

--网络返回错误处理
function BaseNetHandle:fun_OnError____(pResponseData)
	local descr = pResponseData.nErrCode
	pResponseData.hasError = false
	if pResponseData.nErrCode then
		pResponseData.hasError = true
		local code = 0
		local isReset = false
		if descr == "disconnect" then
			pResponseData.hasError = false
			return
		else
			code = pResponseData.code
		end
		ui.wait:hide()
		if code > 100 then
			--报错Tips
			ui.popShow(descr)
			return
		end
		isReset = code <= 0
		local okFunc = nil
		if isReset then
			ti.ProtobufControl:getInstance():closeCommunication()
			_nhm.ServerStop["game"] = true
			descr = descr .. _lgm:get("sys.error.restart.text").content
			okFunc = function()
				if isReset then
					_nhm.ServerStop["game"] = false
					_gm:gameReStart()
				end
			end
		end
		local dialog = nil
		dialog = _dlm:openDialog("SysTip", {
			type = 1,
			msg = descr,
			okFunc = okFunc
		})
	end
end

return BaseNetHandle