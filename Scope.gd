extends Node2D

@export var MOUSE_SPEED = 1
@onready var marker = $Marker2D
var teleported_mouse : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		if teleported_mouse:
			teleported_mouse = false
			return
		var velocity : Vector2 = event.velocity
		velocity = velocity / 100
		print_debug(velocity)
		marker.global_position += velocity * MOUSE_SPEED
		Input.warp_mouse(get_viewport_rect().size/2)
		teleported_mouse = true
		
