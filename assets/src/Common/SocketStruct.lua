--hzs
--C++结构体与lua表之间转换
--2016.8.2

Struct = class("Struct")

--数据表的index开始位置,从0开始以便和C++对应
local tableIndexStart = 0

local function tableinsert(tbl,value)
	if tableIndexStart == 0 then
		if tbl[0] == nil then
			return table.insert(tbl,0,value)
		end
	end
	return table.insert(tbl,value)
end


--数据读取,将结构体转为table
--data:服务器发送的内存
--structType:MSG_GAME_STRUCT类型
--num,数字表示一维数组,表表示多维
--return:table
function Struct.decode(data,structType,num)
	local tbl = {}
	if not data or not structType then
		return tbl,0
	end
	local totalSize = 0
	if type(num)=="table" then
		local num1 = num[1]
		local nextnum = table.nums(num)>2 and {unpack(num,2)} or num[2]
		for i=1,num1 do
			local value,structsize = Struct.decode(data,structType,nextnum)
			tableinsert(tbl,value)
			data = string.sub(data,structsize+1)
			totalSize = totalSize + structsize
		end
		return tbl,totalSize		
	elseif type(num)=="number" and num >=1 then
		for i=1,num do
			local value,structsize = Struct.decode(data,structType,nextnum)
			tableinsert(tbl,Struct.decode(string.sub(data,0,structsize),structType))
			data = string.sub(data,structsize+1)
			totalSize = totalSize + structsize
		end
		return tbl,totalSize
	end
	local structsize-- = Struct.getSize(structType)

	--[[local datasize = string.len(data)
	--assert(datasize == structsize,"error:Struct.decode size not match datasize = "..string.len(data).." structsize = "..Struct.getSize(structType))
	if datasize ~= structsize then
		local name = Struct.getStructName(structType)
		trace("error:Struct.decode size not match StructName = "..name.." datasize = "..string.len(data).." structsize = "..Struct.getSize(structType))
	end]]

	for i,j in pairs(structType) do
		local num = j.num
		if type(num) == "string" then
			num = tonumber(tbl[num])
		end
		--local size = (j.type.size or Struct.getSize(j.type)) * num
		if Struct.isStructData(j.type) then
			tbl[j.key],structsize = Struct.decode(data,j.type,num)
		else
			tbl[j.key],structsize = Struct.readByte(data,j.type,num)
		end
		data = string.sub(data,structsize+1)
		totalSize = totalSize + structsize
	end

	return tbl,totalSize
end

--数据写入
--data:table表
--structType:MSG_GAME_STRUCT类型
--num,数组长度,这里暂不支持多维数组
--return:发送给服务器的数据
function Struct.encode(table,structType,num)
	local data=""
	if not structType or not table then
		return data
	end
	if num and num >1 then
		for i=1,num do
			data = data..Struct.encode(table,structType)
		end
		return data
	end
	for i,j in pairs(structType) do
		data = data..(Struct.isStructData(j.type) and Struct.encode(table[j.key],j.type,j.num) or  Struct.writeByte(table[j.key],j.type,j.num))
	end
	return data
end

--获取结构体大小
--structType:MSG_GAME_STRUCT类型
--return:数字
function Struct.getSize(structType)
	local size = 0
	for i,j in pairs(structType) do

		assert(j.type~=nil, "Struct.getSize unknow type "..(j.key or "nil"))
		local perSize = j.type.size or Struct.getSize(j.type)
		size = size + perSize * Struct.getTblNum(j.num or 1)
	end

	return size
end
---------------------------------------
--private
---------------------------------------
function Struct.getTblNum(tbl)
	if type(tbl) == "table" then
		local value = 1
		for i,j in pairs(tbl) do
			value = value * j
		end
		return value
	else
		return tonumber(tbl) or 0
	end
end

function Struct.isStructData(dataType)
	return dataType.size == nil
end

function Struct.isNumData(dataType)
	return dataType.type == "num"
end


function Struct.isunSignedNumData(dataType)
	return dataType.type == "unnum"
end


function Struct.isStringData(dataType)
	return dataType.type == "string"
end

function Struct.isBoolData(dataType)
	return dataType.type == "bool"
end

function Struct.getStructName(dataType)
	if dataType == nil then
		return ""
	end
	for i,j in pairs(MSG_GAME_STRUCT) do
		if j==dataType then
			return i
		end
	end

	return ""
end

--数据读取,将byte为dataType相应类型
--data:byte
--dataType:MSG_DATA_TYPE
--num数组长度
function Struct.readByte(data,dataType,num)
	if type(num) == "table" then
		local totalSize = 0
		local tbl = {}
		local num1 = num[1]
		local nextnum = table.nums(num)>2 and {unpack(num,2)} or num[2]
		local width = dataType.size
		for k = 2,table.nums(num) do
			width = width * num[k]
		end
		for i=1,num1 do
			local value,size = Struct.readByte(string.sub(data,(i-1)*width+1),dataType,nextnum)
			tableinsert(tbl,value)
			totalSize = totalSize + size
		end
		return tbl,totalSize
	end
	if Struct.isStringData(dataType) then
		local len = num or 1
		local str =  string.sub(data,1,num)
		local endl = string.find(str,'\0')
		if endl then
			str = string.sub(str,1,endl-1)
		end
		return str,len
	elseif Struct.isunSignedNumData(dataType)  then
		return Struct.bytetoUInt(data,dataType.size,num),dataType.size*(num or 1)
	elseif Struct.isNumData(dataType)  then
		return Struct.bytetoInt(data,dataType.size,num),dataType.size*(num or 1)
	elseif Struct.isBoolData(dataType)  then
		return Struct.bytetoBool(data,dataType.size,num),dataType.size*(num or 1)
	end
end


function Struct.writeByte(data,dataType,num)
	if Struct.isStringData(dataType) then
		local str =  tostring(data)
		if string.len(str) >= num then
			return string.sub(str,1,num-1)..string.char(0)
		end
		
		while (string.len(str) < num) do
			str = str..string.char(0)
		end

		return str
	elseif Struct.isNumData(dataType)  then
		return Struct.inttoByte(data,dataType.size,num)
	elseif Struct.isunSignedNumData(dataType)  then
		return Struct.uinttoByte(data,dataType.size,num)
	elseif Struct.isBoolData(dataType)  then
		return Struct.booltoByte(data,dataType.size,num)
	end
end

function Struct.booltoByte(data,size,num)
	local res = ""
	if not num or num == 1 then
		res = string.char(data and 1 or 0)
	else
		for i=1,num do
			res = res..string.char(data[i] and 1 or 0)
		end		
	end
	return res
end

function Struct.bytetoBool(data,size,num)
	local res =  Struct.bytetoInt(data,size,num)
	local function toBool(tbl)
		if type(tbl) ~= "table" then
			return tbl ~= 0
		else
			local res = {}
			for i,j in pairs(tbl) do
				res[i] = toBool(j)
			end

			return res
		end
	end

	return toBool(res)
end


function Struct.bytetoUInt(data,size,num)
	if not data and type(data)~="string" or string.len(data)<size then
		--trace("Struct.bytetoInt data not a string")
		return 0
	end
	local q = 256
	if num == nil then
		local res = 0

		for i=1,size do
			res = res + string.byte(string.sub(data,i,i)) * math.pow(q,i-1)
		end
		return res
	else
		local tbl = {}
		for j=1,num do
			local res = 0
			local start = 1+(j-1)*size
			res = Struct.bytetoUInt(string.sub(data,start,start+size),size)
			tableinsert(tbl,res)
		end

		return tbl
	end
end

function Struct.bytetoInt(data,size,num)
	if type(data)~="string" or data == "" or string.len(data) < size then
		--trace("Struct.bytetoInt data not a string")
		return 0
	end

	local q = 256
	if num == nil then
		local firstByte = math.floor(string.byte(string.sub(data,size,size)) / 128)--大端
		--local firstByte = math.floor(string.byte(string.sub(data,1,1)) / 128)--小端
		local res
		if size == 8 then
			res = Struct.bytetoUInt(string.sub(data,1,4),4,num) + Struct.bytetoUInt(string.sub(data,5,6),2,num) * math.pow(q,4)
			size = 6
		else
			res = Struct.bytetoUInt(data,size,num)
		end
		if firstByte == 0 then
			return res
		end
		return res - math.pow(2,size*8)
	else
		local tbl = {}
		for j=1,num do
			local res = 0
			local start = 1+(j-1)*size
			res = Struct.bytetoInt(string.sub(data,start,start+size),size)
			tableinsert(tbl,res)
		end

		return tbl
	end
end


function Struct.uinttoByte(value,size,num)
	if num and num>1 and type(value) =="table" then
		local res = ""
		for i=tableIndexStart,num-tableIndexStart-1 do
			res = res..Struct.uinttoByte(value[i],size)
		end
		return res
	end
	value = tonumber(value)
	if not value then
		--trace("Struct.uinttoByte value not a number "..(value or "nil"))
		return ""
	end

	local res = ""
	local q = 256
	while(size>0) do
		size = size -1
		local w = math.pow(q,size)
		--res = res..string.char(math.floor(value/w)) --小端
		res = string.char(math.floor(value/w))..res --大端
		value = value%w
	end

	return res
end

function Struct.inttoByte(value,size,num)
	if num and num>1 and type(value) =="table" then
		local res = ""
		for i=tableIndexStart,num-tableIndexStart-1 do
			res = res..Struct.inttoByte(value[i],size)
		end
		return res
	end
	value = tonumber(value)
	if not value then
		--trace("Struct.inttoByte value not a number "..(value or "nil"))
		return ""
	end

	if value < 0 then
		value = math.pow(2,size*8) + value
	end

	return Struct.uinttoByte(value,size,num)
end