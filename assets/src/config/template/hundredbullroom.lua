-- ID                               int                              场类型ID
--iRoomLevel                        int                              房间等级
-- name                             string                           场次名称
-- num2                             int                              底分
-- gold1                            int                              进入需要的金币数量下限
-- gold2                            int                              进入需要的金币数量上限,0为无上限
-- num1                             int                              佣金，每场系统收取金币
-- num3                             int                              AI选牌收取费用

return {
	[1] = {
		iRoomLevel = 2,
		name = "初级场",
		num2 = 100,
		gold1 = 2000,
		gold2 = 0,
		num1 = 20000,
		num3 = 300000,
	},
	[2] = {
		iRoomLevel = 3,
		name = "中级场",
		num2 = 400,
		gold1 = 8000,
		gold2 = 0,
		num1 = 50000,
		num3 = 1000000,
	},
	[3] = {
		iRoomLevel = 4,
		name = "高级场",
		num2 = 1500,
		gold1 = 20000,
		gold2 = 0,
		num1 = 100000,
		num3 = 5000000,
	},
}
