extends Sprite2D

@export var mission_id : int
@export var round : int

# Called when the node enters the scene tree for the first time.
func _ready():
	if Missions.missions_status[round][mission_id]:
		visible = true
	else:
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
