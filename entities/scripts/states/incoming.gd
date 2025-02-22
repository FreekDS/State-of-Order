extends NPCState

var speed = 45

func enter():
	debug.text = "SPAWNING"
	navAgent.navigation_finished.connect(_on_navigation_agent_2d_target_reached)
	animations.play("run", -1, 1.1)
	navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)


func tick(_delta: float):
	var targetPoint = navAgent.get_next_path_position()
	
	var direction = (targetPoint - character.global_position).normalized() * speed
	character.velocity = direction


func exit():
	navAgent.navigation_finished.disconnect(_on_navigation_agent_2d_target_reached)
	

func _on_navigation_agent_2d_target_reached() -> void:
	possibleNextStates=[
		NPCStateManager.STATE.SWIM_IN_FONTAIN,
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.STANDSTILL,
		NPCStateManager.STATE.PROTEST,
	]
	nextStatesWeigths=[
		10,
		50, 
		40,
		3
	]	
	switchState.emit(self)
