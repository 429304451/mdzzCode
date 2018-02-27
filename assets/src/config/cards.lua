local cards = {
	[0x01] = {sp_num = "2o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},--方块 2
	[0x02] = {sp_num = "3o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x03] = {sp_num = "4o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x04] = {sp_num = "5o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x05] = {sp_num = "6o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x06] = {sp_num = "7o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x07] = {sp_num = "8o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x08] = {sp_num = "9o"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x09] = {sp_num = "10o",sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x0A] = {sp_num = "11o",sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x0B] = {sp_num = "qo"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x0C] = {sp_num = "ko"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},
	[0x0D] = {sp_num = "ao"	,sp_huase = "fj"	,sp_huaseSmall = "fj",},--方块  A

	[0x11] = {sp_num = "2e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},	--梅花 2
	[0x12] = {sp_num = "3e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x13] = {sp_num = "4e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x14] = {sp_num = "5e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x15] = {sp_num = "6e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x16] = {sp_num = "7e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x17] = {sp_num = "8e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x18] = {sp_num = "9e"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x19] = {sp_num = "10e",sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x1A] = {sp_num = "11e",sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x1B] = {sp_num = "qe"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x1C] = {sp_num = "ke"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},
	[0x1D] = {sp_num = "ae"	,sp_huase = "mh"	,sp_huaseSmall = "mh",},--梅花A

	[0x21] = {sp_num = "2o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},--红桃 2
	[0x22] = {sp_num = "3o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x23] = {sp_num = "4o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x24] = {sp_num = "5o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x25] = {sp_num = "6o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x26] = {sp_num = "7o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x27] = {sp_num = "8o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x28] = {sp_num = "9o"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x29] = {sp_num = "10o",sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x2A] = {sp_num = "11o",sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x2B] = {sp_num = "qo"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x2C] = {sp_num = "ko"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},
	[0x2D] = {sp_num = "ao"	,sp_huase = "ot"	,sp_huaseSmall = "ot",},--红桃A
	

	[0x31] = {sp_num = "2e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},--黑桃2
	[0x32] = {sp_num = "3e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x33] = {sp_num = "4e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x34] = {sp_num = "5e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x35] = {sp_num = "6e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x36] = {sp_num = "7e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x37] = {sp_num = "8e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x38] = {sp_num = "9e"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x39] = {sp_num = "10e",sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x3A] = {sp_num = "11e",sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x3B] = {sp_num = "qe"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x3C] = {sp_num = "ke"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},
	[0x3D] = {sp_num = "ae"	,sp_huase = "ht"	,sp_huaseSmall = "ht",},--黑桃A
	
	[0x4E] = {sp_num = "je"	,sp_huase = "xw"		,sp_huaseSmall = "",},--小鬼
	[0x4F] = {sp_num = "jo"	,sp_huase = "dw"		,sp_huaseSmall = "",},--大鬼

	[0xDF] = {sp_num = ""	,sp_bk = "cr"	,sp_huaseSmall = "",},--背面
	[0xEF] = {sp_num = ""	,sp_bk = "bm"	,sp_huaseSmall = "",},--背面
	[0xFF] = {sp_num = ""	,sp_bk = "db"	,sp_huaseSmall = "",},--背面
}

local smallCards = {
	[0x4E] = {sp_num = "e"	,sp_huase = ""		,sp_huaseSmall = "xw",},--小鬼
	[0x4F] = {sp_num = "o"	,sp_huase = ""		,sp_huaseSmall = "dw",},--大鬼
	--[0x4E] = {sp_num = ""	,sp_huase = "e"		,sp_huaseSmall = "",},--小鬼
	--[0x4F] = {sp_num = ""	,sp_huase = "o"		,sp_huaseSmall = "",},--大鬼

	[0xFF] = {sp_num = ""	,sp_huase = "b"	,	sp_huaseSmall = "",},--背面
}

setmetatable(smallCards,{__index = 
	function(_,k) 
		local t =  table.copy(cards[k])
		if type(t) == "table" then
			t.sp_huase = "" 
		end
		return t 
	end 
})

return {cards,smallCards}