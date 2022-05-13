extends Area2D
class_name Log
var log_speed = 30


func _process(delta):
	position.x -= log_speed * delta
	if position.x < -950:
		
		position.x += 900
	
	
	
		
