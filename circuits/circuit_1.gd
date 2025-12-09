class_name Circuit1 extends Circuit

@onready var _area0 := $ComponentArea0 as Area2D
@onready var _area1 := $ComponentArea1 as Area2D
@onready var _area_map = [_area0, _area1]

var _entered_map = [false, false]
var _placed_map = [false, false]


# finds area connected to resistor
# or -1 if none
func _get_index_touching() -> int:
	for i in range(len(_entered_map)):
		if _entered_map[i]:
			print("touching ", i)
			return i
	return -1


func valid_circuit(voltage = 0.0, current = 0.0) -> bool:
	return source_on() and \
		_placed_map[1] == true


# checks if resistor is touching an area
func component_entered() -> bool:
	for val in _entered_map:
		if val:
			return true
	return false


# checks if resistor is placed
func component_placed(resistor: Resistor = null) -> bool:
	var i = _get_index_touching()
	if i >= 0:
		return _placed_map[i]
	return false


# places component in one of the areas
func place_in_area(component: Resistor) -> void:
	var i = _get_index_touching()
	if i >= 0:
		_area_map[i].add_child(component)
		component.position = Vector2.ZERO
		component = null
		_placed_map[i] = true
	else:
		print("invalid area")


# removes component from one of the areas
func remove_from_area() -> void:
	var i = _get_index_touching()
	if i >= 0:
		_placed_map[i] = false


func _on_component_area_0_body_entered(body: Node2D) -> void:
	_entered_map[0] = true


func _on_component_area_0_body_exited(body: Node2D) -> void:
	_entered_map[0] = false


func _on_component_area_1_body_entered(body: Node2D) -> void:
	_entered_map[1] = true


func _on_component_area_1_body_exited(body: Node2D) -> void:
	_entered_map[1] = false
