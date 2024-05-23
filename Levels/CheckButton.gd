extends CheckButton

@export var transitioner : Transitioner


func _on_toggled(toggled_on):
	transitioner.set_next_animation(button_pressed)
	get_tree().change_scene_to_file("res://UI/youdied.tscn") 
