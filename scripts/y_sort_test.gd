extends Node2D

var size_modifier = 0.2
var things: Array = []


class Thing:
	var body = RID()
	var position: Vector2
	var image: CompressedTexture2D
	var size: Vector2
	var yoffset: float


func _ready():
	create_thing($Plant.position, $Plant.texture, $Plant.offset.y)
	create_thing($Rock2.position, $Rock2.texture, $Rock2.offset.y)
	create_thing($Plant2.position, $Plant2.texture, $Plant2.offset.y)
	create_thing($Rock.position, $Rock.texture, $Rock.offset.y)
	things.sort_custom(organize_array)
	print("Things:")
	for thing in things:
		print(thing.position)


func _process(_delta):
	queue_redraw()


func create_thing(location: Vector2, image_texture: CompressedTexture2D, img_offset: float):
	var imgsize = image_texture.get_size()
	var thing = Thing.new()
	thing.position = location
	thing.image = image_texture
	thing.size = imgsize
	thing.yoffset = img_offset
	
	things.push_back(thing)


func organize_array(first: Thing, second: Thing) -> bool:
	var first_ypos = first.position.y #+ (first.yoffset * size_modifier)
	var first_mod = first.position.y + first.yoffset
	var second_ypos = second.position.y # + (second.yoffset * size_modifier)
	print(str(first.position.y) + " - " + str(first_ypos) + " - " + str(first_mod))
	if first_ypos < second_ypos:
		return true
	elif first_ypos == second_ypos and first.position.x < second.position.x:
		return true
	return false


func _draw():
	var offset: Vector2
	for thing in things:
		offset = Vector2(-thing.size.x/2, -thing.size.y/2 + thing.yoffset)
		draw_set_transform(thing.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
		draw_texture(thing.image, offset)
	
#	draw_set_transform($Plant.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
#	draw_texture($Plant.texture, Vector2(-size1.x/2, -size1.y/2 + offset1))   #Vector2.ZERO) 	 
#
#	draw_set_transform($Rock2.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
#	draw_texture($Rock2.texture, Vector2(-size2.x/2, -size2.y/2 + offset2))
#
#	draw_set_transform($Plant2.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
#	draw_texture($Plant2.texture, Vector2(-size1.x/2, -size1.y/2 + offset1))   #Vector2.ZERO)  	  
#
#	draw_set_transform($Rock.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
#	draw_texture($Rock.texture, Vector2(-size2.x/2, -size2.y/2 + offset2))
