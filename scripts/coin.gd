extends Area2D

@onready var game_manager = %GameManager
@onready var pickup = $pickup
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	game_manager.add_pt()
	animation_player.play("pickupanimation")
	body.coins += 1
