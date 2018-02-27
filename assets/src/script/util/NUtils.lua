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

--文本创建
function NUtils.labelCreate(data)
	return require("game.views.public.NLabel").new(data)
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

--查找CSD下节点
function NUtils.seekNodeByName(parent, name)
	if not parent then
		return
	end

	if name == parent:getName() then
		return parent
	end

	local findNode
	local children = parent:getChildren()
	local childCount = parent:getChildrenCount()
	if childCount < 1 then
		return
	end
	for i=1, childCount do
		if "table" == type(children) then
			parent = children[i]
		elseif "userdata" == type(children) then
			parent = children:objectAtIndex(i - 1)
		end

		if parent then
			if name == parent:getName() then
				return parent
			end
		end
	end

	for i=1, childCount do
		if "table" == type(children) then
			parent = children[i]
		elseif "userdata" == type(children) then
			parent = children:objectAtIndex(i - 1)
		end

		if parent then
			findNode = NUtils.seekNodeByName(parent, name)
			if findNode then
				return findNode
			end
		end
	end

	return
end

--中英文混合字符串转换为单个字符Table
function NUtils.stringToTable(str)
	
	if str == "" or str == nil then
		return {}
	end

	local words = {}
	local index = 1
	local lenInByte = #str
	repeat
		local curByte = string.byte(str, index)
		local byteCount = 1
		if curByte >0 and curByte <=127 then
			byteCount = 1
		elseif curByte >=192 and curByte <=223 then
			byteCount = 2
		elseif curByte >=224 and curByte <=239 then
			byteCount = 3
		elseif curByte >=240 and curByte <=247 then
			byteCount = 4
		end
		local char = string.sub(str, index, index+byteCount-1)
		table.insert(words,char)
		index = index + byteCount
	until index > lenInByte
	return words
end

--中英文混合字符串获取长度 中文算两位
function NUtils.getStringLen(str)
	local index = 1
	local len = 0
	local lenInByte = #str
	repeat
		local curByte = string.byte(str, index)
		local byteCount = 1
		if curByte == nil then
			byteCount = 0
		elseif curByte >0 and curByte <=127 then
			byteCount = 1
			len = len + 1
		elseif curByte >=192 and curByte <=223 then
			byteCount = 2

		elseif curByte >=224 and curByte <=239 then
			byteCount = 3
			len = len + 2
		elseif curByte >=240 and curByte <=247 then
			byteCount = 4

		end
		index = index + byteCount
	until index > lenInByte
	return len
end

--判断字符串中是否有空格
function NUtils.strHaveSpace(str)
	local index = 1
	local len = 0
	local lenInByte = #str
	repeat
		local curByte = string.byte(str, index)
		local byteCount = 1
		if curByte == 32 then
			return true
		end
		if curByte == 227 then
			return true
		end
		if curByte >0 and curByte <=127 then
			byteCount = 1
		elseif curByte >=192 and curByte <=223 then
			byteCount = 2
		elseif curByte >=224 and curByte <=239 then
			byteCount = 3
		elseif curByte >=240 and curByte <=247 then
			byteCount = 4
		end
		index = index + byteCount
	until index > lenInByte
	return false
end

--判断是否只有中英文数字
function NUtils.strIsChEnNum(str)
	local index = 1
	local len = 0
	local lenInByte = #str
	repeat
		local curByte = string.byte(str, index)
		local byteCount = 1
		if (curByte >=48 and curByte <=57) or 
			(curByte >=65 and curByte <=90) or 
			(curByte >=97 and curByte <=122) or 
			(curByte >=224 and curByte <=239) then
		else
			return false
		end
		if curByte >0 and curByte <=127 then
			byteCount = 1
		elseif curByte >=192 and curByte <=223 then
			byteCount = 2
		elseif curByte >=224 and curByte <=239 then
			byteCount = 3
		elseif curByte >=240 and curByte <=247 then
			byteCount = 4
		end
		index = index + byteCount
	until index > lenInByte
	return true
end

-- pTimeFormat = 1(1:分秒 2：时分 3：时分秒)
function NUtils.parse_SecToTime(pSec,pTimeFormat)
	-- body
	local time = ""
	local tSec = ((pSec%3600))%60
	local tMin = math.floor((pSec%3600)/60)
	local tHour = math.floor(pSec/3600)

	local tTimeFormat = 1
	if pTimeFormat then
		tTimeFormat = pTimeFormat
	end

	if tTimeFormat == 1 then	
		return string.format("%02d:%02d",tMin,tSec)		
	elseif tTimeFormat == 2 then
		return string.format("%02d:%02d",tHour,tMin)
	elseif tTimeFormat == 3 then
		return string.format("%02d:%02d:%02d",tHour,tMin,tSec)
	end
end

function printTable (obj,lua_table)
	if not lua_table then
		cclog(obj,"nil")
		return
	end
	local msg = print_lua_table(obj,lua_table,0)
	cclog(obj,msg)
end

function print_lua_table (obj,lua_table,indent)
    local msg = "{"
    indent = indent +1
    local isFirst = true
    local vFirst = true
    for k, v in pairs(lua_table) do
        if not vFirst then
            msg = msg..","
        end
        vFirst = false
        if type(k) == "string" then
            msg = msg..k.."="
        end
        if type(v) == "table" then
        	if indent < 3 then
	        	local str = print_lua_table(obj,v,indent)
	        	if str then
	        		msg = msg ..str
	        	end
	        end
        elseif type(v) == "string" then
        	msg = msg.."\""..tostring(v).."\""
        else
        	msg = msg..tostring(v)
        end
    end
    msg = msg.."}"
    return msg
end

function scheduleFun(listener, time)
    local handle
    handle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        listener()
    end, time, false)
    return handle
end

function scheduleFunOne(listener, time)
    local handle
    handle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handle)
        listener()
    end, time, false)
    return handle
end

function unscheduleFun(handle)
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handle)
end