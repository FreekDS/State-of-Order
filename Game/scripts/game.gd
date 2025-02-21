## Orchestrates the game sequence:
##	- Startup sequence
##	- End screen
##	- Goto next day
##	- After last day, go back to menu
extends Node2D

@export var dayInformation : Array[DayResource] = []

var currentDay = 0


func _ready() -> void:
	EventBus.timesUp.connect(_handleDayEnd)




func _handleDayEnd():
	pass


func _on_start_day_sequence_pls_start_day() -> void:
	EventBus.dayStarted.emit(dayInformation[0])
