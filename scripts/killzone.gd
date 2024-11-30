extends Area2D


func _on_body_entered(body):
	print("detected")
	body._die()
