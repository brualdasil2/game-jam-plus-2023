extends Node2D

@onready var a2 = $Area2
@onready var a3 = $Area3
@onready var a4 = $Area4
@onready var a5 = $Area5

func _ready():
	if Missions.curr_round >= 2:
		a2.collision_layer = 8
	if Missions.curr_round >= 3:
		a3.collision_layer = 8
	if Missions.curr_round >= 4:
		a4.collision_layer = 8
	if Missions.curr_round >= 5:
		a5.collision_layer = 8
	
