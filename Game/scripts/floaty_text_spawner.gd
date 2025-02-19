extends Node2D

const floatyText = preload("res://UI/components/floating_text.tscn")

func _ready() -> void:
	EventBus.wrongCapture.connect(
		func guyCaptured(who: DikkeRon, score):
			spawnText("[color=red]- social credit", who)
	)
	EventBus.successfulCapture.connect(
		func guyCaptured(who: DikkeRon, score):
			spawnText("[color=green]+ social credit", who)
	)

func spawnText(text: String, who: DikkeRon):
	var textParent = Node2D.new()
	var newFloatingText := floatyText.instantiate() as RichFloatyText
	newFloatingText.bbcode_enabled = true
	newFloatingText.text = text # TODO: somehow fill in why we captured the guy
	textParent.add_child(newFloatingText)
	add_child(textParent)
	textParent.global_position = who.global_position
	newFloatingText.startFloat()
	await newFloatingText.floatEnded
	textParent.queue_free()
