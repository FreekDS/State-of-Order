extends NPCState


const TARGET = Vector2(0,640)

var speed = 45

func enter():
	debug.text = "VAARWEL"
	navAgent.target_position = TARGET
	navAgent.target_reached.connect(func(): character.queue_free())


func tick(_delta):
	if is_queued_for_deletion():
		return
	character.pickable = false
	var target := navAgent.get_next_path_position()
	var dir = (target - character.global_position).normalized()
	character.velocity = dir * speed
	
	if character.global_position.distance_to(TARGET) < 10:
		queue_free()


func exit():
	# SHOULD NOT HAPPEN
	pass
