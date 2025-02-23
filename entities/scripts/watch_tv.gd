extends NPCState


@onready var TV: Televies = $Televies
@onready var tv_time: Timer = $TV_Timer

@export var minTvTime = 8
@export var maxTvTime = 16


func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL,
		NPCStateManager.STATE.SMOKING,
		NPCStateManager.STATE.SWIM_IN_FONTAIN,
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.PROTEST,
	]
	nextStatesWeigths=[
		20,
		30, 
		10,
		40,
		10
	]

func enter():
	debug.text = "TV"
	character.rotation_degrees = 0
	character.sprite.rotation_degrees = 0
	TV.show()
	TV.play()
	animations.play("idle")
	
	Audio.playDeRikZijneMuziek(TV.global_position)
	
	TV.flip_h = character.sprite.flip_h
	if character.sprite.flip_h:
		TV.position.x = -30
	else:
		TV.position.x = 30
		
	tv_time.start(randf_range(minTvTime, maxTvTime))
	

func exit():
	TV.stop()
	TV.hide()
	tv_time.stop()
	Audio.stopDeRikeZineMuziek()
	

func tick(_delta: float):
	character.velocity = Vector2.ZERO

func onDrag():
	TV.stop()
	TV.hide()


func onDragEnd():
	TV.stop()
	TV.hide()
	character.rotation_degrees = 0
	character.sprite.rotation_degrees = 0
	if not character.dead:
		animations.play("idle")
	switchState.emit(self)


func _on_tv_time_timeout() -> void:
	switchState.emit(self)


func _on_tv_timer_timeout() -> void:
	switchState.emit(self)
