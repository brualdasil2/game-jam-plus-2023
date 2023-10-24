extends Node2D

@onready var galileo = $Galileo
@onready var reza = $Reza
@onready var notebook = $Notebook
@onready var scope = $Scope
@onready var anim = $AnimationPlayer
@onready var inPriest = $InPriestNode
@onready var doorSound = $DoorSound
@onready var closeSound = $CloseSound
@onready var praySound = $PraySound
@onready var moon = $MoonProp
@onready var stars = $Stars1Prop
@onready var clock = $ClockProp

# Called when the node enters the scene tree for the first time.
func _ready():
	if HouseState.initialized:
		print_debug("INIT ROLANDO")
		galileo.global_position = HouseState.galileo_pos
		galileo.flip_h = HouseState.galileo_flipped
	if Missions.curr_round == 6:
		get_tree().change_scene_to_file("res://win.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	anim.play("closed")
	if OutPriestState.priest_entering:
		enter_priest()
		moon.visible = false
		stars.visible = false
		clock.visible = false
	anim.play("moon")
	anim.play("stars1")

func _physics_process(delta):
	match galileo.state:
		"walking_to_reza":
			galileo.walk_to_target(delta)
			if galileo.is_on_target():
				galileo.state = "praying"
				praySound.play()
		"walking_to_scope":
			galileo.walk_to_target(delta)
			if galileo.is_on_target():
				galileo.state = "standing"
				open_scope()
		"walking_to_notebook":
			galileo.walk_to_target(delta)
			if galileo.is_on_target():
				galileo.state = "standing"
				open_notebook()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_state():
	HouseState.galileo_pos = galileo.global_position
	HouseState.galileo_flipped = galileo.flip_h
	HouseState.initialized = true

func open_notebook():
	save_state()
	get_parent().load_notebook()
				
func open_scope():
	save_state()
	get_parent().load_scope()
	#get_tree().change_scene_to_file("res://Scope.tscn")

func enter_priest():
	anim.play("open")
	doorSound.play()
	inPriest.reset()
	inPriest.go()

func _on_reza_pressed():
	if inPriest.visible:
		return
	galileo.state = "walking_to_reza"
	galileo.target_x = reza.global_position.x + 85


func _on_notebook_pressed():
	if inPriest.visible:
		return
	galileo.state = "walking_to_notebook"
	galileo.target_x = notebook.global_position.x
	print_debug("NOTEBOOK")


func _on_scope_pressed():
	if inPriest.visible:
		return
	galileo.state = "walking_to_scope"
	galileo.target_x = scope.global_position.x


func _on_reza_mouse_entered():
	if inPriest.visible:
		return
	reza.icon = load("res://res/altar with yellow.png")
	pass # Replace with function body.


func _on_reza_mouse_exited():
	reza.icon = load("res://res/altar.png")
	pass # Replace with function body.


func _on_scope_mouse_entered():
	if inPriest.visible:
		return
	scope.icon = load("res://res/telescope with yellow.png")
	pass # Replace with function body.
	


func _on_scope_mouse_exited():
	scope.icon = load("res://res/telescope.png")
	pass # Replace with function body.


func _on_notebook_mouse_entered():
	if inPriest.visible:
		return
	notebook.icon = load("res://res/book open with yellow.png")
	pass # Replace with function body.


func _on_notebook_mouse_exited():
	notebook.icon = load("res://res/book open.png")
	pass # Replace with function body.

func _on_out_priest_in_door():
	print_debug("PRIEST IN DOOR!!!!!!!!!!")
	enter_priest()


func _on_in_priest_node_in_door_again():
	closeSound.play()
	anim.play("closed")
	var out_priest = get_tree().get_first_node_in_group("out_priest")
	out_priest.reset()
	
