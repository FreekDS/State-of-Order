extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_released("grab_character"):
		EventBus.changeCursor.emit(true)
		for child in get_children():
			if child is Police:
				child.noLongerAcceptStouterik()

func _on_characters_guy_dragged(_who: DikkeRon) -> void:
	for child in get_children():
		if child is Police:
			child.enableAcceptStouterik()
