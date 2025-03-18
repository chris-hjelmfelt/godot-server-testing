extends Node2D

var things: Array = []

class Thing:
	var body = RID()
	var position: Vector2
	var image: CompressedTexture2D
	var size: Vector2
	var size_modifier: Vector2
	var yoffset: float


func _ready():
	for plant in $"../Ground Cover/Plants".get_children():
		create_thing(plant)
		plant.queue_free()
	for rock in $"../Ground Cover/Rocks".get_children():
		create_thing(rock)
		rock.queue_free()
	
	things.sort_custom(organize_array)


func _process(_delta):
	queue_redraw()


# Arrange the array so items with the lowest y-axis values are drawn first
func organize_array(element_1: Thing, element_2: Thing) -> bool:
	if element_1.position.y < element_2.position.y:
		return true
	elif element_1.position.y == element_2.position.y and element_1.position.x < element_2.position.x:
		return true
	return false


func create_thing(myobj: Node2D):
	var imgsize = myobj.texture.get_size()
	var thing = Thing.new()
	
	thing.position = myobj.position
	thing.image = myobj.texture
	thing.size = imgsize
	thing.size_modifier = myobj.scale
	thing.yoffset = myobj.offset.y
	
	things.push_back(thing)


func _draw():
	var offset: Vector2
	for thing in things:
		offset = Vector2(-thing.size.x/2, -thing.size.y/2 + thing.yoffset)
		draw_set_transform(thing.position, 0.0, Vector2(thing.size_modifier.x, thing.size_modifier.y))  # (position, rotation, scale)
		draw_texture(thing.image, offset)  


# Cleanup
func _exit_tree():
	things.clear()
