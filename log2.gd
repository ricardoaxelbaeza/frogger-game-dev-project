extends Sprite

var velocity = 25


func _process(delta):
	position.x += velocity * delta
	if position.x > 650:
		position.x -= 670
