class_name DramaDramaGroteLama
extends MarginContainer


signal done

@onready var TekstEen = $"CenterContainer/HBoxContainer/1"
@onready var TekstTwee = $"CenterContainer/HBoxContainer/2"
@onready var TekstDrie = $"CenterContainer/HBoxContainer/3"
@onready var anim = $AnimationPlayer


func dramatiek() -> void:
	if anim.is_playing():
		print("ellaba ik was nog dramatisch bezig")
	# Visible changes the location/reorders, modulate is the unnoficial workaround to have the tekst keep its location
	anim.play("appear")
	visible = true
	await anim.animation_finished
	done.emit()
	
func HeyIkWilNieuweTekst(een: String, twee: String, drie: String) -> void:
	TekstEen.text = een
	TekstTwee.text = twee
	TekstDrie.text = drie
