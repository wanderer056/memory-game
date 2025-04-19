extends Control

var config = ConfigFile.new()
var current_level
var level_selected
var max_cleared_level


@onready var grid = $GridContainer
#@onready var level_buttons = grid.get_children()


func _ready() -> void:
	var k = config.load("user://data/config.cfg")
	current_level = config.get_value("player","current_level")
	max_cleared_level =config.get_value("player","max_cleared_level")
	for btn in grid.get_children():
		if int(str(btn.name)) > max_cleared_level:
			btn.disabled = true
	level_selected = current_level
	set_pressed()
	connect_button_signal()


func _on_back_button_pressed() -> void:
	save_level_selected()
	SceneTransitioner.change_scene_to_file("res://scenes/main_menu.tscn")


func save_level_selected() -> void:
	if level_selected != null:
		config.set_value("player","current_level",level_selected)
		config.save("user://data/config.cfg")


func set_pressed() -> void:
	for btn in grid.get_children():
		if btn.name == str(current_level):
			btn.set_pressed_no_signal(true)


func connect_button_signal() -> void:
	for level_btn in grid.get_children():
		level_btn.level_button_pressed.connect(_on__level_button_pressed)
	

func _on__level_button_pressed(p_level_selected) -> void:
	var prev_button = grid.get_node(str(level_selected))
	prev_button.button_pressed = false
	level_selected = p_level_selected
