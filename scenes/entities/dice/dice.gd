class_name DiceNode
extends Area2D

@export var is_rolling := false
@export var roll_speed := 10.0
@export var one_shot := false
@export var face: PackedScene

signal finished_rolling

var current_face: Sprite2D

func _ready() -> void:
	if face:
		change_face(face)

@onready var start_rotation := global_rotation


func has_finished_full_rotation() -> bool:
	return rotation >= PI * 2

func handle_rotation(angle: float):
	rotate(angle)
	if one_shot and has_finished_full_rotation():
		is_rolling = false
		finished_rolling.emit()

func _process(delta: float) -> void:
	if is_rolling:
		handle_rotation(delta * roll_speed)
	elif rotation != start_rotation:
		rotation = start_rotation


func change_face(new_face: PackedScene):
	if new_face:
		if current_face:
			current_face.queue_free()
		current_face = new_face.instantiate()
		add_child(current_face)


func roll(new_face: PackedScene):
	change_face(face)
	one_shot = true
	is_rolling = true
	if new_face:
		var callback := change_face.bind(new_face)
		if finished_rolling.is_connected(callback):
			finished_rolling.disconnect(callback)
		finished_rolling.connect(callback)
