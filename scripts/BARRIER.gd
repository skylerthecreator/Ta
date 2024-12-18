extends StaticBody2D

@onready var game_manager = %GameManager
@onready var block = $block

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_manager.first_boss_complete:
		queue_free()
		#block.disabled = true
		#barrier.visible = false
		#portal.disabled = false
