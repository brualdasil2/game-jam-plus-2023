extends Node2D

@export var MOUSE_SPEED = 3
@onready var marker = $Marker2D
var prev_mouse_pos : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	Input.warp_mouse(get_viewport_rect().size/2)
	prev_mouse_pos = get_global_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var mouse_pos : Vector2 = get_global_mouse_position()
	print_debug("MPOS: " + str(mouse_pos))
	var velocity : Vector2 = prev_mouse_pos - mouse_pos
	print_debug(velocity)
	marker.global_position += velocity * delta * MOUSE_SPEED
	prev_mouse_pos = mouse_pos

func _input(event):
	return
	if event is InputEventMouseMotion:
		var velocity : Vector2 = event.velocity
		velocity = velocity / 100
		print_debug(velocity)
		marker.global_position += velocity * MOUSE_SPEED
		Input.warp_mouse(get_viewport_rect().size/2)
		


func _on_mouse_cage_mouse_shape_exited(shape_idx):
	prev_mouse_pos = get_viewport_rect().size/2
	Input.warp_mouse(get_viewport_rect().size/2)
	
