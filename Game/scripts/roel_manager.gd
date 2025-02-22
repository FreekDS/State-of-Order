extends Node

@export var dayRules : DayResource


func _ready() -> void:
	EventBus.guyCaptured.connect(_on_guy_captured)
	
	
func _on_guy_captured(who: DikkeRon):
	
	var traits := who.obtainTraits()
	
	var whyStates = []
	var whyTraits = []
	
	for trat in traits:
		if trat in dayRules.disallowedTraits:
			whyTraits.append(trat)
			
	var states := who.obtainCurrentStates()
	
	for state in states:
		if state in dayRules.disallowedActions:
			whyStates.append(state)
	
	if not whyStates.is_empty() or not whyTraits.is_empty():
		EventBus.successfulCapture.emit(who, dayRules.score, whyStates, whyTraits)
	else:
		EventBus.wrongCapture.emit(who, -dayRules.score)
