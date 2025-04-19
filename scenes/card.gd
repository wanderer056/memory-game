extends Control

class_name Card

enum FlipState{
	FRONT,
	BACK
}

var suit
var value
var face
var back
var matched
var current_state = FlipState.BACK

@onready var animation_player = $AnimationPlayer
@onready var card_texture_button = $CardTextureButton
@onready var flip_sound = $FlipSound


func init(s, v) -> void:
	value = v
	suit = s
	face = load("res://assets/cards/card-"+str(suit)+"-"+str(value)+".png")
	back = GameManager.cardBack
	

func _ready() -> void:
	card_texture_button.set_texture_normal(back)


func _on_card_texture_button_pressed() -> void:
	GameManager.choose_card(self)


func flip() -> void:
	animation_player.play("flip",-1,2.0)
	await animation_player.animation_finished
	if current_state == FlipState.FRONT:
		card_texture_button.texture_normal = back
		current_state = FlipState.BACK			
	else:
		card_texture_button.texture_normal = face
		current_state = FlipState.FRONT
	animation_player.play_backwards("flip")
	flip_sound.play()

func disable_button(disable) -> void:
	card_texture_button.disabled = disable
