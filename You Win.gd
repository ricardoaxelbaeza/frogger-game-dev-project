extends CanvasLayer


func _on_RestartButton_pressed():
	get_tree().change_scene("res://Variant Levels/Level1.tscn")
	GlobalData.lives = 5
	GlobalData.score = 0
	GlobalData.time = 30
	GlobalData.frog1 = false
	GlobalData.frog2 = false
	GlobalData.frog3 = false
	GlobalData.frog4 = false
	GlobalData.frog5 = false

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
