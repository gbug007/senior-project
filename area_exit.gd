extends Area2D
# door behavior script

func _process(delta: float) -> void:
	rotation_degrees += 50 * delta
	
func enable_door():
	monitoring = true
	visible = true
	
	
func disable_door():
	monitoring = false
	visible = false
