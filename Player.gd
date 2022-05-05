extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed : int = 200
var jump_force : int = 600
var gravity : int = 800
var onLog : bool = true

var tile_size = 20
var turn = false
var move_speed = 4

var timer = 90000000

var l = 0
var r = 0
var u = 0
var d = 0

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#vectors can hold two values (value in x and value in y direction)
var vel: Vector2 = Vector2()  #means how many pixels we're going to be moving per second

onready var sprite : Sprite = get_node("Sprite") #references the sprite node

	
func _physics_process(delta): #gets called 60 times a second 
	movement()
	
func movement():
	if l == 0 && r ==0 && u == 0 && d == 0:
		move_input()

	if turn == true:
		if Input.is_action_pressed("move_left") == false && Input.is_action_pressed("move_right") == false && Input.is_action_pressed("move_up") == false && Input.is_action_pressed("move_down") == false:
			turn = false
	#print (l)
	if l != 0:
		global_position.x -= move_speed
		l -= move_speed
	if r != 0:
		global_position.x += move_speed
		r -= move_speed
	if u != 0:
		global_position.y -= move_speed
		u -= move_speed
	if d != 0:
		global_position.y += move_speed
		d -= move_speed
	vel = move_and_slide(vel.normalized() * speed) 
		
#player movement
func move_input(): 
	#left movement
	#print(turn)
	if Input.is_action_pressed("move_left") && $L.is_colliding() == false && turn == false:
		l = tile_size
		turn = true
	#right movement
	if Input.is_action_pressed("move_right") && $R.is_colliding() == false && turn == false:
		r = tile_size
		turn = true
	#up movement
	if Input.is_action_pressed("move_up") && $U.is_colliding() == false && turn == false:
		u = tile_size
		turn = true
	#down movement
	if Input.is_action_pressed("move_down") && $D.is_colliding() == false && turn == false:
		d = tile_size
		turn = true
	
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
			
			
func _process(delta):
	if timer > 0:
		timer -= delta
	else: 
		return

func _on_CollisionBox_area_entered(area): #whenever player is goint to collide
	if area.is_in_group("Row1Cars") or area.is_in_group("Row2Cars") or area.is_in_group("Row3Cars") or area.is_in_group("Row4Cars"):
		GlobalData.lives -= 1
		#print(GlobalData.lives)
		if GlobalData.lives < 1:
			queue_free()
			# maybe show game over? then afer player presses up/down/left right:
			get_tree().change_scene("res://Game Over.tscn")
			
		else:
			get_tree().reload_current_scene()
	
	
			
		

func _on_FirstGoal_area_entered(area):
	if area.is_in_group("endgoal1"): 
		print("hi")

