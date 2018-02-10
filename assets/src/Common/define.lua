--C++协议解析


--请求游戏全局参数  客户端发服务器无包体

MDM_SOCKET_HEARD							=	1 	--心跳包
	ASS_SOCKET_HEARD						=	1 	--心跳包子ID
	ASS_SOCKET_ISCONNECT					=	3	--已经连上
MDM_SOCKET_CONNECT_CHECK					=	100
	ASS_SOCKET_CONNECT_CHECK				=	23 	--客户端主动发起请求,服务器必回

MDM_GP_REQURE_GAME_PARA = 102
	ASS_GP_REQURE_GAME_PARA 				= 	0
	ASS_GP_GAME_PARA_REQ 					= 	1
	
--大厅登录
MDM_GP_LOGON = 100								
	ASS_GP_LOGON_BY_NAME 					= 	1--通过用户名字登录
	ASS_GP_LOGON_ERROR						= 	6--密码错误
	ASS_GP_LOGON_SUCCESS 					= 	5 --登录成功
	--注册和认证相关协议
	ASS_GP_LOGON_REG						=	11									--用户快速注册,
	ASS_GM_MODIFY_MONEY						=	15--修改金钱
	ASS_GP_LOGON_SUCCESS_ADD  				=	16
	ERR_GP_MSG_SIZE_ERR						=	25--结构不一致
MDM_GP_USERREFLASH	=				113
	--ASS_GP_USER_HAS_CREATE_PSW				=	3								-- 查询用户是否创建过密码
	ASS_GP_USER_PASSWORD_UPDATE				=	4								-- 密码更新
	ASS_GP_USER_NICKNAME_UPDATE				=	5			
	ASS_GP_USER_NICKNAME_SEX_HEAD			=	6		
	ASS_GP_USERREFLASH						=	1	
	ASS_GP_USERREFLASH_NOTICE				=	2

MDM_GP_LIST = 101	--游戏列表
	--ASS_GP_LIST_KIND						=	1		--获取游戏类型列表  客户端发服务器无包体,服务器发客户端 struct ComKindInfo/
	--ASS_GP_LIST_NAME						=	2		--/获取游戏名字列表                                      struct ComNameInfo
	--/获取游戏房间数据包			
	--ASS_GP_LIST_ROOM						=	3		--/获取游戏房间列表
	--ASS_GP_LIST_ROOM_BY_ID					=	4		--/只根据一个房间id获取该游戏的所有房间列表	
	ASS_GP_GET_ROOM							=	5		--房间请求(用于手机APP请求进入哪个房间)
	ASS_GP_GET_ROOM_ERROR					=	6		--房间请求失败
	ASS_GP_GET_GAME_PEOPLE_COUNT			=	8 		--获取游戏人数
	ASS_GP_GET_ROOM_BY_ID					=	7       --根据房间ID请求房间
	ASS_GP_GET_GAMELEVEL_PEOPLE_COUNT 		=	10      --根据房间等级返回人数请求
	ASS_GP_GET_ROOM_TIME_ERROR 				=	11

MDM_GP_COIN  							=			0x01000029  	--门票复活
	ASS_GP_COIN_RESURRECTION    		=			1
		enCoinResurrection_game			=			0
		enCoinResurrection_Share		=			1
		enCoinResurrection_DownLoad		=			2
		enCoinResurrection_Pay			=			3

MDM_GP_TURN_TABLE 						=			0x01000030 		--转盘摇奖
	ASS_GP_RED_TURN_TABLE 				=			1				--转盘摇奖
	ASS_GP_RED_TURN_TABLE_RECORD 		=			2				--摇奖记录
	ASS_GP_TURN_TABLE					=			3				--分享转盘

MDM_GP_ACTIVE							=			0x01000007
	ASS_ACTIVELIST 						=			1
	ASS_ACTIVE_LOTTERY_REQ 				=			10
---------------------------------------------------------房间消息----------------------------------------------------------
MDM_GR_LOGON = 100				
	ASS_GR_LOGON_BY_ID						=	5
	ASS_GR_LOGON_SUCCESS 					=	2
	ASS_GR_LOGON_ERROR 						= 	3 				--登录失败
MDM_GR_SOCKET_CLOSE							=	120	
	ASS_GR_ZSERVER_RELOG_KICK				=	1 		--踢下线
	ASS_GR_ROOM								=	2

--房间			
MDM_GR_USER_ACTION	=	102 	--用户动作
	ASS_GR_USER_UP							=	1			--客户端发送无包体								--/用户起来
	ASS_GR_USER_SIT							=	2									--用户坐下
	ASS_GR_WATCH_UP							=	3									--旁观起来
	ASS_GR_WATCH_SIT						=	4									--旁观坐下
	ASS_GR_USER_STATE						=	23                                  --用户状态改变
	ASS_GR_LEFT_DESKSTATION    				=   26                                  --离开位置
	ASS_GR_JOIN_QUEUE						=	11			--加入排队机
	ASS_GR_QUIT_QUEUE						=	12			--退出排队机
	ASS_GR_QUEUE_USER_SIT					=	13
	ASS_GR_USER_COME						=	5			--用户进入
	ASS_GR_NoMoneyTickRoom					=	16 			--金币不足
	ASS_GR_SIT_ERROR						=	8			--坐下错误	
	ASS_GR_FRIEND_USER_SIT					=	21
	ASS_GR_FRIEND_USER_JOIN 				=	22
	ASS_GR_USER_CUT							= 	7
	ASS_GR_USER_AUTO_SIT					=	28
	ASS_GR_DESK_DISSOLVED 					=	29   		--解散桌子
	ASS_GR_USER_STANDUP 					=	9
	ASS_GR_SIGN_UP   						=	20
	ASS_GR_LEAVE_QUEUE  					=	43

MDM_GR_ROOM									=	103									--房间信息
	ASS_GR_USER_AGREE						=	3									--用户同意
	ASS_GR_USER_POINT						=	6
	ASS_GR_MATCH_RANK 						=	210
	ASS_GR_SEND_MONEY_NOTFIY				=	30


MDM_GM_GAME_NOTIFY	=	180			--游戏消息
	ASS_GM_AGREE_GAME						=	1 			--用户准备
	ASS_GM_GAME_STATION						=	2			--游戏状态
	ASS_GAME_BEGIN							=	51			--游戏开始
	ASS_SEND_ALL_CARD						=	55			--发送所有牌(一下发放全部)
	ASS_SEND_FINISH							=	56			--发牌完成
	ASS_CALL_SCORE							=	57			--叫分
	ASS_CALL_SCORE_RESULT					=	58			--叫分结果
	ASS_CALL_SCORE_FINISH					=	59			--叫分结束
	ASS_ROB_NT								=	61			--抢地主
	ASS_ROB_NT_RESULT						=	62			--抢地主结果
	ASS_GAME_MULTIPLE						=	64			--游戏倍数(抢地主后会加倍)
	ASS_ROB_NT_FINISH						=	65			--抢地主结果
	ASS_BACK_CARD_EX						=	67			--底牌数据
	ASS_SHOW_CARD							=	72			--亮牌
	ASS_SHOW_CARD_RESULT					=	73			--亮牌结果
	ASS_SHOW_CARD_FINISH					=	104			--亮牌结束
	ASS_NO_SHOW_CARD						=  	71			--不亮牌
	ASS_NO_SHOW_CARD_RESULT					=	105			--不亮牌结果
	--ASS_DOUBLE_MULTIPLE						=	74			--加倍
	ASS_DOUBLE_MULTIPLE_RESULT				=	75			--加倍结果
	ASS_DOUBLE_MULTIPLE_FINISH				=	103			--加倍结束
	ASS_GAME_PLAY							=	76			--开始游戏
	ASS_OUT_CARD							=	77			--用户出牌
	ASS_OUT_CARD_RESULT						=	78			--出牌結果
	ASS_REPLACE_OUT_CARD					=	80			--代替出牌(79留给超级客户端发牌器)
	ASS_ONE_TURN_OVER						=	81			--一轮完成(使客户端上一轮可用)
	ASS_NEW_TURN							=	82			--新一轮开始
	ASS_AWARD_POINT							=	83			--奖分(炸弹火箭)
	ASS_CONTINUE_END						=	84			--游戏结束
	ASS_NO_CONTINUE_END						=	85			--游戏结束
	ASS_NO_CALL_SCORE_END					=	86			--无人叫分
	ASS_CUT_END								=	87			--用户强行离开
	ASS_SAFE_END							=	88			--游戏安全结束
	ASS_TERMINATE_END						=	89			--意外结束
	ASS_AHEAD_END							=	90			--提前结束
	ASS_AUTO								=	91			--用户托管
	ASS_AI_STATION							=	95			--机器人托管(断线户用)
	ASS_SHOW_CARD_COUNT						=	96			--是否显示手上牌张数
	ASS_POWER_CHANGE						=	97			--活力值变化
	ASS_CS_USER_PICK_SUNSHINE				=	98			--用户收集到阳光值
	ASS_SC_USER_PICK_SUNSHINE				=	99			--收集阳光处理结果
	ASS_CS_USER_POWER100					=	100			--用户的活力达到100
	ASS_CS_CLK_FULL_SUNTREE					=	101			--点击满值的阳光树
	ASS_SC_CLK_FULL_SUNTREE					=	102			--点击。。。。。。。。回包
	ASS_GM_SEND_ALL_CARD_AT_END     		=	200         --游戏结束后,把所有牌发送给客户端,用于录像明牌
	ASS_GM_SEND_USERLOST_INFO	    		=	201         --游戏结束后,把玩家输的详细信息发下去
	--ASS_CHECK_CARD							=	210			--强迫检查更新玩家的牌
	--ASS_SEND_JINGBAO						=	211			--牌小于等于3张,发送警报
	ASS_SEND_SHOWDIPAIPRE           		=	212         --提前发送底牌
	ASS_APPLY_DISSOLVED_ROOM 				=	301			--好友房申请解散
	ASS_REPLY_DISSOLVED_ROOM				=	302
	ASS_APPLY_DISSOLVED_RECOME 				=	303
	ASS_GET_LEAVE_CARD 						=	70
	ASS_SEND_USER_CARD 						=	60
MDM_GM_GAME_FRAME	=	150			--框架消息
	ASS_GM_GAME_INFO						=	1			--游戏信息
	ASS_GM_FORCE_QUIT						=	3 			--离开房间
	ASS_GM_NORMAL_TALK						=	4 			--普通聊天
	ASS_GM_USER_INFO 						=	5 			--查看玩家信息
	ASS_GM_NORMAL_CHAT 						=	6           --聊天系统

MDM_GP_BATTLE_MSG = 	0x01000003		--比赛消息
	ASS_GP_BATTLE_USER_SIGN_UP_REQ 			=	11          --玩家报名
	ASS_BATTLE_CANCLE_SIGNUP				=	13 			--玩家取消报名
	ASS_GP_BATTLE_USER_SIGNUP_INFO_REQ		=	9 			--请求玩家报名信息
	ASS_GP_BATTLE_USER_SIGNUP_REFRESH		=	19 			--报名成功  游戏人数改变
	ASS_BATTLE_MATCH_WILL_BEGIN_NOTIFY		=	12 			--报名人数满，游戏即将开赛
	ASS_GP_FIX_BATTLE_USER_SIGN_UP_REQ		=	16 			--定点赛报名
	ASS_FIX_BATTLE_WILL_START_NOTIFY		=	15   		--定时赛即将开赛
	ASS_CANCLE_FIX_TIME_BATTLE				=  	17			--定点赛人数数不够，取消比赛
	ASS_FIX_BATTLE_END						=	18 			--定点赛比赛结束
	ASS_GP_BATTLE_USER_RANK_INFO_REQ		=  	8
	ASS_GP_BATTLE_REQ_RANK_ONE_ROOM			=	2 			--房间战绩请求
MDM_GR_BATTLE_MSG 		=	0x02000002	--比赛房间消息
	 ASS_GR_MATCH_SYS_INFO					=	4
	 ASS_GR_USER_STATE_NOTIFY				=	7
	 ASS_GR_PLAYING_DESK_CNT_NOTIFY			=	13
	 ASS_GR_PLAYER_MATCH_OVER				=   14
	 ASS_GR_PLAYER_WIN_NOTIFY				=	17
	 ASS_GR_MATCH_NEW_ROUND_BEGIN			=	10
	 ASS_GR_MATCH_NEW_GAME_BEGIN 			= 	11
	 ASS_GR_DESK_GAME_OVER					=	16
	 ASS_GR_MATCH_BEGIN 					=	9
	 ASS_GR_MATCH_USER_RANK					=  	21
	 ASS_Match_ENDTIPS						= 	20
	 ASS_GR_MATCH_RANKS						=	22
	 ASS_GR_MATCH_USER_REBACK_WAIT_OTHER_DESK = 24
--游戏任务
MDM_GR_TASKDAILY 							=	118
	ASS_GR_GAMETASK_BOX_AWARD   			=	3

MDM_GP_PROP	=	140	--商城
	ASS_PROP_BUY = 3
	ASS_PROP_GETUSERPROP = 1
	ASS_PROP_USEPROP = 0x10
	ASS_PROP_BIG_BOARDCASE =	0x07

MDM_GR_PROP = 160
	ASS_PROP_BUYGOLD = 0x12

MDM_GP_MAIL	=			0x01000026--邮件
	ASS_GP_MAIL_ALL							=	1			--获取全部邮件
	ASS_GP_MAIL_READ						=	2			--阅读文件(提取邮件附件)
	ASS_GP_MAIL_NEW							=	3
	ASS_GP_MALL_REQ_NEW 					=	4          --新邮件请求
	ASS_GP_MALL_HAS_READ 					=	5 		   --已读邮件请求

MDM_GP_VIP_LOGE = 	0x0100000F--好友房
	ASS_GP_HAS_CREATE_FRIEND_ROOM 			=	0x10
	ASS_GP_CREATE_FRIEND_ROOM 				=	0x11
	ASS_GP_JOIN_FRIEND_ROOM 				= 	0x12
	ASS_GP_DISSOLVED_FRIEND_ROOM 			=	0x14

MDM_GP_RED	=	0x01000027	--红包
	ASS_GP_SEND_RED							=	1
	ASS_GP_ACCEPT_RED						=	2
	ASS_GP_RECEIVE_RED						=	3
	ASS_GP_SEND_PIAZZA_RED   				=	4
	ASS_GP_GET_PIAZZA_RED 					=	5
	ASS_GP_LOOK_PIAZZA_RED					=	6
	ASS_GP_GUESS_PIAZZA_RED 				=	7
	ASS_GP_NEW_PIAZZA_RED 					=	8
	ASS_GP_BEGUESSED_PIAZZA_RED 			=	9
	ASS_GP_DEL_PIAZZA_RED  					=	10
	ASS_GP_RECOVER_PIAZZA_RED				=	11
	ASS_GP_MY_PIAZZA_RED_INFO 				=	12
	ASS_GP_REDBAG 							=	13
	ASS_GP_PIZZA_RED_INFO 					=	14
	ASS_GP_PIZZA_RED_OPERATOR 				=	15
MDM_GR_RED = 0x02000010
	ASS_GR_RECEIVE_RED						=	1
MDM_GR_VIP_LOGE = 0x02000006
	ASS_GR_VIP_ROOM_OWNER_DISSOLVED 		=	0x05
	ASS_GR_VIP_ROOM_OWNER_START_GAME  		=	0x08

MDM_GR_USER_REFRESH = 0x02000011
	ASS_GR_USER_MONRY_REFRESH				=	1

MDM_GP_MAQ_MSG   = 0x01000004
	ASS_GP_MAQ_MSG_NOTIFY 	=	1
	ASS_GR_MAQ_MSG_NOTIFY   =   2

MDM_GP_TASK     		=			112
	ASS_GP_TASKLIST 				=	1
	ASS_GP_TASK_RECEIVE_REWARD		=	2
	ASS_GP_TASK_FINISH_NOTICE  		=	3
	ASS_GP_NEWTASKINFO  			=	4
	ASS_GP_NEW_TASK_RECIVE 			=	5
	ASS_GP_TASK_WX_SHARE			=	6
MDM_WEB_MAIN_ID 						=			300
	ASS_WEB_MSG_FORBID_USER				=			28		--封号
	ASS_WEB_MSG_FOLLOW_WECHAR 			=			29 		--关注微信任务完成
	ASS_WEB_MSG_RECEIVE_WECHAR_PRIZE 	=			30 		--领取微信关注号奖励成功
	ASS_WEB_MSG_HEAD_VERIFY_FAIL		=			32 		--头像审核未通过
	ASS_WEB_MSG_RECHARGE 				=			35
MDM_GP_SIGN 							=			0x01000028
	ASS_GP_SIGN 						=			1

MDM_GP_VIP 								=			0x01000009
	ASS_VIP_RECEIVE_DAY_REWARD 			=			25

MDM_GR_ROOM_WXRED 						=			0x02000100 --房间微信红包主ID
	ASS_GP_BATTLE_ROOM_SEND_WXRED       = 			20  --发微信红包(第一次发)
	ASS_GP_BATTLE_USER_ACCEPT_WXRED 	=			21
	ASS_GP_BATTLE_ROOM_SEND_BOX 		=			22 --发宝箱
	ASS_GP_BATTLE_ROOM_OPEN_BOX 		=			23


invalid_level = 255
--周卡月卡ID
WEEKS_CARD_ID_GOLD 	=	401
WEEKS_CARD_ID 		=	402
MONTH_CARD_ID 		=	403
--唯一任务ID
MOBILE_PHONE_TASK			=	202
MODIFIED_NICKNAME_TASK		=	201
MODIFY_PASSWORD_TASK		=	203
MODIFY_FOLLOW_WRCHAR_TASK	=	204
MODIFY_RANK_AWARD_TASK   =  	205
MODIFY_VIP_UP_GRADE_TASK 	=	206

enRED_TYPE = {}
enRED_TYPE.RED_TYPE_SEND 			= 0 		--发布
enRED_TYPE.RED_TYPE_OVERTIME 		= 1 		--超时退回
enRED_TYPE.RED_TYPE_RECOVER 		= 2 		--手动下架
enRED_TYPE.RED_TYPE_WAIT 			= 3 		--被猜中等待操作
enRED_TYPE.RED_TYPE_AGREE 			= 4 		--同意
enRED_TYPE.RED_TYPE_REFUSE 			= 5 		--拒绝
enRED_TYPE.RED_TYPE_WAIT_OTHER 		= 6 		--猜中等待对方操作
enRED_TYPE.RED_TYPE_OTHER_AGREE 	= 7 		--对方同意
enRED_TYPE.RED_TYPE_OTHER_REFUSE 	= 8 		--对方拒绝




--数据类型
MSG_DATA_TYPE = {
	DWORD = {size = 4,type = "num"},
	int = {size = 4,type = "num"},
	longint = {size = 4,type = "num"},
	UINT = {size = 4,type = "unnum"},
	char = {size = 1,type = "string"},
	long = {size = 4,type = "num"},
	BYTE = {size = 1,type = "unnum"},
	__int64 = {size = 8,type = "num"},
	time_t = {size = 8,type = "num"},
	bool = {size = 1,type = "bool"},
	short = {size = 2,type = "num"},
	shortChar = {size = 1,type = "string"},--这种类型表示服务器会在前两个字节发数组的长度,后面是正文
}

setmetatable(MSG_DATA_TYPE,{__index=function(self, key) return rawget(self, string.lower(key)) or rawget(self, string.upper(key)) end })

local _len_head_web				= 256
local _len_user_name          = 50
local _len_user_nickname      = 16
local _len_mac				  = 65
local _len_pwd_               = 33
local _len_id_no              = 20
local _len_ip                 = 18
local _len_suggest_title      = 50   --玩家反馈标题长度
local _len_suggest_content    = 201  --玩家反馈内容长度
local MAX_ROOM_PROXY_COUNT    = 4
local NAME_STRING_LEN = 61
local _len_signatrue = 60
local TASK_INFO_LEN			=	100	            --任务介绍长度
local TOTAL_CARD_CNT = 54
local PLAY_COUNT = 3
local _desk_pwd_len				=	7
local PHNOE_NUMBERS_FEW  		=	12
local _len_mag_msg 				=	500
local _max_battle_show_player_rank_num = 20
local _room_name = 30
local RED_REMARK_LEN = 36		--红包说明长度

USER_NO_STATE 		=	0 		--没有状态，不可以访问
USER_LOOK_STATE 	=	1 		--进入了大厅没有坐下
USER_SITTING 		=	2 		--坐在游戏桌
USER_ARGEE 	 		=	3 		--同意状态
USER_WATCH_GAME 	=	4 		--旁观游戏
USER_WATCH_SIT 		=	6 		--坐下等待游戏(坐在位置上旁观)
USER_DESK_AGREE		=	5  		--大厅同意
USER_CUT_GAME 		=	20 		--断线状态			（游戏中状态）
USER_PLAY_GAME		=	21 		--游戏进行中状态	（游戏中状态）

GS_WAIT_SETGAME		=	0		--等待东家设置状态GameStation_2
GS_WAIT_ARGEE		=	1		--等待同意设置GameStation_2
GS_SEND_CARD		=	2		--发牌状态GameStation_3
GS_WAIT_BACK		=	3		--等待扣压底牌GameStation_3
GS_WAIT_SHOW_CARD	=	4		--等待明牌
GS_PLAY_GAME		=	5		--游戏中状态GameStation_4
GS_WAIT_NEXT		=	6		--等待下一盘开始 GameStation_5

--结构体类型
MSG_GAME_STRUCT = {}

--网络数据包结构头
MSG_GAME_STRUCT.NetMessageHead = {
	{type = MSG_DATA_TYPE.DWORD, key = "uMessageSize"},  --数据包大小
	{type = MSG_DATA_TYPE.DWORD, key = "uMainID"},		--处理主类型
	{type = MSG_DATA_TYPE.DWORD, key = "uAssistantID"},	--辅助处理类型 ID
	{type = MSG_DATA_TYPE.DWORD, key = "uHandleCode"},	--数据包处理代码
	{type = MSG_DATA_TYPE.DWORD, key = "dwClientIP"},	--代理传过来的ip内容   20120319
	{type = MSG_DATA_TYPE.DWORD, key = "uCheck"},		--保留字段
}

--登录返回内容
MSG_GAME_STRUCT.CenterServerMsg = 
{
	{type = MSG_DATA_TYPE.char , key = "m_strGameSerialNO",num = 20},			--客户端当前版本系列号
	{type = MSG_DATA_TYPE.char , key = "m_strMainserverIPAddr",num = 20},		--主服务器IP地址
	{type = MSG_DATA_TYPE.long , key = "m_iMainserverPort"},				    --主服务器端口号
}

MSG_GAME_STRUCT.MSG_C_RGAME_PARA_REQ   =   --根据地区请求合作商信息
{
	{type = MSG_DATA_TYPE.int  , key = "iAreaID"},   --要请求的地区ID,为0
	{type = MSG_DATA_TYPE.char  , key = "strGameSerialNO",num = 8},--客户端版本号
};


--快速注册
MSG_GAME_STRUCT.MSG_C_REG_QUICK =             
{	
	----BYTE								bBoy;								--是否男性别
	{type = MSG_DATA_TYPE.char, key = "szName",num = _len_user_name},				--用户登录名(设备号)
	{type = MSG_DATA_TYPE.char, key = "nickName",num = _len_user_nickname},	--
	{type = MSG_DATA_TYPE.char, key = "szMD5Pass",num = _len_pwd_},				--用户加密密码	
	{type = MSG_DATA_TYPE.char, key = "szToken",num = _len_mac},			--MAC
	{type = MSG_DATA_TYPE.char, key = "szMD5",num = 64},
	{type = MSG_DATA_TYPE.char, key = "szHeadWeb",num = _len_head_web},

	{type = MSG_DATA_TYPE.int, key = "bRegWay"},      --注册来源(其他平台)
	{type = MSG_DATA_TYPE.int, key = "iAreaID"},      --运营商ID
	{type = MSG_DATA_TYPE.UINT, key = "iWBFlag",def = 1},     --网吧标识
	{type = MSG_DATA_TYPE.BYTE, key = "iIssue"},      --期数
	{type = MSG_DATA_TYPE.int, key = "iPCID",def = 0},        --试玩平台用户ID
};

--账号登录
MSG_GAME_STRUCT.MSG_GP_S_LogonByNameStruct = 
{
	{type = MSG_DATA_TYPE.char, key = "zName",num = _len_user_name},				--登录名字
	{type = MSG_DATA_TYPE.char, key = "szMD5",num = 33},
	--{type = MSG_DATA_TYPE.char, key = "TML_SN",num = 128},							--MAC地址
	{type = MSG_DATA_TYPE.char, key = "szMD5Pass",num = 33},						--登录密码
	{type = MSG_DATA_TYPE.char, key = "szMathineCode",num = _len_mac},					--本机机器码zxj 2009-11-10 锁定机器
	{type = MSG_DATA_TYPE.UINT, key = "uRoomVer",},							--大厅版
	{type = MSG_DATA_TYPE.BYTE, key = "bLogonType",},							--登录方式,(见enLGONTYPE)
	{type = MSG_DATA_TYPE.char, key = "szHeadWeb",num = _len_head_web},
};

--密码错误
-- MSG_GAME_STRUCT.MSG_GP_R_Logon_Failed =
-- {	
-- 	{type = MSG_DATA_TYPE.int , key = "iPwdErrChance"}, --用户还有多少次试密码错误的机会 
-- 	{type = MSG_DATA_TYPE.char , key = "szErrReason",num = 100},  --账号被禁用的理由
-- };

--登录大厅成功后返回
MSG_GAME_STRUCT.MSG_GP_R_LogonResultApp = 
{
	{type = MSG_DATA_TYPE.int, key = "dwUserID"}, 									--用户 ID 
	{type = MSG_DATA_TYPE.BYTE, key = "bLogoID"},									--用户头像
	{type = MSG_DATA_TYPE.bool, key = "bBoy"},									--性别
	{type = MSG_DATA_TYPE.char, key = "nickName",num = _len_user_nickname},									--用户昵称
	{type = MSG_DATA_TYPE.__int64 , key = "dwMoney"},									--用户金币  
	--{type = MSG_DATA_TYPE.__int64, key = "dwBank"},								--用户财富
	{type = MSG_DATA_TYPE.int, key = "dwTreasure"},                                   --元宝
	--{type = MSG_DATA_TYPE.int, key = "iVipTime"},										--
	--{type = MSG_DATA_TYPE.int, key = "iExperience"},                                  --游戏经验
	--{type = MSG_DATA_TYPE.int, key = "iGameLevel"},                                 --游戏等级
	--{type = MSG_DATA_TYPE.char, key = "cTitle",num = 61},								--玩家头衔	
	{type = MSG_DATA_TYPE.time_t, key = "tmServer"},                               --服务器时间,用于客户端刷新比赛房间
	{type = MSG_DATA_TYPE.int, key = "iCutRoomID"},						           --当前正在的房间
	{type = MSG_DATA_TYPE.int, key = "iCurMatchID"},                               --比赛ID
	{type = MSG_DATA_TYPE.int, key = "iCurGameNameID"},							-- 当前正在游戏的ID
	{type = MSG_DATA_TYPE.BYTE, key = "bCurRoomLevel"},										--当前正在的游戏房间等级
	--{type = MSG_DATA_TYPE.int, key = "iSignupMatchID"},										-- 已报名的比赛ID
	--{type = MSG_DATA_TYPE.int, key = "iSignupRoomID"},										-- 已报名的比赛对应的房间ID
	--{type = MSG_DATA_TYPE.int, key = "dwParam"},										-- 手机验证 &0x0001
	--{type = MSG_DATA_TYPE.int, key = "IsMsgIdentify"},										-- 是否需要短信验证(0,1)
	--{type = MSG_DATA_TYPE.int, key = "iTodyWin"},										-- 今日输赢
	{type = MSG_DATA_TYPE.int, key = "iRedSendAmount"},										-- 发送红包总数
	{type = MSG_DATA_TYPE.int, key = "iRedReceiveAmount"},										-- 收红包总数
	{type = MSG_DATA_TYPE.time_t, key = "tWeekCardTime"},									-- 周卡有效期
	{type = MSG_DATA_TYPE.time_t, key = "tMonthCardTime"},									-- 月卡有效期
	{type = MSG_DATA_TYPE.bool, key = "bIsFirstPay"},										-- 是否首冲过
	{type = MSG_DATA_TYPE.char, key = "szPhoneNumber",num = PHNOE_NUMBERS_FEW},										-- 手机号
	{type = MSG_DATA_TYPE.time_t, key = "tmRegDate"},									--用户注册时间
	--{type = MSG_DATA_TYPE.short, key = "sDssBestRank"},						--定时赛历史最高名次
	--{type = MSG_DATA_TYPE.short, key = "sJssBestRank"},						--即时赛历史最高名次
	{type = MSG_DATA_TYPE.int, key = "iVoucher"},							--奖券
	{type = MSG_DATA_TYPE.bool, key = "bGetWeiXinRed"},							--是否领取过微信红包
	{type = MSG_DATA_TYPE.bool, key = "bIsModifyPsw"},							--是否修改过密码
	{type = MSG_DATA_TYPE.bool, key = "bNewUser"},							--是否
	{type = MSG_DATA_TYPE.BYTE, key = "bVipLevel"},							--VIP等级
	{type = MSG_DATA_TYPE.int	,key = "iRechangeCount"},						--充值总金额
	{type = MSG_DATA_TYPE.bool	,key = "bTodaySign"},							--今日是否签到过
	{type = MSG_DATA_TYPE.bool	,key = "bTodayVipBag"},						--今日是否领取过VIP礼包
	{type = MSG_DATA_TYPE.BYTE	,key = "iCSignDays"},							--连续签到天数
	{type = MSG_DATA_TYPE.int	,key = "iGameCoin"},						--门票
	{type = MSG_DATA_TYPE.int	,key = "iRedMoney"},						--现金红包
	{type = MSG_DATA_TYPE.bool, key = "bCertification"},							--//剩余复活次数
	-- {type = MSG_DATA_TYPE.BYTE, key = "iResurrection"},							--//剩余复活次数
	{type = MSG_DATA_TYPE.bool, key = "bIsResurrectionToday"},							--是否今天已经复活过(新手)
	{type = MSG_DATA_TYPE.int,  key = "iRedTurnCount"},							--今日幸运转盘已使用次数
	{type = MSG_DATA_TYPE.BYTE, key = "bHeadWebLen"},							--头像长宽
	{type = MSG_DATA_TYPE.char, key = "szHeadWeb",num = "bHeadWebLen"},							--头像
};

MSG_GAME_STRUCT.MSG_GP_R_LogonResultAppAdd = 
{
	{type = MSG_DATA_TYPE.BYTE, key = "iDDZSignUpLevel"},						    --斗地主已报名的房间等级
	{type = MSG_DATA_TYPE.BYTE, key = "iNewTaskID"},							    --新手七天任务ID
	{type = MSG_DATA_TYPE.BYTE, key = "iNewTaskValue"},							    --新手七天任务完成情况（0未完成 1已完成 2已领取）
	{type = MSG_DATA_TYPE.BYTE, key = "iNewFinishCount"},							--新手七天任务完成进度
	{type = MSG_DATA_TYPE.bool, key = "bTodayCanRecive"},							--新手七天任务完成进度
	{type = MSG_DATA_TYPE.BYTE, key = "bUserBrnnResureType"},						--百人复活类型
	{type = MSG_DATA_TYPE.int, key = "iPromoTurnCount"},							--推广次数
	{type = MSG_DATA_TYPE.bool, key = "bWXShare"},							        --分享任务
	{type = MSG_DATA_TYPE.time_t, key = "tmResurrectionTM"},						--最后一次复活时间
};

--请求进入的房间信息
MSG_GAME_STRUCT.MSG_GP_GETROOM =
{
	{type = MSG_DATA_TYPE.UINT, key = "uKindID"},							--类型 ID
	{type = MSG_DATA_TYPE.UINT, key = "uNameID"},							--名字 ID
	{type = MSG_DATA_TYPE.UINT, key = "iRoomLevel"},                         --房间等级
};

MSG_GAME_STRUCT.ComRoomInfoApp =
{
	{type = MSG_DATA_TYPE.UINT, key = "uServicePort"},									--/大厅服务端口
	{type = MSG_DATA_TYPE.UINT, key = "szServiceIP"},									--/服务器 IP 地址
	{type = MSG_DATA_TYPE.char, key = "szProxySrvIP",num = 25},		--代理服务器ip列表
	{type = MSG_DATA_TYPE.UINT, key = "szProxySrvPort",},		--[25];	--代理服务器端口列表
	{type = MSG_DATA_TYPE.int, key = "iLessPoint"},										--/底分	
	{type = MSG_DATA_TYPE.int, key = "iBasePoint"},										--/倍率
};


MSG_GAME_STRUCT.MSG_GR_S_RoomLogon =
{
	{type = MSG_DATA_TYPE.UINT, key = "uNameID"},					--名字 ID
	{type = MSG_DATA_TYPE.LONG, key = "dwUserID"},					--用户 ID
	{type = MSG_DATA_TYPE.UINT, key = "uRoomVer"},					--大厅版本, 此字段以前没有实际的应用,现在被改为手机与pc客户端的标志. 0 为PC客户端 1为手机
	{type = MSG_DATA_TYPE.UINT, key = "uGameVer"},					--游戏版本
	{type = MSG_DATA_TYPE.CHAR, key = "szMD5Pass",num = 33},					--加密密码
	{type = MSG_DATA_TYPE.CHAR, key = "nTokenID",num = _len_mac},	--MAC地址
	{type = MSG_DATA_TYPE.CHAR, key = "szSign",num = 33},				
};

MSG_GAME_STRUCT.UserInfoStructApp = 
{
	{type = MSG_DATA_TYPE.int, key = "dwUserID"},							--ID 号码
--	{type = MSG_DATA_TYPE.longint, key = "dwExperience"},						--经验值
--	{type = MSG_DATA_TYPE.int	, key = "dwPoint"},							--分数
	{type = MSG_DATA_TYPE.__int64, key = "dwMoney"},							--金币
--	{type = MSG_DATA_TYPE.__int64, key = "dwBank"},								--银行
--	{type = MSG_DATA_TYPE.UINT	, key = "uWinCount"},							--胜利数目
--	{type = MSG_DATA_TYPE.UINT	, key = "uLostCount"},							--输数目
--	{type = MSG_DATA_TYPE.UINT	, key = "uCutCount"},							--强退数目
--	{type = MSG_DATA_TYPE.UINT	, key = "uMidCount"},							--和局数目
	{type = MSG_DATA_TYPE.UINT	, key = "bLogoID"},							--头像 ID 号码
--	{type = MSG_DATA_TYPE.BYTE	, key = "bDeskNO"},							--游戏桌号
--	{type = MSG_DATA_TYPE.BYTE	, key = "bDeskStation"},						--桌子位置
--	{type = MSG_DATA_TYPE.BYTE	, key = "bUserState"},							--用户状态
	{type = MSG_DATA_TYPE.bool	, key = "bBoy"},								--性别
	{type = MSG_DATA_TYPE.short	, key = "sPlayCount"},							--已进行的局数
	{type = MSG_DATA_TYPE.char	, key = "nickName",num = _len_user_nickname},			--用户昵称
	{type = MSG_DATA_TYPE.bool	, key = "bSignUp"},								--是否报名斗地主
	{type = MSG_DATA_TYPE.BYTE	, key = "bTodayFishCount"},						--今日已领取宝箱次数
};

MSG_GAME_STRUCT.MSG_GR_R_LogonResultApp = 
{
	{type = MSG_DATA_TYPE.UINT, key = "uLessPoint"},										--最少金币数
	{type = MSG_GAME_STRUCT.UserInfoStructApp, key = "pUserInfoStructApp"},					--用户信息
};

MSG_GAME_STRUCT.MSG_GR_R_LogonErrorApp = 
{
	{type = MSG_DATA_TYPE.int, key = "iRoomID"},							--房间ID
	{type = MSG_DATA_TYPE.int, key = "iGameNameID"},						--游戏ID
	{type = MSG_DATA_TYPE.char, key = "szRoomName",num = _room_name},
	{type = MSG_DATA_TYPE.BYTE, key = "iRoomLevel"},		--房间等级
	{type = MSG_DATA_TYPE.int, key = "iRoomPwd"},		--房间密码
};


MSG_GAME_STRUCT.UserCome = 
{
	{type = MSG_DATA_TYPE.int, key = "dwUserID"},							--ID 号码
	{type = MSG_DATA_TYPE.__int64, key = "dwMoney"},							--金币
	{type = MSG_DATA_TYPE.int, key = "iScore"},									--分数
	{type = MSG_DATA_TYPE.bool, key = "bBoy"},									--性别
	{type = MSG_DATA_TYPE.BYTE	, key = "bLogoID"},							--头像 ID 号码
	{type = MSG_DATA_TYPE.BYTE	, key = "bDeskNO"},							--游戏桌号
	{type = MSG_DATA_TYPE.BYTE	, key = "bDeskStation"},						--桌子位置
	{type = MSG_DATA_TYPE.BYTE	, key = "bUserState"},							--用户状态
	{type = MSG_DATA_TYPE.BYTE	, key = "bVipLevel"},							--vip等级
	--{type = MSG_DATA_TYPE.short	, key = "sPlayCount"},							--vip等级
	{type = MSG_DATA_TYPE.char	, key = "nickName",num = _len_user_nickname},			--用户昵称
	--{type = MSG_DATA_TYPE.shortChar, key = "szHeadWeb",num = _len_head_web+2},					--头像
	{type = MSG_DATA_TYPE.BYTE	, key = "headWebLen"},	
	{type = MSG_DATA_TYPE.char, key = "szHeadWeb",num = "headWebLen"},					--头像_len_head_web
};

MSG_GAME_STRUCT.MSG_GR_R_UserCome = 
{
	--{type = MSG_DATA_TYPE.longint, key = "dwUserID"},							--ID 号码
	--{type = MSG_DATA_TYPE.__int64, key = "dwMoney"},							--金币
	--{type = MSG_DATA_TYPE.int, key = "iScore"},									--分数
	--{type = MSG_DATA_TYPE.bool, key = "bBoy"},									--性别
	--{type = MSG_DATA_TYPE.UINT	, key = "bLogoID"},							--头像 ID 号码
	--{type = MSG_DATA_TYPE.BYTE	, key = "bDeskNO"},							--游戏桌号
	--{type = MSG_DATA_TYPE.BYTE	, key = "bDeskStation"},						--桌子位置
	--{type = MSG_DATA_TYPE.BYTE	, key = "bUserState"},							--用户状态
	--{type = MSG_DATA_TYPE.char	, key = "nickName",num = NAME_STRING_LEN},			--用户昵称
	{type = MSG_DATA_TYPE.BYTE	, key = "cbUserCount"},			--玩家个数	
	{type = MSG_GAME_STRUCT.UserCome, key = "userCome",num = "cbUserCount"},					--用户信息
};

MSG_GAME_STRUCT.UserSitApp  =--服务器回包
{
	{type = MSG_DATA_TYPE.LONG, key = "dwUserID"},							--用户 ID
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},						--桌子位置
};
--用户坐下或者起来
MSG_GAME_STRUCT.MSG_GR_R_UserSitApp  =--服务器回包
{
	--{type = MSG_DATA_TYPE.LONG, key = "dwUserID"},							--用户 ID
	--{type = MSG_DATA_TYPE.BYTE, key = "bLock"},								--是否密码
	--{type = MSG_DATA_TYPE.BYTE, key = "bDeskIndex"},							--桌子索引
	--{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},						--桌子位置
	--{type = MSG_DATA_TYPE.BYTE, key = "bUserState"},							--用户状态
	--{type = MSG_DATA_TYPE.BYTE, key = "bIsDeskOwner"},						--台主离开
	{type = MSG_DATA_TYPE.BYTE	, key = "cbUserCount"},			--玩家个数	
	{type = MSG_GAME_STRUCT.UserSitApp, key = "userSitApp",num = "cbUserCount"},					--用户信息
};

MSG_GAME_STRUCT.MSG_GM_LOOK_USER_INFO = 
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},						--用户ID
};

MSG_GAME_STRUCT.MSG_GM_USER_INFO = 
{
	{type = MSG_DATA_TYPE.longint, key = "dwExperience"},						--经验值
	{type = MSG_DATA_TYPE.int, key = "dwPoint"},								--分数
	{type = MSG_DATA_TYPE.UINT, key = "uWinCount"},								--胜利数目
	{type = MSG_DATA_TYPE.UINT, key = "uLostCount"},							--输数目
	{type = MSG_DATA_TYPE.UINT, key = "uCutCount"},								--强退数目
	{type = MSG_DATA_TYPE.UINT, key = "uMidCount"},								--和局数目
	{type = MSG_DATA_TYPE.bool, key = "bBoy"},									--性别
	{type = MSG_DATA_TYPE.int, key = "iLevel"},									--用户等级
	{type = MSG_DATA_TYPE.int, key = "iVipLevel"},								--vip等级
	{type = MSG_DATA_TYPE.char, key = "szSignature",num = _len_signatrue},		--玩家个性签名
};


--游戏状态数据包	（ 等待东家设置状态 ）
MSG_GAME_STRUCT.GameStation_1	=
{
	{type = MSG_DATA_TYPE.BYTE, key = "iVersion"},						--游戏版本号
	{type = MSG_DATA_TYPE.BYTE, key = "iVersion2"},						--游戏版本号
	--游戏信息
};

--是否显示手上牌的张数
MSG_GAME_STRUCT.ShowCardCountStruct	=
{
	{type = MSG_DATA_TYPE.bool, key = "bIsShow"},						--是否显示
};

MSG_GAME_STRUCT.MSG_GR_R_UserAgree	=
{
	--{type = MSG_DATA_TYPE.BYTE, key = "bDeskNO"},							--游戏桌号
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},						--位置号码
	--{type = MSG_DATA_TYPE.BYTE, key = "bAgreeGame"},						--同意标志
};

--游戏开始
MSG_GAME_STRUCT.BeginUpgradeStruct	=
{
	--{type = MSG_DATA_TYPE.char, key = "szTaskInfo",num = TASK_INFO_LEN},			--任务简介
	--{type = MSG_DATA_TYPE.int, key = "iTaskMul"},							--任务倍数
	{type = MSG_DATA_TYPE.BYTE, key = "bTaskID"},							--任务ID
};

--发牌
MSG_GAME_STRUCT.SendAllStruct =
{
	--{type = MSG_DATA_TYPE.BYTE, key = "iFirstCallScore"},										--谁明牌(谁最先叫分)
	--{type = MSG_DATA_TYPE.BYTE, key = "cbSunshineCardCnt"},
	--{type = MSG_DATA_TYPE.BYTE, key = "cbSunshineCard",num = TOTAL_CARD_CNT},
	--{type = MSG_DATA_TYPE.BYTE, key = "iUserCardCount",num = PLAY_COUNT},							--发牌数量
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num = 17},									--发牌队例	
};


MSG_GAME_STRUCT.MSG_GM_S_GameInfo =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bGameStation"},						--游戏状态
	{type = MSG_DATA_TYPE.BYTE, key = "bWatchOther"},						--允许旁观
	{type = MSG_DATA_TYPE.BYTE, key = "bWaitTime"},							--等待时间
	{type = MSG_DATA_TYPE.BYTE, key = "bReserve"},							--保留字段
	{type = MSG_DATA_TYPE.char, key = "szMessage",num = 1000},					--系统消息
};

--客户端向服务器发送下线
--叫地主,不叫地主,	ASS_CALL_SCORE
MSG_GAME_STRUCT.CallScoreStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},										--当前叫分者
	{type = MSG_DATA_TYPE.BYTE, key = "iValue"},												--叫分类型
	{type = MSG_DATA_TYPE.bool, key = "bCallScoreflag"}										--叫分标记
};

--抢地主,不抢地主,	ASS_ROB_NT
MSG_GAME_STRUCT.RobNTStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},									--抢地主座位号
	{type = MSG_DATA_TYPE.BYTE, key = "bRobMul"},										--叫分类型
	{type = MSG_DATA_TYPE.BYTE, key = "iValue"}											--抢地主情况
};

--明牌,不明牌,	ASS_SHOW_CARD
MSG_GAME_STRUCT.ShowCardStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},									--座位号
	{type = MSG_DATA_TYPE.BYTE, key = "iCardList",num = 20},							--扑克信息
--	{type = MSG_DATA_TYPE.BYTE, key = "iCardCount"},									--扑克数目
--	{type = MSG_DATA_TYPE.int, key = "iValue"},											--保留
--	{type = MSG_DATA_TYPE.int, key = "iBase"},											--倍数
};

MSG_GAME_STRUCT.NoShowCardStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},									--座位号
};

--出牌,不出牌,	ASS_OUT_CARD
MSG_GAME_STRUCT.OutCardStruct =
{
	{type = MSG_DATA_TYPE.bool, key = "bOvertime"},										--是否超时
	{type = MSG_DATA_TYPE.BYTE, key = "iCardCount"},										--扑克数目
	{type = MSG_DATA_TYPE.BYTE, key = "iCardList",num = 20},							--扑克信息
};

--托管,取消托管,	AutoStruct
MSG_GAME_STRUCT.AutoStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},										--扑克数目
	{type = MSG_DATA_TYPE.bool, key = "bAuto"},												--托管标记
	{type = MSG_DATA_TYPE.bool, key = "bIsNetCut"},											--是否断线
	{type = MSG_DATA_TYPE.BYTE, key = "iRoundCount"},											--断线后第几局
};

--服务器发向客户端
MSG_GAME_STRUCT.OutCardMsg =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iNextDeskStation"},										--下一出牌者
	--{type = MSG_DATA_TYPE.BYTE, key = "cbSunshineCnt"},											--阳光数量
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},											--当前出牌者
	{type = MSG_DATA_TYPE.BYTE, key = "iBombCount"},												--炸弹的个数
	{type = MSG_DATA_TYPE.bool, key = "bOvertime"},												--是否超时
	{type = MSG_DATA_TYPE.BYTE, key = "iCardCount"},											--扑克数目
	{type = MSG_DATA_TYPE.BYTE, key = "iCardList",num = "iCardCount"},									--扑克信息
	--{type = MSG_DATA_TYPE.BYTE, key = "iCardHandCount"},										--手上牌的张数
	--{type = MSG_DATA_TYPE.BYTE, key = "iCardHand",num = 45},									--手上的牌
	--{type = MSG_DATA_TYPE.BYTE, key = "iCardOutHandCount"},										--出牌玩家还剩拍的张数
	--{type = MSG_DATA_TYPE.BYTE, key = "iCardOutCard",num = 45},									--出牌玩家的牌
	--{type = MSG_DATA_TYPE.BYTE, key = "bLastCard"},												--最大玩家最后一张牌
	
};

MSG_GAME_STRUCT.AwardPointStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},										--座位号
	{type = MSG_DATA_TYPE.BYTE, key = "cbRobNtCnt"},										--奖分
	{type = MSG_DATA_TYPE.BYTE, key = "iBombNum"},											--炸弹个数
};


--游戏开始数据包
MSG_GAME_STRUCT.BeginPlayStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iOutDeskStation"},											--出牌的位置
	--{type = MSG_DATA_TYPE.bool, key = "bShowCard", num = 3},										--是否亮牌
	--{type = MSG_DATA_TYPE.BYTE, key = "cbCard",num = {3,20}},										--扑克数据
};

--底牌数据包
MSG_GAME_STRUCT.BackCardExStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iGiveBackPeople"},										--底牌玩家
	{type = MSG_DATA_TYPE.BYTE, key = "iBackCardCount"},										--扑克数目
	{type = MSG_DATA_TYPE.BYTE, key = "iBackCard", num = 3},												--扑克数据
};

--新一轮数据包
MSG_GAME_STRUCT.NewTurnStruct =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},										--座位号
	{type = MSG_DATA_TYPE.BYTE, key = "bReserve"},											--保留
};

--游戏结束数据包
MSG_GAME_STRUCT.GameEndStruct =
{
	{type = MSG_DATA_TYPE.int, key = "iTurePoint",num = 3},										--玩家得分											--王炸
	{type = MSG_DATA_TYPE.BYTE , key = "iSpecialTaskMul",num = 3},								--任务倍数
	{type = MSG_DATA_TYPE.bool , key = "bChunTian"},											--是否是春天
	{type = MSG_DATA_TYPE.bool , key = "bFanChun"},												--是否是反春							--用户手上扑克数目
	{type = MSG_DATA_TYPE.BYTE , key = "iUserCard",num = {3,20}},								--用户手上的扑克
	{type = MSG_DATA_TYPE.int , key = "iTax",num = 3},											--玩家台费
	{type = MSG_DATA_TYPE.BYTE , key = "iStraightWins",num = 3},								--当前连胜值
};

MSG_GAME_STRUCT.GameStation_2 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iVersion"},						--游戏版本号
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iVersion2"},						--游戏版本号
--	{type = MSG_DATA_TYPE.BYTE, key = "iBackCount"},						--底牌数
--	{type = MSG_DATA_TYPE.BYTE, key = "iBeginTime"},						--开始准备时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime"},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime2"},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScoreTime"},					--叫分计时
--	{type = MSG_DATA_TYPE.BYTE, key = "iHideShowCardBtnTime"},				--隐藏明牌按钮
--	{type = MSG_DATA_TYPE.BYTE, key = "iAddDoubleTime"},					--加倍时间
-- 	{type = MSG_DATA_TYPE.bool, key = "bTurnRule"},							--打牌顺序(1逆时针,0顺时针)
-- 	{type = MSG_DATA_TYPE.bool, key = "bShowVideo"},						--是否显示视频
--	{type = MSG_DATA_TYPE.bool, key = "bArgee",num = PLAY_COUNT},			--用户同意
--	{type = MSG_DATA_TYPE.bool, key = "bShowFirstCard"},					--是否显示发牌中的一张牌
	--{type = MSG_DATA_TYPE.bool, key = "bShowTax"},							--是否显示台费
	{type = MSG_DATA_TYPE.int, key = "iBottomNote"},						--底注
	{type = MSG_DATA_TYPE.BYTE, key = "iShowCardTime"},						--亮牌时间
 	{type = MSG_DATA_TYPE.BYTE, key = "bTotalPlayNum"},                	--游戏总局数(用于好友房)
 	{type = MSG_DATA_TYPE.BYTE, key = "bBeenPlayNum"}, 					--游戏已经进行局数(用于好友房)
 	{type = MSG_DATA_TYPE.char, key = "szPassword",num =_desk_pwd_len}, 	--桌子密码
};


--游戏状态数据包	（ 等待扣押底牌状态 ）

MSG_GAME_STRUCT.GameStation_3 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iVersion"},						--游戏版本号
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iVersion2"},						--游戏版本号
--	{type = MSG_DATA_TYPE.BYTE, key = "iBackCount"},						--底牌数
--	{type = MSG_DATA_TYPE.BYTE, key = "iBeginTime"},						--开始准备时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime"},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime2"},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScoreTime"},					--叫分计时
--	{type = MSG_DATA_TYPE.BYTE, key = "iHideShowCardBtnTime"},			--隐藏明牌按钮
--	{type = MSG_DATA_TYPE.BYTE, key = "iAddDoubleTime"},					--加倍时间
--	{type = MSG_DATA_TYPE.BYTE, key = "iBeenPlayGame"},					--已经游戏的局数
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScorePeople"},				--当前叫分人
	--{type = MSG_DATA_TYPE.BYTE, key = "iGameFlag"},						--叫分标记
--	{type = MSG_DATA_TYPE.BYTE, key = "iCallScoreResult"},				--所叫的分
	{type = MSG_DATA_TYPE.BYTE, key = "iUpGradePeople"},					--庄家位置
	{type = MSG_DATA_TYPE.BYTE, key = "iLeaveTime"},						--重连定时器剩余时间
	--{type = MSG_DATA_TYPE.int, key = "iLeaveDoubleTime"},				--剩余的加倍时间
--	{type = MSG_DATA_TYPE.int, key = "iBackCardCount"},					--底牌数量
--	{type = MSG_DATA_TYPE.BYTE, key = "iBase"},							--当前炸弹个数
--	{type = MSG_DATA_TYPE.UINT, key = "iPlayCount"},						--使用的牌数(54,108,162,216,324)
	{type = MSG_DATA_TYPE.BYTE, key = "cbRobNtMul"},
	{type = MSG_DATA_TYPE.BYTE, key = "cbShowCardMul"},
--	{type = MSG_DATA_TYPE.BYTE, key = "cbBkCardMul"},
--	{type = MSG_DATA_TYPE.BYTE, key = "cbSunshineCardCnt"},
--	{type = MSG_DATA_TYPE.BYTE, key = "cbSunshineCard",num = TOTAL_CARD_CNT},
--	{type = MSG_DATA_TYPE.int, key = "	bDouble",num = PLAY_COUNT},			--加倍情况
	{type = MSG_DATA_TYPE.bool, key = "bAuto",num = PLAY_COUNT},				--托管情况
--	{type = MSG_DATA_TYPE.bool, key = "bShowCard",num = PLAY_COUNT},			--明牌情况
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScore",num = PLAY_COUNT},			--几家叫分情况
	{type = MSG_DATA_TYPE.BYTE, key = "iRobNT",num = PLAY_COUNT},				--抢地主
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardCount",num = PLAY_COUNT},		--用户手上扑克数目
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num = 54},				--用户手上的扑克
-- 	{type = MSG_DATA_TYPE.bool, key = "bTurnRule"},						--打牌顺序
-- 	{type = MSG_DATA_TYPE.bool, key = "bShowVideo"},						--是否显示视频
--	{type = MSG_DATA_TYPE.bool, key = "bShowFirstCard"},					--是否显示发牌中的一张牌
	--{type = MSG_DATA_TYPE.bool, key = "bShowTax"},						--是否显示台费
	--{type = MSG_DATA_TYPE.char, key = "szTaskInfo",num = TASK_INFO_LEN},			--任务简介
	--{type = MSG_DATA_TYPE.int, key = "iTaskMul"},							--任务倍数
	{type = MSG_DATA_TYPE.BYTE, key = "bTaskID"},							--任务ID
	{type = MSG_DATA_TYPE.int, key = "iBottomNote"},						--底注
	{type = MSG_DATA_TYPE.BYTE, key = "iShowCardTime"},						--亮牌时间
	{type = MSG_DATA_TYPE.BYTE, key = "bTotalPlayNum"},                	--游戏总局数(用于好友房)
 	{type = MSG_DATA_TYPE.BYTE, key = "bBeenPlayNum"}, 					--游戏已经进行局数(用于好友房)
 	{type = MSG_DATA_TYPE.char, key = "szPassword",num =_desk_pwd_len}, 	--桌子密码
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iLeaveCardCount"},                --未出牌的个数 － 用于记牌器
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iLeaveCardList",num = TOTAL_CARD_CNT}, --未出的所有牌 － 用于记牌器
};

MSG_GAME_STRUCT.GameStation_4 =
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},						--< 游戏状态
--	{type = MSG_DATA_TYPE.BYTE, key = "iBeginTime"},						--开始准备时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime"},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime2"},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScoreTime"},					--叫分计时
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScorePeople"},				--当前叫分人
--	{type = MSG_DATA_TYPE.BYTE, key = "iGameFlag"},						--叫分标记
--	{type = MSG_DATA_TYPE.BYTE, key = "iCallScoreResult"},				--所叫的分
	{type = MSG_DATA_TYPE.BYTE, key = "iUpGradePeople"},					--庄家位置
	{type = MSG_DATA_TYPE.BYTE, key = "iLeaveTime"},						--重连定时器剩余时间
--	{type = MSG_DATA_TYPE.BYTE, key = "iBase"},							--当前炸弹个数
	{type = MSG_DATA_TYPE.BYTE, key = "cbRobNtMul"},
	{type = MSG_DATA_TYPE.BYTE, key = "cbShowCardMul"},
--	{type = MSG_DATA_TYPE.BYTE, key = "cbBkCardMul"},
	{type = MSG_DATA_TYPE.bool, key = "bAuto",num = PLAY_COUNT},				--托管情况
	{type = MSG_DATA_TYPE.bool, key = "bShowCard",num = PLAY_COUNT},			--明牌情况
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScore",num = PLAY_COUNT},			--几家叫分情况
	{type = MSG_DATA_TYPE.BYTE, key = "iRobNT",num = PLAY_COUNT},				--抢地主
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardCount",num = PLAY_COUNT},		--用户手上扑克数目
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num = 57},				--用户手上的扑克
	--{type = MSG_DATA_TYPE.bool, key = "bShowTax"},						--是否显示台费
	--{type = MSG_DATA_TYPE.char, key = "szTaskInfo",num = TASK_INFO_LEN},			--任务简介
	--{type = MSG_DATA_TYPE.int, key = "iTaskMul"},							--任务倍数
	{type = MSG_DATA_TYPE.BYTE, key = "bTaskID"},							--任务ID
	{type = MSG_DATA_TYPE.int, key = "iBottomNote"},						--底注
	{type = MSG_DATA_TYPE.BYTE, key = "iShowCardTime"},						--亮牌时间
	{type = MSG_DATA_TYPE.BYTE, key = "bTotalPlayNum"},                	--游戏总局数(用于好友房)
 	{type = MSG_DATA_TYPE.BYTE, key = "bBeenPlayNum"}, 					--游戏已经进行局数(用于好友房)
 	{type = MSG_DATA_TYPE.char, key = "szPassword",num =_desk_pwd_len}, 	--桌子密码
};

--游戏状态数据包	（游戏中状态）
MSG_GAME_STRUCT.GameStation_5	=
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},							--< 游戏状态
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime"},							--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime2"},						--出牌思考时间
	{type = MSG_DATA_TYPE.bool, key = "bOvertime",num = PLAY_COUNT},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScoreTime"},						--叫分计时
	{type = MSG_DATA_TYPE.BYTE, key = "iBaseOutCount"},						--出牌的数目
	{type = MSG_DATA_TYPE.BYTE, key = "bIsPass"},							--是否不出
	{type = MSG_DATA_TYPE.BYTE, key = "cbRobNtMul"},
	{type = MSG_DATA_TYPE.BYTE, key = "cbShowCardMul"},
	{type = MSG_DATA_TYPE.BYTE, key = "cbBombMul"},
	{type = MSG_DATA_TYPE.BYTE	, key = "iBase"},								--当前倍数
	{type = MSG_DATA_TYPE.BYTE	, key = "iBombNum"},							--炸弹个数
	{type = MSG_DATA_TYPE.BYTE	, key = "iUpGradePeople"},						--庄家位置
	{type = MSG_DATA_TYPE.BYTE	, key = "iOutCardPeople"},						--现在出牌用户
	{type = MSG_DATA_TYPE.BYTE	, key = "iLeaveTime"},							--重连定时器剩余时间
	{type = MSG_DATA_TYPE.bool, key = "bAuto",num = PLAY_COUNT},					--托管情况
	{type = MSG_DATA_TYPE.bool, key = "bShowCard",num = PLAY_COUNT},				--明牌情况
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardCount",num = PLAY_COUNT},			--用户手上扑克数目
	{type = MSG_DATA_TYPE.BYTE, key = "iDeskCardCount",num = PLAY_COUNT},			--桌面扑克的数目
	{type = MSG_DATA_TYPE.BYTE, key = "iRobNT",num = PLAY_COUNT},					--抢地主
	{type = MSG_DATA_TYPE.BYTE, key = "iUserCardList",num = 57},					--用户手上的扑克
	{type = MSG_DATA_TYPE.BYTE, key = "bTaskID"},							--任务ID
	{type = MSG_DATA_TYPE.int, key = "iBottomNote"},						--底注
	-- {type = MSG_DATA_TYPE.BYTE, key = "iLeaveCardCount"},                    --未出牌的个数 － 用于记牌器
 	-- {type = MSG_DATA_TYPE.BYTE, key = "iLeaveCardList",num = TOTAL_CARD_CNT},--未出的所有牌 － 用于记牌器
 	{type = MSG_DATA_TYPE.BYTE, key = "bTotalPlayNum"},                	--游戏总局数(用于好友房)
 	{type = MSG_DATA_TYPE.BYTE, key = "bBeenPlayNum"}, 					--游戏已经进行局数(用于好友房)
 	{type = MSG_DATA_TYPE.char, key = "szPassword",num =_desk_pwd_len}, 	--桌子密码
};

--游戏状态数据包	（ 等待下盘开始状态  ）
MSG_GAME_STRUCT.GameStation_6	=
{
	{type = MSG_DATA_TYPE.BYTE, key = "bStation"},							--< 游戏状态
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iVersion"},							--游戏版本号
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iVersion2"},							--游戏版本号
--	{type = MSG_DATA_TYPE.BYTE, key = "iBackCount"},							--底牌数
--	{type = MSG_DATA_TYPE.BYTE, key = "iBeginTime"},							--开始准备时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime"},							--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iThinkTime2"},						--出牌思考时间
	{type = MSG_DATA_TYPE.BYTE, key = "iCallScoreTime"},						--叫分计时
--	{type = MSG_DATA_TYPE.BYTE, key = "iAddDoubleTime"},						--加倍时间
--	{type = MSG_DATA_TYPE.BYTE, key = "iHideShowCardBtnTime"},			    --隐藏明牌按钮
-- 	{type = MSG_DATA_TYPE.bool, key = "bTurnRule"},							--打牌顺序
-- 	{type = MSG_DATA_TYPE.bool, key = "bShowVideo"},							--是否显示视频
-- 	{type = MSG_DATA_TYPE.bool, key = "bShowFirstCard"},						--是否显示发牌中的一张牌
--	{type = MSG_DATA_TYPE.bool, key = "bArgee",num = PLAY_COUNT},					--用户同意
	--{type = MSG_DATA_TYPE.bool, key = "bShowTax"},							--是否显示台费
	--{type = MSG_DATA_TYPE.char, key = "szTaskInfo",num = TASK_INFO_LEN},			--任务简介
	--{type = MSG_DATA_TYPE.int	, key ="iTaskMul"},							--任务倍数
	{type = MSG_DATA_TYPE.BYTE, key = "bTaskID"},							--任务ID
	{type = MSG_DATA_TYPE.int, key = "iBottomNote"},						--底注
	{type = MSG_DATA_TYPE.BYTE, key = "iShowCardTime"},						--亮牌时间
	{type = MSG_DATA_TYPE.BYTE, key = "bTotalPlayNum"},                	--游戏总局数(用于好友房)
 	{type = MSG_DATA_TYPE.BYTE, key = "bBeenPlayNum"}, 					--游戏已经进行局数(用于好友房)
 	{type = MSG_DATA_TYPE.char, key = "szPassword",num =_desk_pwd_len}, 	--桌子密码
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iLeaveCardCount"},                    --未出牌的个数 － 用于记牌器
-- 	{type = MSG_DATA_TYPE.BYTE, key = "iLeaveCardList",num = TOTAL_CARD_CNT},     --未出的所有牌 － 用于记牌器
};

local GAME_NUM_MAX = 5
local GAME_ROOM_MAX = 10

--获取游戏人数
MSG_GAME_STRUCT.EveryGamePeople = 
{
	{type = MSG_DATA_TYPE.UINT, key = "uNameID"},					--游戏名称 ID 号码
	{type = MSG_DATA_TYPE.UINT, key = "uRoomPeople"},		--各等级房间游戏人数
};

MSG_GAME_STRUCT.AllGamePeople = 
{
	{type = MSG_GAME_STRUCT.EveryGamePeople, key = "gamePeople",num = GAME_NUM_MAX},	--//所有游戏人数数组
};
MSG_GAME_STRUCT.MSG_GP_C_GET_GAMELEVEL_PEOPLE = 
{
	{type = MSG_DATA_TYPE.int, key = "iKindID"},	--
	{type = MSG_DATA_TYPE.int, key = "iGameNameID"},	--//游戏ID
};
--获取游戏人数
MSG_GAME_STRUCT.GameLevelPeople = 
{
	{type = MSG_DATA_TYPE.BYTE, key = "iLevel"},					--游戏名称 ID 号码
	{type = MSG_DATA_TYPE.short, key = "iPeople"},		--各等级房间游戏人数
};
MSG_GAME_STRUCT.MSG_GP_S_GET_GAMELEVEL_PEOPLE = 
{
	{type = MSG_DATA_TYPE.int, key = "iGameNameID"},	--//游戏ID
	{type = MSG_DATA_TYPE.BYTE, key = "iGameLevelCount"},	--游戏等级
	{type = MSG_GAME_STRUCT.GameLevelPeople, key = "gameLevelPeople",num ="iGameLevelCount"},	--房间人数
};
--房间错误新消息
MSG_GAME_STRUCT.MSG_GP_S_GetRoomErr = 
{
	{type = MSG_DATA_TYPE.BYTE, key = "bErrRemarkLen"},	--房间开放错误描述长度
	{type = MSG_DATA_TYPE.char, key = "szRemark",num ="bErrRemarkLen"},	--房间开放错误描述内容
};
--修改用户金币
--[[
MSG_GAME_STRUCT.MSG_GR_R_UserPoint = 
{
	{type = MSG_DATA_TYPE.longint, key = "dwUserID"},	--用户ID
	{type = MSG_DATA_TYPE.__int64, key = "dwPoint"},	--用户积分
	{type = MSG_DATA_TYPE.int, key = "nExp"},			--经验值
	{type = MSG_DATA_TYPE.__int64, key = "dwMoney"},	--金币
	{type = MSG_DATA_TYPE.BYTE, key = "bWinCount"},		--赢的局数
	{type = MSG_DATA_TYPE.BYTE, key = "bLostCount"},	--输的局数
	{type = MSG_DATA_TYPE.BYTE, key = "bMidCount"},		--平局
	{type = MSG_DATA_TYPE.BYTE, key = "bCutCount"},		--逃局
	--{type = MSG_DATA_TYPE.int, key = "iTaxCom"},		--扣税
	{type = MSG_DATA_TYPE.int, key = "iState"},			--使用护身符，双倍积分卡
	{type = MSG_DATA_TYPE.int, key = "iTaskIndex"},		--每局任务完成ID
	{type = MSG_DATA_TYPE.int, key = "iTaskAwardUnit"},	--
	--{type = MSG_DATA_TYPE.int, key = "iPerformLevel"},	--变现等级
	--{type = MSG_DATA_TYPE.int, key = "iPlayerPlayCnt"},	--
	--{type = MSG_DATA_TYPE.BYTE, key = "cbWinRewardType"},		--连胜奖励类型(1  金币    2   礼券   3  道具  4元宝)
	--{type = MSG_DATA_TYPE.int, key = "iWinRewardAmount"},		--连胜奖励
	--{type = MSG_DATA_TYPE.int, key = "iWinRewardPropID"},	--连胜获得道具的ID
}]]--

--聊天结构
MSG_GAME_STRUCT.MSG_GR_RS_NormalTalk = 
{
	{type = MSG_DATA_TYPE.BYTE, key = "iChatType"},		--信息长度	,11、普通聊天 2、表情
	{type = MSG_DATA_TYPE.BYTE, key = "iChatIndex"},		--信息长度	,11、普通聊天 2、表情
	{type = MSG_DATA_TYPE.LONG, key = "dwSendID"},		--用户 ID
	{type = MSG_DATA_TYPE.BYTE, key = "bDeskStation"},		--用户 ID
	--{type = MSG_DATA_TYPE.char, key = "szMessage",num = 501},		--聊天内容
	{type = MSG_DATA_TYPE.BYTE, key = "szMessage",},		--聊天内容
}

--新的聊天结构（客户端C--->S）
MSG_GAME_STRUCT.MSG_GR_C_ChatInfo = 
{
	{type = MSG_DATA_TYPE.BYTE, key = "bChatType"},		--信息长度	,11、普通聊天 2、表情
	{type = MSG_DATA_TYPE.BYTE, key = "bChatID"},		--信息长度	,11、普通聊天 2、表情
	{type = MSG_DATA_TYPE.BYTE, key = "bChatContenLen"},		--用户 ID
	{type = MSG_DATA_TYPE.char, key = "szMessage",num=60},	--聊天内容
}
--新的聊天结构（客户端S--->C）
MSG_GAME_STRUCT.ChatUserInfo = 
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--用户ID
	{type = MSG_DATA_TYPE.BYTE, key = "bVipLevel"},		--vip
	{type = MSG_DATA_TYPE.BYTE, key = "iHeadID"},		--头像ID
	{type = MSG_DATA_TYPE.BYTE, key = "iNickNameLen"},	--昵称长度
	{type = MSG_DATA_TYPE.char, key = "szNickName",num ="iNickNameLen"},	--昵称
	{type = MSG_DATA_TYPE.BYTE, key = "iHeadWebLen"},	--昵称长度
	{type = MSG_DATA_TYPE.char, key = "szHeadWeb",num ="iHeadWebLen"},	--昵称
}
MSG_GAME_STRUCT.MSG_GR_S_ChatInfo = 
{
	{type = MSG_GAME_STRUCT.ChatUserInfo, key = "userInfo"},	--用户信息
	{type = MSG_GAME_STRUCT.MSG_GR_C_ChatInfo, key = "chatInfo"},	--聊天信息
};
--修改金币
MSG_GAME_STRUCT.MSG_GM_MODIFY_MONEY = 
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--用户 ID
	{type = MSG_DATA_TYPE.BYTE, key = "cbType"},		--//1金钱  2钻石
	{type = MSG_DATA_TYPE.int, key = "iAmount"},		--数量
}


-------------------------斗地主比赛--------------------------
--玩家报名信息
MSG_GAME_STRUCT.MSG_C_BATTLE_USER_SIGN_UP = 
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--玩家ID
	{type = MSG_DATA_TYPE.int, key = "iFeeType"},		--费用类型
	{type = MSG_DATA_TYPE.int, key = "iPropID"},		--道具ID
}
--服务器返回玩家报名消息
MSG_GAME_STRUCT.MSG_S_BATTLE_USER_SIGN_UP = 
{
	{type = MSG_DATA_TYPE.int, key = "iRoomID"},		--房间ID
	{type = MSG_DATA_TYPE.char, key = "szRoomName",num=_room_name},
}
--客户端向服务器发送取消报名的消息
MSG_GAME_STRUCT.MSG_C_CANCLE_SIGNUP = 
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--玩家ID
}
--服务器返回玩家取消报名消息
MSG_GAME_STRUCT.MSG_S_CANCLE_SIGNUP = 
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--玩家ID
}
--根据房间ID请求进入的房间信息
MSG_GAME_STRUCT.MSG_GP_GETROOM_BY_ID =
{
	{type = MSG_DATA_TYPE.UINT, key = "uRoomID"},		--房间ID
}
--客户端向服务器发送请求报名信息
MSG_GAME_STRUCT.MSG_C_BATTLE_USER_SIGNUP_INFO =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--用户ID
}
--服务器向客户端发送玩家报名信息
MSG_GAME_STRUCT.MSG_USER_MATCH_INFO =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
	{type = MSG_DATA_TYPE.int, key = "iUserCount"},		--比赛人数
	{type = MSG_DATA_TYPE.bool, key = "bSignUp"},		--是否报名
}
MSG_GAME_STRUCT.MSG_S_BATTLE_USER_SIGNUP_INFO_APP =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchCount"},		--房间ID
	{type = MSG_GAME_STRUCT.MSG_USER_MATCH_INFO, key = "info",num = 5},		--房间ID
}
--报名成功 ,游戏人数改变
MSG_GAME_STRUCT.MSG_S_BATTLE_USER_SIGNUP_INFO =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
	{type = MSG_DATA_TYPE.int, key = "iSignupUserCnt"},		--房间ID
}
--即时赛人数满，比赛即将开赛通知包
MSG_GAME_STRUCT.MSG_S_BATTLE_MATCH_WILL_START =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
}
--报名显示排行
MSG_GAME_STRUCT.MsgBattleRankInfo = 
{
	{type = MSG_DATA_TYPE.char 	, key = "szNickName",num = _len_user_nickname},						--用户ID号
	--{type = MSG_DATA_TYPE.int	, key = "iBattlePoint"},						--道具ID号
}

MSG_GAME_STRUCT.MSG_S_BATTLE_REQ_RANK_ONE_ROOM =
{
	{type = MSG_DATA_TYPE.int		, key = "iSendCount"},			-- 
	{type = MSG_DATA_TYPE.int		, key = "iSendFlag"},		--0 一次发完   1 开始 2未完，3发完 
	{type = MSG_DATA_TYPE.int		, key = "iBattleIndex"},	--
	{type = MSG_GAME_STRUCT.MsgBattleRankInfo, key = "info" ,num = "iSendCount"},--根据icout 数量读取结构体
};


MSG_GAME_STRUCT.MSG_C_BATTLE_REQ_RANK_ONE_ROOM = 
{
	{type = MSG_DATA_TYPE.int, key = "iBattleIndex"},	--比赛ID
}

--比赛房间消息
--晋级人数
MSG_GAME_STRUCT.MSG_S_GR_MATCH_SYS_INFO =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iWinnerCnt"},		--晋级人数
}
--游戏结束，正在游戏中的桌子张数
MSG_GAME_STRUCT.MSG_S_PLAYING_DESK_CNT_NOTIFY =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iPlayingDeskCnt"},		--正在游戏中的桌子张数
}

--玩家积分更新
MSG_GAME_STRUCT.MSG_S_GR_USER_STATE_NOTIFY =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--玩家ID
	{type = MSG_DATA_TYPE.int, key = "iMatchScore"},		--玩家比赛积分
	{type = MSG_DATA_TYPE.BYTE, key = "iUserState"},		--玩家状态
}
--玩家淘汰
--[[
MSG_GAME_STRUCT.MSG_BATTLE_PRIZE =
{
	{type = MSG_DATA_TYPE.int, key = "iPrizeType"},		--奖励类型    1  金币    2   礼券   3  道具  4元宝
	{type = MSG_DATA_TYPE.int, key = "iAmount"},		--奖励数量
	{type = MSG_DATA_TYPE.int, key = "iPropID"},		--道具ID
	{type = MSG_DATA_TYPE.time_t, key = "tmInvaliad"},		--道具过期时间，如果有
}]]--
MSG_GAME_STRUCT.MSG_S_PLAYER_MATCH_OVER =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		
	{type = MSG_DATA_TYPE.int, key = "iRank"},		
	--{type = MSG_DATA_TYPE.int, key = "iPrizeCnt"},		
	--{type = MSG_GAME_STRUCT.MSG_BATTLE_PRIZE, key = "prizeInfo"},
}
--玩家晋级
MSG_GAME_STRUCT.MSG_S_PLAYER_WIN_NOTIFY =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--玩家ID
	{type = MSG_DATA_TYPE.int, key = "iRank"},			--玩家比赛积分
}
--定时赛报名
MSG_GAME_STRUCT.MSG_C_FIX_BATTLE_USER_SIGN_UP_REQ  =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--玩家ID
	{type = MSG_DATA_TYPE.int, key = "iFeeType"},		--费用类型   1  金币    2   礼券   3  道具  4砖石
	{type = MSG_DATA_TYPE.int, key = "iPropID"},		--如果是道具的话，道具ID号
}
--定时赛报名
MSG_GAME_STRUCT.MSG_S_FIX_BATTLE_USER_SIGN_UP_REQ_APP  =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
}
--定时赛开赛通知
MSG_GAME_STRUCT.MSG_S_FIX_BATTLE_WILL_START_NOTIFY  =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
	{type = MSG_DATA_TYPE.time_t, key = "tmBegin"},		--开赛时间
}
--取消比赛
MSG_GAME_STRUCT.MSG_S_CANCLE_FIX_TIME_BATTLE  =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
}
--比赛结束
MSG_GAME_STRUCT.MSG_S_FIX_BATTLE_END  =
{
	{type = MSG_DATA_TYPE.int, key = "iMatchID"},		--比赛ID
}
MSG_GAME_STRUCT.MSG_BATTLE_RANK_GAME_END  =
{
	{type = MSG_DATA_TYPE.int, key = "iRank"},		--定时赛比赛结束排名
}
--一局游戏结束用户的排名
MSG_GAME_STRUCT.MSG_BATTLE_USER_RANK =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--用户ID
	--{type = MSG_DATA_TYPE.int, key = "iBattleIndex"},	--
	{type = MSG_DATA_TYPE.int, key = "iRank"},			--自己当前排名
	{type = MSG_DATA_TYPE.int, key = "iTotalRank"},		--总排名人数
	{type = MSG_DATA_TYPE.int, key = "iPoint"},			--分数
	--{type = MSG_DATA_TYPE.int, key = "iFinishCount"},	--完成的局数
}
--发送玩家比赛你排名信息
MSG_GAME_STRUCT.MSG_S_GR_RANK_INFO =
{
	{type = MSG_DATA_TYPE.BYTE, key = "cbRank"},		--玩家排名
	{type = MSG_DATA_TYPE.BYTE, key = "cbTotalPlayer"},	--当前游戏总人数
}
--竞赛排行
MSG_GAME_STRUCT.MSG_S_GR_RANK_DETAIL =
{
	{type = MSG_DATA_TYPE.int, key = "iUserID"},		--玩家ID
	{type = MSG_DATA_TYPE.BYTE, key = "cbRank"},		--玩家排名
	{type = MSG_DATA_TYPE.int, key = "iPoint"},			--玩家分数
	{type = MSG_DATA_TYPE.char, key = "szNick",num = _len_user_name},			--玩家昵称
}
MSG_GAME_STRUCT.MSG_S_GR_RANKS =
{
	{type = MSG_DATA_TYPE.int, key = "iRankCount"},		--玩家排名
	{type = MSG_GAME_STRUCT.MSG_S_GR_RANK_DETAIL, key = "rankDetail",num = 12},			--玩家昵称
}
--//断线回来的用户等待其他桌时的信息
MSG_GAME_STRUCT.MSG_S_USER_REBACK_WAIT_OTHER_DESK =
{
	{type = MSG_DATA_TYPE.BYTE, key = "iPlayingDeskCnt"},		--还有多少张桌子在比赛
	{type = MSG_DATA_TYPE.int, key = "iScore"},		--分数
}


MSG_GAME_STRUCT._TAG_PROP_BUY =
{
	--{type = MSG_DATA_TYPE.long, key = "dwUserID"},		--购买者ID
	{type = MSG_DATA_TYPE.int, key = "nPropID"},		--道具ID			
}


--MSG_GAME_STRUCT.MSG_PROP_C_GETSAVED =
--{
	--{type = MSG_DATA_TYPE.long, key = "dwUserID"},		--玩家ID
--}

MSG_GAME_STRUCT.MSG_PROP_S_GETPROP = 
{
	{type = MSG_DATA_TYPE.long	, key = "dwUserID"},						--用户ID号
	{type = MSG_DATA_TYPE.int	, key = "nPropID"},						--道具ID号
	{type = MSG_DATA_TYPE.int	, key = "nHoldCount"},						--拥有道具的数量
	{type = MSG_DATA_TYPE.time_t , key = "tmInvalid"},                      --过期时间   sean.yang  20120409  
}
MSG_GAME_STRUCT._TAG_USERPROP = MSG_GAME_STRUCT.MSG_PROP_S_GETPROP

MSG_GAME_STRUCT.MSG_PROP_S_GETPROP_RES =
{
	{type = MSG_DATA_TYPE.int, key = "iSendCount"},        --数量
	{type = MSG_DATA_TYPE.int, key = "iSendFlag"},         --0 一次发完   1 开始 2未完,3发完
	{type = MSG_GAME_STRUCT.MSG_PROP_S_GETPROP, key = "msgPropGet",num = "iSendCount"},
}

MSG_GAME_STRUCT._TAG_USINGPROP =
{
	{type = MSG_DATA_TYPE.int		, key = "dwUserID"},					--使用道具的用户ID
	{type = MSG_DATA_TYPE.int		, key = "dwTargetUserID"},					--使用道具时的对象用户ID,可以是自己
	{type = MSG_DATA_TYPE.int		, key = "nPropID"},					--道具ID
}
MSG_GAME_STRUCT._TAG_BOARDCAST =
{
	{type = MSG_DATA_TYPE.char		, key = "szMessage",num=256},					--使用道具的用户ID
}


MSG_GAME_STRUCT.MSG_QUERY_CREATE_PASSWORD    =
{
	{type = MSG_DATA_TYPE.UINT			, key = "uUserID"},
	{type = MSG_DATA_TYPE.char			, key = "szMD5Pass",num =_len_pwd_},								--用户旧加密密码
};

MSG_GAME_STRUCT.MSG_USER_PASSWORD    =
{
	{type = MSG_DATA_TYPE.UINT			, key = "uUserID"},
	{type = MSG_DATA_TYPE.char			, key = "szOldMD5Pass",num =_len_pwd_},							--用户旧加密密码
	{type = MSG_DATA_TYPE.char			, key = "szNewMD5Pass",num =_len_pwd_},							--用户新加密密码
};

MSG_GAME_STRUCT.MSG_USER_NICKNAME_UPDATE=
{
	{type = MSG_DATA_TYPE.UINT			, key = "uUserID"},
	{type = MSG_DATA_TYPE.char			, key = "szNickName",num = 32},										--昵称 
};

MSG_GAME_STRUCT.MSG_USER_SEX_HEAD_UPDATE=
{
	{type = MSG_DATA_TYPE.UINT			, key = "uUserID"},
	{type = MSG_DATA_TYPE.BYTE			, key = "bSex"},												--性别(0女 1男)
	{type = MSG_DATA_TYPE.BYTE			, key = "bHead"},												--头像ID
};


MSG_GAME_STRUCT.MAIL_INFO =
{
	{type = MSG_DATA_TYPE.UINT , key = "uMsgID"},	--消息ID
	{type = MSG_DATA_TYPE.bool , key = "bHasProp"},			--是否有附件
	{type = MSG_DATA_TYPE.BYTE		, key = "bTitleLen"},			--标题长
	{type = MSG_DATA_TYPE.char , key = "chTitle",num = "bTitleLen"},		--标题
	{type = MSG_DATA_TYPE.BYTE		, key = "bContentLen"},			--内容长
	{type = MSG_DATA_TYPE.char , key = "chContent",num = "bContentLen"},     --内容
	{type = MSG_DATA_TYPE.time_t, key = "tmMailTime"}, --发布时间
};


MSG_GAME_STRUCT.MSG_S_MAIL_INFO =
{
	{type = MSG_DATA_TYPE.int		, key = "iSendCount"},        --数量
	{type = MSG_DATA_TYPE.int		, key = "iSendFlag"},         --0 一次发完   1 开始 2未完，3发完
	{type = MSG_GAME_STRUCT.MAIL_INFO	, key = "mailInfo" ,num = "iSendCount"},	--/邮件
};


MSG_GAME_STRUCT.MSG_C_MAIL_READ	=
{
	{type = MSG_DATA_TYPE.int , key = "iUserID"},
	{type = MSG_DATA_TYPE.UINT , key = "uMsgID"},	--消息ID
};
MSG_GAME_STRUCT.MAIL_PROP =
{
	{type = MSG_DATA_TYPE.int		, key = "iPropType"},		--道具类型(0金币，1道具，2奖券，3钻石)
	{type = MSG_DATA_TYPE.int		, key = "iPropID"},		--道具ID
	{type = MSG_DATA_TYPE.int		, key = "iAmount"},		--数量
};

MSG_GAME_STRUCT.MSG_S_MAIL_PROP =
{
	{type = MSG_DATA_TYPE.int			, key = "iCount"},			--数量
	{type = MSG_DATA_TYPE.BYTE		, key = "cbRet"},			--操作返回码
	{type = MSG_GAME_STRUCT.MAIL_PROP	, key = "mailProp" ,num = "iCount"},
};


----------------------好友房消息------------------------------
MSG_GAME_STRUCT.MSG_S_HAS_CREATE_FRIEND_ROOM =
{
	{type = MSG_DATA_TYPE.bool		, key = "bHasCreate"},		--游戏ID
	{type = MSG_DATA_TYPE.int		, key = "iGameNameID"},		--游戏ID
	{type = MSG_DATA_TYPE.int  		, key = "iRoomID"},			--创建的房间号
	{type = MSG_DATA_TYPE.int  		, key = "iRoomPwd"},			--创建的房间号
	{type = MSG_DATA_TYPE.BYTE  	, key = "iRoomLevel"},			--房间等级
	-- {type = MSG_DATA_TYPE.bool		, key = "bHasCreate"},		--是否已经创建哈好友房
	-- {type = MSG_DATA_TYPE.int  		, key = "iBaseNote"},			--创建的房间号
};

MSG_GAME_STRUCT.MSG_GR_C_Friend_UserSit =
{
	{type = MSG_DATA_TYPE.BYTE		, key = "cbSitFlag"},			
	{type = MSG_DATA_TYPE.int		, key = "szPassword"},		--好友房房间密码
	-- {type = MSG_DATA_TYPE.int		, key = "iPlayNum"},		--局数
	-- {type = MSG_DATA_TYPE.int		, key = "iBaseNote"},		--底注
};
MSG_GAME_STRUCT.MSG_S_CREATE_FRIEND_ROOM =
{
	-- {type = MSG_DATA_TYPE.int		, key = "iRoomID"},		--好友房房间ID
	-- {type = MSG_DATA_TYPE.int		, key = "iRoomPwd"},	--房间密码
	{type = MSG_DATA_TYPE.int		, key = "iGameNameID"},		--游戏ID
	{type = MSG_DATA_TYPE.int  		, key = "iRoomID"},			--创建的房间号
	{type = MSG_DATA_TYPE.int  		, key = "iRoomPwd"},			--创建的房间号
	{type = MSG_DATA_TYPE.BYTE  	, key = "iRoomLevel"},			--房间等级
	-- {type = MSG_DATA_TYPE.bool		, key = "bHasCreate"},		--是否已经创建哈好友房
};
MSG_GAME_STRUCT.MSG_C_CREATE_FRIEND_ROOM =
{
	{type = MSG_DATA_TYPE.int		, key = "iGameNameID"},		--游戏ID
	{type = MSG_DATA_TYPE.BYTE		, key = "iRoomLevel"},		--房间等级
};

MSG_GAME_STRUCT.MSG_GR_C_Friend_UserJoin =
{
	{type = MSG_DATA_TYPE.int,		 key = "szPassword"},		--好友房房间密码
};
MSG_GAME_STRUCT.MSG_C_JOIN_FRIEND_ROOM =
{
	{type = MSG_DATA_TYPE.int,		 key = "szPassword"},		--好友房房间密码
};
MSG_GAME_STRUCT.MSG_S_JOIN_FRIEND_ROOM =
{
	{type = MSG_DATA_TYPE.int		, key = "iGameNameID"},		--游戏ID
	{type = MSG_DATA_TYPE.int		, key = "iRoomID"},		--好友房房间ID
	{type = MSG_DATA_TYPE.int		, key = "iRoomPwd"},		--好友房房间ID
	{type = MSG_DATA_TYPE.BYTE  	, key = "iRoomLevel"},			--房间等级
};
MSG_GAME_STRUCT.MSG_GR_R_UserCut =
{
	{type = MSG_DATA_TYPE.BYTE		, key = "bDeskStation"},		--桌子号
};

--红包
MSG_GAME_STRUCT.MSG_C_SEND_RED=
{
	{type = MSG_DATA_TYPE.int 		, key = "iAmount"},				--发送金额
};


MSG_GAME_STRUCT.MSG_S_ACCEPT_RED=
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedID"},			--红包ID
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbRedType"},			--红包类型
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbRedLevel"},			--红包级别
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbHeadID"},	--头像
	{type = MSG_DATA_TYPE.BYTE , key = "cbNickNameLen"},					--昵称长度
	{type = MSG_DATA_TYPE.char , key = "nickName",num = "cbNickNameLen"},	--用户昵称
	{type = MSG_DATA_TYPE.BYTE , key = "cbHeadWebLen"},					--网址长度
	{type = MSG_DATA_TYPE.char , key = "szHeadWeb",num = "cbHeadWebLen"},		--头像链接

};

MSG_GAME_STRUCT.MSG_C_RECEIVE_RED=
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedID"},					--红包ID
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbRedType"},			--红包类型
};

MSG_GAME_STRUCT.MSG_S_RECEIVE_RED=
{
	{type = MSG_DATA_TYPE.int 		, key = "iAmount"},				--领取的红包金额
};

MSG_GAME_STRUCT.MSG_C_SEND_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iAmount"},				--领取的红包金额
	{type = MSG_DATA_TYPE.char 		, key = "szRemark",num=RED_REMARK_LEN},				--领取的红包金额
}
MSG_GAME_STRUCT.MSG_S_SEND_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedNo"},				--红包编号
}
MSG_GAME_STRUCT.PIAZZA_RED_BRIEF = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iID"},					--红包编号(1-9999)
	{type = MSG_DATA_TYPE.int 		, key = "iUserID"},				--发布红包的玩家ID
	{type = MSG_DATA_TYPE.time_t 	, key = "tCreateTime"},			--红包生成时间
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbRemarkLen"},				--红包说明长度
	{type = MSG_DATA_TYPE.char 		, key = "szRemark",num="cbRemarkLen"},		--领取的红包金额
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbnickNameLen"},					--用户昵称长度
	{type = MSG_DATA_TYPE.char 		, key = "nickName",num="cbnickNameLen"},	--用户昵称

}
MSG_GAME_STRUCT.MSG_S_GET_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iSendCount"},				--数量
	{type = MSG_DATA_TYPE.int 		, key = "iSendFlag"},				--0 一次发完   1 开始 2未完，3发完
	{type = MSG_GAME_STRUCT.PIAZZA_RED_BRIEF, key = "info" ,num = "iSendCount"},	--广场红包
}
MSG_GAME_STRUCT.PIAZZA_RED_DETAIL = 
{
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbHeadID"},				--头像ID
	{type = MSG_DATA_TYPE.int 		, key = "iRedAmount"},				--红包金额
	{type = MSG_DATA_TYPE.int 		, key = "iGuessCount"},				--竞猜次数
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbVipLevel"},			--用户自定义头像长度
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbSex"},			--用户自定义头像长度
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbHeadWebLen"},			--用户自定义头像长度
	{type = MSG_DATA_TYPE.char 		, key = "szHeadWeb",num="cbHeadWebLen"},			--用户自定义头像长度
}
MSG_GAME_STRUCT.MSG_C_LOOK_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedNo"},				--红包编号
}
MSG_GAME_STRUCT.MSG_C_GUESS_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedNo"},				--红包编号
	{type = MSG_DATA_TYPE.int 		, key = "iRedAmount"},			--红包金额
}
--回收红包
MSG_GAME_STRUCT.MSG_C_RECOVER_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedNo"},				--红包编号
}
MSG_GAME_STRUCT.MSG_S_RECOVER_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedNo"},				--红包编号
	{type = MSG_DATA_TYPE.int 		, key = "iRedAmount"},			--红包金额
	{type = MSG_DATA_TYPE.BYTE 		, key = "iType"},				--回收类型
}
MSG_GAME_STRUCT.MSG_S_BEGUESSED_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedAmount"},				--红包金额
	{type = MSG_DATA_TYPE.char 		, key = "nickName",num=_len_user_nickname},			--被猜中红包的用户昵称
}
MSG_GAME_STRUCT.MSG_S_DEL_PIAZZA_RED = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedNo"},				--红包编号
	{type = MSG_DATA_TYPE.int 		, key = "iUserID"},				--用户ID
}
MSG_GAME_STRUCT.MSG_S_PIAZZA_RED_INFO = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iID"},				--红包编号
	{type = MSG_DATA_TYPE.int 		, key = "iRedAmount"},			--红包金额
	{type = MSG_DATA_TYPE.BYTE 		, key = "iType"},				--红包状态（1退回 2被取走 3已领取）
	{type = MSG_DATA_TYPE.time_t 	, key = "tCreateTime"},			--时间
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbRemarkLen"},			--红包说明长度
	{type = MSG_DATA_TYPE.char 		, key = "szRemark",num="cbRemarkLen"},		--领取的红包金额
	{type = MSG_DATA_TYPE.BYTE 		, key = "cbnickNameLen"},					--用户昵称长度
	{type = MSG_DATA_TYPE.char 		, key = "nickName",num="cbnickNameLen"},	--用户昵称
}
MSG_GAME_STRUCT.MSG_S_MY_PIAZZA_RED_INFO = 
{
	{type = MSG_DATA_TYPE.BYTE 		, key = "iSendCount"},				--数量
	{type = MSG_DATA_TYPE.BYTE 		, key = "iSendFlag"},				--一次性发完
	{type = MSG_GAME_STRUCT.MSG_S_PIAZZA_RED_INFO, key = "info" ,num = "iSendCount"},
}
MSG_GAME_STRUCT.MSG_S_REDBAG = 
{
	{type = MSG_DATA_TYPE.BYTE 		, key = "iRedBagNum"},				--获得福袋数量
}
MSG_GAME_STRUCT.MSG_C_PIAZZA_RED_OP = 
{
	{type = MSG_DATA_TYPE.int 		, key = "iRedID"},				--红包ID
	{type = MSG_DATA_TYPE.BYTE 		, key = "iOpType"},				--操作(enRED_OP)
}

--好友房
MSG_GAME_STRUCT.ApplyDissolvedMsg =
{
	{type = MSG_DATA_TYPE.BYTE 		, key ="bStation"},			--申请解散的位置
	{type = MSG_DATA_TYPE.time_t 	, key ="iTime"},			--申请解散时间
};
MSG_GAME_STRUCT.ReplyDissolvedMsg=
{
	{type = MSG_DATA_TYPE.bool  		, key = "bAgree"},			--是否同意解散
};
MSG_GAME_STRUCT.SReplyDissolvedMsg=
{
	{type = MSG_DATA_TYPE.BYTE   		, key = "bStation"},		--回复者的位置
	{type = MSG_DATA_TYPE.bool    		, key = "bAgree"},			--是否同意解散
};
MSG_GAME_STRUCT.ApplyDissolvedReComeMsg=
{
	{type = MSG_DATA_TYPE.BYTE   		, key = "bStation"},		--回复者的位置
	{type = MSG_DATA_TYPE.BYTE    		, key = "bAgreeDissolved", num = PLAY_COUNT},--是否同意解散
	{type = MSG_DATA_TYPE.time_t    	, key = "tTimeLeft"},			--剩余时间
};
--剩余的牌的数据
MSG_GAME_STRUCT.LeaveCardStruct=
{
	{type = MSG_DATA_TYPE.BYTE   		, key = "iLeaveCardList", num = TOTAL_CARD_CNT},		--回复者的位置	--剩余时间
};
--刷新牌的数据
MSG_GAME_STRUCT.MSG_GR_R_SendUserCards=
{
	{type = MSG_DATA_TYPE.BYTE   		, key = "iUserCardCount"},
	{type = MSG_DATA_TYPE.BYTE   		, key = "iUserCard", num = 20},	
};

MSG_GAME_STRUCT.MSG_USER_MONEY_REFRESH = 
{
	{type = MSG_DATA_TYPE.BYTE    , key = "cbDeskStation"},		--座位号
	{type = MSG_DATA_TYPE.__int64 , key = "iUserMoney"},			--金币
	{type = MSG_DATA_TYPE.int     , key = "iUserTreasure"},		--元宝
};

MSG_GAME_STRUCT.MSG_MAQ_MSG_APP = 
{
	{type = MSG_DATA_TYPE.BYTE    , key = "bMaqType"},		--跑马灯类型（enMAQTYPE）
	{type = MSG_DATA_TYPE.BYTE    , key = "bNickNameLen"},		--玩家昵称长度
	{type = MSG_DATA_TYPE.char     , key = "NickName",num ="bNickNameLen"},		--玩家昵称
	{type = MSG_DATA_TYPE.BYTE    , key = "bMaqLen"},		--消息长度
	{type = MSG_DATA_TYPE.char     , key = "szMsgContent",num ="bMaqLen"},		--跑马灯(消息内容)
}

--任务系统
MSG_GAME_STRUCT.MSG_TaskInfo = 
{
	{type = MSG_DATA_TYPE.int      , key = "iTaskID"},			--任务ID
	{type = MSG_DATA_TYPE.BYTE      , key = "cbTaskValue"},		--（0未完成 1已完成 2已领取）
	{type = MSG_DATA_TYPE.int		, key = "cbTaskFinishValue"},			--任务完成次数
}

MSG_GAME_STRUCT.MSG_UserTaskInfo =
{
	{type = MSG_DATA_TYPE.BYTE		, key = "cbTaskCount"},			--数量
	{type = MSG_GAME_STRUCT.MSG_TaskInfo, key = "TaskInfo" ,num = "cbTaskCount"},
}

--分享位置,0新手七日任务分享,1转盘兑换分享
MSG_GAME_STRUCT.MSG_C_WXShare =
{
	{type = MSG_DATA_TYPE.BYTE		, key = "iTaskType"},			--数量
}


MSG_GAME_STRUCT.MSG_TaskFinish =
{
	{type = MSG_DATA_TYPE.int		, key = "iTaskID"},			--任务ID
};

MSG_GAME_STRUCT.MSG_NewTaskReceiveReward =
{
	{type = MSG_DATA_TYPE.BYTE		, key = "iTaskID"},			--任务ID
};

MSG_GAME_STRUCT.MSG_TaskReceiveReward =  
{
	{type = MSG_DATA_TYPE.int      , key = "iTaskID"},			--任务ID
	{type = MSG_DATA_TYPE.BYTE      , key = "iSign"},			--任务标记
}
--领取救济金信息
MSG_GAME_STRUCT.MSG_GR_SEND_MONEY_NOTFIY_APP =  
{
	{type = MSG_DATA_TYPE.int      , key = "iUserID"},			--赠送玩家ID
}
--刷新金币
MSG_GAME_STRUCT.MSG_GP_USER_REFLASH =  
{
	{type = MSG_DATA_TYPE.longint      , key = "dwUserID"},			--玩家ID
	{type = MSG_DATA_TYPE.__int64      , key = "dwMoney"},			--玩家金币
	{type = MSG_DATA_TYPE.int      		, key = "dwGameCoin"},		--玩家奖券
	{type = MSG_DATA_TYPE.int      		, key = "dwTreasure"},		--玩家元宝
	{type = MSG_DATA_TYPE.int      		, key = "iLuckeyKey"},		--幸运钥匙数
}
MSG_GAME_STRUCT.MSG_WEB_USER_RECHARGE_NOTICE = 
{
	{type = MSG_DATA_TYPE.int      , key = "iMvid"},			--商品ID
}
--换桌
MSG_GAME_STRUCT.MSG_GR_C_UserAutoSit =  
{
	{type = MSG_DATA_TYPE.BYTE      , key = "bSitType"},			--玩家ID
}

MSG_GAME_STRUCT.MSG_S_WXRED =  
{
	{type = MSG_DATA_TYPE.BYTE      , key = "iKeyCount"},			--钥匙数目
}

MSG_GAME_STRUCT.MSG_GR_UserState =  
{
	{type = MSG_DATA_TYPE.BYTE      , key = "bDeskStation"},		--用户状态改变位置
	{type = MSG_DATA_TYPE.BYTE      , key = "bUserState"},			--用户状态
}

MSG_GAME_STRUCT.MSG_GR_SIGNUP =  
{
	{type = MSG_DATA_TYPE.BYTE      , key = "iLevel"},		        --报名等级
}
-----------------------------------------大厅新增结构------------------------------------------
MSG_GAME_STRUCT.MSG_S_RedTurnTableResult =  
{
	{type = MSG_DATA_TYPE.BYTE      , key = "iTurnCount"},			--ID
	{type = MSG_DATA_TYPE.int      	, key = "iID", num = 10},			--ID
}

--分享转盘
MSG_GAME_STRUCT.MSG_S_TurnTableResult =  
{
	{type = MSG_DATA_TYPE.BYTE      , key = "iTurnType"},			--type
	{type = MSG_DATA_TYPE.BYTE      , key = "iTurnCount"},			--ID
	{type = MSG_DATA_TYPE.int      	, key = "iID", num = "iTurnCount"},			--ID
}

MSG_GAME_STRUCT.RedTurnTableRecord =  
{
	{type = MSG_DATA_TYPE.BYTE      , key = "iGoodsType"},		--商品类型
	{type = MSG_DATA_TYPE.int      	, key = "iAmount"},			--数量
	{type = MSG_DATA_TYPE.time_t    , key = "tRecordTime"},		--记录时间
}
MSG_GAME_STRUCT.MSG_S_RedTurnTableRecord =  
{
	{type = MSG_DATA_TYPE.int      	, key = "iCount"},			--数量
	{type = MSG_GAME_STRUCT.RedTurnTableRecord    , key = "turnRecord" ,num="iCount"},		--记录
}
MSG_GAME_STRUCT.MSG_C_RedTurnTable =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "iTurnCount"},			--转的次数(enRedTurnTableCount)
}

MSG_GAME_STRUCT.MSG_C_TurnTable =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "iTurnType"},			--转的类型 分享转圈为1
	{type = MSG_DATA_TYPE.BYTE      	, key = "iTurnCount"},			--转的次数(enRedTurnTableCount)
}


MSG_GAME_STRUCT.MSG_C_LOTTERY_REQ =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "bLotteryReqType"},			--抽奖等级(enLottery_ReqType)
}
MSG_GAME_STRUCT.MSG_S_LOTTERY_REQ =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "bLotteryReqType"},			--抽奖等级(enLottery_ReqType)
	{type = MSG_DATA_TYPE.int      	, key = "LotteryID"},			--抽奖ID
}
MSG_GAME_STRUCT.ActiveInfo =  
{
	{type = MSG_DATA_TYPE.int      	, key = "iID"},			            --活动ID
	{type = MSG_DATA_TYPE.time_t      	, key = "tBeginTime"},			--开始时间
	{type = MSG_DATA_TYPE.time_t      	, key = "tEndTime"},			--结束时间
}
MSG_GAME_STRUCT.MSG_S_ActiveList =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "iCount"},			--个数
	{type = MSG_GAME_STRUCT.ActiveInfo  , key = "activeInfo",num="iCount"},
}

---新增游戏任务结构体（2018-01-26）
MSG_GAME_STRUCT.MSG_GR_C_GameTaskBoxAward =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "iAwardType"},			--领取宝箱类型
}
MSG_GAME_STRUCT.MSG_GR_S_GameTaskBoxAward =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "iPlayCount"},			--玩家局数
}

--复活类型
--0对局,1分享,2下载,3充值
MSG_GAME_STRUCT.MSG_C_COIN_RESURRECTION =  
{
	{type = MSG_DATA_TYPE.BYTE      	, key = "iResurrectoinType"},			--玩家局数
}
--消息映射
--主ID副ID与哪个结构体对应
--_def表示没有指明副ID时默认对应
local getdefTbl = function(tbl) return setmetatable(tbl,{__index=function(self, key) return rawget(self, "_def") end }) end

--大厅的消息
MSG_MAP = {}
	MSG_MAP[MDM_SOCKET_HEARD] = {
		[ASS_SOCKET_HEARD] = {send = nil,rec = nil,filter = true},
		[ASS_SOCKET_ISCONNECT] = {send = nil,rec = nil,filter = true},
	}
	MSG_MAP[MDM_SOCKET_CONNECT_CHECK] = {
		[ASS_SOCKET_CONNECT_CHECK] = {send = nil,rec = nil,}
	}
	--登录游戏
	MSG_MAP[MDM_GP_REQURE_GAME_PARA] = getdefTbl({
		[ASS_GP_REQURE_GAME_PARA] = {send = MSG_GAME_STRUCT.MSG_C_RGAME_PARA_REQ,rec = MSG_GAME_STRUCT.CenterServerMsg,filter = true}, --waitfor内容为空表示返回的消息ID跟本身相同
		})
	--登录账号
	MSG_MAP[MDM_GP_LOGON] = getdefTbl({
		[ASS_GP_LOGON_REG] = {send = MSG_GAME_STRUCT.MSG_C_REG_QUICK,rec = nil,waitfor = {MDM_GP_LOGON}},--快速登录
		[ASS_GP_LOGON_BY_NAME] = {send = MSG_GAME_STRUCT.MSG_GP_S_LogonByNameStruct,rec = nil--[[,waitfor = {MDM_GP_LOGON}]]},--名字登录
		[ASS_GP_LOGON_SUCCESS] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GP_R_LogonResultApp,updateHandleCode = true},--返回成功-- 这个消息需要保存uHandleCode
		[ASS_GP_LOGON_SUCCESS_ADD] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GP_R_LogonResultAppAdd,updateHandleCode = true},--返回成功-- 这个消息需要保存uHandleCode
		[ASS_GP_LOGON_ERROR] = {send = nil,rec = nil,filter = true},--返回密码错误
		[ERR_GP_MSG_SIZE_ERR] = {send = nil,rec = nil,filter = true},
		[ASS_GM_MODIFY_MONEY] = {send = MSG_GAME_STRUCT.MSG_GM_MODIFY_MONEY,rec = nil,filter = true},--修改金币
	})

	--房间列表
	MSG_MAP[MDM_GP_LIST] = getdefTbl({
		[ASS_GP_GET_ROOM] = {send = MSG_GAME_STRUCT.MSG_GP_GETROOM,rec = MSG_GAME_STRUCT.ComRoomInfoApp,waitfor = {"RoomSocket"}},--点击房间
		[ASS_GP_GET_ROOM_ERROR] = {send = nil,rec = nil},--点击房间
		[ASS_GP_GET_GAME_PEOPLE_COUNT] = {send = nil,rec = MSG_GAME_STRUCT.AllGamePeople},--点击房间
		[ASS_GP_GET_ROOM_BY_ID] = {send = MSG_GAME_STRUCT.MSG_GP_GETROOM_BY_ID,rec = MSG_GAME_STRUCT.ComRoomInfoApp,waitfor = {"RoomSocket"}},--点击房间
		[ASS_GP_GET_GAMELEVEL_PEOPLE_COUNT] = {send = MSG_GAME_STRUCT.MSG_GP_C_GET_GAMELEVEL_PEOPLE,rec = MSG_GAME_STRUCT.MSG_GP_S_GET_GAMELEVEL_PEOPLE},--获取
		[ASS_GP_GET_ROOM_TIME_ERROR] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GP_S_GetRoomErr},--获取
		
	})

	--比赛消息
	MSG_MAP[MDM_GP_BATTLE_MSG] = getdefTbl({
		[ASS_GP_BATTLE_USER_SIGN_UP_REQ] = {send = MSG_GAME_STRUCT.MSG_C_BATTLE_USER_SIGN_UP,rec = MSG_GAME_STRUCT.MSG_S_BATTLE_USER_SIGN_UP},
		[ASS_BATTLE_CANCLE_SIGNUP] = {send = MSG_GAME_STRUCT.MSG_C_CANCLE_SIGNUP,rec = nil,waitfor = {}},	--退赛
		[ASS_GP_BATTLE_USER_SIGNUP_INFO_REQ] = {send = MSG_GAME_STRUCT.MSG_C_BATTLE_USER_SIGNUP_INFO,rec = MSG_GAME_STRUCT.MSG_S_BATTLE_USER_SIGNUP_INFO_APP},	--请求报名信息
		[ASS_GP_BATTLE_USER_SIGNUP_REFRESH] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_BATTLE_USER_SIGNUP_INFO,filter = true},	--退赛
		[ASS_BATTLE_MATCH_WILL_BEGIN_NOTIFY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_BATTLE_MATCH_WILL_START,filter = true},--即时赛人数满即将开赛通知
		[ASS_GP_FIX_BATTLE_USER_SIGN_UP_REQ] = {send = MSG_GAME_STRUCT.MSG_C_FIX_BATTLE_USER_SIGN_UP_REQ,rec = MSG_GAME_STRUCT.MSG_S_FIX_BATTLE_USER_SIGN_UP_REQ_APP},--定时赛报名通知包
		[ASS_FIX_BATTLE_WILL_START_NOTIFY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_FIX_BATTLE_WILL_START_NOTIFY,filter = true},--定时赛即将开赛通知
		[ASS_CANCLE_FIX_TIME_BATTLE] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_CANCLE_FIX_TIME_BATTLE,filter = true},--取消定时赛通知
		[ASS_FIX_BATTLE_END] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_FIX_BATTLE_END,filter = true},--定时赛结束
		[ASS_GP_BATTLE_REQ_RANK_ONE_ROOM] = {send = MSG_GAME_STRUCT.MSG_C_BATTLE_REQ_RANK_ONE_ROOM,rec = MSG_GAME_STRUCT.MSG_S_BATTLE_REQ_RANK_ONE_ROOM,waitfor = {}}
	})
	--商城道具
	MSG_MAP[MDM_GP_PROP] = getdefTbl({
		[ASS_PROP_BUY] = {send = MSG_GAME_STRUCT._TAG_PROP_BUY,rec = nil,waitfor = {}},--购买商城物品
		[ASS_PROP_GETUSERPROP] = {send = nil,rec = MSG_GAME_STRUCT.MSG_PROP_S_GETPROP_RES},	--获取用户道具（登录大厅成功后给服务器发送）
		[ASS_PROP_USEPROP] = {send = MSG_GAME_STRUCT._TAG_USINGPROP,rec = MSG_GAME_STRUCT._TAG_USINGPROP},	--道具使用（大厅使用）
		[ASS_PROP_BIG_BOARDCASE] = {send = MSG_GAME_STRUCT._TAG_BOARDCAST,rec = nil},	--道具使用（大厅使用）
	})
	--修改信息
	MSG_MAP[MDM_GP_USERREFLASH] = getdefTbl({
		--[ASS_GP_USER_HAS_CREATE_PSW] = {send = MSG_GAME_STRUCT.MSG_QUERY_CREATE_PASSWORD,rec =nil},	--判断是否创建过密码:
		[ASS_GP_USER_PASSWORD_UPDATE] = {send = MSG_GAME_STRUCT.MSG_USER_PASSWORD,rec = nil},	--修改密码
		[ASS_GP_USER_NICKNAME_UPDATE] = {send = MSG_GAME_STRUCT.MSG_USER_NICKNAME_UPDATE,rec = nil},	--修改昵称
		[ASS_GP_USER_NICKNAME_SEX_HEAD] = {send = MSG_GAME_STRUCT.MSG_USER_SEX_HEAD_UPDATE,rec = nil},	--修改性别
		[ASS_GP_USERREFLASH] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GP_USER_REFLASH},	--游戏中刷新玩家数据
		[ASS_GP_USERREFLASH_NOTICE] = {send = nil,rec = nil},	--通知玩家刷新数据
	})
	--邮件
	MSG_MAP[MDM_GP_MAIL] = getdefTbl({
		[ASS_GP_MAIL_ALL] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_MAIL_INFO,filter = true},	--获取用户道具（登录大厅成功后给服务器发送）
		[ASS_GP_MAIL_READ] = {send = MSG_GAME_STRUCT.MSG_C_MAIL_READ,rec = MSG_GAME_STRUCT.MSG_S_MAIL_PROP,waitfor = {},},	--读取邮件
		[ASS_GP_MALL_REQ_NEW] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_MAIL_INFO},	--读取邮件
		[ASS_GP_MALL_HAS_READ] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_MAIL_INFO},	--读取邮件
	})
	--好友房
	MSG_MAP[MDM_GP_VIP_LOGE] = getdefTbl({
		[ASS_GP_HAS_CREATE_FRIEND_ROOM] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_HAS_CREATE_FRIEND_ROOM},	
		[ASS_GP_CREATE_FRIEND_ROOM] = {send = MSG_GAME_STRUCT.MSG_C_CREATE_FRIEND_ROOM,rec = MSG_GAME_STRUCT.MSG_S_CREATE_FRIEND_ROOM},
		[ASS_GP_JOIN_FRIEND_ROOM] = {send = MSG_GAME_STRUCT.MSG_C_JOIN_FRIEND_ROOM,rec = MSG_GAME_STRUCT.MSG_S_JOIN_FRIEND_ROOM},
		[ASS_GP_DISSOLVED_FRIEND_ROOM] = {send = nil,rec = nil},
	})
	--红包
	MSG_MAP[MDM_GP_RED] = getdefTbl({
		[ASS_GP_SEND_RED] = {send = MSG_GAME_STRUCT.MSG_C_SEND_RED,rec = nil,filter = true},	
		[ASS_GP_ACCEPT_RED] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_ACCEPT_RED,filter = true},
		[ASS_GP_RECEIVE_RED] = {send = MSG_GAME_STRUCT.MSG_C_RECEIVE_RED,rec = MSG_GAME_STRUCT.MSG_S_RECEIVE_RED,filter = true},
		[ASS_GP_SEND_PIAZZA_RED] = {send = MSG_GAME_STRUCT.MSG_C_SEND_PIAZZA_RED, rec = MSG_GAME_STRUCT.MSG_S_SEND_PIAZZA_RED,filter = true},
		[ASS_GP_GET_PIAZZA_RED] = {send = nil, rec = MSG_GAME_STRUCT.MSG_S_GET_PIAZZA_RED,waitfor = {},filter = true},
		[ASS_GP_LOOK_PIAZZA_RED] = {send=MSG_GAME_STRUCT.MSG_C_LOOK_PIAZZA_RED,rec = MSG_GAME_STRUCT.PIAZZA_RED_DETAIL,filter = true},
		[ASS_GP_GUESS_PIAZZA_RED] = {send=MSG_GAME_STRUCT.MSG_C_GUESS_PIAZZA_RED,rec = nil,filter = true},
		[ASS_GP_NEW_PIAZZA_RED] = {send = nil, rec = MSG_GAME_STRUCT.PIAZZA_RED_BRIEF,filter = true},
		--[ASS_GP_BEGUESSED_PIAZZA_RED] = {send = nil, rec = MSG_GAME_STRUCT.MSG_S_BEGUESSED_PIAZZA_RED},
		[ASS_GP_DEL_PIAZZA_RED] = {send = nil, rec = MSG_GAME_STRUCT.MSG_S_DEL_PIAZZA_RED,filter = true},
		[ASS_GP_RECOVER_PIAZZA_RED] = {send = MSG_GAME_STRUCT.MSG_C_RECOVER_PIAZZA_RED, rec = nil,filter = true},
		[ASS_GP_MY_PIAZZA_RED_INFO] = {send = nil, rec = MSG_GAME_STRUCT.MSG_S_MY_PIAZZA_RED_INFO,filter = true},
		[ASS_GP_REDBAG] = {send = nil, rec = MSG_GAME_STRUCT.MSG_S_REDBAG,filter = true},
		[ASS_GP_PIZZA_RED_INFO] = {send = nil, rec = MSG_GAME_STRUCT.MSG_S_PIAZZA_RED_INFO,filter = true},
		[ASS_GP_PIZZA_RED_OPERATOR] = {send = MSG_GAME_STRUCT.MSG_C_PIAZZA_RED_OP, rec = nil,filter = true},
	})
	MSG_MAP[MDM_GP_MAQ_MSG] = getdefTbl({
		[ASS_GP_MAQ_MSG_NOTIFY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_MAQ_MSG_APP,filter = true},	
	})
	--任务系统
	MSG_MAP[MDM_GP_TASK] = getdefTbl({
		[ASS_GP_TASKLIST] = {send = nil,rec = MSG_GAME_STRUCT.MSG_UserTaskInfo},	
		[ASS_GP_TASK_RECEIVE_REWARD] = {send = MSG_GAME_STRUCT.MSG_TaskReceiveReward,rec = MSG_GAME_STRUCT.MSG_TaskReceiveReward,waitfor = {}},
		[ASS_GP_TASK_FINISH_NOTICE] = {send = nil,rec = MSG_GAME_STRUCT.MSG_TaskFinish,filter = true},
		-- [ASS_GP_NEWTASKINFO] = {send = nil,rec = MSG_GAME_STRUCT.MSG_TaskInfo,filter = true},
		[ASS_GP_NEW_TASK_RECIVE] = {send = nil,rec = MSG_GAME_STRUCT.MSG_NewTaskReceiveReward,filter = true},	
		[ASS_GP_TASK_WX_SHARE] = {send = MSG_GAME_STRUCT.MSG_C_WXShare,rec = MSG_GAME_STRUCT.MSG_C_WXShare,filter = true},	
	})
	--关注微信任务
	MSG_MAP[MDM_WEB_MAIN_ID] = getdefTbl({
		[ASS_WEB_MSG_FOLLOW_WECHAR] = {send = nil,rec = nil},	
		[ASS_WEB_MSG_RECEIVE_WECHAR_PRIZE] = {send = nil,rec = nil,filter = true},
		[ASS_WEB_MSG_RECHARGE] = {send = nil,rec = MSG_GAME_STRUCT.MSG_WEB_USER_RECHARGE_NOTICE},	--通知玩家刷新数据
	})
	--签到
	MSG_MAP[MDM_GP_SIGN] = getdefTbl({
		[ASS_GP_SIGN] = {send = nil,rec = nil,waitfor = {},filter = true},	
	})
	--领取VIP每日礼包
	MSG_MAP[MDM_GP_VIP] = getdefTbl({
		[ASS_VIP_RECEIVE_DAY_REWARD] = {send = nil,rec = nil,waitfor = {}},	
	})
	--门票复活
	MSG_MAP[MDM_GP_COIN] = getdefTbl({
		[ASS_GP_COIN_RESURRECTION] = {send = MSG_GAME_STRUCT.MSG_C_COIN_RESURRECTION,rec = nil,waitfor = {}},	
	})
	--转盘摇奖
	MSG_MAP[MDM_GP_TURN_TABLE] = getdefTbl({
		[ASS_GP_RED_TURN_TABLE] = {send = MSG_GAME_STRUCT.MSG_C_RedTurnTable,rec = MSG_GAME_STRUCT.MSG_S_RedTurnTableResult},	
		[ASS_GP_RED_TURN_TABLE_RECORD] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_RedTurnTableRecord},	
		[ASS_GP_TURN_TABLE] = {send = MSG_GAME_STRUCT.MSG_C_TurnTable,rec = MSG_GAME_STRUCT.MSG_S_TurnTableResult},
	})
	--活动配置
	MSG_MAP[MDM_GP_ACTIVE] = getdefTbl({
		[ASS_ACTIVELIST] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_ActiveList},	
		[ASS_ACTIVE_LOTTERY_REQ] = {send = MSG_GAME_STRUCT.MSG_C_LOTTERY_REQ,rec = MSG_GAME_STRUCT.MSG_S_LOTTERY_REQ},
	})
--房间的消
MSG_ROOM_MAP = {}
	MSG_ROOM_MAP[MDM_SOCKET_HEARD] = {
		[ASS_SOCKET_HEARD] = {send = nil,rec = nil,filter = true},
	}
	MSG_ROOM_MAP[MDM_SOCKET_CONNECT_CHECK] = {
		[ASS_SOCKET_CONNECT_CHECK] = {send = nil,rec = nil,}
	}

	MSG_ROOM_MAP[MDM_GR_LOGON] = getdefTbl({
		[ASS_GR_LOGON_BY_ID] = {send = MSG_GAME_STRUCT.MSG_GR_S_RoomLogon,rec = nil,filter = true},--进入房间
		[ASS_GR_LOGON_SUCCESS] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_R_LogonResultApp,updateHandleCode = true},--进入房间
		[ASS_GR_LOGON_ERROR] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_R_LogonErrorApp,filter = true},
	})
	MSG_ROOM_MAP[MDM_GR_USER_ACTION] = getdefTbl({
		[ASS_GR_USER_COME] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_R_UserCome},--进入房间
		[ASS_GR_USER_SIT] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_R_UserSitApp,filter = true},--进入房间
		[ASS_GR_USER_UP] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_R_UserSitApp,filter = true},--离开房间
		[ASS_GR_QUEUE_USER_SIT] = {send = nil,rec =MSG_GAME_STRUCT.MSG_GR_R_UserSitApp,filter = true},
		[ASS_GR_NoMoneyTickRoom] = {send = nil,rec = nil,filter = true},
		[ASS_GR_FRIEND_USER_SIT] = {send = MSG_GAME_STRUCT.MSG_GR_C_Friend_UserSit, rec =nil,filter = true},
		[ASS_GR_FRIEND_USER_JOIN] = {send = MSG_GAME_STRUCT.MSG_GR_C_Friend_UserJoin, rec =nil,filter = true},
		[ASS_GR_USER_CUT] = {send = nil, rec = MSG_GAME_STRUCT.MSG_GR_R_UserCut,filter = true},
		[ASS_GR_USER_AUTO_SIT] = {send = MSG_GAME_STRUCT.MSG_GR_C_UserAutoSit, rec = nil,filter = true},
		[ASS_GR_DESK_DISSOLVED] = {send = nil, rec = nil},
		[ASS_GR_USER_STATE] = {send = nil, rec = MSG_GAME_STRUCT.MSG_GR_UserState},
		[ASS_GR_USER_STANDUP] = {send = nil, rec = nil},
		[ASS_GR_SIGN_UP] = {send = MSG_GAME_STRUCT.MSG_GR_SIGNUP, rec = nil},
		[ASS_GR_LEAVE_QUEUE] = {send = nil, rec = nil},
	})
	MSG_ROOM_MAP[MDM_GM_GAME_NOTIFY] = getdefTbl({
		[ASS_GM_GAME_STATION] = {filter = true,send = nil,rec = function(stateType)
			if stateType == GS_WAIT_SETGAME or
				stateType== GS_WAIT_ARGEE	then
				return  MSG_GAME_STRUCT.GameStation_2
			elseif stateType == GS_SEND_CARD or
				stateType == GS_WAIT_BACK then
				return MSG_GAME_STRUCT.GameStation_3
			elseif stateType == GS_WAIT_SHOW_CARD then
				return MSG_GAME_STRUCT.GameStation_4
			elseif stateType == GS_PLAY_GAME then
				return MSG_GAME_STRUCT.GameStation_5
			elseif stateType == GS_WAIT_NEXT then
				return MSG_GAME_STRUCT.GameStation_6
			elseif stateType == WB_GS_WAIT_ARGEE then 		--斗牛状态
				return  MSG_GAME_STRUCT.WB_GameStation_2
			elseif stateType == WB_GS_GAME_BEGIN then 		--斗牛状态
				return  MSG_GAME_STRUCT.WB_GameStation_3
			elseif stateType == WB_GS_FAPAI then
				return  MSG_GAME_STRUCT.WB_GameStation_4
			elseif stateType == WB_GS_QIANGZHUANG then
				return  MSG_GAME_STRUCT.WB_GameStation_5
			elseif stateType == WB_GS_QIANGZHUANG_FINISH then
				return MSG_GAME_STRUCT.WB_GameStation_6
			elseif stateType == WB_GS_XIAZHU then
				return MSG_GAME_STRUCT.WB_GameStation_7
			elseif stateType == WB_GS_XUANPAI then
				return MSG_GAME_STRUCT.WB_GameStation_8
			elseif stateType == WB_GS_GAME_END then
				return MSG_GAME_STRUCT.WB_GameStation_9
			elseif stateType == WB_GS_WAIT_NEXT then
				return MSG_GAME_STRUCT.WB_GameStation_10
			elseif stateType == BR_GS_GAME_BEGIN then       --百人牛牛
				return MSG_GAME_STRUCT.BR_GameStation_3
			elseif stateType == BR_GS_SEND_CARD or stateType == BR_GS_WAIT_NEXT or stateType == BR_GS_REST or stateType == BR_GS_WAIT_SEND_CARD then
				return MSG_GAME_STRUCT.BR_GameStation_4
			elseif stateType == CR_GS_WAIT_WAITE then
				return MSG_GAME_STRUCT.CR_GameStation_2
			elseif stateType == CR_GS_GAME_BEGIN then
				return MSG_GAME_STRUCT.CR_GameStation_3
			elseif stateType == CR_GS_XIAZHU or stateType == CR_GS_SEANDBACKCARD then
				return MSG_GAME_STRUCT.CR_GameStation_4
			elseif stateType == CR_GS_GAMEEND then
				return MSG_GAME_STRUCT.CR_GameStation_5
			end
		end},--进入游戏服务器返回
		[ASS_SHOW_CARD_COUNT] = {send = nil,rec = MSG_GAME_STRUCT.ShowCardCountStruct,filter = true},--斗地主游戏服务器返回
		--[ASS_GR_USER_AGREE] = {send = nil,rec = nil},--用户准备
		[ASS_SEND_ALL_CARD] = {send = nil,rec = MSG_GAME_STRUCT.SendAllStruct,filter = true},--发卡
		[ASS_GAME_BEGIN] = {send = nil,rec = MSG_GAME_STRUCT.BeginUpgradeStruct,filter = true},--游戏开始
		[ASS_CALL_SCORE] = {send = MSG_GAME_STRUCT.CallScoreStruct,rec = MSG_GAME_STRUCT.CallScoreStruct,filter = true},--通知叫分
		[ASS_CALL_SCORE_RESULT] = {send = nil, rec = MSG_GAME_STRUCT.CallScoreStruct,filter = true},--叫分结果
		[ASS_CALL_SCORE_FINISH] = {send = nil,rec = MSG_GAME_STRUCT.CallScoreStruct,filter = true},--叫分完成
		[ASS_ROB_NT] = {send = MSG_GAME_STRUCT.RobNTStruct,rec = MSG_GAME_STRUCT.RobNTStruct},--通知抢地主
		[ASS_CALL_SCORE] = {send = MSG_GAME_STRUCT.CallScoreStruct,rec = MSG_GAME_STRUCT.CallScoreStruct,filter = true},--通知叫分
		[ASS_CALL_SCORE_RESULT] = {send = nil, rec = MSG_GAME_STRUCT.CallScoreStruct,filter = true},--叫分结果
		[ASS_CALL_SCORE_FINISH] = {send = nil,rec = MSG_GAME_STRUCT.CallScoreStruct,filter = true},--叫分完成
		[ASS_NO_CALL_SCORE_END] = {send = nil,rec = nil,filter = true},--无人叫分
		[ASS_ROB_NT] = {send = MSG_GAME_STRUCT.RobNTStruct,rec = MSG_GAME_STRUCT.RobNTStruct,filter = true},--通知抢地主
		[ASS_GAME_MULTIPLE] = {send = nil,rec = MSG_GAME_STRUCT.AwardPointStruct,filter = true},--有人抢地主
		[ASS_AWARD_POINT] = {send = nil,rec = MSG_GAME_STRUCT.AwardPointStruct,filter = true},--炸弹翻倍
		[ASS_ROB_NT_RESULT] = {send = nil,rec = MSG_GAME_STRUCT.RobNTStruct,filter = true},--抢地主结果
		[ASS_ROB_NT_FINISH] = {send = nil,rec = MSG_GAME_STRUCT.RobNTStruct,filter = true},--抢地主完成
		[ASS_GAME_PLAY] = {send = nil,rec = MSG_GAME_STRUCT.BeginPlayStruct,filter = true},--开始游戏
		[ASS_BACK_CARD_EX] = {send = nil,rec = MSG_GAME_STRUCT.BackCardExStruct,filter = true},--显示底牌数据
		[ASS_OUT_CARD] = {send = MSG_GAME_STRUCT.OutCardStruct,rec = MSG_GAME_STRUCT.OutCardMsg,filter = true},--通知用户出牌
		[ASS_OUT_CARD_RESULT] = {send = nil,rec = MSG_GAME_STRUCT.OutCardMsg,filter = true},--出牌结果
		[ASS_NEW_TURN] = {send = nil,rec = MSG_GAME_STRUCT.NewTurnStruct,filter = true},--新一轮出牌
		[ASS_CONTINUE_END] = {send = nil,rec = MSG_GAME_STRUCT.GameEndStruct,filter = true},--游戏结束
		[ASS_NO_CONTINUE_END] = {send = nil,rec = MSG_GAME_STRUCT.GameEndStruct,filter = true},--游戏结束
		[ASS_SAFE_END] = {send = nil,rec = nil,filter = true},
		[ASS_AUTO] = {send = MSG_GAME_STRUCT.AutoStruct,rec = MSG_GAME_STRUCT.AutoStruct,filter = true},--托管
		[ASS_SHOW_CARD] = {send = nil,rec = nil,filter = true},--亮牌时间
		[ASS_SHOW_CARD_RESULT] = {send = nil,rec = MSG_GAME_STRUCT.ShowCardStruct,filter = true},--亮牌
		[ASS_NO_SHOW_CARD] = {send = nil,rec = nil,filter = true},--发送不亮牌
		[ASS_NO_SHOW_CARD_RESULT] = {send = nil,rec = MSG_GAME_STRUCT.NoShowCardStruct,filter = true},--不亮牌结果
		[ASS_SHOW_CARD_FINISH] = {send = nil,rec = nil,filter = true},--亮牌时间结束
		[ASS_GM_AGREE_GAME] = {send = nil,rec = nil,filter = true},--亮牌时间结束
		[ASS_APPLY_DISSOLVED_ROOM] = {send = nil,rec = MSG_GAME_STRUCT.ApplyDissolvedMsg,},--申请解散
		[ASS_REPLY_DISSOLVED_ROOM] = {send = MSG_GAME_STRUCT.ReplyDissolvedMsg,rec = MSG_GAME_STRUCT.SReplyDissolvedMsg,},--申请解散
		[ASS_APPLY_DISSOLVED_RECOME] = {send = nil,rec = MSG_GAME_STRUCT.ApplyDissolvedReComeMsg,},--重连进来，如若有人申请解散
		[ASS_GET_LEAVE_CARD] = {send = nil,rec = MSG_GAME_STRUCT.LeaveCardStruct},--剩余的牌的数据
		[ASS_SEND_USER_CARD] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_R_SendUserCards},--剩余的牌的数据
	})
	MSG_ROOM_MAP[MDM_GR_ROOM] = getdefTbl({
		[ASS_GR_USER_AGREE] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_R_UserAgree,filter = true},--用户准备
		[ASS_GR_USER_POINT] = {send = nil,rec = nil,filter = true},--用户准备
		[ASS_GR_MATCH_RANK] = {send = nil,rec = nil,filter = true},--玩家排名
		[ASS_GR_SEND_MONEY_NOTFIY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GR_SEND_MONEY_NOTFIY_APP},--领取救济金
		
	})
	MSG_ROOM_MAP[MDM_GM_GAME_FRAME] = getdefTbl({
		[ASS_GM_GAME_INFO] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GM_S_GameInfo,filter = true},--
		[ASS_GM_NORMAL_TALK] = {send = MSG_GAME_STRUCT.MSG_GR_RS_NormalTalk,rec = MSG_GAME_STRUCT.MSG_GR_RS_NormalTalk},
		[ASS_GM_USER_INFO] = {send = MSG_GAME_STRUCT.MSG_GM_LOOK_USER_INFO,rec = MSG_GAME_STRUCT.MSG_GM_USER_INFO,filter = true},
		[ASS_GM_NORMAL_CHAT] = {send = MSG_GAME_STRUCT.MSG_GR_C_ChatInfo,rec = MSG_GAME_STRUCT.MSG_GR_S_ChatInfo},
	})

	MSG_ROOM_MAP[MDM_GR_BATTLE_MSG] = getdefTbl({
		[ASS_GR_MATCH_SYS_INFO] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_GR_MATCH_SYS_INFO,filter = true},--
		[ASS_GR_PLAYING_DESK_CNT_NOTIFY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_PLAYING_DESK_CNT_NOTIFY,filter = true},
		[ASS_GR_USER_STATE_NOTIFY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_GR_USER_STATE_NOTIFY,filter = true},
		[ASS_GR_PLAYER_MATCH_OVER] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_PLAYER_MATCH_OVER,filter = true},
		[ASS_GR_PLAYER_WIN_NOTIFY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_PLAYER_WIN_NOTIFY,filter = true},
		[ASS_GR_MATCH_NEW_ROUND_BEGIN] = {send = nil,rec = nil,filter = true},
		[ASS_GR_MATCH_NEW_GAME_BEGIN] = {send = nil,rec = nil,filter = true},
		[ASS_GR_DESK_GAME_OVER] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_PLAYING_DESK_CNT_NOTIFY,filter = true},
		[ASS_GR_MATCH_BEGIN] = {send = nil,rec = nil},
		[ASS_GR_MATCH_USER_RANK] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_GR_RANK_INFO},
		[ASS_GP_BATTLE_USER_RANK_INFO_REQ] = {send = nil,rec = MSG_GAME_STRUCT.MSG_BATTLE_USER_RANK,filter = true},--排名
		[ASS_Match_ENDTIPS] = {send = nil,rec = MSG_GAME_STRUCT.MSG_BATTLE_RANK_GAME_END},
		[ASS_GR_MATCH_RANKS] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_GR_RANKS},
		[ASS_GR_MATCH_USER_REBACK_WAIT_OTHER_DESK] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_USER_REBACK_WAIT_OTHER_DESK},
	})
	--比赛消息
	--[[MSG_MAP[MDM_GP_BATTLE_MSG] = getdefTbl({
		[ASS_GP_BATTLE_USER_RANK_INFO_REQ] = {send = nil,rec = MSG_GAME_STRUCT.MSG_BATTLE_USER_RANK,filter = true},--排名
	})]]--
		--商城道具
	MSG_ROOM_MAP[MDM_GR_PROP] = getdefTbl({
		[ASS_PROP_USEPROP] = {send = MSG_GAME_STRUCT._TAG_USINGPROP,rec = MSG_GAME_STRUCT._TAG_USINGPROP},	--道具使用
		[ASS_PROP_BUYGOLD] = {send = MSG_GAME_STRUCT._TAG_PROP_BUY,rec = MSG_GAME_STRUCT._TAG_PROP_BUY,waitfor = {}}
	})
	MSG_ROOM_MAP[MDM_GP_USERREFLASH] = getdefTbl({
		[ASS_GP_USERREFLASH] = {send = nil,rec = MSG_GAME_STRUCT.MSG_GP_USER_REFLASH},	--游戏中刷新玩家数据
	})
	--红包
	MSG_ROOM_MAP[MDM_GR_RED] = getdefTbl({
		[ASS_GR_RECEIVE_RED] = {send = MSG_GAME_STRUCT.MSG_C_RECEIVE_RED,rec = MSG_GAME_STRUCT.MSG_S_RECEIVE_RED},
	})
	MSG_ROOM_MAP[MDM_GR_VIP_LOGE] = getdefTbl({
		[ASS_GR_VIP_ROOM_OWNER_DISSOLVED] = {send = nil,rec = nil},
		[ASS_GR_VIP_ROOM_OWNER_START_GAME] = {send = nil,rec = nil},
	})
	MSG_ROOM_MAP[MDM_GR_USER_REFRESH] = getdefTbl({
		[ASS_GR_USER_MONRY_REFRESH] = {send = nil,rec = MSG_GAME_STRUCT.MSG_USER_MONEY_REFRESH},
	})
	MSG_ROOM_MAP[MDM_GR_ROOM_WXRED] = getdefTbl({
		[ASS_GP_BATTLE_ROOM_SEND_WXRED] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_WXRED},
		[ASS_GP_BATTLE_ROOM_SEND_BOX] = {send = nil,rec = nil},
		[ASS_GP_BATTLE_ROOM_OPEN_BOX] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_WXRED},
		-- [ASS_GP_BATTLE_USER_ACCEPT_WXRED] = {send = nil,rec = MSG_GAME_STRUCT.MSG_S_WXRED_INFO},
	})
	MSG_ROOM_MAP[MDM_GP_MAQ_MSG] = getdefTbl({
		[ASS_GR_MAQ_MSG_NOTIFY] = {send = nil,rec = MSG_GAME_STRUCT.MSG_MAQ_MSG_APP,filter = true},	
	})
	--游戏任务
	MSG_ROOM_MAP[MDM_GR_TASKDAILY] = getdefTbl({
		[ASS_GR_GAMETASK_BOX_AWARD] = {send = MSG_GAME_STRUCT.MSG_GR_C_GameTaskBoxAward,rec = MSG_GAME_STRUCT.MSG_GR_S_GameTaskBoxAward},	--游戏五局任务
	})