extends Area2D
@onready var AS = $AnimatedSprite2D
@onready var CS = $CollisionShape2D
@onready var down = $down

var SPEED = 60
var direction = 0
# Called when the node enters the scene tree for the first time
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == 1 and scale.x > 0:
		scale.x *= -1
	if AS.animation != "die":
		AS.play("default")
		position.x += delta * SPEED * direction
		if !down.is_colliding():
			position.y += delta * SPEED
	else:
		if !AS.is_playing():
			queue_free()

func _on_body_entered(body):
	if body.is_in_group("player") and AS.animation != "die":
		body.hit(1, direction)
	AS.play("die")
