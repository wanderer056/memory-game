
extends Node

signal game_completed()
signal card_matched()

var cardBack = preload("res://assets/cards/cardBack_blue2.png")
var card_scene = preload("res://scenes/card.tscn")
var card1
var card2
var card3
var game_complete_count
var game_scene = preload("res://scenes/game.tscn")

func _ready() -> void:
	if FileAccess.file_exists("user://data/config.cfg"):
		return
	
	if not FileAccess.file_exists("res://data/config.cfg"):
		printerr("err")
		return

	var m_file_handle: FileAccess = FileAccess.open("res://data/config.cfg", FileAccess.READ)
	
	if m_file_handle == null:
		printerr("err")
		return
	
	if not DirAccess.dir_exists_absolute("user://data"):
		DirAccess.make_dir_absolute("user://data")
	
	var m_user_file = FileAccess.open("user://data/config.cfg", FileAccess.WRITE)
	m_user_file.store_string(m_file_handle.get_as_text())
	
	m_user_file.close()
	m_file_handle.close()
	
		
	
	
	

func choose_card(card) -> void:
	if card1 == null:
		card1 = card
		card1.flip()
		card1.disable_button(true)
	elif card2 == null:
		card2 =card
		card2.flip()
		card2.disable_button(true)
		check_cards()
	elif card3 == null and !(card1.value ==card2.value and card1.suit == card2.suit):
		card1.flip()
		card2.flip()
		card3 = card
		card3.flip()
		card1.disable_button(false)
		card2.disable_button(false)
		card3.disable_button(true)
		card1 = card3
		card2 = null
		card3 = null
		
	

func check_cards() -> void:
	await get_tree().create_timer(0.5).timeout
	if card2 != null:
		if card1.value == card2.value and card1.suit == card2.suit:
			card1.modulate = Color(0.6,0.6,0.6,0.5)
			card2.modulate = Color(0.6,0.6,0.6,0.5)
			card1.matched = true
			card2.matched = true
			game_complete_count -= 2
			card_matched.emit()
			card1 = null
			card2 = null
			if game_complete_count == 0:
				game_completed.emit()
				print("game_complete")
			
		elif card3 == null:
			card1.flip()
			card2.flip()
			card1.disable_button(false)
			card2.disable_button(false)
			card1 = null
			card2 = null


func start_game() -> void:
	var game = game_scene.instantiate()
	game.grid_size = 8*8
	game.level_num = 2
	get_tree().change_scene_to_packed(game)
