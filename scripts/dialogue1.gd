extends Area2D

@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Ah, look who's finally awake!", 
"You don't remember who or where you are?...",
"You have suffered a great injury. You must've lost your memory from it.",
"I prepared for you a healing potion next to the bed. Don't worry, it's a family recipe!",
"I'm afraid for reasons I cannot say, I am unable to tell you who you are, nor who I am.",
"Although, if you follow the path in front of you, you may regain your memory, but I must warn you, it is not a path that everyone survives.",
"Take my amulet on that table. It will provide you with a layer of great protection."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Maurice")
		started = true
