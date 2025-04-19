extends Control

@onready var progress_bar = $ProgressBar
@onready var progress_timer = $Timer

func _ready() -> void:
	pass


func _on_animation_player_animation_finished(p_anim_name) -> void:
	load_bar()


func _on_timer_timeout() -> void:
	progress_bar.value += 2


func _on_progress_bar_value_changed(p_value) -> void:
	if p_value == 100:
		SceneTransitioner.change_scene_to_file("res://scenes/main_menu.tscn")
		

func load_bar() -> void:
	var tween = create_tween()
	tween.tween_property(progress_bar,"value",100,3.0)
