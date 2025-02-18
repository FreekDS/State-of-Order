extends Area2D

func burenGraag():
	var resultaat=[]
	for iets in get_overlapping_bodies():
		if iets is DikkeRon and iets != self.get_parent():
			resultaat.append(iets)
	return resultaat
