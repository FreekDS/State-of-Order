extends NPCState

@export var detectOthers : Area2D

@export var speechBubble : SpeechBubble

@export var gunSprite:Sprite2D

@export var bulletScene:PackedScene
	
@onready var state_length: Timer = $StateLength
@onready var speech_bubble_timer: Timer = $SpeechBubbleTimer

@export var aimTime = 5

var neighbourchosen : DikkeRon

var gun_words = [
	"gun",
]
var active = false

func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.TALK_TO_SOMEONE,
	]
	nextStatesWeigths=[
		10,
		10, 
		10
	]
func enter():
	if neighbourchosen != null:
		gunSprite.visible = true
		debug.text = "GUN aiming"
		state_length.start(aimTime)
		gunSprite.rotation=neighbourchosen.global_position.angle_to_point(self.character.global_position)
		speech_bubble_timer.start(randf_range(1,2))
		active = true
		speechBubble.option = gun_words.pick_random()
		speechBubble.open()
	else:
		print("Schieten naar niets gaat niet")
		switchState.emit(self)

func tick(_delta: float):
	character.velocity = Vector2.ZERO
	if neighbourchosen == null:
		switchState.emit(self)
	# ja deze extra check is nodig, dank u godot
	if neighbourchosen != null:
		gunSprite.rotation=neighbourchosen.global_position.angle_to_point(self.character.global_position)

func exit():
	state_length.stop()
	speech_bubble_timer.stop()
	gunSprite.visible = false
	neighbourchosen=null
	active = false
	if speechBubble.isOpen:
		speechBubble.close()

func checkViable() -> bool:
	var buren = detectOthers.burenGraag()
	for buur in buren:
		neighbourchosen = buur
		return true
	neighbourchosen = null
	return false


func _on_state_length_timeout() -> void:
	var rad=self.character.global_position.angle_to_point(neighbourchosen.global_position)
	Audio.iShotTheSherrif(character.global_position)
	await get_tree().create_timer(.8).timeout
	EventBus.kogelHier.emit(character.global_position,Vector2(cos(rad), sin(rad)))
	self.switchState.emit(self)


func _on_speech_bubble_timer_timeout() -> void:
	if speechBubble != null:
		speechBubble.option = gun_words.pick_random()
		speechBubble.open()
		
		get_tree().create_timer(4.0).timeout.connect(
			func():
				if speechBubble.isOpen:
					speechBubble.close()
				if active:
					pass
					#idleEffectTimer.start(randf_range(2,4))
		)
