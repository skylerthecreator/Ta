extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	if body.hp < body.MAX_HP:
		body.hp += 1
	animation_player.play("eating")

