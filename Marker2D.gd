extends Marker2D

@export var MOUSE_SPEED = 150
@export var MOUSE_ACCEL = 200
@export var MOUSE_FRICTION = 100

const MOVING_TRESHOLD = 0.1

var prev_mouse_pos : Vector2 = Vector2.ZERO
var tpd : bool = false
var velocity : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	center_mouse()
	prev_mouse_pos = get_mouse_pos()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if tpd:
		prev_mouse_pos = get_mouse_pos()
		tpd = false
		return
	var mouse_pos : Vector2 = get_mouse_pos()
	var mouse_direction : Vector2 = mouse_pos - prev_mouse_pos
	if mouse_direction.length() > MOVING_TRESHOLD:
		print_debug("MOVING" + str(mouse_direction))
		print_debug("MPOS" + str(mouse_pos))
		print_debug("MPREV" + str(prev_mouse_pos))
		mouse_direction = mouse_direction.normalized()
		velocity += MOUSE_ACCEL * delta * mouse_direction
		if velocity.length() > MOUSE_SPEED:
			velocity = velocity.normalized() * MOUSE_SPEED
	else:
		var op_dir : Vector2 = velocity.normalized() * -1
		velocity += MOUSE_FRICTION * delta * op_dir
	global_position += velocity * delta
	prev_mouse_pos = mouse_pos
		
func center_mouse():
	Input.warp_mouse(get_viewport_rect().size / 2)

func get_mouse_pos() -> Vector2:
	return get_local_mouse_position()


func _on_mouse_cage_mouse_shape_exited(shape_idx):
	prev_mouse_pos = get_viewport_rect().size/2
	center_mouse()
	tpd = true
	print_debug("TPCENTER")


