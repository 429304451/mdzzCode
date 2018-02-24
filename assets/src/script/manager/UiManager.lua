--界面管理类 （负责界面任务分配）
UiManager = {}
_uim = UiManager
_uim.__cname = "UiManager"

--当前页面
_uim.curLayer = nil
--下一个页面
_uim.nextLayer = nil

--初始化
function UiManager:init()
	_lym:init()
end

--打开页面
function UiManager:showLayer(obj,...)
	if obj.type == _gm.ID_Win then
		_lym:showLayer(obj,...)
	elseif obj.type == _gm.ID_Dlg then
		_dlm:showDialog(obj,...)
	elseif obj.type == _gm.ID_SysTip then
		_dlm:showSysTip(obj,...)
	end

	--隐藏特定节点
	self:hideObjChild(obj)
end

--获取页面
function UiManager:getLayer(obj)
	--支持旧版
    if util._wins and obj.path and not tolua.isnull(util._wins[obj.path]) then
        return util._wins[obj.path]
    end
	if obj.type == _gm.ID_Win then
		return _lym:getLayer(obj)
	elseif obj.type == _gm.ID_Dlg or obj.type == _gm.ID_SysTip then
		return _dlm:getDialog(obj)
	end
end

--获取页面是否正在显示
function UiManager:isLayerRuning(obj)
	local layer = self:getLayer(obj)
	if layer and layer:isVisible() then
		return true
	end
	return false
end

--关闭页面
function UiManager:closeLayer(obj,delay)
	if obj.type == _gm.ID_Win then
		_lym:closeLayer(obj)
	elseif obj.type == _gm.ID_Dlg or obj.type == _gm.ID_SysTip then
		_dlm:closeDialog(obj,delay)
	end
end

------------------------
--隐藏节点相关
--外部调用hideLayoutNode即可
----------------------
--public
--隐藏窗口特定的节点
--如: 隐藏活动按钮
--UiManager:addHideMap(ui.SelectGame,"groundNode._mainRoomItems.4")
--UiManager:addHideMap(ui.SelectGame,{"groundNode","_mainRoomItems","4"})
function UiManager:addHideMap(obj,keys,bShow)
	obj.__hideMap = obj.__hideMap or {}
	obj.__hideMap[keys] = not bShow

	self:hideObjChild(obj)
end

--private
function UiManager:hideObjChild(obj)
	if not (type(obj.__hideMap) == "table") then
		return
	end

	local layout = self:getLayer(obj)
	if tolua.isnull(layout) then
		return
	end
	for keys in pairs(obj.__hideMap) do
		local temKey = table.copy(keys)
		self:hideLayoutChild(layout,temKey,true)
	end
end

function UiManager:hideLayoutChild(layout,keys,bHide)
	self:onAddChildNode(layout,keys,function(child) self:hideNodeForever(child,bHide) end)
	if layout.onHideChild then
		layout.onHideChild(layout,keys)
	end
end

--添加子节点的回调
function UiManager:onAddChildNode(parent,keys,callBack,args)
	if not type(callBack) == "function" then
		trace("error: UiManager:onAddChildNode callBack not a function")
		return
	end

	if type(keys) == "string" then
		keys = string.split(keys,".")
	end
	if table.nums(keys) == 0 then
		args = type(args) == "table" and args or {args}
		callBack(parent,unpack(args))
		return
	else
		local key = table.remove(keys,1)
		local child = parent[key]
		if child then
			self:onAddChildNode(child,keys,callBack,args)
		else
			if type(parent)=="userdata" then
				parent = tolua.getpeer(parent)
			end
			table.onKeyChange(parent,function(t,k,v)
				if tostring(k) == key then
					self:onAddChildNode(v,keys,callBack,args)
				end
			end)
		end
	end
end

--隐藏节点,并不再让它显示
function UiManager:hideNodeForever(node,bHide)
	if tolua.isnull(node) then
		return
	end
	node.__oldsetVisible = node.__oldsetVisible or node.setVisible
	node.bHide = bHide
	if bHide then
		node:__oldsetVisible(false) 
		node.setVisible = function() end
	else
		node:__oldsetVisible(true)
		node.setVisible = node.__oldsetVisible
	end
end

--------------------------