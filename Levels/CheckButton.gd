extends CheckButton

@export var transitioner : Transitioner


func _on_toggled(toggled_on):
	transitioner.set_next_animation(button_pressed)
