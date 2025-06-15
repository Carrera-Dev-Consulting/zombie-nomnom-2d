class_name DieManager
extends Node

@export var bag: DieBag
@export var default_draw := 3
@export var hand_dice: Array[DiceNode]
@export var dice_container: Node
@export var max_shots := 3
@export var columns := 3
@export var SIZE := 64
@export var score_label: Label
@export var winner_screen: PackedScene

signal has_player_died

var current_shots := 0
var total_points := 0
var is_dead := false
var is_game_over := false
var current_hand: Array[Die] = []
var die_on_table: Array[Die] = []

func _ready() -> void:
	bag.reset() # make sure we setup the bag
	for die in hand_dice:
		die.hide()
	%"Roll Dice".disabled = true
	%"Next Turn".disabled = true

func lock_buttons(locked: bool = true):
	%"Draw Button".disabled = locked
	%"Roll Dice".disabled = locked

func refill_and_grab_bag(draw_amount: int) -> Array[Die]:
	var scored_dice: Array[Die] = []
	var new_die_on_table: Array[Die] = []

	for die in die_on_table:
		if die.current_face.total_brains > 1:
			scored_dice.append(die)
		else:
			new_die_on_table.append(die)
	
	# clear the table
	for node in dice_container.get_children():
		node.queue_free()

	# add dice that remain
	for die in new_die_on_table:
		var child := die.current_face.face.instantiate()
		dice_container.add_child(child)

	die_on_table = new_die_on_table

	bag.add_dice(scored_dice)

	return bag.grab_dice(draw_amount)

func show_dice():
	for die in hand_dice:
		die.show()

func draw_dice():
	if is_dead or is_game_over:
		print("Can't draw dice when you are dead")
		return
	%"Roll Dice".disabled = false
	print("Drawing Dice...")
	current_hand = current_hand.filter(func (die: Die): return die.current_face.is_reroll_die)
	var draw_amount := default_draw - current_hand.size()
	var new_dice: Array[Die] = []
	if not draw_amount:
		print("No dice to draw...")
		show_dice()
		return

	var drawn_dice := bag.grab_dice(draw_amount)
	
	if not drawn_dice:
		print("Refilling bag and trying to draw again...")
		drawn_dice = refill_and_grab_bag(draw_amount)

	if not drawn_dice:
		# second check to ensure dice was drawn..
		print("Failed to draw dice")
		return

	for i in range(current_hand.size(), current_hand.size() + drawn_dice.size()):
		var drawn_index := i - current_hand.size()
		var dice := hand_dice[i]
		dice.change_face(drawn_dice[drawn_index].current_face.face)
	show_dice()
	current_hand.append_array(drawn_dice)
	%"Draw Button".disabled = true

func calculate_position_on_grid() -> Vector2:
	var y_offset := die_on_table.size() / columns
	var x_offset := die_on_table.size() % columns
	return Vector2(SIZE * x_offset, SIZE * y_offset)

func roll_dice():
	if is_dead or is_game_over:
		return
	
	%"Next Turn".disabled = false
	for index in current_hand.size():
		var die: Die = current_hand[index]
		var dice_node := hand_dice[index]
		var die_face = die.roll()
		dice_node.show()
		dice_node.roll(die_face.face)

		if die_face.total_shots:
			current_shots += die_face.total_shots
			var element: Sprite2D = die_face.face.instantiate()
			dice_container.add_child(element)
			element.apply_scale(Vector2(2, 2))
			element.position = calculate_position_on_grid()
			die_on_table.append(die)
			print("Appended Size", die_on_table.size())
		elif die_face.total_brains:
			var element: Sprite2D = die_face.face.instantiate()
			dice_container.add_child(element)
			element.apply_scale(Vector2(2, 2))
			element.position = calculate_position_on_grid()
			die_on_table.append(die)
			print("Appended Size", die_on_table.size())
	is_dead = current_shots >= max_shots
	%"Roll Dice".disabled = true
	if is_dead:
		has_player_died.emit()
		%"Next Turn".text = "Start Next Turn"
		lock_buttons()
	else:
		%"Draw Button".disabled = false

func score_dice():
	total_points += die_on_table.reduce(func (acc:int, die: Die): return  acc + die.current_face.total_brains, 0)
	score_label.text = "Score: %s" % total_points

func reset_player():
	if is_game_over:
		print("Can't reset on an over game.")
		return

	if not is_dead:
		print("Not dead scoring brains...")
		score_dice()

	if total_points >= 13:
		is_game_over = true
		lock_buttons()
		go_to_game_won_screen()
		

	bag.reset()

	for die in hand_dice:
		die.hide()
	
	for child in dice_container.get_children():
		child.queue_free()

	is_dead = false
	current_shots = 0
	current_hand = []
	die_on_table = []
	%"Next Turn".text = "Score Brains"
	lock_buttons(false)

func go_to_game_won_screen():
	if winner_screen:
		print("Winner Screen")
		get_tree().change_scene_to_packed(winner_screen)
	else:
		score_label.text = "You Won!!!"
