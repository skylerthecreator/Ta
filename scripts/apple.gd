extends Area2D

const COINS_PER_APPLE = 2

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager

func _on_body_entered(body):
	if body.hp < body.MAX_HP:
		body.hp += 1
	else:
		for i in range(COINS_PER_APPLE):
			game_manager.add_pt()
		
	animation_player.play("eating")
