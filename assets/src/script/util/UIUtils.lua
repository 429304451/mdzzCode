-- UI工具
-- Author: gaomeng.ning
-- Date: 2017-3-7
local postedLog = {}
require("script.util.ui")

function ui.printCsError(path)
	trace("-----------------------------------------------")
	trace("----------------!!!!!!!!!!!!!!!----------------")
	trace("  ")
	trace("Cs Create Error!!!!!! Cs File Not Found ："..path)
	if not postedLog[path] then
		postedLog[path] = true
		util.postLogToServer("Cs Create Error!!!!!! Cs File Not Found ："..path)
	end
	trace("  ")
	trace("----------------!!!!!!!!!!!!!!!----------------")
	trace("-----------------------------------------------")
end

--创建CS节点
function ui.loadCS(path)
	local resType = string.sub(path,-4,-1)
	local node = nil
	if resType == ".csd" then
		if cc.FileUtils:getInstance():isFileExist(path) then
			node = cc.CSLoader:getInstance():createNodeWithFlatBuffersForSimulator(path)
		else
			ui.printCsError(path)
		end
	else
		if cc.FileUtils:getInstance():isFileExist(path..".csb") then
			node = cc.CSLoader:createNode(path..".csb")
		else
			ui.printCsError(path..".csb")
		end
	end
	return node
end

--从csd界面转lua的界面创建
function ui.createCsb(obj)
	print("ui.createCsb", obj)
	local pathTable = string.split(obj.uipath,".")
	local cabPath = "csb"

	for i=2,#pathTable do
		cabPath = cabPath .. "/" .. pathTable[i]
	end
	trace("==========从csd界面转lua的界面创建==========",cabPath)
	local node = ui.loadCS(cabPath)
	local tab = tolua.getpeer(node)
	if not tab then
		tab = {}
		tolua.setpeer(node, tab)
	end
	ui.setNodeMap(node, tab)
	return {root = node}
end

function ui.setNodeMap(node, tbl)
	if not node then
		return
	end
	local findNode
	local children = node:getChildren()
	local childCount = node:getChildrenCount()
	if childCount < 1 then
		return
	end
	for i=1, childCount do
		if "table" == type(children) then
			tbl[children[i]:getName()] = children[i]
			ui.setNodeMap(children[i], tbl)
		end
	end
	return
end