extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager


var player = null

func _on_body_entered(body):
	player = body
	player.buy = false

func _process(_delta):
	if player and player.buy:
		animation_player.play("pickup")
		game_manager.immunity_unlocked = true
		player = null
		
func _on_body_exited(_body):
	player = null
