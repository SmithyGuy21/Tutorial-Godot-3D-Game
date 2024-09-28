extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

signal squashed

func squash():
	squashed.emit()
	queue_free()
	
func initialize(start_pos, player_pos):
	player_pos.y=0
	look_at_from_position(start_pos, player_pos, Vector3.UP)
	rotate_y(randf_range(-PI/4, PI/4))
	var rand_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD*rand_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer2.speed_scale=1+(rand_speed/min_speed)

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_visible_notifier_screen_exited() -> void:
	queue_free()
