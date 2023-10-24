extends CharacterBody2D

@onready var pos1 : Marker2D
@onready var pos2 : Marker2D
@onready var pos3 : Marker2D
@onready var pos4 : Marker2D
@onready var pos5 : Marker2D
@onready var timer = $Timer
@onready var knock = $"../KnockSound"
@onready var walk = $WalkSound

@export var MIN_MOVE_SPEED = 50.0
@export var MAX_MOVE_SPEED = 300.0
@export var MIN_STEPS_AUDIO_FREQ = 0.5
@export var MAX_STEPS_AUDIO_FREQ = 1.5
@export var MIN_TIMER = 1.0
@export var MAX_TIMER = 3.0

var move_speed = MIN_MOVE_SPEED
var target_pos : Vector2
var target_pos_numb = 1
var moving : bool = false
var paused = false
var on_door = false

signal in_door

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(MIN_TIMER)
	pos1 = get_parent().get_node("./Pos1")
	pos2 = get_parent().get_node("./Pos2")
	pos3 = get_parent().get_node("./Pos3")
	pos4 = get_parent().get_node("./Pos4")
	pos5 = get_parent().get_node("./Pos5")
	if OutPriestState.initialized:
		print_debug("READY PRIEST INITING TO: " + str(OutPriestState.target_pos_numb))
		move_speed = OutPriestState.move_speed
		target_pos = OutPriestState.target_pos
		target_pos_numb = OutPriestState.target_pos_numb
		moving = OutPriestState.moving
		paused = OutPriestState.paused
		velocity = OutPriestState.velocity
		global_position = OutPriestState.global_position
		on_door = OutPriestState.on_door
	
func save_state():
	OutPriestState.move_speed = move_speed
	OutPriestState.target_pos = target_pos
	OutPriestState.target_pos_numb = target_pos_numb
	OutPriestState.moving = moving
	OutPriestState.paused = paused
	OutPriestState.velocity = velocity
	OutPriestState.global_position = global_position
	OutPriestState.initialized = true
	OutPriestState.on_door = on_door
	
func reset():
	target_pos_numb = 1
	global_position = pos1.global_position
	new_timer()
	paused = false

func stop():
	paused = true
	walk.stop()

func new_timer():
	moving = false
	var rand_time = randf_range(MIN_TIMER, MAX_TIMER)
	timer.start(rand_time)
	
	
func is_in_pos():
	return (global_position - target_pos).length() < 10.0

func arrive_in_door():
	on_door = true
	stop()
	knock.play()
	

func enter_door():
	in_door.emit()

func _physics_process(delta):
	if on_door:
		pass
	if paused:
		return
	if is_in_pos() and moving:
		if target_pos_numb == 5:
			arrive_in_door()
			
		new_timer()
		velocity = Vector2.ZERO
		walk.stop()
		
	if moving:
		var dir = target_pos - global_position
		dir = dir.normalized()
		velocity = move_speed * dir
		
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func map_speed_to_pitch(speed : float) -> float:
	return (((speed - MIN_MOVE_SPEED) / (MAX_MOVE_SPEED - MIN_MOVE_SPEED)) * (MAX_STEPS_AUDIO_FREQ - MIN_STEPS_AUDIO_FREQ)) + MIN_STEPS_AUDIO_FREQ

func _on_timer_timeout():
	print_debug("TIMER!")
	moving = true
	move_speed = randf_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED)
	#var pos = randi_range(1, 5)
	var pos = 5
	while pos == target_pos_numb:
		pos = randi_range(1, 5)
	target_pos_numb = pos
	print_debug("POS: " + str(pos))
	if not paused:
		walk.pitch_scale = map_speed_to_pitch(move_speed)
		print_debug("speed: " + str(move_speed) + " -- pitch: " + str(walk.pitch_scale))
		walk.play()
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


func _on_knock_sound_finished():
	enter_door()
