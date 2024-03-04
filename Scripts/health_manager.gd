extends Node

var MAX_HEALTH : int = 3
var CURRENT_HEALTH : int


func _ready():
	CURRENT_HEALTH = MAX_HEALTH
	
func decrease_health(health_amount : int):
	CURRENT_HEALTH -+ health_amount
	
	if CURRENT_HEALTH < 0:
		CURRENT_HEALTH = 0
	
	print("decrease_health called")


func increase_health(health_amount : int):
	CURRENT_HEALTH += health_amount
	
	if CURRENT_HEALTH > MAX_HEALTH:
		CURRENT_HEALTH = MAX_HEALTH
	 
	print("increase_health called")
