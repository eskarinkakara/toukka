extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	Global.player_alive = true
	get_tree().change_scene_to_file("res://node.tscn")
	


func _on_options_button_pressed():
	var options = load("res://settings.tscn").instantiate()
	get_tree().current_scene.add_child(options)


func _on_quit_button_pressed():
	get_tree().quit()
