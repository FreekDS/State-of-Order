class_name NPCState
extends Node

signal switchState(oldState: NPCState, requestedState: NPCStateManager.STATE)

@export var character : CharacterBody2D
@export var animations : AnimationPlayer
@export var navAgent : NavigationAgent2D
@export var debug : Label

var possibleNextStates : Array[NPCStateManager.STATE] = []

func setup(char : CharacterBody2D,
		   anim : AnimationPlayer,
		   nav : NavigationAgent2D,
		   debugLabel : Label):
	character = char
	animations = anim
	navAgent = nav
	debug = debugLabel
	

func enter():
	pass


func tick():
	pass


func exit():
	pass
