extends Node2D
# wanted offset, max distance, actual pos, radius
var points = [
	[Vector2(0,0),0,Vector2(0,0),5],
	[Vector2(0,2),10,Vector2(0,0),4],
	[Vector2(0,3),10,Vector2(0,0),3],
	[Vector2(0,4),10,Vector2(0,0),2],
	]
var prevpos=Vector2(0,0)
func _process(delta: float) -> void:
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
		
	queue_redraw()
	
func _draw() -> void:
	for point in points:
		draw_circle(point[2],point[3],Color.RED)
	
