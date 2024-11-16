extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager
@onready var description = $description

var player = null

func _ready():
	description.visible = false

func _process(_delta):
	if player and player.buy:
		animation_player.play("pickup")
		game_manager.immunity_unlocked = true
		player = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		description.visible = true
		player = body
		player.buy = false
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		description.visible = false
		player = null
