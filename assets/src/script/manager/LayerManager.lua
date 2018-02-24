--页面管理类
LayerManager = {}
_lym = LayerManager
_lym.__cname = "LayerManager"

--当前页面
_lym.curLayer = nil
--下一个页面
_lym.nextLayer = nil
_lym.localZOrder = 0
--layerMap
local layerMap = {}

--初始化
function LayerManager:init()
	layerMap = {}
	_au:clearCoinRain()

	_au:initCoinRain()
	--self:initLayer(ui.rankMain)
	self:initLayer(ui.task)
	self:initLayer(ui.activityMain)
	self:initLayer(ui.PersonalInfo)
	--self:initLayer(ui.exchange)
	--self:initLayer(ui.redSquare)
	self._zOrder = 0
end

--初始化页面
function LayerManager:initLayer(obj)
	local layer = self:getLayerDoCreate(obj)
	layer:setVisible(false)
end

--打开页面
function LayerManager:showLayer(obj,...)
	if self:isLayerRuning(obj) then
		return
	end
	local layer = self:getLayerDoCreate(obj)
	layer:setVisible(true)
	if _lym.curLayer == layer then
		trace("-----当前页面已展示-----")
		return
	end
	_lym.curLayer = layer
	if layer.onEnter then
		layer:onEnter(...)
	end
	if layer.resize then
		layer:resize()
	else
		--util.aptSelf(layer)
	end
	if obj.backKeytoClose then
		local function backClose()
			return not self:closeLayer(obj)
		end
		util.addEventBack(layer,backClose)
	end
	_lym.localZOrder = _lym.localZOrder + 1
	layerMap[obj.id].layer:setLocalZOrder(_lym.localZOrder)
	return layerMap[obj.id].layer
end

--获取页面(不存在后创建)
function LayerManager:getLayerDoCreate(obj)
	if not layerMap[obj.id] then
		layerMap[obj.id] = {}
	end
	if tolua.isnull(layerMap[obj.id].layer) then
		layerMap[obj.id].layer = self:createLayer(obj)
		--基础页面层
		local winLayer = util.getBaseLayer("winLayer")
		winLayer:addChild(layerMap[obj.id].layer)
	end
	--记录最后一次被使用的时间
	layerMap[obj.id].time = os.time()
	return layerMap[obj.id].layer
end

--获取页面(不存在返回nil)
function LayerManager:getLayer(obj)
	if layerMap[obj.id] then
		return layerMap[obj.id].layer
	else
		return nil
	end
end

--获取页面是否正在显示
function LayerManager:isLayerRuning(obj)
	if layerMap[obj.id] and not tolua.isnull(layerMap[obj.id].layer) and layerMap[obj.id].layer:isVisible() then
		return true
	end
	return false
end

--创建页面
function LayerManager:createLayer(obj)
	trace("createLayer:",obj.path)
	return require(obj.path).new(obj)
end

--关闭页面
function LayerManager:closeLayer(obj,remove)
	if not layerMap[obj.id] then
		return false
	end
	local layer = layerMap[obj.id].layer
	if tolua.isnull(layer) or not layer:isVisible() then
		return false
	end
	if layer.onExit then
		layer:onExit()
	end
	layerMap[obj.id].layer:setLocalZOrder(0)
	_lym.curLayer = nil
	if obj.clear or remove then
		util.tryDispose(layer)
		layerMap[obj.id] = nil
	else
		layer:setVisible(false)
	end
	return true
end

--清除缓存
function LayerManager:clearLayer(obj)
	util.tryDispose(layer)
	layerMap[obj.id] = nil
end

--清除缓存
function LayerManager:cleanLayerMap()
	for k,v in pairs(layerMap) do
		--self:closeLayer(k)
		--util.tryDispose(v.layer)
		--layerMap[k] = nil
		if not tolua.isnull(v.layer) then
			if v.layer.onExit then
				v.layer:onExit()
			end
			v.layer:setLocalZOrder(0)
			v.layer:setVisible(false)
		end
	end
	_lym.localZOrder = 0
end

