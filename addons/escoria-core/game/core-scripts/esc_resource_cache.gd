# A cache for resources
extends Node
class_name ESCResourceCache


signal resource_loading_progress(path, progress)
signal resource_loading_done(path)
signal resource_queue_progress(queue_size)


var queue: Array = []
var pending: Dictionary = {}


func queue_resource(path: String, p_in_front: bool = false, p_permanent: bool = false):
	if path in pending:
		return

	elif ResourceLoader.has_cached(path):
		var res = ResourceLoader.load(path)
		pending[path] = ESCResourceDescriptor.new(res, p_permanent)
	else:
		var err = ResourceLoader.load_threaded_request(path)
		if p_in_front:
			queue.insert(0, path)
		else:
			queue.push_back(path)
		pending[path] = ESCResourceDescriptor.new(null, p_permanent)


func cancel_resource(path):
	if path in pending:
		if pending[path].res is Resource:
			queue.erase(pending[path].res)
		pending.erase(path)


func clear():
	for p in pending.keys():
		if pending[p].permanent:
			continue
		cancel_resource(p)
	#queue = []
	#pending = {}


func get_progress(path):
	var ret = -1
	if path in pending:
		if !(pending[path].res is Resource):
			var progress = [0.0]
			var status = ResourceLoader.load_threaded_get_status(path, progress)
			ret = progress[0]
		else:
			ret = 1.0
			emit_signal("resource_loading_done", path)
	emit_signal("resource_loading_progress", path, ret)

	return ret


func is_ready(path):
	var ret

	if path in pending:
		ret = pending[path].res is Resource
	else:
		ret = false

	return ret


func _wait_for_resource(path):
	while true:
		#VisualServer.call("sync") # workaround because sync is a keyword
		RenderingServer.force_sync()
		OS.delay_usec(16000) # wait 1 frame

		if queue.size() == 0 || queue[0] != path:
			return pending[path].res


func get_resource(path):
	if path in pending:
		if !(pending[path].res is Resource):
			if path != queue[0]:
				var pos = queue.find(path)
				queue.remove_at(pos)
				queue.insert(0, path)

			var res = _wait_for_resource(path)

			if !pending[path].permanent:
				pending.erase(path)

			return res

		else:
			var res = pending[path].res
			if !pending[path].permanent:
				pending.erase(path)

			return res
	else:
		# We can't use ESCProjectSettingsManager here since this method
		# can be called from escoria._init()
		if not ProjectSettings.get_setting("escoria/platform/skip_cache"):
			var res = ResourceLoader.load(path)
			pending[path] = ESCResourceDescriptor.new(res, true)
			return res
		return ResourceLoader.load(path)


func print_progress(p_path, p_progress):
	printt(p_path, "loading", round(p_progress * 100), "%")


func res_loaded(p_path):
	printt("loaded resource", p_path)


func print_queue_progress(p_queue_size):
	printt("queue size:", p_queue_size)


func start():
	pass
	## Uncomment these for debug, or wait for someone to implement log levels
	# connect("resource_loading_progress", self, "print_progress")
	# connect("resource_loading_done", self, "res_loaded")
	# connect("resource_queue_progress", self, "print_queue_progress")


func _process(_delta) -> void:
	while queue.size() > 0:
		var path = queue[0]

		var ret = ResourceLoader.load_threaded_get_status(path)

		if ret != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			printt("finished loading ", path)
			if path in pending: # else it was already retrieved
				pending[path].res = ResourceLoader.load_threaded_get(path)

			queue.erase(path) # something might have been put at the front of the queue while we polled, so use erase instead of remove
			emit_signal("resource_queue_progress", queue.size())
