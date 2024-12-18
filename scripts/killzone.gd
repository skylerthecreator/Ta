extends Area2D
@onready var mark = $Marker2D


func _on_body_entered(body):
	body.position = mark.position
	body.hit(2, 0)
	
