extends CharacterBody2D

@export var speed = 400
@export var jump_force = 200
@export var max_jumps = 5
@export var max_walk_stamina = 100  # Maximum walking stamina
@export var walk_stamina_drain = 20  # Stamina drain per second while walking
@export var walk_stamina_regen = 0   # Stamina regeneration per second when not walking

var screen_size
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_action_active = false
var current_jumps = max_jumps  # Current available jumps
var current_walk_stamina = max_walk_stamina  # Current walking stamina
var can_process_input = true  # A flag to control input processing

# AudioStreamPlayer references
@onready var walk_sound = $move
@onready var jump_sounds = [$hyppy1, $hyppy2, $hyppy3]
@onready var cant_walk_sound = $cantWalkSound
@onready var cant_jump_sound = $cantJumpSound
var next_jump_sound_index = 0

@onready var jump_bar = get_node("../Control/sugarLevel")
@onready var walk_bar = get_node("../Control/appleJamLevel")

func _ready():
	screen_size = get_viewport_rect().size
	jump_bar.max_value = max_jumps
	jump_bar.value = current_jumps
	walk_bar.max_value = max_walk_stamina
	walk_bar.value = current_walk_stamina
	add_to_group("player")

func _process(delta):
	if is_action_active:
		velocity.x = 0
		return  # Exit the process function early if an action is active.

	if can_process_input:
		handle_movement(delta)
		handle_actions()
		pass
	handle_stamina(delta)

	move_and_slide()

func disable_input():
	can_process_input = false

func enable_input():
	can_process_input = true
	
func handle_movement(delta):
	var is_moving = false

	if Input.is_action_pressed("move_right") and current_walk_stamina > 0:
		velocity.x = speed
		is_moving = true
	elif Input.is_action_pressed("move_left") and current_walk_stamina > 0:
		velocity.x = -speed
		is_moving = true
	else:
		velocity.x = 0

	if is_moving and velocity.y == 0:
		if not walk_sound.playing:
			walk_sound.play()
		current_walk_stamina -= walk_stamina_drain * delta
		walk_bar.value = current_walk_stamina
	else:
		current_walk_stamina = min(current_walk_stamina + walk_stamina_regen * delta, max_walk_stamina)
		walk_bar.value = current_walk_stamina

	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")
		velocity.y = 0
	else:
		velocity.y += gravity * delta
		$AnimatedSprite2D.animation = "down"

	if is_on_floor() and current_jumps > 0 and Input.is_action_just_pressed("jump"):
		play_next_jump_sound()
		velocity.y = -jump_force
		current_jumps -= 1
		jump_bar.value = current_jumps

	elif is_on_floor() and current_jumps <= 0 and Input.is_action_just_pressed("jump"):
		if not cant_jump_sound.playing:
			cant_jump_sound.play()

func play_next_jump_sound():
	jump_sounds[next_jump_sound_index].play()
	next_jump_sound_index = (next_jump_sound_index + 1) % jump_sounds.size()

func handle_actions():
	if Input.is_action_just_pressed("posso_actions"):
		# start_action("posso_actions")
		pass

func handle_stamina(delta):
	pass  # Implement any additional stamina logic here
