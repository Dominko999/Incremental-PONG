extends Node


func scale_up_and_down(object : Object, scale_up_size : float, scale_down_size : float, scale_up_time : float, scale_down_time : float):
	if object is Control:
		object.pivot_offset = object.size / 2
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(object, "scale", scale_up_size * Vector2.ONE, scale_up_time)
	tween.tween_property(object, "scale", scale_down_size * Vector2.ONE, scale_down_time)
	await tween.finished

func shake(object : Object, shake_force : float, shake_duration : float):
	
	var original_rotation = object.rotation_degrees
	
	if object is Control:
		object.pivot_offset = object.size / 2

	var tween = create_tween()

	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	var shake_interval = 0.05
	
	var steps = int(shake_duration / shake_interval)
	
	for i in range(steps):
		var damping = 1.0 - (float(i) / float(steps))
		var current_strength = shake_force * damping
		
		var random_rotation = randf_range(-current_strength, current_strength)
		var target_rot = original_rotation + random_rotation
		
		tween.tween_property(object, "rotation_degrees", target_rot, shake_interval)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
			
	tween.tween_property(object, "rotation_degrees", original_rotation, shake_interval)
	
	await tween.finished

func flash(object : Object, flash_color : Color, flash_duration : float):
	
	var original_color = object.modulate
	
	var tween = create_tween()
	
	tween.tween_property(object, "modulate", flash_color, flash_duration)
	tween.tween_property(object, "modulate", original_color, flash_duration)
	await tween.finished
