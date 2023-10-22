extends CharacterBody2D

@export var MOUSE_SPEED = 10050
@export var MOUSE_ACCEL = 1000
@export var MOUSE_FRICTION = 1000

@export var FIND_TIME = 2.0

@onready var rayleft = $pontoesq/RayCast2D
@onready var rayright = $pontodir/RayCast2D
@onready var mousecage = $MouseCage
@onready var charge_progress = $Node2D/TextureProgressBar

const MOVING_TRESHOLD = 0.1

var prev_mouse_pos : Vector2 = Vector2.ZERO
var tpd : bool = false
var find_charge = 0.0
var charge_blocked = false

var curr_area : ScopeObject

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	center_mouse()
	prev_mouse_pos = get_mouse_pos()
	if ScopeState.initialized:
		global_position = ScopeState.scope_position


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
	move_and_slide()
	pos_tests()
	prev_mouse_pos = mouse_pos

func save_state():
	ScopeState.scope_position = global_position
	ScopeState.initialized = true

func go_to_house(cause):
	save_state()
	if cause == "priest":
		OutPriestState.priest_entering = true
	get_parent().get_parent().load_house()
	#get_tree().change_scene_to_file("res://House.tscn")
	
	
func reset_charge():
	find_charge = 0.0
	charge_blocked = true
	
func charge_find(delta):
	if charge_blocked:
		return
	find_charge += delta
	if find_charge <= FIND_TIME:
		return
	if curr_area == null:
		print_debug("ERROR! No planet found")
		reset_charge()
		return
	# TODO: test curr round
	var mission_id = curr_area.mission_id
	var mission_round = curr_area.round
	var mission_rounds_dict = Missions.missions_status[Missions.curr_round]
	if mission_id not in mission_rounds_dict:
		print_debug("ERROR! No planet found")
		reset_charge()
		return
	if mission_rounds_dict[mission_id] == true:
		print_debug("ERROR! No planet found")
		reset_charge()
		return
	if mission_round != Missions.curr_round:
		print_debug("ERROR! No planet found")
		reset_charge()
		return
	Missions.missions_status[Missions.curr_round][mission_id] = true
	print_debug("FOUND PLANET " + str(curr_area.mission_id))
	if Missions.all_round_missions_done():
		print_debug("ROUND DONE!")
		Missions.curr_round += 1
		go_to_house("left")
	reset_charge()
	
func _process(delta):
	if Input.is_action_just_pressed("right_click"):
		go_to_house("left")
	elif Input.is_action_pressed("left_click"):
		charge_find(delta)
	else:
		find_charge = 0.0
		charge_blocked = false
	charge_progress.value = int(find_charge / FIND_TIME * 100)
		

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
	curr_area = area.get_parent()
	


func _on_crosshair_area_area_exited(area):
	curr_area = null


func _on_out_priest_in_door():
	go_to_house("priest")
