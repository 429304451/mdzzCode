local SensitiveWord = class("SensitiveWord")

function SensitiveWord:lua_string_split(str, split_char)
    local sub_str_tab = {}
    self.mgc = {}
    while (true) do
        local pos = string.find(str, split_char)
        if (not pos) then
            --sub_str_tab[#sub_str_tab + 1] = str
            self.mgc[str] = true
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        --sub_str_tab[#sub_str_tab + 1] = sub_str
        self.mgc[sub_str] = true
        --trace(sub_str .. "****")
        str = string.sub(str, pos + 3, #str)
    end

    --return sub_str_tab
end

function SensitiveWord:ctor()
    self.mgc = {}
    local data
     local data
    data = cc.FileUtils:getInstance():getStringFromFile("res/img2/config/sensitive_words.txt")--io.open("../../assets/res/img2/config/sensitive_words.txt","r")
    if data ~= nil then
        local tbl = self:lua_string_split(data,"、")
    end
    
end
--过滤敏感词（如果onlyKnowHas为true，表示只想知道是否存在敏感词，不会返回过滤后的敏感词，比如用户注册的时候，
--我们程序是只想知道用户取的姓名是否包含敏感词的(这样也能提高效率，检测到有一个敏感词就直接返回)，
--而聊天模块是要返回过滤之后的内容的，那么onlyKnowHas可以不设，但这需要遍历所有可能）
function SensitiveWord:filterSensitiveWords( content , onlyKnowHas)
    --trace("是否存在特殊字符",content,onlyKnowHas)
    if content == nil or content == '' then
        return ''
    end
  
    --获取每一个字符
    local wordlist = {} 
    local q = 1
    for w in string.gmatch(content, ".[\128-\191]*") do   
        wordlist[q]= w
        q=q+1
    end
    --获取字符串中从起始位置到结束位置的字符
    local function findWord( wordTable, startpos,endpos )
        local result = ''
        for i=startpos,endpos do
            result = result..wordTable[i]
        end
        return result
    end

    local length = #(string.gsub(content, "[\128-\191]", ""))  --计算字符串的字符数（而不是字节数）
    local i,j = 1,1
   -- local replaceList={}
    --local mgc = {['敏感词1']=true,['敏感词2']=true,['敏感词3']=true}
    local bFind = false
    local function check(  )
        local v = findWord(wordlist,i,j)
        local item = self.mgc[v]
        if item == true then
            if onlyKnowHas == true then
                bFind = true
                return true
            end
            --table.insert(replaceList,v)
            j = j+1
            i = j
        else
            j = j+1
        end
        local limit = (j-i) >= 15 and true or (j > length and true or false) 
        if limit == true then --因为一个敏感词最多15个字，不会太长，目的提高效率
            i = i +1
            j = i 
        end
        if i <= length then
            check()
        end
    end
    check()
    return bFind
    
end

function SensitiveWord:replaceSensitiveWords( content , onlyKnowHas)
    --trace("是否存在特殊字符",content,onlyKnowHas)
    local str = content
    if content == nil or content == '' then
        return ''
    end
  
    --获取每一个字符
    local wordlist = {} 
    local q = 1
    for w in string.gmatch(content, ".[\128-\191]*") do   
        wordlist[q]= w
        q=q+1
    end
    --获取字符串中从起始位置到结束位置的字符
    local function findWord( wordTable, startpos,endpos )
        local result = ''
        for i=startpos,endpos do
            result = result..wordTable[i]
        end
        return result
    end

    local length = #(string.gsub(content, "[\128-\191]", ""))  --计算字符串的字符数（而不是字节数）
    local i,j = 1,1
   -- local replaceList={}
    --local mgc = {['敏感词1']=true,['敏感词2']=true,['敏感词3']=true}
    local bFind = false
    local function check(  )
        local v = findWord(wordlist,i,j)
        local item = self.mgc[v]
        if item == true then
            local str1 = string.gsub(str,v,"***",1)
            str = str1
            j = j+1
            i = j
        else
            j = j+1
        end
        local limit = (j-i) >= 15 and true or (j > length and true or false) 
        if limit == true then --因为一个敏感词最多15个字，不会太长，目的提高效率
            i = i +1
            j = i 
        end
        if i <= length then
            check()
        end
    end
    check()
    return str
end

return SensitiveWord