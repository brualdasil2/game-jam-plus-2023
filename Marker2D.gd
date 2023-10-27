extends CharacterBody2D

@export var MAX_SPEED = 1000
@export var LINEAR_SPEED = 100
@export var ACCELERATION = 10
@export var FRICTION = 300

@export var FIND_TIME = 2.0

@onready var charge_progress = $Node2D/TextureProgressBar
@onready var certoSound = $Certosound
@onready var erradoSound = $ErradoSound

var find_charge = 0.0
var charge_blocked = false

var curr_area : ScopeObject

var acc_mouse_direction : Vector2 = Vector2.ZERO
var var_speed : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.use_accumulated_input = false
	#center_mouse()
	#prev_mouse_pos = get_mouse_pos()
	if ScopeState.initialized:
		global_position = ScopeState.scope_position


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		acc_mouse_direction += event.relative

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var mouse_direction : Vector2 = acc_mouse_direction
	
	# linear speed component
	var linear_speed : Vector2 = mouse_direction * delta * LINEAR_SPEED
	
	# variable speed component (acceleration)
	var_speed += mouse_direction * delta * ACCELERATION
	
	# friction
	var op_dir : Vector2 = velocity.normalized() * -1
	if find_charge == 0.0:
		var_speed += FRICTION * delta * op_dir
	
	velocity = linear_speed + var_speed
	
	# speed cap
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

	if find_charge == 0.0:
		move_and_slide()
	
	acc_mouse_direction = Vector2.ZERO

func save_state():
	ScopeState.scope_position = global_position
	ScopeState.initialized = true

func go_to_house(cause):
	save_state()
	if cause == "priest":
		OutPriestState.priest_entering = true
	elif cause == "missions":
		HouseState.just_completed_page = true
	get_parent().get_parent().load_house()
	
	
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
		erradoSound.play()
		reset_charge()
		return

	var mission_id = curr_area.mission_id
	var mission_round = curr_area.round
	var mission_rounds_dict = Missions.missions_status[Missions.curr_round]
	if mission_id not in mission_rounds_dict:
		erradoSound.play()
		reset_charge()
		return
	if mission_rounds_dict[mission_id] == true:
		erradoSound.play()
		reset_charge()
		return
	if mission_round != Missions.curr_round:
		erradoSound.play()
		reset_charge()
		return
	if ScopeState.focus_value != curr_area.focus and curr_area.focus != 0:
		erradoSound.play()
		reset_charge()
		return
	Missions.missions_status[Missions.curr_round][mission_id] = true
	certoSound.play()
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
	
	var scroll = 0
	if Input.is_action_just_pressed("scroll_up"):
		scroll = 1
	elif Input.is_action_just_pressed("scroll_down"):
		scroll = -1
	if scroll != 0:
		ScopeState.focus_value += scroll
		ScopeState.focus_value = clamp(ScopeState.focus_value, ScopeState.MIN_FOCUS, ScopeState.MAX_FOCUS)
		

func center_mouse():
	#get_viewport().
	#Input.warp_mouse(get_viewport_rect().size / 2)
	# Get the current size of the viewport
	var viewport_size = get_viewport_rect().size

	# Calculate the center position
	var center_position = viewport_size / 2

	# Set the mouse cursor position to the center
	#OS.set_mouse_position(center_position)

func get_mouse_pos() -> Vector2:
	return get_global_mouse_position() - global_position



func _on_crosshair_area_area_entered(area):
	if not (area is ObjectArea):
		return
	curr_area = area.get_parent()
	


func _on_crosshair_area_area_exited(area):
	curr_area = null


func _on_out_priest_in_door():
	go_to_house("priest")


func _on_certosound_finished():
	if Missions.all_round_missions_done():
		Missions.curr_round += 1
		go_to_house("missions")
