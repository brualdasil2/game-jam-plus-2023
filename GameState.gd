extends Node2D

@onready var mainMusic = $MainMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(load("res://House.tscn").instantiate())
	mainMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_scene(name):
	var node = get_tree().get_first_node_in_group(name)
	if node:
		node.queue_free()

func load_house():
	remove_scene("scope")
	remove_scene("notebook")
	add_child(load("res://House.tscn").instantiate())

func load_scope():
	remove_scene("house")
	remove_scene("notebook")
	add_child(load("res://Scope.tscn").instantiate())

func load_game_over():
	mainMusic.stop()
	remove_scene("house")
	add_child(load("res://game_over.tscn").instantiate())

func load_notebook():
	remove_scene("house")
	var curr_round = Missions.curr_round
	add_child(load("res://cad_" + str(curr_round) + ".tscn").instantiate())
		
