extends Label

var score = 0
var score_increment = 100
var is_active: bool = true

func set_is_active(new_value: bool):
	is_active = new_value

func _process(delta: float) -> void:
	if not is_active:
		return
	score += score_increment * delta
	text = str(int(score))
