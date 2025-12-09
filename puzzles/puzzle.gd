class_name Puzzle extends Node2D


signal resistor_interact(component: Resistor)
signal exit()


@onready var button := $Button as Area2D
@onready var button_timer := $ButtonTimer as Timer
@onready var area_exit := $AreaExit as Area2D
@onready var player := $Player as Player
@onready var hand := $Player/Hand as Node2D
@onready var exit_text := $ExitText as RichTextLabel

var _circuit : Circuit
var _timed_out := true
var _button_entered := false
var _exit_entered := false
var _door_open := false
var _holding_resistor := false
var _joint = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_circuit = find_child("Circuit*", false)
	
	var children = get_children()
	for child in children:
		if child is Resistor:
			child.set_puzzle(self)
	
	exit_text.visible = false
	area_exit.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _button_pressed():
		print("button pressed")
		# toggle power source
		_circuit.toggle_source()
		_timed_out = false
		button_timer.start()
		
	_change_scenes()
	
	if _circuit.valid_circuit() and not _door_open:
		# open door when puzzle is valid
		print("door open")
		exit_text.visible = true
		area_exit.enable_door()
		_door_open = true
	elif not _circuit.valid_circuit() and _door_open:
		# close door when puzzle is invalid
		print("door closed")
		area_exit.disable_door()
		_door_open = false

func _change_scenes():
	if name == "Puzzle" and _exited_area():
		get_tree().change_scene_to_file("res://puzzles/puzzle_1.tscn")
	elif name == "Puzzle1" and _exited_area():
		get_tree().change_scene_to_file("res://puzzles/puzzle_2.tscn")
	elif name == "Puzzle2" and _exited_area():
		get_tree().change_scene_to_file("res://puzzles/puzzle_3.tscn")
	elif name == "Puzzle3" and _exited_area():
		get_tree().change_scene_to_file("res://end_screen.tscn")

func _button_pressed():
	return _timed_out and _button_entered and \
	Input.is_action_just_pressed("interact")
	
func _exited_area():
	return _exit_entered and \
	Input.is_action_just_pressed("interact")


func _on_button_body_entered(body: Node2D) -> void:
	_button_entered = true
	
	
func _on_button_body_exited(body: Node2D) -> void:
	_button_entered = false


func _on_button_timer_timeout() -> void:
	button_timer.stop()
	_timed_out = true


# picks up component if touching
func pickup_component(resistor: Resistor):
	print("attempting to pickup component")
	if _circuit.component_placed(resistor):
		_circuit.remove_from_area()

	resistor.set_freeze_enabled(true)
	resistor.get_parent().remove_child(resistor)
	hand.add_child(resistor)
	resistor.position = Vector2.ZERO


# detects if component has a valid placement in the circuit
func place_component(resistor: Resistor):
	# remove resistor from hand
	hand.remove_child(resistor)
	
	# place resistor or drop it
	if _circuit.component_entered():
		print("component in place")
		_circuit.place_in_area(resistor)
	else:
		drop_resistor(resistor)


# drop resistor on the ground
func drop_resistor(resistor: Resistor):
	resistor.set_freeze_enabled(false)
	add_child(resistor)
	resistor.global_position = hand.global_position
	resistor = null


func _on_resistor_interact(resistor: Resistor) -> void:
	print("interacted!")
	if _holding_resistor:
		_holding_resistor = false
		place_component(resistor)
	else:
		pickup_component(resistor)
		_holding_resistor = true


func _on_area_exit_body_entered(body: Node2D) -> void:
	_exit_entered = true


func _on_area_exit_body_exited(body: Node2D) -> void:
	_exit_entered = false
