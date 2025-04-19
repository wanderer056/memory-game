extends Control

signal retry_button_pressed()
signal next_button_pressed()
signal exposure_button_pressed()

@onready var timer_label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/TimerLabel
@onready var level_label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/LevelLabel
@onready var game_over_screen = $GameOverScreen
@onready var game_completed_screen = $GameCompletedScreen
@onready var exposure_button = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer4/ExposureButton


func set_timer_label(time) -> void:
	timer_label.text = str(time)
	

func set_difficulty_label(level) -> void:
	level_label.text = str(level)


func set_exposure_label(exposure) -> void:
	exposure_button.text = str(exposure)


func show_game_over_screen(state) -> void:
	if state:
		await get_tree().create_timer(0.5).timeout
		game_over_screen.show()
	else:
		game_over_screen.hide()

func show_game_completed_screen(state) -> void:
	if state:
		game_completed_screen.show()
	else:
		game_completed_screen.hide()

func _on_retry_button_pressed() -> void:
	retry_button_pressed.emit()


func _on_next_button_pressed() -> void:
	next_button_pressed.emit()


func _on_home_button_pressed() -> void:
	get_tree().paused = false
	SceneTransitioner.change_scene_to_file("res://scenes/main_menu.tscn")


func _on_returnbutton_pressed() -> void:
	AudioManager.play_click()
	SceneTransitioner.change_scene_to_file("res://scenes/main_menu.tscn")


func _on_restart_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().reload_current_scene()


func _on_exposure_button_pressed() -> void:
	exposure_button_pressed.emit()
	
	
func disable_exposure_button(p_disable_state) -> void:
	exposure_button.disabled = p_disable_state
