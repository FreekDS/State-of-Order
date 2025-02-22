extends NPCState


@onready var protestSign: Sprite2D = $ProtestSign
@onready var protestTime: Timer = $ProtestTimer

@export var minProtestTime = 3
@export var maxProtestTime = 5

func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL,
		NPCStateManager.STATE.SMOKING,
		NPCStateManager.STATE.SWIM_IN_FONTAIN,
		NPCStateManager.STATE.WANDER_AIMLESS
	]
	nextStatesWeigths=[
		20,
		30, 
		10,
		40
	]

func enter():
	debug.text = "PROTEST"
	character.rotation_degrees = 0
	character.sprite.rotation_degrees = 0
	protestSign.show()
	animations.play("idle")
	
	
	protestSign.flip_h = character.sprite.flip_h
	if character.sprite.flip_h:
		protestSign.position.x = -12
	else:
		protestSign.position.x = 12
		
	protestTime.start(randf_range(minProtestTime, maxProtestTime))
	

func exit():
	protestSign.hide()
	protestTime.stop()
	

func tick(_delta: float):
	character.velocity = Vector2.ZERO

func onDrag():
	protestSign.stop()
	protestSign.hide()


func onDragEnd():
	protestSign.show()
	character.rotation_degrees = 0
	character.sprite.rotation_degrees = 0
	if not character.dead:
		animations.play("idle")


func _on_protest_timer_timeout() -> void:
	switchState.emit(self) # Replace with function body.
