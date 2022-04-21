extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var speed : int = 200
var jump_force : int = 600
var gravity : int = 800

#vectors can hold two values (value in x and value in y direction)
var vel: Vector2 = Vector2()  #means how many pixels we're going to be moving per second

onready var sprite : Sprite = get_node("Sprite") #references the sprite node

func _physics_process(delta): #gets called 60 times a second 
	
	vel.x = 0 #initial vel = 0, so it doesnt move automatomatically in x dir
	
	#left and right movements
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
	if Input.is_action_pressed("move_right"):
		vel.x += speed
		
	#starts applying velocity 
	vel = move_and_slide(vel,Vector2.DOWN) 
	
	
	#flips the sprite depending on direction moving
	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
		
func _on_CarCollider_area_entered(area):
	queue_free()
	# maybe show game over? then afer player presses up/down/left right:
	get_tree().change_scene("res://MainMenu.tscn")
	
func _on_LogCollider_area_entered(area):
	pass

func _on_LogCollider_area_exited(area):
	queue_free()
	# maybe show game over? then afer player presses up/down/left right:
	get_tree().change_scene("res://MainMenu.tscn")
