extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var light = load("res://light.tscn")
	var small_light = load("res://small_light.tscn")
	for c in get_children():
		if c.name.begins_with("1"):
			c.add_child(small_light.instantiate())
		else:
			c.add_child(light.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
