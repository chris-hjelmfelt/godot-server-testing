extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@export var speed: int = 500


func _process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	# face sprite in correct direction
	if (direction.x < -0.1):
		sprite_2d.set_flip_h( true )
	elif (direction.x > 0.1):
		sprite_2d.set_flip_h( false )
	
	move_and_slide()
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	$"../CanvasLayer/UI/HBox/FPS".text = str(Engine.get_frames_per_second())
