extends Area2D

@onready var glacial_animation = $glacial_animation
@onready var glacial_shape = $glacial_shape
@onready var slow_time = $slow_time
@onready var shatter = $shatter
@onready var flying = $flying

var SPEED = 300
var cast_dir = 0
var exploding = false
var target = null
var ogs = 0

func _ready():
	flying.play()
func _physics_process(delta):
	if exploding:
		glacial_shape.disabled = true
	else:
		if cast_dir < 0:
			glacial_animation.flip_h = true
		visible = true
		glacial_shape.disabled = false
		glacial_animation.play("shoot")
		position.x += SPEED * delta * cast_dir
	if  glacial_animation.animation == "explode" and !glacial_animation.is_playing():
		glacial_animation.visible = false
		
	
	
func _on_area_entered(area):
	flying.stop()
	shatter.play()
	if area.is_in_group("enemies"):
		area.hit(1)
		ogs = area.SPEED
		target = area
		area.SPEED *= 1.0/2.0
		slow_time.start()
	glacial_animation.play("explode")
	exploding = true;


func _on_body_entered(_body):
	flying.stop()
	shatter.play()
	glacial_animation.play("explode")
	exploding = true




func _on_slow_time_timeout():
	if is_instance_valid(target):
		target.SPEED = ogs
	queue_free()
