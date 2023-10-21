extends Sprite2D

@export var WALK_SPEED : float = 50.0

enum State {STANDING, WALKING, PRAYING, ON_TELESCOPE}
var state : State = State.STANDING

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func walk_to(x_pos):
	global_position = global_position.move_toward(Vector2(x_pos, global_position.y), WALK_SPEED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
