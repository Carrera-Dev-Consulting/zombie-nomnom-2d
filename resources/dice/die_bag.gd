class_name DieBag
extends Resource

@export var contents: Dictionary[Die, int]
var current_contents: Dictionary[Die, int]


func reset():
	current_contents = contents.duplicate()
	
func grab_dice(amount: int) -> Array[Die]:
	return []
