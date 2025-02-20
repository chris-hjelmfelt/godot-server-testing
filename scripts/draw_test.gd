extends Node2D

var size_modifier = 0.3
var offset1 = -26
var offset2 = -9
var size1
var size2


func _ready():
	size1 = $Plant.texture.get_size()
	size2 = $Rock.texture.get_size()


func _process(_delta):
	queue_redraw()


func _draw():
	draw_set_transform($Plant.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
	draw_texture($Plant.texture, Vector2(-size1.x/2, -size1.y/2 + offset1))   #Vector2.ZERO)   
	
	draw_set_transform($Rock.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
	draw_texture($Rock.texture, Vector2(-size2.x/2, -size2.y/2 + offset2))
