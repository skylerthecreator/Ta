extends StaticBody2D

@onready var game_manager = %GameManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_manager.first_boss_complete:
		queue_free()
