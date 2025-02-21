extends Control


func _on_play_pressed() -> void:
	#TransitionAnimations.close()
	#TransitionAnimations.done.connect(
		#func(isOpen: bool):
			#if not isOpen:
				#print("verander nr game scene pls")
	#)
	$AnimationPlayer.play("play")
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	$Settings.visible = !$Settings.visible


func _on_hilde_credits_pressed() -> void:
	pass


func _on_settings_close_request() -> void:
	$Settings.hide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "play":
		TransitionAnimations.open()
		TransitionAnimations.done.connect(
		func(isOpen: bool):
			if isOpen:
				print("verander nr game scene pls")
	)
