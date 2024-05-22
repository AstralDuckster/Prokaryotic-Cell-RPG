extends TextureProgressBar

@export var virus3: Virus_3

func _ready():
	virus3.healthChanged.connect(update)
	update() 
	
func update():
	if virus3.maxHealth > 0:
		value = virus3.currentHealth * 100 / virus3.maxHealth
		print("Virus_3 Health: ", virus3.currentHealth)
