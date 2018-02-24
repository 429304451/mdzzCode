--容器层管理类
ContainerManager = {}
_ctm = ContainerManager
_ctm.__cname = "ContainerManager"

--保存层的列表
local ContainerMap = {}

--sId 添加层对应的索引
--container 添加的容器层
function ContainerManager:fun_Add(sId,container)
	if not sId or not container then
		print("ContainerManager:sId or container is nil!")
		return
	end
	if not ContainerMap[sId] then
		ContainerMap[sId] = container
		print("ContainerManager:fun_Add %s", sId)
	else
		print("容器模块已存在：%s", sId)
	end
end

--获取对应索引的容器层
--sId  索引值
function ContainerManager:fun_Get(sId)
	if ContainerMap[sId] then
		return ContainerMap[sId]
	else
		print("容器索引值无效：%s", sId)
		return nil
	end
end