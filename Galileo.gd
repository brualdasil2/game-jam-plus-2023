extends Sprite2D
class_name Galileo

@export var WALK_SPEED : float = 150.0

var state = "standing"
var target_x = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func walk_to_target(delta):
	if target_x > global_position.x:
		flip_h = true
	else:
		flip_h = false
	global_position = global_position.move_toward(Vector2(target_x, global_position.y), WALK_SPEED*delta)

func is_on_target():
	return global_position.x == target_x

func play_animations():
	match state:
		"standing":
			#print_debug("STANDING")
			pass
		"walking":
			#print_debug("WALKING")
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_animations()
