extends Control

const GAME = preload("res://Game/game.tscn")

@export var hierzo : Sprite2D 

func _ready() -> void:
	if TransitionAnimations.closed:
		TransitionAnimations.close()
	
	if hierzo != null:
		if Globals.playedTutorial == false:
			$HBoxContainer/Play.modulate = Color.DARK_GRAY
			hierzo.show()
		else:
			$HBoxContainer/Play.modulate = Color.WHITE
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
	$HBoxContainer.visible=false
	$CreditsContainer.visible=true
	$TextureRect.visible=false

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


func _on_go_back_pressed() -> void:
	$HBoxContainer.visible=true
	$CreditsContainer.visible=false
	$TextureRect.visible=true
