extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export (PackedScene) var clone
export (PackedScene) var variant
var starting_lives = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.lives = starting_lives

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartVariant_pressed():
	get_tree().change_scene_to(variant)
