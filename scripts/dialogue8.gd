extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Well done! That wasn't so difficult now was it?",
"However, for what's to come next, you will need a little bit of... firepower.",
"Accept my gift, just up ahead on that hill."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Maurice")
		started = true
