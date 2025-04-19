extends Node2D

var stop_state = 0.0
var playing = true

@onready var click_sound = $ClickSound


func play_music(state) -> void:
	playing = state
	if state:
		$BackgroundMusic.play(stop_state)
	else:
		stop_state = $BackgroundMusic.get_playback_position()
		$BackgroundMusic.stop()


func play_click() -> void:
	click_sound.play()
