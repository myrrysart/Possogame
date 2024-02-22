extends CharacterBody2D

@export var speed = randi_range(20, 100)
var initial_speed = speed
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D  # Ensure this path matches your AnimatedSprite2D node

func _ready():
	if animated_sprite != null:
		animated_sprite.play()

func _process(delta):
	velocity.x = speed
	move_and_slide()

	# Flip the sprite based on the direction of movement
	animated_sprite.flip_h = speed > 0

	# Check for wall collision
	if is_on_wall():
		speed = -initial_speed
		initial_speed = speed


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
