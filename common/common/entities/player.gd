extends Node3D

func _get_local_input() -> Dictionary:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input := {}
	if input_vector != Vector2.ZERO:
		input["input_vector"] = input_vector
	return input

func _network_process(input: Dictionary) -> void:
	var input_vec = input.get("input_vector", Vector2.ZERO)
	position += Vector3(input_vec.x, 0, input_vec.y)

func _save_state() -> Dictionary:
	return {
		position = position
	}

func _load_state(state: Dictionary) -> void:
	position = state['position']
