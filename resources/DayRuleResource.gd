class_name DayResource
extends Resource

@export_range(1,5) var dayNumber := 1
@export var disallowedActions : Array[NPCStateManager.STATE] = []
@export var disallowedTraits : Array[NPCTraitManager.TRAIT] = []

@export var score = 1

@export var isKillDay = false
