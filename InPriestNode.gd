extends CharacterBody2D

@onready var pos1 : Marker2D
@onready var pos2 : Marker2D

@onready var timer = $Timer
@onready var anim = $"../AnimationPlayer"
@onready var sprite = $InPriestSp
@onready var galileo = $"../Galileo"
@onready var gameOverTimer = $GameOverTimer

@export var MOVE_SPEED = 100.0
@export var TIMER = 2.0

var move_speed = MOVE_SPEED
var target_pos : Vector2
var target_pos_numb = 1
var moving : bool = false
var paused = false
var reached_pos_1 = false

signal in_door_again

# Called when the node enters the scene tree for the first time.
func _ready():
	pos1 = get_parent().get_node("./Pos1")
	pos2 = get_parent().get_node("./Pos2")
	global_position = pos2.global_position
	visible = false
	target_pos = pos1.global_position
	

func reset():
	target_pos_numb = 1
	target_pos = pos1.global_position
	global_position = pos2.global_position
	paused = false

func stop():
	paused = true

func go():
	visible = true
	moving = true
	sprite.flip_h = true
	check_galileo()
	
func is_in_pos():
	return (global_position - target_pos).length() < 10.0

func arrive_in_door():
	visible = false
	print_debug("IN DOOR AGAIN")
	in_door_again.emit()
	reset()
	
func check_galileo():
	if galileo.state == "praying":
		return
	galileo.frozen = true
	print_debug("GAME OVER")
	moving = false
	gameOverTimer.start()

func _physics_process(delta):
	if not visible:
		return
	if paused:
		return
	if is_in_pos() and moving:
		if target_pos_numb == 1:
			moving = false
			timer.start()
		if target_pos_numb == 2:
			arrive_in_door()
		
		velocity = Vector2.ZERO
		
	if moving:
		var dir = target_pos - global_position
		dir = dir.normalized()
		velocity = move_speed * dir
		
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		if velocity.x < 0:
			sprite.flip_h = false
		anim.play("priest_walk")
	else:
		anim.play("priest_stand")
		

func _on_timer_timeout():
	moving = true
	target_pos_numb = 2
	target_pos = pos2.global_position



func _on_game_over_timer_timeout():
	get_parent().get_parent().load_game_over()
