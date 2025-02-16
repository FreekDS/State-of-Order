extends Control


func _on_play_pressed() -> void:
	TransitionAnimations.close()
	TransitionAnimations.done.connect(
		func(isOpen: bool):
			if not isOpen:
				print("verander nr game scene pls")
	)
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	$CreditsContainer.visible = !$CreditsContainer.visible


func _on_hilde_credits_pressed() -> void:
	pass


func _on_settings_close_request() -> void:
	$CreditsContainer.hide()
