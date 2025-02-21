extends NPCState


func enter():
	debug.text = "wait for day to start"
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.TALK_TO_SOMEONE,
	]
	animations.play("idle")
	EventBus.dayStarted.connect(
		func(_dayData):
			switchState.emit(self),
		CONNECT_ONE_SHOT
	)

func tick(delta: float):
	character.velocity = Vector2.ZERO
	
	
func exit():
	#nothing to cleanup
	pass
