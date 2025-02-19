class_name Police
extends Area2D


var _canAcceptStouterik := false


var pendingStouterik : DikkeRon = null


func enableAcceptStouterik():
	_canAcceptStouterik = true
	monitoring = true


func noLongerAcceptStouterik():
	_canAcceptStouterik = false
	monitoring = false


func _input(event: InputEvent) -> void:
	if event.is_action_released("grab_character") and pendingStouterik != null:
		EventBus.guyCaptured.emit(pendingStouterik)
		pendingStouterik.die()
		pendingStouterik = null
		$highlight.hide()


func _on_body_entered(body: Node2D) -> void:
	if body is DikkeRon:
		if body.selected:
			pendingStouterik = body
			$highlight.show()


func _on_body_exited(body: Node2D) -> void:
	if body == pendingStouterik:
		pendingStouterik = null
		$highlight.hide()
