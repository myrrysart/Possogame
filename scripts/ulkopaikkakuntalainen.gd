extends Area2D

@onready var video_player = $VideoStreamPlayer  # Adjust the path to your VideoPlayer node
var is_video_playing = false
@onready var player = get_node("../Player")  # Adjust the path to your player node

# Called when the node enters the scene tree for the first time.
func _ready():
	var animated_sprite = $AnimatedSprite2D
	if animated_sprite != null:
		animated_sprite.play()
	connect("body_entered", Callable(self, "_on_body_entered"))
	video_player.connect("finished", Callable(self, "_on_VideoPlayer_finished"))

func _on_body_entered(body):
	if body.is_in_group("player"):  # Assuming your player is in a group named 'player'
		video_player.play()  # Play the video
		is_video_playing = true  # Set the flag
		player.disable_input()  # Disable player input
		call_deferred("deferred_scene_change")

func deferred_scene_change():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = "res://stages/stage_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)

func _on_VideoPlayer_finished():
	is_video_playing = false  # Reset the flag when the video finishes
	player.enable_input()  # Re-enable player input

func _process(delta):
	if is_video_playing:
		return  # Ignore inputs while the video is playing
