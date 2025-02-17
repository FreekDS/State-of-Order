extends Node2D

@export var sprite:Sprite2D

# wanted offset, max distance, actual pos, radius
var points = [
	[Vector2(0,-1),0,Vector2(0,0),5],
	[Vector2(0,0),0,Vector2(0,0),5],
	[Vector2(0,2),10,Vector2(0,0),4],
	[Vector2(0,4),10,Vector2(0,0),2],
	[Vector2(0,3),10,Vector2(0,0),3],
	]
var prevpos:Vector2=Vector2(0,0)

var DragMode : bool = false

var spriteLocBeforeMove : Vector2= Vector2(0,0)

func _process(delta: float) -> void:
	if( not DragMode):
		updatePointsNormal()
	else:
		updatePointsNormal()
		sprite.offset=points.back()[2]
	queue_redraw()
	
func updatePointsNormal() -> void:
	var dif = prevpos-get_parent().global_position
	prevpos=get_parent().global_position
	
	for i in points:
		i[2]+=dif
		
	for i in range(len(points)-1,-1,-1):
		if i==0:
			points[i][2]=Vector2(0,0)
			continue
		points[i][2]=(points[i][0]+points[i][2]+points[i-1][2])/2
		
	for i in range(len(points)):
		if i == 0:
			continue
		if points[i][2].distance_to(points[i][0]+points[i-1][2])> points[i][1]:
			var dir = (points[i-1][2]+points[i][0]).direction_to(points[i][2])
			var offset = dir * points[i][1]
			points[i][2]=points[i-1][2]+offset+points[i][0]
			
func updatePointsDrag() -> void:
	pass
	
func _draw() -> void:
	for i in range(len(points)):
		if DragMode and i==len(points):
			continue
		var point=points[i]
		draw_circle(point[2],point[3],Color.RED)
	
func EnableDragmode() -> void:
	spriteLocBeforeMove=sprite.offset
	#reverse of the points + extra last one indicating the user
	points.reverse()
	points.append([points.back()[0],points.back()[1],points.back()[2],0])
	DragMode = true
	
func DisableDragmode() -> void:
	sprite.offset=spriteLocBeforeMove
	DragMode = false
	points.remove_at(len(points))
	points.reverse()
	
	
