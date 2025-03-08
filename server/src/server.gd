extends Node

const EXPECTED_CLIENTS = 2
var clients = 0
var game_started = false

@export var player1: Node3D
@export var player2: Node3D

func _ready():
	ServerMgr.start(self)
	SyncManager.connect("peer_added", on_peer_added)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST: ServerMgr.stop(self)

func on_peer_added(_peer_id):
	clients += 1
	if clients == EXPECTED_CLIENTS:
		start_game()

func start_game():
	if game_started: return
	game_started = true
	print("Starting game...")
	var players = [player1, player2]
	var table = {}
	var peer_ids = SyncManager.peers.keys()
	for idx in peer_ids.size():
		var peer_id = peer_ids[idx]
		table[idx + 1] = peer_id
		players[idx].set_multiplayer_authority(peer_id)
	RPC.receive_player_ids.rpc(table)
	ServerMgr.start_sync_manager()
	
