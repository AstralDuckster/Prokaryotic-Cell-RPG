extends Node

var max_health = 0
var current_health = max_health

signal healthChanged

func _ready():
	current_health = max_health
	
func decrease_health(health_amount : int):
	current_health -= health_amount
	
	if current_health <= 0:
		current_health = 0
	
	print("decrease_health called")
	healthChanged.emit(current_health)

func increase_health(health_amount : int):
	current_health += health_amount
	
	if current_health > max_health:
		current_health = max_health
	 
	print("increase_health called")
	healthChanged.emit(current_health)
