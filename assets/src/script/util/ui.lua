ui=class("ui")
--type:页面类型  id:唯一标识  clear:关闭后是否删除(只有ID_Win 有效)  path:页面地址  backKeytoClose:返回键关闭窗口
ui.Login 				= {type=_gm.ID_Main,	id=10001,	clear=false	,path="modules.login.Login",uipath="ui.login.Login"}
ui.update 				= {type=_gm.ID_Dlg,		id=10002,	clear=true	,path="modules.login.update",uipath="ui.login.update",backKeytoClose=false}
ui.inGameUpdate 		= {type=_gm.ID_Dlg,		id=10002,	clear=true	,path="modules.login.inGameUpdate",uipath="ui.login.update",backKeytoClose=false}
ui.selAccount 			= {type=_gm.ID_Dlg,		id=10003,	clear=true	,path="modules.login.selAccount",uipath="ui.login.selAccount"}
