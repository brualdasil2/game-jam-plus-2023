extends Node2D

@export var MOUSE_SPEED = 10
@onready var marker = $Marker2D
@onready var shape = $Marker2D/MouseCage/CollisionShape2D
var prev_mouse_pos : Vector2 = Vector2.ZERO
var tpd : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	center_mouse()
	prev_mouse_pos = get_global_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if tpd:
		prev_mouse_pos = get_global_mouse_position()
		tpd = false
		return
	var mouse_pos : Vector2 = get_global_mouse_position()
	print_debug("MPOS: " + str(mouse_pos))
	print_debug("PREV_MPOS: " + str(prev_mouse_pos))
	var velocity : Vector2 = mouse_pos - prev_mouse_pos
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
		center_mouse()
		
func center_mouse():
	Input.warp_mouse(get_viewport_rect().size / 2)

func _on_mouse_cage_mouse_shape_exited(shape_idx):
	prev_mouse_pos = get_viewport_rect().size/2
	center_mouse()
	tpd = true
	print_debug("TPCENTER")
	
func is_mouse_in_shape():
	var mouse_pos = get_global_mouse_position()
	#shape.
