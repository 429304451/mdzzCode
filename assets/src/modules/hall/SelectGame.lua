
local GroundNode = require("modules.hall.GroundNode")


local SelectGame = class("SelectGame",BaseLayer)

function SelectGame:ctor(data)
	print("---------data", data)
	SelectGame.super.ctor(self, data)
	_gm.mainLayer = self
	self._bdelay = true
	self._bShowRule = false;
	--背景
	self.csBgNode = Animation:createSpeciallyEffect("csb/effect/01wutai", 0, 162, true)
	self:addChild(self.csBgNode,-1)
	_gm.bgScaleW2 = _gm.bgScaleW2 or _gm.bgScaleW>1 and 1 or _gm.bgScaleW
	self.csBgNode:setScale(_gm.bgScaleW,1)
	self.csBgNode:setPosition(WIN_center)

	ui.setNodeMap(self.csBgNode, self)

	--主界面选场节点
	self.groundNode = GroundNode.new()
	self.groundNode:setPosition(WIN_center)
	self.groundNode:setScale(_gm.bgScaleW2)
	self:addChild(self.groundNode)
	-- self.groundNode:initListItems()
end



return SelectGame

