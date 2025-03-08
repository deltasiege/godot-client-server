extends Node

func _ready():
	ClientMgr.connect_to_server(self)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST: ClientMgr.disconnect_from_server(self)
