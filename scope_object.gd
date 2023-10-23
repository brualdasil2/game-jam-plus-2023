extends Sprite2D
class_name ScopeObject

@export var mission_id = 0
@export var round = 0
@export var focus = 0.0

@export var done_texture : Texture2D 

#@export var scopeCrosshair : CrosshairArea

signal hit_scope

# Called when the node enters the scene tree for the first time.
func _ready():
	#scopeCrosshair
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Missions.missions_status[round][mission_id]:
	pass

	

func _on_area_2d_area_entered(area):
	#print_debug("")
	pass
