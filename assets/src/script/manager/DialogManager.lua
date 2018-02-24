-- 弹出框管理
-- Author: gaomeng.ning
-- Date: 2017-03-7
-- 
DialogManager = {}
_dlm = DialogManager
_dlm.__cname = "DialogManager"

--保存对话框的列表
local DialogMap = {}

--打开页面
function DialogManager:showDialog(obj,...)
	self:closeDialog(obj)
	if DialogMap[obj.id] and not tolua.isnull(DialogMap[obj.id].dlg) then
		trace("----当前对话框已存在----",obj.path)
		return
	end
	DialogMap[obj.id] = {}
	DialogMap[obj.id].dlg = require(obj.path).new(obj,...)
	if not obj.backKeytoClose or obj.backKeytoClose ~= false then
		local function backClose()
			self:closeDialog(obj)
		end
		util.addEventBack(DialogMap[obj.id].dlg,backClose)
	end
	if DialogMap[obj.id].dlg.resize then
		DialogMap[obj.id].dlg:resize()
	else
		util.aptSelf(DialogMap[obj.id].dlg)
	end
	--基础对话框层
	local dialogLayer = util.getBaseLayer("dialogLayer")
	dialogLayer:addChild(DialogMap[obj.id].dlg)
end

--打开系统级Tip
function DialogManager:showSysTip(obj,...)
	if not DialogMap[obj.id] then
		DialogMap[obj.id] = {}
	end
	if DialogMap[obj.id].dlg then return end
	DialogMap[obj.id].dlg = require(obj.path).new(obj,...)
	if not obj.backKeytoClose or obj.backKeytoClose ~= false then
		local function backClose()
			self:closeDialog(obj)
		end
		util.addEventBack(DialogMap[obj.id].dlg,backClose)
	end
	--系统对话框层
	local sysTipLayer = util.getBaseLayer("sysTipLayer")
	sysTipLayer:addChild(DialogMap[obj.id].dlg)
end

--获取页面
function DialogManager:getDialog(obj)
	if DialogMap[obj.id] then
		return DialogMap[obj.id].dlg
	else
		return nil
	end
end

--关闭页面
function DialogManager:closeDialog(obj,delayTime)
	if not DialogMap[obj.id] then
		return
	end
	local delay = delayTime or 0.35
	local dlg = DialogMap[obj.id].dlg
	if tolua.isnull(dlg) then
		return
	end
	if dlg.onExit then
		dlg:onExit()
	end
	if dlg.closeSelf then
		dlg:closeSelf()
	end
	scheduleFunOne(function() util.tryDispose(dlg) end, delay)
	DialogMap[obj.id] = nil
end

--清除缓存
function DialogManager:clearDialog(obj)
	DialogMap[obj.id] = nil
end

