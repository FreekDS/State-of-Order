extends TabContainer


signal closeRequest

func _ready() -> void:
	set_tab_disabled(2, true) # Graphics tab is not working yet

func _on_close_pressed():
	closeRequest.emit()
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if !Rect2(position, size).has_point(get_local_mouse_position()):
				closeRequest.emit()
