--游戏ID
local GAME_ID = {}

GAME_ID.MAIN				=		1
GAME_ID.ACTIVITY			=		2
GAME_ID.HAPPY_POKER			=		10003300    --斗地主
GAME_ID.CONTEST_POKER       =		10003303    --斗地主定时比赛
GAME_ID.GRABRED_LOARDS   	=		10003400    --红包场斗地主
GAME_ID.CONTEST_POKERS      =		10003304    --斗地主即时比赛
GAME_ID.Friend_POKER		=		10003301    --斗地主好友房
GAME_ID.KANPAI				=		10900500    --看牌抢庄
GAME_ID.BAIREN				=		10901800    --百人
GAME_ID.SHUIGUO				=		10801800    --水果机
GAME_ID.HUANLEBIPAI			=		10902500    --疯狂双十
GAME_ID.CRAZY_FRIEND_GAME	=		10902501    --疯狂双十好友房
GAME_ID.TWOAGAINST_DDZ		=		10003401    --二人斗地主
GAME_ID.TWOMAHJONG_GAME		=		10003402    --二人麻将
GAME_ID.PKSC				=		5

setmetatable(GAME_ID,{__index = function(t,k,v) return rawget(t,k) or 0 end})

return GAME_ID