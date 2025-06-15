class_name DieBag
extends Resource

@export var contents: Dictionary[Die, int] = {}
var current_contents: Dictionary[Die, int] = {}


func reset():
	current_contents = contents.duplicate()

func add_values(agg: int, value: int) -> int:
	return agg + value

func grab_dice(amount: int) -> Array[Die]:
	var total = current_contents.values().reduce(add_values, 0) as int
	if total < amount:
		return []
	var values: Array[Die]  = []
	for i in amount:
		var current := 0
		# only works because each weight counts as one instance
		var selected := randi_range(0, total - values.size())
		for item in current_contents:
			current += current_contents[item]
			if current >= selected:
				current_contents[item] -= 1
				values.append(item.duplicate())
				break
	return values 

func add_dice(dice: Array[Die]) -> void:
	for die in dice:
		# add the die bag to the spot it was in
		current_contents[die] += 1
