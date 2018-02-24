--打印工具
local printTime = 0;
local timeCount = 0;
cclog = function(obj,...)
    if ... then
        local cur = os.clock();
        timeCount = timeCount +1;
        local collec = "";
        if timeCount == 10 then
            timeCount = 0;
            collec = string.format(" - %0.2f KB,",collectgarbage("count"));
        end
        local str = string.format(...);
        if obj and obj.__cname then
            print(string.format(" - %s]%.3fs%s:%s",obj.__cname,(cur-printTime),collec,str))
        else
            print(string.format("]%.3fs,%s",(cur-printTime),str))
        end
        printTime = cur;
    end
end 

function printTable (obj,lua_table,indent)
    if not GameManager:fun_Instance().IsPrintLog then
        return;
    end
	if not lua_table then
		cclog(obj,"nil");
		return;
	end
    local finalIndent = 3;
    if indent then
        finalIndent = indent;
    end
	local msg = print_lua_table(obj,lua_table,0,finalIndent);
	cclog(obj,"%s",msg);
end

function print_lua_table (obj,lua_table,indent,finalIndent)
    local msg = "{";
    indent = indent +1;
    local isFirst = true;
    local vFirst = true;
    for k, v in pairs(lua_table) do
        if k ~= "class" then
            if not vFirst then
                msg = msg..",";
            end
            vFirst = false;
            if type(k) == "string" then
                msg = msg..k.."=";
            end
            if type(v) == "table" then
            	if indent < finalIndent then
    	        	local str = print_lua_table(obj,v,indent,finalIndent);
    	        	if str then
    	        		msg = msg ..str;
    	        	end
    	        end
            elseif type(v) == "string" then
            	msg = msg.."\""..tostring(v).."\"";
            else
            	msg = msg..tostring(v);
            end
        end
    end
    msg = msg.."}";
    return msg;
end

m_nMaxLevel = 0;

local Log = {};

	
return Log;