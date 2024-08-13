class_name ESCTween
extends Node


signal tween_all_completed
signal tween_completed(object: Object, key: NodePath)
signal twwen_started(object: Object, key: NodePath)
signal tween_step(object: Object, key: NodePath, elapsed: float, value: Object)


enum TweenProcessMode {
	TWEEN_PROCESS_PHYSICS = 0,
	TWEEN_PROCESS_IDLE = 1
}


var playback_process_mode: TweenProcessMode = TweenProcessMode.TWEEN_PROCESS_IDLE
var playback_speed: float = 1.0
var repeat: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called every physics step. 'delta' is the elapsed time since the previous physics step.
func _physics_process(delta):
	pass


func follow_method(
		object: Object, method: String, initial_val: Variant, target: Object,
		target_method: String, duration: float,
		trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
		ease_type: Tween.EaseType = Tween.EaseType.EASE_IN_OUT,
		delay: float = 0.0) -> bool:
	return true


func follow_property(
		object: Object, property: NodePath, initial_val: Variant,
		target: Object, target_property: NodePath, duration: float,
		trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
		ease_type: Tween.EaseType = Tween.EaseType.EASE_IN_OUT,
		delay: float = 0.0) -> bool:
	return true


func get_runtime() -> float:
	return 0.0


func interpolate_callback(
		object: Object, duration: float, callback: String,
		arg1: Variant = null, arg2: Variant = null, arg3: Variant = null,
		arg4: Variant = null, arg5: Variant = null, arg6: Variant = null,
		arg7: Variant = null, arg8: Variant = null) -> bool:
	return true


func interpolate_deferred_callback(
		object: Object, duration: float, callback: String,
		arg1: Variant = null, arg2: Variant = null, arg3: Variant = null,
		arg4: Variant = null, arg5: Variant = null, arg6: Variant = null,
		arg7: Variant = null, arg8: Variant = null) -> bool:
	return true


func interpolate_method(
		object: Object, method: String, initial_val: Variant,
		final_val: Variant, duration: float,
		trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
		ease_type: Tween.EaseType = Tween.EaseType.EASE_IN_OUT,
		delay: float = 0.0) -> bool:
	return true


func interpolate_property(
		object: Object, property: NodePath, initial_val: Variant,
		final_val: Variant, duration: float,
		trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
		ease_type: Tween.EaseType = Tween.EaseType.EASE_IN_OUT,
		delay: float = 0.0) -> bool:
	object.set_indexed(property, final_val) # fixme
	emit_signal("tween_completed", object, property)
	emit_signal("tween_all_completed")
	return true


func is_active() -> bool:
	return false


func remove(object: Object, key:String = "") -> bool:
	return true


func remove_all() -> bool:
	return true


func reset(object: Object, key:String = "") -> bool:
	return true


func reset_all() -> bool:
	return true


func resume(object: Object, key:String = "") -> bool:
	return true


func resume_all() -> bool:
	return true


func seek(time: float) -> bool:
	return true


func set_active(active: bool) -> void:
	pass


func start() -> bool:
	return true


func stop(object: Object, key:String = "") -> bool:
	return true


func stop_all() -> bool:
	return true


func targeting_method(
		object: Object, method: String, initial: Object, initial_method: String,
		final_val: Variant, duration: float,
		trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
		ease_type: Tween.EaseType = Tween.EaseType.EASE_IN_OUT,
		delay: float = 0.0) -> bool:
	return true


func targeting_property(
		object: Object, property: NodePath, inital: Object,
		initial_val: NodePath, final_val: Variant, duration: float,
		trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
		ease_type: Tween.EaseType = Tween.EaseType.EASE_IN_OUT,
		delay: float = 0.0) -> bool:
	return true


func tell() -> float:
	return 0.0
