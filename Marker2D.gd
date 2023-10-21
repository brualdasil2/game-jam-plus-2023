extends Marker2D

@export var MOUSE_SPEED = 10050
@export var MOUSE_ACCEL = 1000
@export var MOUSE_FRICTION = 1000
@onready var rayleft = $pontoesq/RayCast2D
@onready var rayright = $pontodir/RayCast2D
@onready var mousecage = $MouseCage

const MOVING_TRESHOLD = 0.1

var prev_mouse_pos : Vector2 = Vector2.ZERO
var tpd : bool = false
var velocity : Vector2 = Vector2.ZERO

var curr_area

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
		mouse_direction = mouse_direction.normalized()
		velocity += MOUSE_ACCEL * delta * mouse_direction
		if velocity.length() > MOUSE_SPEED:
			velocity = velocity.normalized() * MOUSE_SPEED
	else:
		var op_dir : Vector2 = velocity.normalized() * -1
		velocity += MOUSE_FRICTION * delta * op_dir
	global_position += velocity * delta
	pos_tests()
	prev_mouse_pos = mouse_pos
		

		

func center_mouse():
	Input.warp_mouse(get_viewport_rect().size / 2)
	tpd = true

func get_mouse_pos() -> Vector2:
	return get_local_mouse_position()

func pos_tests():
	var mouse_pos = get_mouse_pos()
	if mouse_pos.length()> 100:
		center_mouse()

func _on_mouse_cage_mouse_shape_exited(shape_idx):
	prev_mouse_pos = get_viewport_rect().size/2
	center_mouse()
	tpd = true





func _on_crosshair_area_area_entered(area):
	if not (area is ObjectArea):
		return
	curr_area = area
	var parent = area.get_parent()
	print_debug(parent.mission_id)


func _on_crosshair_area_area_exited(area):
	curr_area = 0
