--容器页面层基类
BaseContainer = class(..., function()
	return cc.Layer:create()
end)

function BaseContainer:ctor(sId)
	_ctm:fun_Add(sId, self)
	self.m_sId = sId
end

return BaseContainer