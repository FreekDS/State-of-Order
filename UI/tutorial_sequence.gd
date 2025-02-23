extends Node2D



var sequences = [
	"camera_move",
	"pause info",
	"drag"
]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var curr = 0

var canAdvance = true

func _ready() -> void:
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play(sequences[curr])
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and canAdvance:
		if event.button_index == MOUSE_BUTTON_LEFT:
			curr += 1
			canAdvance = false
			await get_tree().create_timer(.1).timeout
			
			if curr >= len(sequences):
				Globals.playedTutorial = true
				get_tree().change_scene_to_file("res://UI/Menu.tscn")
				return
			
			animation_player.play("RESET")
			await animation_player.animation_finished
			animation_player.play(sequences[curr])
			
			get_tree().create_timer(1).timeout
			canAdvance = true
			
