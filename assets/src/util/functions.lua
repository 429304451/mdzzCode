local string = string
local print = print
local table = table
-- require "lpeg"
-- local P = lpeg.P
-- local C = lpeg.C
-- local Ct =  lpeg.Ct
-- local M = lpeg.match
local randCardinal = 1000000

function setRandCardinal()
	if randCardinal > 2000000 then
		randCardinal = 1000000
	end
	randCardinal = randCardinal+1
end

function math.rand(num1, num2)
	setRandCardinal()
	math.randomseed(os.time()+randCardinal)
	if num1 and num2 then
		return math.random(num1,num2)
	elseif num1 then
		return math.random(num1)
	else
		return math.random()
	end
end

function tonum(v, base)
    return tonumber(v, base) or 0
end

function toint(v)
    return math.round(tonum(v))
end

-- 从一个数字列表中 随机多个不同的数
function randMulNumber(numTab, count)
	setRandCardinal()
	local arg = numTab
	local selected = {}
	math.random(0, #arg)
	math.randomseed(os.time()+randCardinal)
	-- if #arg<=count then return unpack(arg) end
	if count <= 0 then return selected end
	if #arg <= count then return arg end
	while #selected < count do
		math.random(#arg)
		table.insert(selected,table.remove(arg,math.random(#arg)))
	end
	-- return unpack(selected)
	return selected
end

-- 类似于 string.formatnumberthousands(num) 
function string.formatNum(num)
	if not num then
		num = 0
	end
	local str = tostring(num)
	local count = 0
	local result = ""
	for i=#str, 1, -1  do
		count = count + 1
		local s = string.sub(str, i,i)
		result = s..result
		if count == 3 and i ~= 1 then
			result = ","..result
			count = 0
		end
	end
	return result
end

function string.split(s, sep)
  sep = P(sep)
  local elem = C((1 - sep)^0)
  local p = lpeg.Ct(elem * (sep * elem)^0)   -- make a table capture
  return M(p, s)
end


-- local num = 1234567
-- local result = string.formatNum(num)
-- print(result)
