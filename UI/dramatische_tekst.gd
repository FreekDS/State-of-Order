extends MarginContainer

@onready var TekstEen=$"CenterContainer/HBoxContainer/1"
@onready var TekstTwee=$"CenterContainer/HBoxContainer/2"
@onready var TekstDrie=$"CenterContainer/HBoxContainer/3"
@onready var timer=$Timer

var tekstCounter=0
func dramatiek():
	if tekstCounter != 0:
		print("ellaba ik was nog dramatisch bezig")
	TekstEen.visible=false
	TekstTwee.visible=false
	TekstDrie.visible=false
	visible=true
	tekstCounter=1
	timer.start()

func HeyIkWilNieuweTekst(een:String,twee:String,drie:String):
	TekstEen.text=een
	TekstTwee.text=twee
	TekstDrie.text=drie


func _on_timer_timeout() -> void:
	if tekstCounter==1:
		TekstEen.visible=true
	elif tekstCounter==2:
		TekstTwee.visible=true
	elif tekstCounter==3:	
		TekstDrie.visible=true
	else:
		visible=false
		tekstCounter=0
	tekstCounter+=1
	timer.start()
