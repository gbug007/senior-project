extends Area2D


var _player_entered = false
var _component_placed = false
var _puzzle: Puzzle

var resistor: Resistor

func _on_body_entered(body: Node2D) -> void:
	_player_entered = true
	add_to_group("touching components")


func _on_body_exited(body: Node2D) -> void:
	_player_entered = false
	remove_from_group("touching components")

func is_placed() -> bool:
	return _component_placed

func get_ohms() -> int:
	if resistor:
		return resistor.resistance_ohms
	return 0

# functions for saying whether the component is in place
func mark_as_placed() -> void:
	_component_placed = true
	

func mark_as_unplaced() -> void:
	_component_placed = false
