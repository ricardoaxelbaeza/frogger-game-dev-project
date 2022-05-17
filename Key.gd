extends Node2D

func _ready():
	print(GlobalData.key_found)

func _on_Area2D_body_entered(body):
	GlobalData.key_found = true
	$"../KeySound".play()
	queue_free()
