extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["These golden coins will be very beneficial as you venture deeper into your journey.",
"I advise you to collect as many as you can... but beware of the traps!",
"Also beware of cliffs! Falling will lead to a very painful death..."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines)
		started = true
