extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Hey you, come over here! I am offering the deal of a LIFETIME! You don't want to miss it."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Riea")
		started = true
