extends Node2D

@export var trade: bool = false
const COUNT: int = 1000
const thing_images: Array = [preload("res://images/plant.png"), preload("res://images/rock.png")]
var things: Array = []
var barepatch: Vector2 = Vector2(1000,400)
var baresize: int = 100


class Thing:
	var body = RID()
	var position = Vector2()
	var image = CompressedTexture2D


func _ready():
	
	if trade == true:
		for plant in $"../Plants".get_children():
			var location = plant.position
			plant.queue_free()
			create_thing(location, plant.texture)
		for rock in $"../Rocks".get_children():
			var location = rock.position
			rock.queue_free()
			create_thing(location, rock.texture)
	else:
		for _i in COUNT:
			var location = Vector2(
				randf_range(0, get_viewport_rect().size.x),
				randf_range(0, get_viewport_rect().size.y)
			)
			if location.x < barepatch.x + baresize and location.x > barepatch.x - baresize and location.y < barepatch.y + baresize and location.y > barepatch.y - baresize:
				pass  # skip these
			else:
				var image = thing_images[randi() % 2]
				create_thing(location, image)
	things.sort_custom(organize_array)


func _process(_delta):
	queue_redraw()


# Arrange the array so items with the lowest y-axis values are drawn first
func organize_array(element_1: Thing, element_2: Thing) -> bool:
	if element_1.position.y < element_2.position.y:
		return true
	elif  element_1.position.y == element_2.position.y and element_1.position.x < element_2.position.x:
		return true
	return false


func create_thing(location: Vector2, image: CompressedTexture2D):
	var thing = Thing.new()
	thing.position = location
	thing.image = image
	
	things.push_back(thing)


func _draw():
	var offset: Vector2
	for thing in things:
		offset = -thing.image.get_size() * 0.5
		draw_texture(thing.image, thing.position + offset)


# Cleanup
func _exit_tree():
	things.clear()
