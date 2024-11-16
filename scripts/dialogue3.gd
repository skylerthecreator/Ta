extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["You will encounter many monsters on along the way.",
"For now, you must first learn to utilize your agility and avoid them."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines)
		started = true
