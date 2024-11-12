extends Area2D

@onready var game_manager = %GameManager
@onready var pickup = $pickup
@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	game_manager.coins += 1
	animation_player.play("pickupanimation")
