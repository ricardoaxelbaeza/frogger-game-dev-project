extends Node2D

func _ready():
	print(GlobalData.key_found)

func _on_Area2D_body_entered(body):
	pass # Replace with function body.
	GlobalData.key_found = true
	print(GlobalData.key_found)
	queue_free()
	
	
