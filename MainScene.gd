extends Node2D

const CAR = preload ("res://Car/Car.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _addcars():
	var car = CAR.instance()
	car.positon = $"carstart1position"
	add_child(car)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
