class_name ServerMgr

const DEFAULT_PORT = 18346
const MAX_CLIENTS = 64

static func start(root: Node):
	Logger.debug("Starting server")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	root.multiplayer.multiplayer_peer = peer
	root.multiplayer.peer_connected.connect(_on_client_connected)
	root.multiplayer.peer_disconnected.connect(_on_client_disconnected)
	SyncManager.sync_started.connect(_on_sync_started)
	SyncManager.sync_stopped.connect(_on_sync_stopped)

static func stop(root: Node):
	Logger.debug("Stopping server")
	SyncManager.stop()
	SyncManager.clear_peers()
	root.multiplayer.multiplayer_peer.close()
	root.multiplayer.multiplayer_peer = null
	root.multiplayer.peer_connected.disconnect(_on_client_connected)
	root.multiplayer.peer_disconnected.disconnect(_on_client_disconnected)
	SyncManager.sync_started.disconnect(_on_sync_started)
	SyncManager.sync_stopped.disconnect(_on_sync_stopped)

static func start_sync_manager():
	Logger.info("Starting SyncManager")
	await Engine.get_main_loop().create_timer(2.0).timeout
	SyncManager.start()

static func _on_client_connected(id: int):
	Logger.info("Client '" + str(id) + "' connected")
	SyncManager.add_peer(id)

static func _on_client_disconnected(id: int):
	Logger.info("Client '" + str(id) + "' disconnected")
	SyncManager.remove_peer(id)

static func _on_sync_started():
	Logger.start_sync_logging()

static func _on_sync_stopped():
	Logger.stop_sync_logging()
