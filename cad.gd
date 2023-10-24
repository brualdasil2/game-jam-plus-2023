extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func go_to_house(cause):
	if cause == "priest":
		OutPriestState.priest_entering = true
	get_parent().load_house()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
		go_to_house("left")

func _on_out_priest_in_door():
	go_to_house("priest")
