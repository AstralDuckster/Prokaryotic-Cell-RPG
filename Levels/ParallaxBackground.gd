var scroll_x = 0

func _process(delta):	
	# Scroll background
	scroll_x -= 200 * delta
	ParallaxBackground.scroll_offset.x = scroll_x
	
