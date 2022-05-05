class_name Obstacle
extends KinematicBody2D

export var velocity: Vector2

func _physics_process(_delta):
	var _v = move_and_slide(velocity * 64 * Global.game_speed)
	
	if velocity.x > 0 and global_position.x > 1920:
		if Global.game_over:
			queue_free()
		else:
			global_position.x -= 2240
	elif velocity.x < 0 and global_position.x < -320:
		if Global.game_over:
			queue_free()
		else:
			global_position.x += 2240
