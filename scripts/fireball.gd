extends Area2D

@onready var fireball_animation = $fireball_animation
@onready var fireball_shape = $fireball_shape
@onready var fireball_hit = $fireball_hit
@onready var fireball_land = $fireball_land
@onready var fireball_blast = $fireball_blast

var charged = false
var SPEED = 150
var cast_dir = 0
var exploding = false
var adjusted = false

func _physics_process(delta):
	if exploding:
		pass
	elif charged:
		if cast_dir < 0 and !adjusted:
			fireball_animation.flip_h = true
			fireball_shape.position.x -= 2.2
			adjusted = true
		visible = true
		fireball_shape.disabled = false
		fireball_animation.play("shoot")
		fireball_hit.play()
		position.x += SPEED * delta * cast_dir
	if fireball_animation.animation == "explode" and !fireball_animation.is_playing():
		fireball_animation.visible = false
	
func _on_body_entered(body):
	fireball_hit.stop()
	fireball_land.play()
	fireball_animation.play("explode")
	fireball_blast.start()
	charged = false
	exploding = true
func _on_area_entered(area):
	fireball_hit.stop()
	if area.is_in_group("enemies"):
		#areas0.append(area)
		area.hit = true
	fireball_land.play()
	fireball_animation.play("explode")
	fireball_blast.start()
	charged = false
	exploding = true


func _on_fireball_blast_timeout():
	queue_free()



