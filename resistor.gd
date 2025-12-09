class_name Resistor extends RigidBody2D


@onready var resistor_pickup_timer := $ResistorPickupTimer as Timer
@export var resistance_ohms: int


var _touching_player := false
var _resistor_timed_out := true
var _puzzle : Puzzle

func _ready() -> void:
	if resistance_ohms:
		$Label.text = str(resistance_ohms)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _resistor_timed_out and _touching_player and \
	Input.is_action_just_pressed("interact"):
		_puzzle.resistor_interact.emit(self)
		_resistor_timed_out = false
		resistor_pickup_timer.start()


func set_puzzle(puzzle: Puzzle) -> void:
	_puzzle = puzzle


func _on_resistor_pickup_timer_timeout() -> void:
	resistor_pickup_timer.stop()
	_resistor_timed_out = true


func _on_area_2d_body_entered(body: Player) -> void:
	_touching_player = true


func _on_area_2d_body_exited(body: Player) -> void:
	_touching_player = false
