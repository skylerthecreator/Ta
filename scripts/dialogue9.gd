extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Your first spell! Or rather, a reminder of a spell you already knew...",
"Here, test it out against these training dummies. When you're ready, the final challenge of this area awaits you below."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Maurice")
		started = true
