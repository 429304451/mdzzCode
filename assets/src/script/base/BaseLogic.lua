--逻辑系统基础模块类
BaseLogic = class(...)

function BaseLogic:ctor(sId)
	_lsm:fun_Add(sId, self)
	self.m_sId = sId
	self.type = "logic"
end

--网络请求注册
function BaseLogic:fun_RegNotifyCallback(netHandleId,pNotifyName,pCallbackActionName,pLogicObj,pCallbackFun)
	_nhm:fun_Get(netHandleId):fun_RegCallback(pNotifyName,pCallbackActionName,pLogicObj,pCallbackFun)
end

--发出消息
--notify : 发送到的通信模块
--action : 动作指令，请参看通信文档
--data : 发送的数据内容，tabel类型
function BaseLogic:fun_Request(netHandleId,pNotifyName, pActionName, pRequestData)
	_nhm:fun_Get(netHandleId):fun_Request(pNotifyName, pActionName, pRequestData)
end

return BaseLogic