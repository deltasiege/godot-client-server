class_name ClientMgr

const DEFAULT_IP_ADDRESS = "127.0.0.1"
const DEFAULT_PORT = 18346

static func connect_to_server(root: Node, ip: String = DEFAULT_IP_ADDRESS, port: int = DEFAULT_PORT):
	Logger.debug("Connecting to server: " + str(ip) + ":" + str(port))
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	root.multiplayer.multiplayer_peer = peer
	root.multiplayer.peer_connected.connect(_on_peer_connected)
	root.multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	root.multiplayer.connected_to_server.connect(_on_connected_to_server)
	root.multiplayer.connection_failed.connect(_on_connection_failed)
	root.multiplayer.server_disconnected.connect(_on_server_disconnected)
	SyncManager.sync_lost.connect(_on_sync_lost)
	SyncManager.sync_regained.connect(_on_sync_regained)
	SyncManager.sync_error.connect(_on_sync_error)
	SyncManager.sync_started.connect(_on_sync_started)
	SyncManager.sync_stopped.connect(_on_sync_stopped)

static func disconnect_from_server(root: Node):
	Logger.debug("Disconnecting from server")
	SyncManager.stop()
	SyncManager.clear_peers()
	root.multiplayer.multiplayer_peer.close()
	root.multiplayer.multiplayer_peer = null
	root.multiplayer.peer_connected.disconnect(_on_peer_connected)
	root.multiplayer.peer_disconnected.disconnect(_on_peer_disconnected)
	root.multiplayer.connected_to_server.disconnect(_on_connected_to_server)
	root.multiplayer.connection_failed.disconnect(_on_connection_failed)
	root.multiplayer.server_disconnected.disconnect(_on_server_disconnected)
	SyncManager.sync_lost.disconnect(_on_sync_lost)
	SyncManager.sync_regained.disconnect(_on_sync_regained)
	SyncManager.sync_error.disconnect(_on_sync_error)
	SyncManager.sync_started.disconnect(_on_sync_started)
	SyncManager.sync_stopped.disconnect(_on_sync_stopped)

static func _on_peer_connected(id: int):
	Logger.info("Peer '" + str(id) + "' connected")
	SyncManager.add_peer(id)

static func _on_peer_disconnected(id: int):
	Logger.info("Peer '" + str(id) + "' disconnected")
	SyncManager.remove_peer(id)

static func _on_connected_to_server():
	Logger.info("Successfully connected to server")

static func _on_connection_failed():
	Logger.error("Connection failed")
	
static func _on_server_disconnected():
	Logger.info("Server disconnected")

static func _on_sync_lost():
	Logger.info("Sync lost")

static func _on_sync_regained():
	Logger.info("Sync regained")

static func _on_sync_error(error: String):
	Logger.error("Fatal sync error " + str(error))

static func _on_sync_started():
	Logger.start_sync_logging()

static func _on_sync_stopped():
	Logger.stop_sync_logging()
