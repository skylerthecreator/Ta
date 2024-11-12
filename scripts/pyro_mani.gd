extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %GameManager

var player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player and player.buy:
		game_manager.fireball_unlocked = true
		animation_player.play("pickup")
		player = null

func _on_body_entered(body):
	player = body
	player.buy = false

func _on_body_exited(_body):
	player = null
