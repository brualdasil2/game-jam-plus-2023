extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game_state.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://credits.tscn")

func _on_how_button_pressed():
	get_tree().change_scene_to_file("res://how_to.tscn")
