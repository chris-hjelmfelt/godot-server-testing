extends Node2D

const COUNT: int = 400
const thing_images: Array = [preload("res://images/plant.png"), preload("res://images/rock.png")]
var things: Array = []
var shape


class Thing:
	var body = RID()
	var position = Vector2()
	var image = CompressedTexture2D


func _ready():
	shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape, 20)
	
	for _i in COUNT:
		var location = Vector2(
			randf_range(0, get_viewport_rect().size.x),
			randf_range(0, get_viewport_rect().size.y)
		)
		
		var image = thing_images[randi() % 2]
		var thing = Thing.new()
		thing.body = PhysicsServer2D.body_create()
		thing.position = location
		thing.image = image

		PhysicsServer2D.body_set_space(thing.body, get_world_2d().get_space())
		PhysicsServer2D.body_add_shape(thing.body, shape)
		PhysicsServer2D.body_set_collision_mask(thing.body, 0)  # doesn't collide with other "things"

		var transform2d = Transform2D()
		transform2d.origin = thing.position
		PhysicsServer2D.body_set_state(thing.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

		things.push_back(thing)
	things.sort_custom(organize_array)


func _process(_delta):
	queue_redraw()


func _physics_process(_delta):
	var transform2d = Transform2D()
	for thing in things:
		transform2d.origin = thing.position
		PhysicsServer2D.body_set_state(thing.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)


# Arrange the array so items with the lowest y-axis values are drawn first
func organize_array(element_1: Thing, element_2: Thing) -> bool:
	if element_1.position.y < element_2.position.y:
		return true
	elif  element_1.position.y == element_2.position.y and element_1.position.x < element_2.position.x:
		return true
	return false


func _draw():
	var offset: Vector2
	for thing in things:
		offset = -thing.image.get_size() * 0.5
		draw_texture(thing.image, thing.position + offset)


# Cleanup
func _exit_tree():
	for thing in things:
		PhysicsServer2D.free_rid(thing.body)

	PhysicsServer2D.free_rid(shape)
	things.clear()

