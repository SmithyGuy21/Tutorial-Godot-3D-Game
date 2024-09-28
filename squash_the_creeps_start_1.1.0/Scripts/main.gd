extends Node

@export var mob_scene: PackedScene
# Called when the node enters the scene tree for the first time.

func _on_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation
	# choose any % completion of path
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit() -> void:
	$Timer.stop()
	$GameOver.play()
	$MusicPlayer.stop()
	$UserInterface/Retry.show()

func _ready():
	$UserInterface/Retry.hide()
	$Select.play()
	$MusicPlayer.play()
	$Player.on_jump.connect($UserInterface/ScoreLabel.on_jump.bind())

func _unhandled_input(event: InputEvent) -> void:
	if $UserInterface/Retry.visible and event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

#func jump():
