extends TextureProgressBar

@export var virus1: Virus_1

func _ready():
	virus1.healthChanged.connect(update)
	update() 
	
func update():
	if virus1.maxHealth > 0:
		value = virus1.currentHealth * 100 / virus1.maxHealth
		print("Virus_1 Health: ", virus1.currentHealth)


