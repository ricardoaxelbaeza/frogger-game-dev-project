extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed : int = 200
var jump_force : int = 600
var gravity : int = 800
var onLog : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#vectors can hold two values (value in x and value in y direction)
var vel: Vector2 = Vector2()  #means how many pixels we're going to be moving per second

onready var sprite : Sprite = get_node("Sprite") #references the sprite node

func _physics_process(delta): #gets called 60 times a second 
	
	vel.x = 0 #initial vel = 0, so it doesnt move automatomatically in x dir
	vel.y = 0 #initial vel = 0, so it doesnt move automatomatically in y dir
	#left and right movements
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
	if Input.is_action_pressed("move_right"):
		vel.x += speed
	if Input.is_action_pressed("move_up"):
		vel.y -= speed
	if Input.is_action_pressed("move_down"):
		vel.y += speed
		
		
	#starts applying velocity 
	vel = move_and_slide(vel.normalized() * speed) 
	
	
	#flips the sprite depending on direction moving
	if vel.x < 0:
		sprite.flip_h = true
		
			
	elif vel.x > 0:
		sprite.flip_h = false
		
	#var y = position.y
	#print (y)
	#if y == 176.382812:
		#print("hello")
	#else:
		#print ("bye")
		
	
	#print(position.y)
func _on_LogCollider_area_entered(area):
	onLog = true

func _on_LogCollider_area_exited(area):
	onLog = false
	if not onLog and position.y < 350:
		GlobalData.lives -= 1
		if GlobalData.lives < 0:
			queue_free()
			# maybe show game over? then afer player presses up/down/left right:
			get_tree().change_scene("res://MainMenu.tscn")
		else:
			get_tree().reload_current_scene()

func _on_CollisionBox_area_entered(area): #whenever player is goint to collide
	if area.is_in_group("Row1Cars") or area.is_in_group("Row2Cars") or area.is_in_group("Row3Cars") or area.is_in_group("Row4Cars") or area.is_in_group("Row5Cars"):
		GlobalData.lives -= 1
		print(GlobalData.lives)
		if GlobalData.lives < 0:
			queue_free()
			# maybe show game over? then afer player presses up/down/left right:
			get_tree().change_scene("res://MainMenu.tscn")
		else:
			get_tree().reload_current_scene()
			
	if area.is_in_group("tile1"):
		print ("hi")
			
	if area.is_in_group("lilypad1"):
		print("at goal 1")
		get_tree().reload_current_scene()

	

	
			

