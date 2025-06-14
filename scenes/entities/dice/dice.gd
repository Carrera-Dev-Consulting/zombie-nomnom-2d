class_name DiceNode
extends Area2D

@export var is_rolling := false
@export var roll_speed := 10.0
@export var one_shot := false
@export var face: PackedScene

func _ready() -> void:
	if face:
		add_child(face.instantiate())

@onready var start_rotation := global_rotation


func has_finished_full_rotation() -> bool:
	return rotation >= PI * 2

func handle_rotation(angle: float):
	rotate(angle)
	
	if one_shot and has_finished_full_rotation():
		is_rolling = false

func _process(delta: float) -> void:
	if is_rolling:
		handle_rotation(delta * roll_speed)
	elif global_rotation != start_rotation:
		rotation = start_rotation

func roll():
	one_shot = true
	is_rolling = true
