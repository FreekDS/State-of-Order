extends NPCState

@export var minIdleTime = 0.5
@export var maxIdleTime = 4.0

@onready var idle_time: Timer = $IdleTime


func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS
	]

func enter():
	debug.text = "IDLE"
	animations.stop()
	idle_time.start(randf_range(minIdleTime, maxIdleTime))
	animations.play("idle")


func tick():
	character.velocity = Vector2.ZERO



func exit():
	pass


func _on_idle_time_timeout() -> void:
	var nextState = possibleNextStates.pick_random()
	switchState.emit(self, nextState)
