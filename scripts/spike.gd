extends Area2D

@onready var damagetick = $damagetick

var player = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		if !player.dead:
			player._hit(1)
			damagetick.start()


func _on_damagetick_timeout():
	if player:
		if !player.dead:
			player._hit(1)
			damagetick.start()


func _on_body_exited(_body):
	player = null
	damagetick.stop()
