extends Node

@export var play_scene: PackedScene


func _on_button_pressed() -> void:
	if play_scene:
		get_tree().change_scene_to_packed(play_scene)
