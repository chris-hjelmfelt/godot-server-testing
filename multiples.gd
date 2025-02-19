extends Node2D

@export var count: int = 1000
@export var size_modifer: float = 1.0
@export var trade: bool = false
const thing_images: Array = [preload("res://images/plant.png"), preload("res://images/rock.png")]
var things: Array = []
var barepatch: Vector2 = Vector2(1000,400)
var baresize: int = 100


class Thing:
	var body = RID()
	var position: Vector2
	var image: CompressedTexture2D
	var yoffset: float


func _ready():
	
	if trade == true:
		for plant in $"../Plants".get_children():
			create_thing(plant.position, plant.texture, plant.offset.y)
			plant.queue_free()
		for rock in $"../Rocks".get_children():
			create_thing(rock.position, rock.texture, rock.offset.y)
			rock.queue_free()
	else:
		for _i in count:
			var location = Vector2(
				randf_range(0, get_viewport_rect().size.x),
				randf_range(0, get_viewport_rect().size.y)
			)
			if location.x < barepatch.x + baresize and location.x > barepatch.x - baresize and location.y < barepatch.y + baresize and location.y > barepatch.y - baresize:
				pass  # skip these
			else:
				var image = thing_images[randi() % 2]
				create_thing(location, image, 0.0)
	things.sort_custom(organize_array)


func _process(_delta):
	queue_redraw()


# Arrange the array so items with the lowest y-axis values are drawn first
func organize_array(element_1: Thing, element_2: Thing) -> bool:
	if (element_1.position.y + element_1.yoffset) < (element_2.position.y + element_2.yoffset):
		return true
	elif (element_1.position.y + element_1.yoffset) == (element_2.position.y + element_2.yoffset) and element_1.position.x < element_2.position.x:
		return true
	return false


func create_thing(location: Vector2, image: CompressedTexture2D, img_offset: float):
	var thing = Thing.new()
	thing.position = location
	thing.image = image
	thing.yoffset = img_offset
	
	things.push_back(thing)


func _draw():
	var offset: Vector2
	for thing in things:
		var size = thing.image.get_size()
		offset = Vector2(-size.x/2, -(size.y/2) + thing.yoffset) * 1/size_modifer
		draw_set_transform(thing.position, 0.0, Vector2(1/size_modifer, 1/size_modifer))  # (position, rotation, scale)
		draw_texture(thing.image, Vector2.ZERO + offset)


# Cleanup
func _exit_tree():
	things.clear()
