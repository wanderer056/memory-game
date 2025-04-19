extends CanvasLayer

@onready var animation_player1 = $AnimationPlayer

func change_scene_to_file(target:String):
	animation_player1.play("transition")
	await animation_player1.animation_finished
	get_tree().change_scene_to_file(target)
	animation_player1.play_backwards("transition")
	
