extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed : int = 200
var jump_force : int = 600
var gravity : int = 800
var onLog : bool = false


var tile_size = 32 # change by multiples of 4
var turn = false
var move_speed = 4

var l = 0
var r = 0
var u = 0
var d = 0

var score_timer
var second_timer
var frog_reset_timer
var pause_timer
var start_position
var pause = false

var frog_texture = preload("../Art/Frog.png")
var death_texture = preload("../Art/FrogDeath.png")

var jump_sound
var music

var active_collision_count = 0
var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	score_timer = get_node("../ScoreTimer")
	second_timer = get_node("../SecondTimer")
	frog_reset_timer = get_node("../FrogResetTimer")
	pause_timer = get_node("../PauseTimer")
	start_position = $"../StartPosition".position
	sprite.set_texture(frog_texture)
	jump_sound = get_node("../JumpSound")
	music = get_node("../Music")
	if (score_timer.paused == true):
		score_timer.paused = false
		score_timer.stop()
	pause = false
	score_timer.start(30)
	second_timer.start()
	music.play()


#vectors can hold two values (value in x and value in y direction)
var vel: Vector2 = Vector2()  #means how many pixels we're going to be moving per second

onready var sprite : Sprite = get_node("Sprite") #references the sprite node

	
func _process(delta): #gets called 60 times a second
	if not pause:
		movement()
	$"../Lilypads/Lilypad1/Success1".visible = GlobalData.frog1
	$"../Lilypads/Lilypad2/Success1".visible = GlobalData.frog2
	$"../Lilypads/Lilypad3/Success1".visible = GlobalData.frog3
	$"../Lilypads/Lilypad4/Success1".visible = GlobalData.frog4
	$"../Lilypads/Lilypad5/Success1".visible = GlobalData.frog5
	
	# reset frogs after all goals have been reached
	if not frog_reset_timer.is_stopped():
		if frog_reset_timer.get_time_left() <= 5:
			GlobalData.frog1 = false
		if frog_reset_timer.get_time_left() <= 4:
			GlobalData.frog2 = false
		if frog_reset_timer.get_time_left() <= 3:
			GlobalData.frog3 = false
		if frog_reset_timer.get_time_left() <= 2:
			GlobalData.frog4 = false
		if frog_reset_timer.get_time_left() <= 1:
			GlobalData.frog5 = false
	
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
		jump_sound.play()
	#right movement
	if Input.is_action_pressed("move_right") && $R.is_colliding() == false && turn == false:
		r = tile_size
		turn = true
		jump_sound.play()
	#up movement
	if Input.is_action_pressed("move_up") && $U.is_colliding() == false && turn == false:
		u = tile_size
		turn = true
		GlobalData.score += 10
		jump_sound.play()
	#down movement
	if Input.is_action_pressed("move_down") && $D.is_colliding() == false && turn == false:
		d = tile_size
		turn = true
		jump_sound.play()
	
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
		if GlobalData.lives < 1:
			game_over()
		else:
			sprite.set_texture(death_texture)
			pause = true
			score_timer.paused = true
			pause_timer.start()

	# Player reaches goal areas:
	if area.is_in_group("Lilypad1"):
		GlobalData.frog1 = true
		handle_lilypad()
		
	if area.is_in_group("Lilypad2"):
		GlobalData.frog2 = true
		handle_lilypad()
		
	if area.is_in_group("Lilypad3"):
		GlobalData.frog3 = true
		handle_lilypad()
		
	if area.is_in_group("Lilypad4"):
		GlobalData.frog4 = true
		handle_lilypad()
		
	if area.is_in_group("Lilypad5"):
		GlobalData.frog5 = true
		handle_lilypad()

func handle_lilypad():
	score_timer.paused = true
	# +50 points for getting a frog to the lilypad
	GlobalData.score += 50
	# +10 points for each unused half second left on the timer
	GlobalData.score += floor(score_timer.get_time_left() / 0.5) * 10
	if (GlobalData.frog1 and GlobalData.frog2 and GlobalData.frog3 and GlobalData.frog4 and GlobalData.frog5):
		# +1000 points for getting all 5 frogs to end
		GlobalData.score += 1000
		# reset frogs for replay
		reset_frogs()
	else:
		visible = false
		pause_timer.start()

func reset_frogs():
	score_timer.paused = true
	visible = false
	frog_reset_timer.start(5)

func game_over():
	music.stop()
	score_timer.stop()
	queue_free()
	get_tree().change_scene("res://Game Over.tscn")
	GlobalData.key_found = false

func _on_SecondTimer_timeout():
	GlobalData.time = round(score_timer.get_time_left())

func _on_ScoreTimer_timeout():
	game_over()

func _pause():
	if Input.is_action_pressed("ui_cancel"):
		#bring up menu over screen; pause game; allow exiting of pause menu
		# exit to main menu if player chooses
		pass
	pass

func _on_FrogResetTimer_timeout():
	position = start_position
	visible = true
	_ready()

func _on_PauseTimer_timeout():
	position = start_position
	visible = true
	_ready()
