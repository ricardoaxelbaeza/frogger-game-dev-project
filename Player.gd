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
var game_over_sound

var active_collision_count = 0
var velocity := Vector2.ZERO

var status = 0
var status2 = 0
var logvelocity = Vector2()

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
	game_over_sound = get_node("../GameOverSound")
  
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
	
func movement():
	if l == 0 && r ==0 && u == 0 && d == 0:
		move_input()

	if turn == true:
		if Input.is_action_pressed("move_left") == false && Input.is_action_pressed("move_right") == false && Input.is_action_pressed("move_up") == false && Input.is_action_pressed("move_down") == false:
			turn = false
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
	
	if status > 0 and status2 == 0:
		global_position.x -= 1.5
	if status == 0 and status2 > 0:
		global_position.x += 1.5
		
#player movement
func move_input(): 
	#left movement
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

func _on_CollisionBox_area_entered(area): #whenever player is goint to collide
	if area.is_in_group("Row1Cars") or area.is_in_group("Row2Cars") or area.is_in_group("Row3Cars") or area.is_in_group("Row4Cars") or area.is_in_group("Row5Cars"):
		if not pause:
			$"../LoseLifeSound".play()
			GlobalData.lives -= 1
			sprite.set_texture(death_texture)
			pause = true
			score_timer.paused = true
		if GlobalData.lives == 0:
			game_over()
		elif GlobalData.lives > 0:
			pause_timer.start()
	  
	if area.is_in_group("log"):
		status += 1
	if area.is_in_group("otherlog"):
		status2 += 1
	  
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
		

func _on_CollisionBox_area_exited(area):
	if area.is_in_group("log"):
		status -= 1
		
		if(status == 0 and status2 == 0):
			GlobalData.lives -= 1
			if GlobalData.lives < 1:
				game_over()
			else:
				sprite.set_texture(death_texture)
				pause = true
				pause_timer.start()
				score_timer.paused = true
				_ready()	
	if area.is_in_group("otherlog"):
		status2 -= 1
		if(status == 0 and status2 == 0):
			GlobalData.lives -= 1
			if GlobalData.lives < 1:
				game_over()
			else:
				sprite.set_texture(death_texture)
				pause = true
				pause_timer.start()
				score_timer.paused = true
				_ready()

func handle_lilypad():
	$"../GoalSound".play()
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
	frog_reset_timer.start(2)
	$"../5FrogsSound".play()

func game_over():
	music.stop()
	game_over_sound.play()
	score_timer.stop()
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
	GlobalData.frog1 = false
	GlobalData.frog2 = false
	GlobalData.frog3 = false
	GlobalData.frog4 = false
	GlobalData.frog5 = false
	position = start_position
	visible = true
	_ready()

func _on_PauseTimer_timeout():
	position = start_position
	visible = true
	_ready()

func _on_GameOverSound_finished():
	queue_free()
	get_tree().change_scene("res://Game Over.tscn")
