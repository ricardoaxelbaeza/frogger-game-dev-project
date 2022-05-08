extends Area2D

var log_speed = 150

func _process(delta):
	position.x -= log_speed * delta


func _on_log_body_entered(body):
	print("collision!")
