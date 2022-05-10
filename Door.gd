extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	pass # Replace with function body.
	if(GlobalData.key_found == true):
		print("key has been found")
	else: 
		print("please find key")
