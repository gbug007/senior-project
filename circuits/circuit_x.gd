class_name CircuitX extends Circuit

@onready var voltage_source = $VoltageSource as RigidBody2D
@onready var areas = find_children(
	"ComponentArea*", # pattern
	"Area2D", # type
	false # not recursive
	)

# determine valid circuit based on current flowing through output and 
# valid voltage
func valid_circuit(voltage = 0.0, current = 0.0) -> bool:
	return source_on() and areas[0].is_placed()


func component_entered() -> bool:
	return get_tree().get_first_node_in_group("touching components") != null

func component_placed(resistor: Resistor = null) -> bool:
	for area in areas:
		if area.is_placed() and area.resistor == resistor:
			return true
	return false

# todo: map area to resistor
func place_in_area(component: Resistor) -> void:
	var area = get_tree().get_first_node_in_group("touching components")
	area.add_child(component)
	area.resistor = component
	component.position = Vector2.ZERO
	component = null
	area.mark_as_placed()

func remove_from_area() -> void:
	var area = get_tree().get_first_node_in_group("touching components")
	area.mark_as_unplaced()
