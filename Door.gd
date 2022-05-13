extends Node2D

export(PackedScene) var next_level

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
		#change scene to next level depending on current scene
		get_tree().change_scene_to(next_level)
	else: 
		print("please find key")
