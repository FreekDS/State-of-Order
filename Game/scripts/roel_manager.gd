extends Node

@export var dayRules : DayResource


func _ready() -> void:
	EventBus.guyCaptured.connect(_on_guy_captured)
	
	
func _on_guy_captured(who: DikkeRon):
	
	var traits := who.obtainTraits()
	
	for trat in traits:
		if trat in dayRules.disallowedTraits:
			EventBus.successfulCapture.emit(who, dayRules.score)
			return
			
	var states := who.obtainCurrentStates()
	
	for state in states:
		if state in dayRules.disallowedActions:
			EventBus.successfulCapture.emit(who, dayRules.score)
			return
	
	EventBus.wrongCapture.emit(who, dayRules.score)
	
