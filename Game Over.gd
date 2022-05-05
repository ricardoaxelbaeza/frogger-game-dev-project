extends CanvasLayer



func _on_RestartButton_pressed():
	get_tree().change_scene("res://MainScene.tscn")
	GlobalData.lives = 5

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
