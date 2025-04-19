
extends Control

@export var card_scene: PackedScene

var card_sc_pl = preload("res://scenes/card.tscn")
var deck = Array()
var another_deck = Array()
var grid_size
var level_time
var level_num
var level
var exposure
var config = ConfigFile.new()
var exposure_used
var level_grid_dict ={
	1:4,2:6,3:8,4:10,5:12,6:16,7:20,8:24,9:30,10:36,11:64
}

@onready var grid = $GridContainer
@onready var game_timer = $GameTimer
@onready var hud = $HUD
@onready var card_matched = $CardMatched
@onready var level_complete_audio = $LevelComplete
@onready var next_level_audio = $LevelComplete2
@onready var game_over = $GameOver


func _ready() -> void:
	var k = config.load("user://data/config.cfg")
	
	level_num = config.get_value("player","current_level")
	exposure = config.get_value("player","exposure")
	grid_size = level_grid_dict[level_num]
	exposure_used = false
	
	level = "Level " + str(level_num)
	level_time = 10.0 * level_num
	grid.columns = sqrt(grid_size)
	fillDeck()
	dealDeck()
	set_game_timer()
	hud.set_difficulty_label(level)
	hud.set_exposure_label(exposure)
	
	#Connecting game_complete_signal
	GameManager.game_completed.connect(_on_game_completed)
	GameManager.card_matched.connect(_on_card_matched)
	
	AudioManager.play_music(false)

func fillDeck() -> void:
	for suit in range(1,5):
		for value in range(1,14):
			var c = card_scene.instantiate()
			var c1 = card_scene.instantiate()
			c.init(suit,value)
			c1.init(suit,value)
			deck.append(c)
			another_deck.append(c1)
			

func dealDeck() -> void:
	deck.shuffle()
	var required_deck = []
	for ind in range(0,grid_size/2):
		required_deck.append(deck[ind])
	
	#Selecting same cards from another deck
	var length = len(required_deck)
	for ind in range(0,length):
		for a_card in another_deck:
			if a_card.value == required_deck[ind].value and a_card.suit == required_deck[ind].suit:
				required_deck.append(a_card)
	
	#Shuffling and Adding child in the grid
	required_deck.shuffle()
	GameManager.game_complete_count = len(required_deck)
	for card in required_deck:
		grid.add_child(card)


func set_game_timer() -> void:
	game_timer.start(level_time)


func _on_time_dispaly_timer_timeout() -> void:
	var time_rem = int(game_timer.time_left)
	hud.set_timer_label(time_rem)
	


func _on_game_timer_timeout() -> void:
	get_tree().paused = true
	game_over.play()
	hud.show_game_over_screen(true)


func _on_game_completed() -> void:
	get_tree().paused = true
	level_complete_audio.play()
	next_level_audio.play()
	
	config.set_value("player","current_level",level_num + 1)
	var max_cleared_level = config.get_value("player","max_cleared_level")
	config.set_value("player","max_cleared_level",max(max_cleared_level,level_num+1))
	config.save("user://data/config.cfg")
	
	set_exposure()
	hud.show_game_completed_screen(true)


func _on_hud_retry_button_pressed() -> void:
	get_tree().paused = false
	hud.show_game_over_screen(true)
	get_tree().reload_current_scene()


func _on_hud_next_button_pressed() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene()


func _on_card_matched() -> void:
	card_matched.play()


func set_exposure() -> void:
	var current_level = config.get_value("player","current_level")
	var max_cleared_level = config.get_value("player","max_cleared_level")
	
	if current_level == max_cleared_level and (current_level - 1) % 3 == 0:
		exposure += 1
		
	config.set_value("player","exposure",exposure)
	config.save("user://data/config.cfg")


func _on_hud_exposure_button_pressed() -> void:
	if exposure > 0:
		exposure -= 1
		exposure_used = true
		hud.set_exposure_label(exposure)
		config.set_value("player","exposure",exposure)
		config.save("user://data/config.cfg")
		
		for card in grid.get_children():
			#Card current state is enum (front,back)		
			if card.current_state == 1 and !card.matched:
				card.flip()
			card.disable_button(true)
		
		#Disabling exposure button until normal state
		hud.disable_exposure_button(true)
		
		#Deselecting selected cards when exposure power is used
		GameManager.card1 = null
		GameManager.card2 = null
		GameManager.card3 = null

		await get_tree().create_timer(3.0).timeout
		
		for card in grid.get_children():
			if !card.matched:
				card.flip()
				card.disable_button(false)
			
		hud.disable_exposure_button(false)
