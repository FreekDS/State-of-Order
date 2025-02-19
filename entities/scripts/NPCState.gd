class_name NPCState
extends Node

@warning_ignore("unused_signal")
signal switchState(oldState: NPCState)

@export var character : CharacterBody2D
@export var animations : AnimationPlayer
@export var navAgent : NavigationAgent2D
@export var debug : Label

var possibleNextStates : Array[NPCStateManager.STATE] = []

func setup(ch : CharacterBody2D,
		   anim : AnimationPlayer,
		   nav : NavigationAgent2D,
		   debugLabel : Label):
	character = ch
	animations = anim
	navAgent = nav
	debug = debugLabel
	

func enter():
	pass


func tick():
	pass


func exit():
	pass
	
func checkViable()->bool:
	return true
