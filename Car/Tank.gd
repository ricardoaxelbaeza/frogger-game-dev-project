extends Area2D

export var car_speed = 100

func _process(delta):
	position.x += car_speed * delta
	
	if position.x > 600:
		position.x -= 700
	elif position.x < -100:
		position.x += 700
		
