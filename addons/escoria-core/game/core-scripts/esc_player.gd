@tool
# A playable character
@icon("res://addons/escoria-core/design/esc_player.svg")
class_name ESCPlayer
extends ESCItem




# Whether the player can be selected like an item
@export var selectable: bool = false


# A player is always movable
func _init():
	is_movable = true
	_force_registration = true


# Ready function
func _ready():
	super._ready()
	if selectable:
		super._ready()
	else:
		tooltip_name = ""
