extends CircuitX


func valid_circuit(voltage = 0.0, current = 0.0) -> bool:
	if source_on() and areas[0].is_placed() and areas[1].is_placed():
			return areas[0].get_ohms() < areas[1].get_ohms()
	return false
