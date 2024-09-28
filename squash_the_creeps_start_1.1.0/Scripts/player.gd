extends CharacterBody3D

signal hit
signal on_jump
# Player speed in meters/sec
@export var speed = 14
# downward acceleration in the air, in meters/second^2
@export var fall_acceleration = 75
@export var initial_jump = 21
@export var initial_bounce = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta) -> void:
	var direction = Vector3.ZERO
	#$Pivot.rotation.x = PI / 6 * velocity.y / initial_jump		# jump arc animation
	#print("position.y:", position.y)
	if Input.is_action_pressed("move_right"):
		direction.x+=1
	if Input.is_action_pressed("move_left"):
		direction.x-=1
	if Input.is_action_pressed("move_back"):
		direction.z+=1
	if Input.is_action_pressed("move_forward"):
		direction.z-=1
	if Input.is_action_pressed("jump") and is_on_floor() and position.y<0.23:
		#print("velocity.y:", velocity.y)
		target_velocity.y=initial_jump
		$Jump.play()
		on_jump.emit()
	if direction!=Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis=Basis.looking_at(direction)	# Player looks the way it is moving
		$AnimationPlayer.speed_scale=2
	else:
		$AnimationPlayer.speed_scale=1
	
	target_velocity.x= direction.x*speed
	target_velocity.z= direction.z*speed
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration*delta)
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				if Input.is_action_pressed("jump"):
					$Jump.play()
					target_velocity.y = initial_jump
				else:
					$ShortHop.play()
					target_velocity.y = initial_bounce
				break
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()


func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
