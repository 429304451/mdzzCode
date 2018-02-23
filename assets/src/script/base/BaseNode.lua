-- 节点基类
BaseNode = class(..., function ()
	return cc.Node:create()
end)

function BaseNode:ctor()
	--按钮响应CD屏蔽节点
	self.canInCding = false
	self.canInCdNode = cc.Node:create()
	self:addChild(self.canInCdNode)
end

--启动响应CD屏蔽
function BaseNode:runResponseCd(cdTime)
	local cdTime = cdTime or 0.3
	self.canInCding = true
	local delay = cc.DelayTime:create(cdTime)
	local function cFun()
		self.canInCding = false
	end
	local callFun = cc.CallFunc:create(cFun)
	local sequence = cc.Sequence:create(delay,callFun)
	self.canInCdNode:runAction(sequence)
end

return BaseNode