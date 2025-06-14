extends Node2D

@onready var die := %dice

func _on_button_pressed() -> void:
	die.roll()
