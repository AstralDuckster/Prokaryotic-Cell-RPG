class_name Mainmenu
extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://Levels/base_level.tscn") as PackedScene

func _ready():
	start_button.button_down.connect(on_Start_pressed)
	exit_button.button_down.connect(on_Exit_pressed)


func on_Start_pressed():
	get_tree().change_scene_to_packed(start_level)

func on_Exit_pressed():
	get_tree().quit()
