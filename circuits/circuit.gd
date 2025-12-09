class_name Circuit extends Node2D


@onready var _source := $VoltageSource as RigidBody2D
@onready var _area := $ComponentArea as Area2D

var _component_in_area := false
var _component_in_place := false


## kept methods

func toggle_source() -> void:
	_source.visible = not _source.visible

	
func source_on() -> bool:
	return _source.visible


func valid_circuit(voltage = 0.0, current = 0.0) -> bool:
	return source_on() and _component_in_place


## overridden methods

func _get_touching() -> Resistor:
	var touching = get_tree().get_first_node_in_group("touching components")
	print(touching)
	return touching


func component_entered() -> bool:
	return _component_in_area


func component_placed(resistor: Resistor = null) -> bool:
	return _component_in_place


func place_in_area(component: Resistor) -> void:
	_area.add_child(component)
	component.position = Vector2.ZERO
	component = null
	_component_in_place = true


func remove_from_area() -> void:
	_component_in_place = false


func _on_component_area_body_entered(body: Node2D) -> void:
	_component_in_area = true


func _on_component_area_body_exited(body: Node2D) -> void:
	_component_in_area = false
