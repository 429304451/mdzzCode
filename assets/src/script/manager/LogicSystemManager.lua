--逻辑系统管理
LogicSystemManager = {}
_lsm = LogicSystemManager
_lsm.__cname = "LogicSystemManager"

--保存Logic的列表
local LogicMap = {}

--sId 添加层对应的索引
--logic 添加的逻辑层
function LogicSystemManager:fun_Add(sId,logic)
	if not sId or not logic then
		print("LogicSystemManager:sId or logic is nil!")
		return
	end
	if not LogicMap[sId] then
		LogicMap[sId] = logic
		print("LogicSystemManager:fun_Add %s", sId)
	else
		print("逻辑模块已存在：%s", sId)
	end
end

--获取对应索引的逻辑层
--sId  索引值
function LogicSystemManager:fun_Get(sId)
	if LogicMap[sId] then
		return LogicMap[sId]
	else
		print("逻辑索引值无效：%s", sId)
		return nil
	end
end

--初始化登陆逻辑层
function LogicSystemManager:fun_init_login()
	
	-- local SysLogic = require("game.logic.SysLogic")
	-- SysLogic.new()
	
	-- local AccountLogic = require("game.logic.AccountLogic")
	-- AccountLogic.new()

end

--初始化逻辑层
function LogicSystemManager:fun_init()
	--水果机去除了
	--local FruitsLogic = require("script.logic.FruitsLogic").new()
	
end