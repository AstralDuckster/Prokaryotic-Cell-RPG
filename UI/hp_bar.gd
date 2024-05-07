extends Node2D

@export var heart1 = Texture2D
@export var heart0 = Texture2D

@onready var heart_1 = $Heart
@onready var heart_2 = $Heart2
@onready var heart_3 = $Heart3
@onready var heart_4 = $Heart4
@onready var heart_5 = $Heart5

func _ready():
	HealthManager.on_health_changed.connect(on_player_health_changed)
	
func on_player_health_changed(player_current_health : int):
	if player_current_health >= 5:
		heart_5.texture = heart1
	else:
		heart_5.texture = heart0
	
	if player_current_health >= 4:
		heart_4.texture = heart1
	else:
		heart_4.texture = heart0
	
	if player_current_health >= 3:
		heart_3.texture = heart1
	else:
		heart_3.texture = heart0

	if player_current_health >= 2:
		heart_2.texture = heart1
	else:
		heart_2.texture = heart0
	
	if player_current_health >= 1:
		heart_1.texture = heart1
	else:
		heart_1.texture = heart0
