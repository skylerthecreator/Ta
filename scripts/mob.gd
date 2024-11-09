extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body.hp > 1:
		body.hp -= 1
		body.hit = true
	else:
		Engine.time_scale = 0.5
		body.hit = true
		body.dead = true
		timer.start()
	

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func take_damage():
	print("damage taken")
