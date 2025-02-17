extends MarginContainer

@onready var TekstEen = $"CenterContainer/HBoxContainer/1"
@onready var TekstTwee = $"CenterContainer/HBoxContainer/2"
@onready var TekstDrie = $"CenterContainer/HBoxContainer/3"
@onready var anim = $AnimationPlayer
func dramatiek() -> void:
	if anim.active:
		print("ellaba ik was nog dramatisch bezig")
	# Visible changes the location/reorders, modulate is the unnoficial workaround to have the tekst keep its locationø
	anim.play("appear")
	visible = true
	
func HeyIkWilNieuweTekst(een: String, twee: String, drie: String) -> void:
	TekstEen.text = een
	TekstTwee.text = twee
	TekstDrie.text = drie


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		anim.play("fade")
