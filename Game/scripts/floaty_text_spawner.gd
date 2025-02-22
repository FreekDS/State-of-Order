extends Node2D

const floatyText = preload("res://UI/components/floating_text.tscn")

func _ready() -> void:
	EventBus.wrongCapture.connect(
		func guyCaptured(who: DikkeRon, _score):
			spawnText("[color=red]- social credit", who)
	)
	EventBus.successfulCapture.connect(
		func guyCaptured(who: DikkeRon, _score, whyStates, whyTraits):
			spawnText("[color=green]+ social credit", who, whyStates, whyTraits)
	)

func spawnText(text: String, who: DikkeRon, whyStates = [], whyTraits = []):
	var textParent = Node2D.new()
	var newFloatingText := floatyText.instantiate() as RichFloatyText
	newFloatingText.bbcode_enabled = true
	newFloatingText.text = text # TODO: somehow fill in why we captured the guy
	
	for whyState in whyStates:
		var rule = PauseMenu.TRANSLATION_STATES[whyState]
		newFloatingText.text = newFloatingText.text + "\n[font_size=10]" + rule
		pass
	for whyTrait in whyTraits:
		var rule = PauseMenu.TRANSLATION_TRAITS[whyTrait]
		newFloatingText.text = newFloatingText.text + "\n[font_size=10]" + rule
	
	textParent.add_child(newFloatingText)
	add_child(textParent)
	textParent.global_position = who.global_position
	newFloatingText.startFloat()
	await newFloatingText.floatEnded
	textParent.queue_free()
