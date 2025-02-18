extends Area2D

func burenGraag():
	var resultaat=[]
	for iets in get_overlapping_bodies():
		if iets is DikkeRon:
			resultaat.append(iets)
	return resultaat
