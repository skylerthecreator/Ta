extends Area2D

const COINS_PER_APPLE = 2

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager

func _on_body_entered(_body):
	if game_manager.hp < game_manager.MAX_HP:
		game_manager.hp += 1
	else:
		game_manager.coins += COINS_PER_APPLE
	animation_player.play("eating")
