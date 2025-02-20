extends Node2D

@export var count: int = 1000
@export var size_modifier: float = 1.0
@export var trade: bool = false
var thing_images: Array = [preload("res://images/plant.png"), preload("res://images/rock.png")]
var thing_yoffsets: Array = [-28.0,-9.0]
var things: Array = []
var barepatch: Vector2 = Vector2(1000,400)
var baresize: int = 100
var viewsize: Vector2

class Thing:
	var body = RID()
	var position: Vector2
	var image: CompressedTexture2D
	var size: Vector2
	var yoffset: float


func _ready():
	viewsize = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)
	if trade == true:
		for plant in $"../Ground Cover/Plants".get_children():
			create_thing(plant.position, plant.texture, plant.offset.y)
			plant.queue_free()
		for rock in $"../Ground Cover/Rocks".get_children():
			create_thing(rock.position, rock.texture, rock.offset.y)
			rock.queue_free()
	else:
		for _i in count:
			var location = Vector2(
				randf_range(-viewsize.x * 3, viewsize.x * 4),
				randf_range(-viewsize.y * 3, viewsize.y * 4)
			)
			if location.x < barepatch.x + baresize and location.x > barepatch.x - baresize and location.y < barepatch.y + baresize and location.y > barepatch.y - baresize:
				pass  # skip these
			else:
				var rand = randi() % 2
				create_thing(location, thing_images[rand], thing_yoffsets[rand])
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


func create_thing(location: Vector2, image_texture: CompressedTexture2D, img_offset: float):
	var imgsize = image_texture.get_size()
	var thing = Thing.new()
	thing.position = location
	thing.image = image_texture
	thing.size = imgsize
	thing.yoffset = img_offset
	
	things.push_back(thing)


func _draw():
	var offset: Vector2
	for thing in things:
		offset = Vector2(-thing.size.x/2, -thing.size.y/2 + thing.yoffset)
		draw_set_transform(thing.position, 0.0, Vector2(size_modifier, size_modifier))  # (position, rotation, scale)
		draw_texture(thing.image, offset)  


# Cleanup
func _exit_tree():
	things.clear()
