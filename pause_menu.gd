extends ColorRect
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var play_button: Button = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton")
@onready var quit_button: Button = get_node("CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton")

#func _ready() -> void:

func _unhandled_input(event: InputEvent) ->void:
	if event.is_action_pressed("quit"):
		if get_tree().paused:
			unpause()
		else:
			pause()	
	play_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
