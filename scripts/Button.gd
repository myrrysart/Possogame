extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", Callable(self, "_on_Button_pressed"))

func _on_Button_pressed():
	get_tree().reload_current_scene()
