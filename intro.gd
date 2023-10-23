extends Node2D

@onready var video = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#video.play()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("right_click"):
		get_tree().change_scene_to_file("res://menu.tscn")


func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://menu.tscn")
