extends NPCState

@onready var bloodsplotion: Node2D = $Bloodsplotion

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	debug.text = "DED LMAO"
	animations.stop()
	character.sprite.rotation_degrees = 0
	character.rotation_degrees = 0
	character.sprite.modulate = Color.LIGHT_BLUE
	character.sprite.diePainfully()
	var dir := 1 if character.sprite.flip_h else -1
	
	character.velocity = Vector2.ZERO
	
	bloodsplotion.emitting = true
	var tween := character.sprite.create_tween()
	tween.tween_property(character, "rotation_degrees", dir * 90, .4)


func tick(_delta: float) -> void:
	character.velocity = Vector2.ZERO


func onDrag():
	character.rotation_degrees = 0


func onDragEnd():
	animations.stop()
	var dir := 1 if character.sprite.flip_h else -1
	character.rotation_degrees = dir * 90

func exit():
	# Cannot happen
	pass
