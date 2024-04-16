extends Area2D

@export var player: Player
@export var facing_shape : FacingCollisionShape2D

func _ready():
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)
	
func _on_player_facing_direction_changed(facing_right : bool):
	if (facing_right):
		facing_shape.position = facing_shape.facing_right_position
	else:
		facing_shape.position = facing_shape.facing_left_position
