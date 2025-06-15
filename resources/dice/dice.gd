class_name Die
extends Resource

@export var faces: Dictionary[DieFace, int]

func roll() -> DieFace:
	if not faces.size():
		# can't roll an empty die
		return null

	var total_value : int   = faces.values().reduce(func (agg: int, value: int): return agg + value, 0)
	var current_value := 0
	var selected_value := randi_range(0, total_value)
	for item in faces:
		current_value += faces[item]
		# value should be within the aggregate sum
		if selected_value <= current_value:
			return item
	# default to the first face if we were unable to find a face
	return faces.keys()[0]
