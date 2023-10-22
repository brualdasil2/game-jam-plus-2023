extends CharacterBody2D

@onready var pos1 : Marker2D
@onready var pos2 : Marker2D
@onready var pos3 : Marker2D
@onready var pos4 : Marker2D
@onready var pos5 : Marker2D
@onready var timer = $Timer

@export var MIN_MOVE_SPEED = 50.0
@export var MAX_MOVE_SPEED = 400.0
@export var MIN_TIMER = 1.0
@export var MAX_TIMER = 3.0

var move_speed = MIN_MOVE_SPEED
var target_pos : Vector2
var target_pos_numb = 1
var moving : bool = false
var paused = false

signal in_door

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(MIN_TIMER)
	pos1 = get_parent().get_node("./Pos1")
	pos2 = get_parent().get_node("./Pos2")
	pos3 = get_parent().get_node("./Pos3")
	pos4 = get_parent().get_node("./Pos4")
	pos5 = get_parent().get_node("./Pos5")
	
func reset():
	target_pos_numb = 1
	global_position = pos1.global_position
	new_timer()
	paused = false

func stop():
	paused = true

func new_timer():
	moving = false
	var rand_time = randf_range(MIN_TIMER, MAX_TIMER)
	timer.start(rand_time)
	
	
func is_in_pos():
	return (global_position - target_pos).length() < 10.0

func arrive_in_door():
	in_door.emit()
	stop()

func _physics_process(delta):
	if paused:
		return
	if is_in_pos() and moving:
		if target_pos_numb == 5:
			arrive_in_door()
			
		new_timer()
		velocity = Vector2.ZERO
		
	if moving:
		var dir = target_pos - global_position
		dir = dir.normalized()
		velocity = move_speed * dir
		
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	print_debug("TIMER!")
	moving = true
	move_speed = randf_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED)
	var pos = randi_range(1, 5)
	while pos == target_pos_numb:
		pos = randi_range(1, 5)
	target_pos_numb = pos
	print_debug("POS: " + str(pos))
	match pos:
		1:
			target_pos = pos1.global_position
		2:
			target_pos = pos2.global_position
		3:
			target_pos = pos3.global_position
		4:
			target_pos = pos4.global_position
		5:
			target_pos = pos5.global_position
