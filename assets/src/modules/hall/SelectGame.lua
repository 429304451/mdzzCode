



local SelectGame = class("SelectGame",BaseLayer)

function SelectGame:ctor(data)
	print("---------data", data)
	SelectGame.super.ctor(self)
	-- _gm.mainLayer = self
	-- self._bdelay = true
	-- self._bShowRule = false;
	--背景
	-- self.csBgNode = Animation:createSpeciallyEffect("csb/effect/01wutai", 0, 162, true)
	-- self:addChild(self.csBgNode,-1)
	-- _gm.bgScaleW2 = _gm.bgScaleW2 or _gm.bgScaleW>1 and 1 or _gm.bgScaleW
	-- self.csBgNode:setScale(_gm.bgScaleW,1)
	-- self.csBgNode:setPosition(WIN_center)

    --local ani = Animation:createSpeciallyEffect("csb/effect/07lizi", 0, 162, true)
    --self.csBgNode:addChild(ani)

	-- ui.setNodeMap(self.csBgNode, self)
end



return SelectGame

