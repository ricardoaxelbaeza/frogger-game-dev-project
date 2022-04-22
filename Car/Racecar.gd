extends Area2D

export var car_speed = 300

func _process(delta):
	position.x -= car_speed * delta
	
	if position.x > 1920:
		position.x -= 2240
	elif position.x < -320:
		position.x += 2240
		
