extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Psst... down here! I have the deal of a LIFETIME! Just for you!"]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Riea")
		started = true
