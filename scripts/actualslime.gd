extends Area2D
@onready var AS = $AnimatedSprite2D
@onready var CS = $CollisionShape2D

var SPEED = 60
var direction = 0
# Called when the node enters the scene tree for the first time
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if AS.animation != "die":
		AS.play("default")
		position.x += delta * SPEED * direction
	else:
		if !AS.is_playing():
			queue_free()

func _on_body_entered(body):
	if body.is_in_group("player") and AS.animation != "die":
		body.hit(1, direction)
	AS.play("die")
