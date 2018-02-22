ui=class("ui")
--type:页面类型  id:唯一标识  clear:关闭后是否删除(只有ID_Win 有效)  path:页面地址  backKeytoClose:返回键关闭窗口
ui.Login 				= {type=_gm.ID_Main,	id=10001,	clear=false	,path="modules.login.Login",uipath="ui.login.Login"}
ui.update 				= {type=_gm.ID_Dlg,		id=10002,	clear=true	,path="modules.login.update",uipath="ui.login.update",backKeytoClose=false}
ui.inGameUpdate 		= {type=_gm.ID_Dlg,		id=10002,	clear=true	,path="modules.login.inGameUpdate",uipath="ui.login.update",backKeytoClose=false}
ui.selAccount 			= {type=_gm.ID_Dlg,		id=10003,	clear=true	,path="modules.login.selAccount",uipath="ui.login.selAccount"}
ui.SelectGame 			= {type=_gm.ID_Main,	id=10004,	clear=false	,path="modules.hall.SelectGame",uipath="ui.hall.SelectGame"}
ui.PersonalInfo 		= {type=_gm.ID_Win,		id=10005,	clear=false	,path="modules.playerInfo.PersonalInfo",uipath="ui.playerInfo.PersonalInfo2",backKeytoClose=true}
ui.happy_game 			= {type=_gm.ID_Win,		id=10006,	clear=false	,path="modules.happy_game",uipath="ui.happy_game"}
ui.playerInfo 			= {type=_gm.ID_Dlg,		id=10007,	clear=true	,path="modules.playRoom.playerInfo",uipath="ui.playRoom.playerInfo"}
ui.rankPlayerInfo 		= {type=_gm.ID_Dlg,		id=10008,	clear=true	,path="modules.rank.playerInfo",uipath="ui.common.playerInfo",notCloseOther=true}
ui.gameBuyCard 			= {type=_gm.ID_Dlg,		id=10009,	clear=true	,path="modules.playRoom.gameBuyCard",uipath="ui.details.gameBuyCard"}
ui.Loading 				= {type=_gm.ID_SysTip,	id=10010,	clear=true	,path="modules.sys.Loading",uipath="ui.system.Loading"}
ui.chatLayer 			= {type=_gm.ID_Dlg,		id=10011,	clear=true	,path="modules.playRoom.chatLayer",uipath="ui.playRoom.chatLayer"}
ui.pochang 				= {type=_gm.ID_Dlg,		id=10012,	clear=true	,path="modules.playRoom.pochang",uipath="ui.details.pochang"}
ui.pochang_buzhu 		= {type=_gm.ID_SysTip,	id=10013,	clear=false	,path="modules.playRoom.pochang_buzhu",uipath="ui.details.pochang_buzhu"}
ui.loadingbull 			= {type=_gm.ID_SysTip,	id=10014,	clear=false	,path="modules.classicWatchBrand.loadingbull",uipath="ui.classicWatchBrand.loadingbull"}
ui.niuniugame 			= {type=_gm.ID_Win,		id=10015,	clear=false	,path="modules.classicWatchBrand.niuniugame",uipath="ui.classicWatchBrand.niuniugame"}
ui.shop 				= {type=_gm.ID_Win,		id=10016,	clear=false	,path="modules.shop.shop",uipath="ui.shop.shop",backKeytoClose=true}
ui.bag 					= {type=_gm.ID_Win,		id=10017,	clear=false	,path="modules.bag.bag",backKeytoClose=true}
ui.exchange 			= {type=_gm.ID_Win,		id=10018,	clear=false	,path="modules.exchange.exchange",uipath="ui.exchange.exchange",backKeytoClose=true}
ui.activityMain			= {type=_gm.ID_Win,		id=10019,	clear=false	,path="modules.activity.activityMainNew",uipath="ui.activity.activityMain",backKeytoClose=true}
ui.selectHead 			= {type=_gm.ID_Dlg,		id=10021,	clear=true	,path="modules.playerInfo.selectHead",uipath="ui.playerInfo.selectHead",backKeytoClose=true}
ui.selectHeadWay 		= {type=_gm.ID_Dlg,		id=10022,	clear=true	,path="modules.playerInfo.selectHeadWay",uipath="ui.playerInfo.selectHeadWay",backKeytoClose=true}
ui.changePaw 			= {type=_gm.ID_Dlg,		id=10023,	clear=true	,path="modules.playerInfo.changePaw",uipath="ui.playerInfo.changePaw"}
ui.bindMobile 			= {type=_gm.ID_Dlg,		id=10024,	clear=true	,path="modules.playerInfo.bindMobile",uipath="ui.playerInfo.bindMobile"}
ui.settingFrame 		= {type=_gm.ID_Dlg,		id=10025,	clear=true	,path="modules.setting.settingFrame",uipath="ui.setting.mainSetting"}
ui.gameSetting 			= {type=_gm.ID_Dlg,		id=10026,	clear=true	,path="modules.setting.gameSetting",uipath="ui.setting.gameSetting"}
ui.aboutFrame 			= {type=_gm.ID_Dlg,		id=10027,	clear=true	,path="modules.setting.aboutFrame",uipath="ui.setting.about"}
ui.task 				= {type=_gm.ID_Win,		id=10028,	clear=false	,path="modules.task.task",uipath="ui.task.taskMainFrame",backKeytoClose=true}
ui.winStreak 			= {type=_gm.ID_Dlg,		id=10029,	clear=false	,path="modules.playRoom.winStreak",uipath="ui.winStreak.winningStreak"}
ui.charge 				= {type=_gm.ID_Dlg,		id=10030,	clear=true	,path="modules.shop.charge"}
ui.wordstip 			= {type=_gm.ID_Dlg,		id=10031,	clear=true	,path="modules.playRoom.wordstip"}
ui.getVoucher 			= {type=_gm.ID_Dlg,		id=10032,	clear=true	,path="modules.exchange.getVoucher",uipath="ui.exchange.getVoucher"}
ui.mail 				= {type=_gm.ID_Dlg,		id=10033,	clear=true	,path="modules.mail.mail",uipath="ui.mail.mailMainFrame"}
ui.wordstip2 			= {type=_gm.ID_Dlg,		id=10034,	clear=true	,path="modules.playRoom.wordstip2"}
--快速购买
ui.quickBuyGold 		= {type=_gm.ID_Dlg,		id=10035,	clear=true	,path="modules.playRoom.quickBuyGold",backKeytoClose=true}
--ui.paytip 	            = {type=_gm.ID_Dlg,		id=10036,	clear=true	,path="modules.shop.paytip",uipath="ui.shop.shop"}

--斗地主比赛
ui.matchloading 		= {type=_gm.ID_Dlg,		id=11000,	clear=true	,path="modules.matchgame.matchloading",uipath="ui.matchgame.matchloading"}
--ui.matchtypeselect 	= {type=_gm.ID_Win,		id=11001,	clear=true	,path="modules.matchgame.matchtypeselect",uipath="ui.matchgame.matchtypeselect"}
ui.SingUpUI 			= {type=_gm.ID_Dlg,		id=11002,	clear=true	,path="modules.matchgame.SingUpUI",uipath="ui.matchgame.SingUpUI",backKeytoClose=true}
ui.jsswaitpage 			= {type=_gm.ID_Dlg,		id=11003,	clear=true	,path="modules.matchgame.jsswaitpage",uipath="ui.matchgame.jsswaitpage",backKeytoClose=true}
ui.match_game 			= {type=_gm.ID_Win,		id=11005,	clear=true	,path="modules.matchgame.match_game",uipath="ui.matchgame.match_game"}

--好友斗地主
ui.friend_game 			= {type=_gm.ID_Win,		id=12001,	clear=true	,path="modules.Friendsgame.friend_game",uipath="ui.friendsgame.friend_game"}
ui.createFriendRoom 	= {type=_gm.ID_Dlg,		id=12002,	clear=true	,path="modules.Friendsgame.createFriendRoom",uipath="ui.friendsgame.createFriendRoom"}
ui.jiaruroom 			= {type=_gm.ID_Dlg,		id=12003,	clear=true	,path="modules.Friendsgame.jiaruroom",uipath="ui.friendsgame.jiaruroom"}
ui.freindDissolu 		= {type=_gm.ID_Dlg,		id=12004,	clear=false	,path="modules.Friendsgame.freindDissolu",uipath="ui.friendsgame.freindDissolu"}

--看牌抢庄
ui.watchbrand_game 		= {type=_gm.ID_Win,		id=13001,	clear=true	,path="modules.watchbrandgame.watchbrand_game",uipath="ui.watchbrandgame.watchbrand_game"}
ui.bullType 			= {type=_gm.ID_Dlg,		id=13002,	clear=true	,path="modules.watchbrandgame.bullType",uipath="ui.watchbrandgame.bullType"}
ui.fivebox 				= {type=_gm.ID_Dlg,		id=13004,	clear=true	,path="modules.watchbrandgame.fivebox",uipath="ui.watchbrandgame.treasureBox",backKeytoClose=true}

--新增功能
ui.redSquare 			= {type=_gm.ID_Win,		id=14001,	clear=false	,path="modules.hongbao.redSquare",uipath="ui.hongbao.redSquare",backKeytoClose=true}
ui.showMsg 				= {type=_gm.ID_Dlg,		id=14002,	clear=true	,path="modules.hongbao.showMsg",uipath="ui.tips.showMsg",backKeytoClose=true}
ui.redHelp 				= {type=_gm.ID_Dlg,		id=14003,	clear=true	,path="modules.hongbao.redHelp",uipath="ui.hongbao.redHelp",backKeytoClose=true}
ui.rankMain 			= {type=_gm.ID_Win,		id=14004,	clear=false	,path="modules.rank.rankMain",uipath="ui.rank.rankMain",backKeytoClose=true}
ui.rankTips 			= {type=_gm.ID_Dlg,		id=14005,	clear=true	,path="modules.rank.rank_tips",uipath="ui.tips.rank_tips",backKeytoClose=true}
--签到功能
ui.sign 				= {type=_gm.ID_Dlg,		id=14006,	clear=true	,path="modules.activity.sign",uipath="ui.activity.sign",backKeytoClose=true}
--首冲
ui.firstCharge			= {type=_gm.ID_Dlg,		id=14007,	clear=true	,path="modules.shop.firstChargeDlg"}
--百人帮助
ui.hundredHelp 			= {type=_gm.ID_Dlg,		id=14008,	clear=true	,path="modules.hundredniuniu.hundredHelp",backKeytoClose=true}
--百人走势图
ui.winningTrend 		= {type=_gm.ID_Win,		id=14009,	clear=true	,path="modules.hundredniuniu.winningTrend",backKeytoClose=true}
ui.hundredniuniu_game 	= {type=_gm.ID_Win,		id=14030,	clear=true	,path="modules.hundredniuniu.hundredniuniu_game",uipath="ui.hundredniuniu.hundredniuniu_game"}
ui.Jackpot 				= {type=_gm.ID_Dlg,		id=14031,	clear=true	,path="modules.hundredniuniu.Jackpot",uipath="ui.hundredniuniu.Jackpot",backKeytoClose=true}
ui.showPrizeInfo 		= {type=_gm.ID_Dlg,		id=14031,	clear=true	,path="modules.hundredniuniu.showPrizeInfo",uipath="ui.hundredniuniu.showPrizeInfo",backKeytoClose=true}
ui.allPlayerInfo 		= {type=_gm.ID_Dlg,		id=14033,	clear=true	,path="modules.hundredniuniu.allPlayerInfo",uipath="ui.hundredniuniu.allPlayerInfo",backKeytoClose=true}
ui.onthelist 			= {type=_gm.ID_Dlg,		id=14035,	clear=true	,path="modules.hundredniuniu.onthelist",uipath="ui.hundredniuniu.onthelist",backKeytoClose=true}
ui.onthelistHelp 		= {type=_gm.ID_Dlg,		id=14036,	clear=true	,path="modules.hundredniuniu.onthelistHelp",uipath="ui.hundredniuniu.onthelist",backKeytoClose=true}
--聊天
ui.baiRenChat 			= {type=_gm.ID_Dlg,		id=14100,	clear=true	,path="modules.chat.baiRenChat",uipath="ui.hundredniuniu.onthelist",backKeytoClose=true}
--排行
ui.hunRankHelp 			= {type=_gm.ID_Dlg,		id=14101,	clear=true	,path="modules.hundredniuniu.hunRankHelp",backKeytoClose=true}
ui.hunRank 				= {type=_gm.ID_Dlg,		id=14102,	clear=true	,path="modules.hundredniuniu.hunRank",backKeytoClose=true}

--新的斗地主功能
ui.grabredlords_game 	= {type=_gm.ID_Win,		id=17001,	clear=true	,path="modules.grabredlords.grabredlords_game",uipath="ui.grabredlords_game.grabredlords_game"}
ui.grabredlordsHelp 	= {type=_gm.ID_Dlg,		id=17002,	clear=true	,path="modules.grabredlords.grabredlordsHelp",backKeytoClose=true}
--游戏现金红包兑换
-- ui.cashredExc 			= {type=_gm.ID_Win,		id=17100,	clear=false	,path="modules.cashredExc.cashredExc",uipath="ui.cashredExc.cashredExcTitle",backKeytoClose=true}
ui.cashredExc 			= {type=_gm.ID_Win,		id=17100,	clear=true	,path="modules.cashredExc.cashredCenter",uipath="ui.cashredExc.cashredCenter",backKeytoClose=true}

ui.noRedMoney 			= {type=_gm.ID_Dlg,		id=17101,	clear=true	,path="modules.cashredExc.noRedMoney",uipath="ui.cashredExc.noRedMoney",backKeytoClose=true}
ui.noMenpiaoRevive 		= {type=_gm.ID_Dlg,		id=17102,	clear=true	,path="modules.cashredExc.noMenpiaoRevive",uipath="ui.cashredExc.noMenpiaoRevive",backKeytoClose=true}
ui.hongbaoActivity 		= {type=_gm.ID_Dlg,		id=17103,	clear=true	,path="modules.activity.hongbaoActivity",uipath="ui.activity.hongbaoActivity",backKeytoClose=true}
ui.hongbaoActivityHelp 	= {type=_gm.ID_Dlg,		id=17104,	clear=true	,path="modules.activity.hongbaoActivityHelp",uipath="ui.activity.hongbaoActivityHelp",backKeytoClose=true}
ui.BindPhoneTip 		= {type=_gm.ID_Dlg,		id=17105,	clear=true	,path="modules.activity.BindPhoneTip",backKeytoClose=true}

--水果机
ui.fruits_game 			= {type=_gm.ID_Win,		id=16030,	clear=true	,path="script.layer.fruits.FruitsMainLayer",backKeytoClose=true}
ui.showMoreDlg			= {type=_gm.ID_Dlg,		id=16031,	clear=true	,path="script.layer.fruits.ShowMoreDlg",backKeytoClose=true}
ui.fruitsHelp 			= {type=_gm.ID_Dlg,		id=16032,	clear=true	,path="script.layer.fruits.FruitsHelpDlg",backKeytoClose=true}
ui.fruitsJackpot 		= {type=_gm.ID_Dlg,		id=16033,	clear=true	,path="script.layer.fruits.JackpotDlg",backKeytoClose=true}

--新增微信分享
ui.weChatshare 			= {type=_gm.ID_Dlg,		id=16035,	clear=true	,path="modules.activity.weChatshare",backKeytoClose=true}
ui.campaign 			= {type=_gm.ID_Dlg,		id=16036,	clear=true	,path="modules.activity.campaign",backKeytoClose=true}
ui.lottery  			= {type=_gm.ID_Dlg,		id=16037,	clear=false	,path="modules.lottery.lottery",backKeytoClose=true}
ui.oneLotteryReward  	= {type=_gm.ID_Dlg,		id=16038,	clear=true	,path="modules.lottery.oneLotteryReward",backKeytoClose=true}
ui.tenLotteryReward  	= {type=_gm.ID_Dlg,		id=16039,	clear=true	,path="modules.lottery.tenLotteryReward",backKeytoClose=true}
ui.goldDraw 			= {type=_gm.ID_Dlg,		id=16040,	clear=true	,path="modules.goldDraw.goldDraw",backKeytoClose=true}
ui.loginWelfare 		= {type=_gm.ID_Dlg,		id=16051,	clear=true	,path="modules.loginWelfare.loginWelfare",backKeytoClose=true}
ui.lotteryCharge  		= {type=_gm.ID_Dlg,		id=16042,	clear=false	,path="modules.activity.lotteryCharge",backKeytoClose=true}
ui.fiveReward  	        = {type=_gm.ID_Dlg,		id=16043,	clear=true	,path="modules.lottery.fiveReward",backKeytoClose=true}
ui.lotteryDiamond  		= {type=_gm.ID_Dlg,		id=16044,	clear=true	,path="modules.activity.lotteryDiamond",backKeytoClose=true}
ui.resurreMole 			= {type=_gm.ID_Win,		id=16045,	clear=false	,path="modules.cashredExc.resurreMoleDlg",backKeytoClose=true}
ui.identityCards 		= {type=_gm.ID_Dlg,		id=16046,	clear=false	,path="modules.shop.identityCards",backKeytoClose=true}
--招财进宝
ui.fortune 				= {type=_gm.ID_Dlg,		id=16041,	clear=true	,path="modules.fortune.fortune",backKeytoClose=true}
--疯狂双十
ui.crazyGame 			= {type=_gm.ID_Win,		id=17200,	clear=true	,path="modules.crazyGame.crazyGame"}
ui.crazyGameFriend 		= {type=_gm.ID_Win,		id=17210,	clear=true	,path="modules.crazyGame.crazyGameFriend"}
ui.crazySelect 			= {type=_gm.ID_Dlg,		id=17201,	clear=true	,path="modules.crazyGame.crazySelect",backKeytoClose=true}
ui.jiaruroomCrazy 		= {type=_gm.ID_Dlg,		id=17202,	clear=true	,path="modules.crazyGame.jiaruroomCrazy",backKeytoClose=true}
ui.crazyNoCardTip 		= {type=_gm.ID_Dlg,		id=17203,	clear=true	,path="modules.crazyGame.crazyNoCardTip",backKeytoClose=true}
--公用游戏页面
ui.userInfo 			= {type=_gm.ID_Dlg,		id=18000,	clear=true	,path="modules.commonGame.userInformation",backKeytoClose=true}
ui.gameChat 			= {type=_gm.ID_Dlg,		id=18001,	clear=true	,path="modules.commonGame.gameChat",backKeytoClose=true}
ui.gameHelp 			= {type=_gm.ID_Dlg,		id=18002,	clear=true	,path="modules.commonGame.gameHelp",backKeytoClose=true}
ui.gameSet 				= {type=_gm.ID_Dlg,		id=18003,	clear=true	,path="modules.commonGame.gameSetting",backKeytoClose=true}
ui.gameTask 			= {type=_gm.ID_Dlg,		id=18004,	clear=true	,path="modules.commonGame.gameTask",backKeytoClose=true}
ui.showGameTip 			= {type=_gm.ID_Dlg,		id=18005,	clear=true	,path="modules.commonGame.showGameTip",backKeytoClose=true}
ui.gameBoxTask 			= {type=_gm.ID_Dlg,		id=18004,	clear=true	,path="modules.commonGame.gameBoxTask",backKeytoClose=true}
--分享
ui.shareMain 			= {type=_gm.ID_Win,		id=19001,	clear=true	,path="modules.share.shareMain",backKeytoClose=true}