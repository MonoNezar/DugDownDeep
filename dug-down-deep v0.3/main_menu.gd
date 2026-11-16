extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_Start_pressed() -> void:
	print("Started")
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_Quit_pressed() -> void:
	get_tree().quit()
