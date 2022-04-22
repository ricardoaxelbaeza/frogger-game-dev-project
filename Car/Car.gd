extends Area2D

var car_speed = 250

func _process(delta):
	position.x -= car_speed * delta
	
	if position.x > 1920:
		position.x -= 2240
	elif position.x < -320:
		position.x += 2240
		
