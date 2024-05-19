extends "res://UI/main_menu.gd"



func _on_Start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/base_level.tscn")
	
func on_Exit_pressed():
	get_tree().quit()
