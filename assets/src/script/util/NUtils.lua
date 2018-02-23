-- 工具集
-- Author: gaomeng.ning
-- Date: 2016-05-31 12:08:46
--
NUtils = {}

--前面高概率 中心低概率随机数
function NUtils.getFrontRandom()
	repeat
		x = math.random(0,99)
		y = math.random(0,99)
	until y <= - x + 100
	return x
end

--判断一个值是否在Table中
function NUtils.valueExist(pTable,value)
	for k,v in pairs(pTable) do
		if value == v then
			return true
		end
	end
	return false
end

--传入Table去除重复内容 导出新Table
function NUtils.tableDeleteRepeat(pTable)
	local returnTable = {}
	for i=1,#pTable do
		local isExist = 0
		for j=1,#returnTable do
			if pTable[i] == returnTable[j] then
				isExist = 1
			end
		end
		if isExist == 0 then
			table.insert(returnTable,pTable[i])
		end
	end
	return returnTable
end

--取符号
function NUtils.getMark(num)
	local mark = 1
	if num ~= 0 then
		mark = num/math.abs(num)
	end
	return mark
end

--数字转Rmb字符串
function NUtils.toRMBstring(num)
	local str = "00"
	local num = tostring(num)
	local index = 0
	local len = #num
	for i=math.ceil(#num/3),1,-1 do
		local litStr = ""
		index = index + 1
		if math.abs(-3-3*(index-1)) > len then
			litStr = string.sub(num,-len,-1-3*(index-1))
		else
			litStr = string.sub(num,-3-3*(index-1),-1-3*(index-1))
		end
		if index == 1 then
			str = litStr.."."..str
		else
			str = litStr..","..str
		end
	end
	return str
end

--给出两点 算出点2相对于点1角度
function NUtils.anglePointCount(pPoint1,pPoint2)
    local angle = nil
    if pPoint2.y >= pPoint1.y then
        angle = math.deg(math.acos((pPoint2.x-pPoint1.x)/math.abs(cc.pGetDistance(pPoint1,pPoint2))))
    else
        angle = math.deg(-math.acos((pPoint2.x-pPoint1.x)/math.abs(cc.pGetDistance(pPoint1,pPoint2)))) + 360
    end
    return angle
end

--获取资源中心点  (精灵 ，偏移X , 偏移 Y)
function NUtils.getCenterPoint(pSprite,pX,pY)
	local x = pX or 0
	local y = pY or 0
	return cc.p(pSprite:getContentSize().width/2+x,pSprite:getContentSize().height/2+y)
end

--设置位置偏移            (原点 , 偏移点)
function NUtils.getDeviationPoint(pPoint,pPointN)
	return cc.p(pPoint.x+pPointN.x,pPoint.y+pPointN.y)
end

--计算相对基准位置偏移   (类型,当前点)
function NUtils.getBenchmarkPoint(pType,pPoint)
	local benchmarkPoint
	if pType == "center" then
		benchmarkPoint = WIN_center
	elseif pType == "left_down" then
		benchmarkPoint = WIN_left_down
	elseif pType == "left_up" then
		benchmarkPoint = WIN_left_up
	elseif pType == "right_down" then
		benchmarkPoint = WIN_right_down
	elseif pType == "right_up" then
		benchmarkPoint = WIN_right_up
	end
	return cc.p(pPoint.x-benchmarkPoint.x,pPoint.y-benchmarkPoint.y)
end

--计算相对父节点位置偏移   (父节点,当前点)
function NUtils.getParentLocalPoint(pParent,pPoint)
	return cc.p(pPoint.x-pParent:getPositionX(),pPoint.y-pParent:getPositionY())
end

--计算相对父节点原点位置偏移   (父节点,当前点)
function NUtils.getParentZeroLocalPoint(pParent,pPoint)
	local size = pParent:getContentSize()
	local width = size.width
	local height = size.height
	return cc.p(pPoint.x-pParent:getPositionX()+width/2,pPoint.y-pParent:getPositionY()+height/2)
end










