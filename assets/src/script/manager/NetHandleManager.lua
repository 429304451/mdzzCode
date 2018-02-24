--网络模块管理
NetHandleManager = {}
_nhm = NetHandleManager
_nhm.__cname = "NetHandleManager"

--保存netHandle的列表
local NetHandleMap = {}

--sId 添加层对应的索引
--netHandle 添加的网络层
function NetHandleManager:fun_Add(sId,netHandle)
	if not sId or not netHandle then
		print("NetHandleManager:sId or netHandle is nil!")
		return
	end
	if not NetHandleMap[sId] then
		NetHandleMap[sId] = netHandle
		print("NetHandleManager:fun_Add ", sId)
	else
		print("网络模块已存在：", sId)
	end
end

--获取对应索引的网络层
--sId  索引值
function NetHandleManager:fun_Get(sId)
	if NetHandleMap[sId] then
		return NetHandleMap[sId]
	else
		print("网络索引值无效：", sId)
		return nil
	end
end

function NetHandleManager:fun_init_login()
	
	-- local SysNetHandle = require("game.nethandle.SysNetHandle") 
	-- SysNetHandle.new()
	
	-- local AccountNetHandle = require("game.nethandle.AccountNetHandle")
	-- AccountNetHandle.new()

end

function NetHandleManager:fun_init()
	
	local FruitsNetHandle = require("script.nethandle.FruitsNetHandle").new()
	
end
