extends Area2D
@export var parent: DikkeRon

func burenGraag():
	var resultaat=[]
	for iets in get_overlapping_bodies():
		if iets is DikkeRon and iets != self.get_Parent():
			resultaat.append(iets)
	return resultaat

func get_Parent():
	return parent
