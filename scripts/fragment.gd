extends Area2D


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	if body.is_in_group("player"):
		description.visible = true
		player = body
		player.buy = false
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		description.visible = false
		player = null
