extends Node 2D

export var velocity: Vector2

func _physics_process(delta):
  var _v = move_and_slide(velocity * 64)
  
  if velocity.x > 0 and global_position.x >1920:
	global_position.x -= 2240
  elif velocity.x < 0 and global_position.x <-320:
	global_position += 2240
