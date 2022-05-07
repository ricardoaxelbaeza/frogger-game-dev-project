extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export (PackedScene) var clone
export (PackedScene) var variant
export (PackedScene) var clone
var starting_lives = 5
var starting_score = 0
var starting_time = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.lives = starting_lives
	GlobalData.score = starting_score
	GlobalData.time = starting_time
	GlobalData.frog1 = false
	GlobalData.frog2 = false
	GlobalData.frog3 = false
	GlobalData.frog4 = false
	GlobalData.frog5 = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_StartVariant_pressed():
	get_tree().change_scene_to(variant)


func _on_StartClone_pressed():
	get_tree().change_scene_to(clone)
