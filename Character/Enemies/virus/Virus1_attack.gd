extends Area2D

@export var damage : int = 10
@export var player : Player 

func _on_body_entered(body):
	# If the body that entered the sword hit zone is a damageable object,
	# damage it
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
			print("damaged")
