extends StaticBody2D

@onready var game_manager = %GameManager
@onready var block = $block
@onready var next = $next
@onready var marker_2d = $next/Marker2D
@onready var portal = $next/portal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_manager.first_boss_complete:
		block.disabled = true
		portal.disabled = false


func _on_next_body_entered(body):
	if body.is_in_group("player"):
		body.position = marker_2d.position
