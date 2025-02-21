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
