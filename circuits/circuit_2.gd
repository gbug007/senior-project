class_name Circuit2 extends Circuit1


func valid_circuit(voltage = 0.0, current = 0.0) -> bool:
	return source_on() and \
		_placed_map == [true, true]
