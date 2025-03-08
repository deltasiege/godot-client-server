class_name Logger

const PREFIX = "[]: "
const LOG_FILE_DIR = "sync_logs"
const LOG_FILE_ENABLED := true

static func debug(msg: String):
	print(PREFIX, msg)

static func info(msg: String):
	print(PREFIX, msg)

static func warn(msg: String):
	push_warning(PREFIX, msg)

static func error(msg: String):
	push_error(PREFIX, msg)

static func start_sync_logging():
	if !LOG_FILE_ENABLED: return
	var dir = DirAccess.open("user://")
	if not dir.dir_exists(LOG_FILE_DIR): dir.make_dir(LOG_FILE_DIR)
	
	var dt = Time.get_datetime_string_from_system(true).replace(":", "_")
	var file_name = dt + ".log"
	
	SyncManager.start_logging("user://" + LOG_FILE_DIR + "/" + file_name)

static func stop_sync_logging():
	if !LOG_FILE_ENABLED: return
	SyncManager.stop_logging()
