-- ID                               int                              场类型ID
-- name                             string                           看牌抢庄场次名称
-- num2                             int                              底分
-- gold1                            int                              进入需要的金币数量下限
-- gold2                            int                              进入需要的金币数量上限,0为无上限
-- num1                             int                              佣金，每场系统收取金币
-- num3                             int                              AI选牌收取费用
-- Price1                           int                              第1次换牌需要的钻石数
-- Price2                           int                              第2次换牌需要的钻石数
-- Price3                           int                              第3次换牌需要的钻石数

return {
	[1] = {
		name = "新手场",
		num2 = 100,
		gold1 = 2000,
		gold2 = 50000,
		num1 = 360,
		num3 = 0,
		boxNum = 5,
		getNumber = 15,
		rewardID1 = 6,
		rewardnum1 = 1,
		rewardID2 = 1,
		rewardnum2 = 888,
	},
	[2] = {
		name = "中级场",
		num2 = 400,
		gold1 = 10000,
		gold2 = 150000,
		num1 = 1200,
		num3 = 0,
		boxNum = 5,
		getNumber = 20,
		rewardID1 = 6,
		rewardnum1 = 2,
		rewardID2 = 1,
		rewardnum2 = 3888,
	},
	[3] = {
		name = "高级场",
		num2 = 1500,
		gold1 = 80000,
		gold2 = 0,
		num1 = 4000,
		num3 = 0,
		boxNum = 5,
		getNumber = 30,
		rewardID1 = 6,
		rewardnum1 = 3,
		rewardID2 = 1,
		rewardnum2 = 12888,
	},
	[4] = {
		name = "大师场",
		num2 = 5000,
		gold1 = 300000,
		gold2 = 0,
		num1 = 15000,
		num3 = 0,
		boxNum = 5,
		getNumber = 30,
		rewardID1 = 6,
		rewardnum1 = 3,
		rewardID2 = 1,
		rewardnum2 = 12888,
	},
}
