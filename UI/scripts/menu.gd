extends Control

const GAME = preload("res://Game/game.tscn")

@export var hierzo : Sprite2D 

func _ready() -> void:
	if TransitionAnimations.closed:
		TransitionAnimations.close()
	
	if hierzo != null:
		if Globals.playedTutorial == false:
			hierzo.show()
		else:
			hierzo.hide()


func _on_play_pressed() -> void:
	#TransitionAnimations.close()
	#TransitionAnimations.done.connect(
		#func(isOpen: bool):
			#if not isOpen:
				#print("verander nr game scene pls")
	#)
	$AnimationPlayer.play("play")
	await $AnimationPlayer.animation_finished
	TransitionAnimations.open()
	await TransitionAnimations.done
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(GAME)


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


func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/tutorial_sequence.tscn")
