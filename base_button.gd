extends Button

signal level_button_pressed(p_level_selected)

@export var level_selected: int

@onready var click_sound = $AudioStreamPlayer2D


func _on_pressed() -> void:
	level_button_pressed.emit(level_selected)
	click_sound.play()
