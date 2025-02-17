class_name NPCStateManager
extends Node2D

@export var characterBody : CharacterBody2D
@export var navigationAgent: NavigationAgent2D

enum STATE {
	WANDER_AIMLESS,
	SHOOT_SOMEONE,
	HIT_SOMEONE,
	SMOKING,
	WATCH_TV,
	SWIM_IN_FONTAIN,
	PROTEST,
	RUN,
	USE_TRAIN,
}


var navigationMap : RID

var _state : STATE = STATE.WANDER_AIMLESS


var speed = 50

var targetPoint := Vector2.ZERO


func _ready():
	set_physics_process(false)
	set_physics_process.call_deferred(true)

func _physics_process(delta: float) -> void:
	
	match _state:
		STATE.WANDER_AIMLESS:
			if navigationAgent.is_navigation_finished() or targetPoint.is_equal_approx(Vector2.ZERO):
				navigationAgent.target_position = NavigationServer2D.map_get_random_point(navigationMap, 1, true)
				print("Ik ben dikke ron en ik loop naar", navigationAgent.target_position)
				targetPoint = navigationAgent.get_next_path_position()
			
			targetPoint = navigationAgent.get_next_path_position()
			
			var direction = (targetPoint - global_position).normalized() * speed
			
			characterBody.velocity = direction
			


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
#	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		navigationAgent.target_position = NavigationServer2D.map_get_random_point(navigationMap, 1, true)
		print("Ik ben dikke ron en ik loop naar", navigationAgent.target_position)
		targetPoint = navigationAgent.get_next_path_position()

#func _on_navigation_agent_2d_waypoint_reached(details: Dictionary) -> void:
	#print("tussenpunt bereikt, hoera")
	#targetPoint = navigationAgent.get_next_path_position()


func _on_navigation_agent_2d_link_reached(details: Dictionary) -> void:
	print("tussenpunt bereikt, hoera")
	targetPoint = navigationAgent.get_next_path_position()


func _on_navigation_agent_2d_target_reached() -> void:
	print("TADAA")


func _on_navigation_agent_2d_waypoint_reached(details: Dictionary) -> void:
	print("waypoint")
	
