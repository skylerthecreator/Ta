extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	body.hp = body.MAX_HP
	animation_player.play("pickup")
