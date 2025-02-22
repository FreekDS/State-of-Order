class_name NPCStateManager
extends Node2D

@export var characterBody : DikkeRon
@export var navigationAgent: NavigationAgent2D
@export var animations : AnimationPlayer

@export var detectOthers : Area2D

@export var debug: Label


enum STATE {
	
	_WAIT_DAYSTART,
	
	WANDER_AIMLESS,
	TALK_TO_SOMEONE,
	STANDSTILL,
	
	LEAVING,
	INCOMING,
	DEAD,
	
	HODL_GUN,
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
	STATE._WAIT_DAYSTART: $_WAIT_DAYSTART,
	STATE.WANDER_AIMLESS: $WANDER_AIMLESS,
	STATE.TALK_TO_SOMEONE: $TALK_TO_SOMEONE,
	STATE.STANDSTILL: $IDLE,
	STATE.HIT_SOMEONE: $HIT_SOMEONE,
	STATE.SWIM_IN_FONTAIN: $SWIM_IN_FOUNTAIN,
	STATE.INCOMING: $INCOMING,
	STATE.LEAVING: $LEAVE,
	STATE.HODL_GUN: $HODL_GUN,
	STATE.SHOOT_SOMEONE: $SHOOT_SOMEONE,
	STATE.DEAD: $DEAD,
	STATE.SMOKING: $SMOKE,
	STATE.WATCH_TV: $WATCH_TV,
	STATE.PROTEST: $PROTEST,
}



var _targetState : STATE = STATE.WANDER_AIMLESS


var navigationMap : RID

var _state : NPCState = null
var _stateType := STATE._WAIT_DAYSTART

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
	
	_state = stateMap[STATE._WAIT_DAYSTART]
	_stateType = STATE._WAIT_DAYSTART
	_state.enter()


func pickstate(oldState : NPCState) -> STATE:
	var max=0
	for i in oldState.nextStatesWeigths:
		max += i
	var rand = randf_range(0, max)
	for i in len(oldState.nextStatesWeigths):
		rand -= oldState.nextStatesWeigths[i]
		if rand<0:
			return oldState.possibleNextStates[i]
	return oldState.possibleNextStates[len(oldState.possibleNextStates)-1]

func _on_state_switch_requested(oldState: NPCState):
	if _stateType==STATE.DEAD or _stateType==STATE.LEAVING:
		return
	oldState.exit()
	var counter=0
	if oldState.possibleNextStates.is_empty():
		return
	var newstate = pickstate(oldState)
	while not stateMap[newstate].checkViable():
		newstate = pickstate(oldState)
		counter+=1
		if counter > 20:
			print("Yup tis kapot, na nen hoop trys op niets uitgekomen, wandel anders maar efkes")
			newstate = STATE.WANDER_AIMLESS
			break
	_state = stateMap[newstate]
	_stateType = newstate
	_state.enter()


func _physics_process(delta: float) -> void:
	if characterBody.dead:
		# not processing any state changes anymore if dead
		return
		
	if _state != null:
		_state.tick(delta)

func recalculateRoute():
	navigationAgent.target_position = navigationAgent.target_position

	
func getStates() -> Array[STATE]:
	if _state.isMainActionBusy():
		return [_stateType]
	const fallback := STATE.STANDSTILL
	return [fallback]


func getViableNextStates():
	return _state.possibleNextStates

# zeer gevaarlijke functie, kan tot deadlocks zorgen
func enforceNextState():
	#signal functie gebruiken voor niet signal, freek gaat blij zijn
	_on_state_switch_requested(_state)
	
#Voor praten of schieten ofzo moet ge meerdere characters samen iets laten doen
func enforceState(sate: STATE):
	if _stateType in [STATE.DEAD, STATE.LEAVING]:
		return
	_state.exit()
	_stateType = sate
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


func _on_dikke_ron_drag_started() -> void:
	if _state != null:
		_state.onDrag()


func _on_dikke_ron_drag_ended() -> void:
	if _state != null:
		_state.onDragEnd()
