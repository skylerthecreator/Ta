extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager
@onready var insufficientfunds = $insufficientfunds

const COST = 0
var player = null

func _on_body_entered(body):
	player = body
	player.buy = false

func _process(_delta):
	if player and player.buy and game_manager.coins >= COST:
		game_manager.coins -= COST
		game_manager.amnova_unlocked = true
		animation_player.play("pickup")
		player = null
	elif player and player.buy and game_manager.score < COST:
		insufficientfunds.play()
		
func _on_body_exited(_body):
	player = null
