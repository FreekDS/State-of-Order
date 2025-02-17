extends MarginContainer

@onready var TekstEen = $"CenterContainer/HBoxContainer/1"
@onready var TekstTwee = $"CenterContainer/HBoxContainer/2"
@onready var TekstDrie = $"CenterContainer/HBoxContainer/3"
@onready var timer = $Timer

var tekstCounter = 0
func dramatiek() -> void:
	if tekstCounter != 0:
		print("ellaba ik was nog dramatisch bezig")
	# Visible changes the location/reorders, modulate is the unnoficial workaround to have the tekst keep its locationø
	
	TekstEen.modulate.a = 0
	TekstTwee.modulate.a = 0
	TekstDrie.modulate.a = 0
	visible = true
	tekstCounter = 1
	timer.start()

func HeyIkWilNieuweTekst(een: String, twee: String, drie: String) -> void:
	TekstEen.text = een
	TekstTwee.text = twee
	TekstDrie.text = drie


func _on_timer_timeout() -> void:
	if tekstCounter == 1:
		TekstEen.modulate.a = 255
	elif tekstCounter == 2:
		TekstTwee.modulate.a = 255
	elif tekstCounter == 3:	
		TekstDrie.modulate.a = 255
	else:
		visible = false
		tekstCounter = 0
	tekstCounter += 1
	timer.start()
