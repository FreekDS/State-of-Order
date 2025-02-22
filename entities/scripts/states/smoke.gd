extends NPCState


@onready var sigar: Sprite2D = $sigar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var smoke_time: Timer = $SmokeTime

@export var minSmokeTime = 1
@export var maxSmokeTime = 3

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
	debug.text = "SMOKE"
	character.rotation_degrees = 0
	character.sprite.rotation_degrees = 0
	sigar.show()
	animations.play("idle")
	anim.play("smoke")
	
	sigar.flip_h = character.sprite.flip_h
	if character.sprite.flip_h:
		sigar.offset.x = -.7
	else:
		sigar.offset.x = 7 
		
	smoke_time.start(randf_range(minSmokeTime, maxSmokeTime))
	

func exit():
	sigar.hide()
	anim.stop()
	smoke_time.stop()
	

func tick(_delta: float):
	character.velocity = Vector2.ZERO

func onDrag():
	sigar.hide()
	pass


func onDragEnd():
	sigar.show()
	character.rotation_degrees = 0
	character.sprite.rotation_degrees = 0
	if not character.dead:
		animations.play("idle")


func _on_smoke_time_timeout() -> void:
	switchState.emit(self)
