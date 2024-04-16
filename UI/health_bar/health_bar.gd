extends TextureProgressBar

@export var player: Player

func _ready():
	player.healthChanged.connect(update)
	update() 

func update():
	if player.maxHealth > 0:
		value = player.currentHealth * 100 / player.maxHealth
		print("Player Health: ", player.currentHealth)
	else:
		value = 0
		print("Player Health: ", player.currentHealth)

