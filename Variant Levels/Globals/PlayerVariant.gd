extends KinematicBody2D

var speed : int = 200
var jump_force : int = 600
var gravity : int = 800
var onLog : bool = true

var tile_size = 32 # change by multiples of 4
var turn = false
var move_speed = 4

var l = 0
var r = 0
var u = 0
var d = 0

var score_timer
var second_timer
var pause_timer
var start_position
var pause = false

var frog_texture = preload("res://Art/Frog.png")
var death_texture = preload("res://Art/FrogDeath.png")

var jump_sound
var music
var game_over_sound
var music_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	score_timer = get_node("../ScoreTimer")
	second_timer = get_node("../SecondTimer")
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
	if not music_playing:
		music.play()
		music_playing = true

#vectors can hold two values (value in x and value in y direction)
var vel: Vector2 = Vector2()  #means how many pixels we're going to be moving per second

onready var sprite : Sprite = get_node("Sprite") #references the sprite node

	
func _process(delta): #gets called 60 times a second
	if not pause:
		movement()
	
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
		lose_life()
			
	if area.is_in_group("Door"):
		if(GlobalData.key_found == true):
			print("key has been found")
			handle_score()
			$"../WinSound".play()
		else: 
			print("please find key")
			$"../NoKeySound".play()

func game_over():
	music.stop()
	handle_score()
	if not pause:
		game_over_sound.play()
	score_timer.stop()
	GlobalData.key_found = false

func lose_life():
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

func handle_score():
	print(get_tree().get_current_scene().get_name())
	if get_tree().get_current_scene().get_name() == "Level1":
		GlobalData.score_1 = GlobalData.score
		print(GlobalData.score_1)
	if get_tree().get_current_scene().get_name() == "Level2":
		GlobalData.score_2 = GlobalData.score
		print(GlobalData.score_2)
	if get_tree().get_current_scene().get_name() == "Level3":
		GlobalData.score_3 = GlobalData.score
		print(GlobalData.score_3)
	if get_tree().get_current_scene().get_name() == "Level4":
		GlobalData.score_4 = GlobalData.score
		print(GlobalData.score_4)
	GlobalData.total_score = GlobalData.score_1 + GlobalData.score_2 + GlobalData.score_3 + GlobalData.score_4

func _on_SecondTimer_timeout():
	GlobalData.time = round(score_timer.get_time_left())

func _on_ScoreTimer_timeout():
	lose_life()

func _pause():
	if Input.is_action_pressed("ui_cancel"):
		#bring up menu over screen; pause game; allow exiting of pause menu
		# exit to main menu if player chooses
		pass
	pass

func _on_PauseTimer_timeout():
	position = start_position
	visible = true
	_ready()

func _on_GameOverSound_finished():
	queue_free()
	get_tree().change_scene("res://Game Over.tscn")
