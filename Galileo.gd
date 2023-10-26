extends Sprite2D
class_name Galileo

@export var WALK_SPEED : float = 125.0

@onready var anim = $AnimationPlayer

var state = "standing"
var target_x = 0.0
var frozen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.speed_scale = 0.5

func walk_to_target(delta):
	if frozen:
		return
	if target_x > global_position.x:
		flip_h = true
	else:
		flip_h = false
	global_position = global_position.move_toward(Vector2(target_x, global_position.y), WALK_SPEED*delta)

func is_on_target():
	return global_position.x == target_x

func play_animations():
	if frozen:
		anim.play("stand")
	elif state == "standing":
		anim.play("stand")
	elif state in ["walking_to_reza", "walking_to_scope", "walking_to_notebook"]:
		anim.play("walk")
	elif state == "praying":
		anim.play("pray")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_animations()
