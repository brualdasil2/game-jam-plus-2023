extends Node2D

@onready var priest = $Priest

#signal in_door

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2.ZERO

func reset():
	priest.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_state():
	priest.save_state()

func _on_priest_in_door():
	get_tree().call_group("priest_listener", "_on_out_priest_in_door")
