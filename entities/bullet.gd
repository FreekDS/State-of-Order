extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is DikkeRon:
		body.beKilled()
		self.queue_free()
