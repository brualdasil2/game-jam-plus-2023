extends Sprite2D
class_name ScopeObject

@export var mission_id = 0
@export var round = 0

@export var constelation_done_frame : int = -1

const MIN_FOCUS = 0
const MAX_FOCUS = 40
var focus = 0

signal hit_scope

func random_focus() -> int:
	var rand_f = randi_range(ScopeState.MIN_FOCUS, ScopeState.MAX_FOCUS)
	while rand_f == 0:
		rand_f = randi_range(ScopeState.MIN_FOCUS, ScopeState.MAX_FOCUS)
	return rand_f

# Called when the node enters the scene tree for the first time.
func _ready():
	if round not in ScopeState.focus_values:
		ScopeState.focus_values[round] = {}
	if mission_id in ScopeState.focus_values[round]:
		focus = ScopeState.focus_values[round][mission_id]
	elif constelation_done_frame != -1:
		focus = 0
		ScopeState.focus_values[round][mission_id] = focus
	else:
		focus = random_focus()
		ScopeState.focus_values[round][mission_id] = focus
		
	

func connect_constelation():
	if constelation_done_frame == -1:
		return
	if not Missions.missions_status[round]:
		return
	if Missions.missions_status[round][mission_id]:
		frame = constelation_done_frame

func blur_focus():
	if focus == 0:
		return
	var focus_diff = abs(ScopeState.focus_value - focus)
	var max_focus_diff = ScopeState.MAX_FOCUS - ScopeState.MIN_FOCUS
	var blur_amount = (float(focus_diff) / float(max_focus_diff)) * MAX_FOCUS
	#print_debug(":::::::: MY BLUR: " + str(blur_amount))
	material.set_shader_parameter("blur_strength", int(blur_amount))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	connect_constelation()
	blur_focus()

	

func _on_area_2d_area_entered(area):
	#print_debug("")
	pass
