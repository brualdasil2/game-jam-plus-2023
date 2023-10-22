extends Node2D

@onready var galileo = $Galileo
@onready var reza = $Reza
@onready var notebook = $Notebook
@onready var scope = $Scope
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if HouseState.initialized:
		print_debug("INIT ROLANDO")
		galileo.global_position = HouseState.galileo_pos
		galileo.flip_h = HouseState.galileo_flipped
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	anim.play("closed")

func _physics_process(delta):
	match galileo.state:
		"walking_to_reza":
			galileo.walk_to_target(delta)
			if galileo.is_on_target():
				galileo.state = "praying"
		"walking_to_scope":
			galileo.walk_to_target(delta)
			if galileo.is_on_target():
				galileo.state = "standing"
				open_scope()
		"walking_to_notebook":
			galileo.walk_to_target(delta)
			if galileo.is_on_target():
				galileo.state = "standing"
				# open notebook

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_state():
	HouseState.galileo_pos = galileo.global_position
	HouseState.galileo_flipped = galileo.flip_h
	HouseState.initialized = true
	print("SET HS INIT: " + str(HouseState.initialized))

func open_scope():
	save_state()
	get_tree().change_scene_to_file("res://Scope.tscn")

func _on_reza_pressed():
	galileo.state = "walking_to_reza"
	galileo.target_x = reza.global_position.x + 85


func _on_notebook_pressed():
	galileo.state = "walking_to_notebook"
	galileo.target_x = notebook.global_position.x
	print_debug("NOTEBOOK")


func _on_scope_pressed():
	galileo.state = "walking_to_scope"
	galileo.target_x = scope.global_position.x


func _on_reza_mouse_entered():
	reza.icon = load("res://res/altar with yellow.png")
	pass # Replace with function body.


func _on_reza_mouse_exited():
	reza.icon = load("res://res/altar.png")
	pass # Replace with function body.


func _on_scope_mouse_entered():
	scope.icon = load("res://res/telescope with yellow.png")
	pass # Replace with function body.
	


func _on_scope_mouse_exited():
	scope.icon = load("res://res/telescope.png")
	pass # Replace with function body.


func _on_notebook_mouse_entered():
	notebook.icon = load("res://res/book open with yellow.png")
	pass # Replace with function body.


func _on_notebook_mouse_exited():
	notebook.icon = load("res://res/book open.png")
	pass # Replace with function body.


func _on_priest_in_door():
	print_debug("PRIEST IN DOOR!!!!!!!!!!")
	anim.play("open")
