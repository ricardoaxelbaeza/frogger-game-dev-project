extends Area2D

var log_speed = 150

func _process(delta):
	position.x -= log_speed * delta
	if position.x < -950:
		print("positionn is ff")
		position.x += 900
	
	
	
		
