-- ID                               int                              场类型ID
--type                              int                              房间类型
-- name                             string                           场次名称
-- goldmin                          int                              准入金币下限
-- goldmax                          int                              准入金币上限,0为无上限
-- num1                             int                              台费
-- num2                             int                              底注


return {
	[2] = {
		type = 1,
		level = 2,
		name = "初级场",
		gold1 = 1000,
		gold2 = 80000,
		num1 = 250,
		num2 = 50,
		picture = "chujichang.png",
		boxNum = 2,
		getNumber = 15,
		rewardID1 = 6,
		rewardnum1 = 1,
		rewardID2 = 1,
		rewardnum2 = 666,
	},
	[3] = {
		type = 1,
		level = 3,
		name = "中级场",
		gold1 = 5000,
		gold2 = 150000,
		num1 = 800,
		num2 = 200,
		picture = "zhongjichang.png",
		boxNum = 2,
		getNumber = 15,
		rewardID1 = 6,
		rewardnum1 = 2,
		rewardID2 = 1,
		rewardnum2 = 1666,
	},
	[4] = {
		type = 1,
		level = 4,
		name = "高级场",
		gold1 = 20000,
		gold2 = 0,
		num1 = 2000,
		num2 = 1000,
		picture = "gaojichang.png",
		boxNum = 3,
		getNumber = 15,
		rewardID1 = 6,
		rewardnum1 = 3,
		rewardID2 = 1,
		rewardnum2 = 3666,
	},
	[5] = {
		type = 2,
		level = 5,
		name = "豪华场",
		gold1 = 1000,
		gold2 = 0,
		num1 = 500,
		num2 = 60,
		picture = "haohuachang.png",
	},
	[6] = {
		type = 2,
		level = 6,
		name = "至尊场",
		gold1 = 10000,
		gold2 = 0,
		num1 = 1500,
		num2 = 600,
		picture = "zhizhunchang.png",
	},
	[7] = {
		type = 2,
		level = 7,
		name = "王者场",
		gold1 = 100000,
		gold2 = 0,
		num1 = 6000,
		num2 = 6000,
		picture = "wangzhechang.png",
	},
}
