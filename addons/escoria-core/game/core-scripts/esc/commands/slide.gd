# `slide object target [speed]`
#
# Moves `object` towards the position of `target`. This command is
# non-blocking.
#
# - *object*: Global ID of the object to move
# - *target*: Global ID of the target object
# - *speed*: The speed at which to slide in pixels per second (will default to
#   the speed configured on the `object`)
#
# **Warning** This command does not respect the room's navigation polygons, so
# `object` can be moved even when outside walkable areas.
#
# @ESC
extends ESCBaseCommand
class_name SlideCommand


# A hash of tweens currently active for animated items
var _tweens: Dictionary


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		2,
		[TYPE_STRING, TYPE_STRING, TYPE_INT],
		[null, null, -1]
	)


# Validate whether the given arguments match the command descriptor
func validate(arguments: Array):
	if not super.validate(arguments):
		return false

	if not escoria.object_manager.has(arguments[0]):
		raise_error(
			self,
			"Invalid first object. Object with global id '%s' not found." % arguments[0]
		)
		return false
	if not escoria.object_manager.has(arguments[1]):
		raise_error(
			self,
			"Invalid second object. Object with global id '%s' not found." % arguments[1]
		)
		return false
	return true


# Slide the object by generating a tween
#
# #### Parameters
#
# - *source*: The item to slide
# - *destination*: The destination item to slide to
# - *speed*: The speed at which to slide in pixels per second (will default to
#   the speed configured on the `object`)
#
# **Returns** The generated (and started) tween
func _slide_object(
	source: ESCObject,
	destination: ESCObject,
	speed: int = -1
) -> Tween3:
	if speed == -1:
		speed = source.node.speed
	var tween: Tween3
	if _tweens.has(source.global_id):
		tween = (_tweens.get(source.global_id) as Tween3)
		tween.stop_all()
	else:
		tween = Tween3.new(source.node)
		tween.finished.connect(_on_tween_completed)

	var duration = source.node.position.distance_to(
		destination.node.position
	) / speed

	tween.interpolate_property(
		source.node,
		"global_position",
		source.node.global_position,
		destination.node.global_position,
		duration
	)

	tween.play()
	_tweens[source.global_id] = tween
	return tween



# Run the command
func run(command_params: Array) -> int:
	_slide_object(
		escoria.object_manager.get_object(command_params[0]),
		escoria.object_manager.get_object(command_params[1]),
		command_params[2]
	)
	return ESCExecution.RC_OK


# Function called when the command is interrupted.
func interrupt():
	for tween in _tweens:
		tween.stop_all()


func _on_tween_completed(tween: Tween, _key: NodePath):
	if tween:
		tween.queue_free()
