extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Welcome, valued customer! Please, browse our selection of the RAREST items all around Vatereo! Allpurchasesarefinal-"]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Riea")
		started = true
