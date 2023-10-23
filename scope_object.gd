extends Sprite2D
class_name ScopeObject

@export var mission_id = 0
@export var round = 0
@export var focus = 0.0

@export var constelation_done_frame : int = -1

#@export var scopeCrosshair : CrosshairArea

signal hit_scope

# Called when the node enters the scene tree for the first time.
func _ready():
	#scopeCrosshair
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if constelation_done_frame == -1:
		return
	if not Missions.missions_status[round]:
		return
	if Missions.missions_status[round][mission_id]:
		frame = constelation_done_frame

	

func _on_area_2d_area_entered(area):
	#print_debug("")
	pass
