extends Area2D

@onready var animation_player = $AnimationPlayer


var player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and player.buy:
		player.skill0 = true
		animation_player.play("pickup")
		player = null

func _on_body_entered(body):
	player = body
	player.buy = false

func _on_body_exited(body):
	player = null
