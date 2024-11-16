extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager
@onready var insufficientfunds = $insufficientfunds
@onready var description = $description


const COST = 8
const SPEED_INC = 25
var player = null

func _ready():
	description.visible = false

func _process(_delta):
	if player and player.buy and game_manager.coins >= COST:
		game_manager.coins -= COST
		player.speed += SPEED_INC
		player.MAX_SPEED += SPEED_INC
		animation_player.play("pickup")
		player = null
	elif player and player.buy and game_manager.coins < COST:
		insufficientfunds.play()
		
func _on_body_entered(body):
	if body.is_in_group("player"):
		description.visible = true
		player = body
		player.buy = false
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		description.visible = false
		player = null
	



