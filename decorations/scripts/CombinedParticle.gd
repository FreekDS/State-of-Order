@tool
extends Node2D

@export var emitting = false :
	set(value):
		for child in get_children():
			if child is GPUParticles2D:
				child.emitting = value
		emitting = value


var _particles : Array[GPUParticles2D] = []



func _ready() -> void:
	for child in get_children():
		if child is GPUParticles2D:
			_particles.append(child as GPUParticles2D)
			child.emitting = emitting


func emit():
	for child in _particles:
		child.emitting = true
	
func stop():
	for child in _particles:
		child.emitting = false
