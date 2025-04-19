extends Control


func _ready() -> void:
	if !AudioManager.playing:
		AudioManager.play_music(true)


func _on_start_button_pressed() -> void:
	SceneTransitioner.change_scene_to_file("res://scenes/game.tscn")


func _on_select_level_button_pressed() -> void:
	SceneTransitioner.change_scene_to_file("res://scenes/level_select_menu.tscn")
