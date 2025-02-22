class_name NPCState
extends Node

@warning_ignore("unused_signal")
signal switchState(oldState: NPCState)

@export var character : DikkeRon
@export var animations : AnimationPlayer
@export var navAgent : NavigationAgent2D
@export var debug : Label

var possibleNextStates : Array[NPCStateManager.STATE] = []
var nextStatesWeigths : Array[int] = []

func setup(ch : DikkeRon,
		   anim : AnimationPlayer,
		   nav : NavigationAgent2D,
		   debugLabel : Label):
	character = ch
	animations = anim
	navAgent = nav
	debug = debugLabel
	

func enter():
	pass


func tick(delta: float):
	pass


func exit():
	pass
	
func checkViable()->bool:
	return true

func onDrag():
	pass
	
func onDragEnd():
	pass
	
## Some states have substates that are not part of the main violating state:
## e.g. when walking towards the fountain to swim, this is not forbidden
func isMainActionBusy():
	return true
