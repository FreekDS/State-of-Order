class_name NPCStateManager
extends Node2D

@export var characterBody : CharacterBody2D
@export var navigationAgent: NavigationAgent2D
@export var animations : AnimationPlayer

@export var detectOthers : Area2D

@export var debug: Label


enum STATE {
	
	
	WANDER_AIMLESS,
	TALK_TO_SOMEONE,
	STANDSTILL,
	
	LEAVING,
	INCOMING,
	
	SHOOT_SOMEONE,
	HIT_SOMEONE,
	SMOKING,
	WATCH_TV,
	SWIM_IN_FONTAIN,
	PROTEST,
	RUN,
	USE_TRAIN,
}

@onready var stateMap = {
	STATE.WANDER_AIMLESS: $WANDER_AIMLESS,
	STATE.TALK_TO_SOMEONE: $TALK_TO_SOMEONE,
	STATE.STANDSTILL: $IDLE,
}



var _targetState : STATE = STATE.WANDER_AIMLESS


var navigationMap : RID

var _state : NPCState = null
var speed = 50
var targetPoint := Vector2.ZERO

var _buren=[]

func _ready():
	for child in get_children():
		if child is NPCState:
			child.setup(
				characterBody,
				animations,
				navigationAgent,
				debug
			)
			child.switchState.connect(_on_state_switch_requested)
	
	# Make sure nav map is available with the following hack
	set_physics_process(false)
	set_physics_process.call_deferred(true)
	
	_state = stateMap[STATE.WANDER_AIMLESS]
	_state.enter()



func _on_state_switch_requested(oldState: NPCState):
	oldState.exit()
	var newstate = oldState.possibleNextStates.pick_random()
	while not stateMap[newstate].checkViable():
		newstate = oldState.possibleNextStates.pick_random()
	_state = stateMap[newstate]
	_state.enter()


func _physics_process(_delta: float) -> void:
	if _state != null:
		_state.tick()

func recalculateRoute():
	navigationAgent.target_position = navigationAgent.target_position

func getViableNextStates():
	return _state.possibleNextStates

# Praten wordt via 1 user gedaan, dus als die stops moet ge bij den andere een volgende staat enforcen
func enforceNextState():
	#signal functie gebruiken voor niet signal, freek gaat blij zijn
	_on_state_switch_requested(_state)
	
#Voor praten of schieten ofzo moet ge meerdere characters samen iets laten doen
func enforceState(sate: STATE):
	_state.exit()	
	_state = stateMap[sate]
	_state.enter()

# Mogelijke states:
#	NORMAL, gewoon wat rondwandelen op het plein. Mss kunnen we versch behaviors proberen makne?
#				- bv: gaat nr markt, wandelt door het park, wandelt doelloos rond, zo'n dingen
#	
# 	Dan states die aanduiden wat de guys doen da ni mag.
#	Sommige dingen mogen standaard ni, zoals wapendracht ofzo, ma das eerder een trait, ni echt de purpose
#	van deze class pakt
#	
#	Acties kunnen enkel on screen gebeuren mss?
#	
#	Voorbeelden van wat hier kan gedaan worden:
#		- Shooting another guy
#		- Fruit pikken van de marktkramer(s)
#		- vuilbak omgooien
#		- rick ashley muziek afspelen
#		- Hond zonder leiband
#	
#	Na een actie lopen de guys mss gewoon weg? Guys die actie verricht hebben moogt ge ook nog pakken vr punten
