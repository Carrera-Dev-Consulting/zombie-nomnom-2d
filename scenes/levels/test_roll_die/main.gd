extends Node2D

@onready var die := %dice
@export var die_face : Array[PackedScene]

func _on_button_pressed() -> void:
	var choice := randi() % die_face.size()
	print(choice, die_face[choice])
	die.roll(die_face[choice])
