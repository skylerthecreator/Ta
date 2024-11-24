extends Area2D

@onready var shape = $shape
@onready var explode = $explode
@onready var explodesound = $explodesound
@onready var end = $end


var charged = false
var SPEED = 500
var cast_dir = 0
var exploding = false

func _physics_process(delta):
	if exploding:
		shape.disabled = true
	elif charged:
		if cast_dir < 0:
			explode.flip_h = true
		visible = true
		shape.disabled = false
		position.x += SPEED * delta * cast_dir
	if exploding and !explode.is_playing():
		explode.visible = false
	
func _on_body_entered(_body):
	queue_free()
	
func _on_area_entered(area):
	explode.visible = true
	exploding = true
	if area.is_in_group("enemies") and !area.is_in_group("ineffective"):
		area.hit(area.MAX_HP)
	explode.visible = true
	explode.play("default")
	explodesound.play()
	end.start()


func _on_end_timeout():
	queue_free()
