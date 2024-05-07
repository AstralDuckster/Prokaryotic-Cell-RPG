extends Node

class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockback_direction : Vector2)

@export var health : float = 20 
	
func hit(damage : int, knockback_direction : Vector2):
	health -= damage
	print("damage taken")
	
	# Local signal for subscribers that only care about this specific
	# damageable object
	emit_signal("on_hit", get_parent(), damage, knockback_direction)

# After the dead animation plays, remove the parent node from the scene
# This also removes children

