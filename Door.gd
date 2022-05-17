extends Node2D

export(PackedScene) var next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_WinSound_finished():
	#change scene to next level depending on current scene
	get_tree().change_scene_to(next_level)
