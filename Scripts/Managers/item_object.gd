extends RigidBody2D
class_name ItemObject
@export var item : Item = null
var amount : int = 1
var maxItemStack : int = 10

var despawnTime := 60.0
@onready var despawnTimer := $"DespawnTimer"

func _ready():
	if (!item || item.maxStack == 0 || amount == 0):
		# Deletes any item object without an attached item
		item = null
		queue_free()
		print("Bye")
	else:
		$"ItemSprite".texture = item.sprite
		despawnTimer.wait_time = despawnTime
		despawnTimer.start()

# TODO: Make items attract to player
func _physics_process(delta):
	linear_velocity *= 0.9

func _process(delta):
	modulate.a = 1 * despawnTimer.time_left/despawnTime + 0.2

func _on_pickup_area_body_entered(body):
	print(get_groups())
	if (body.is_in_group("Player")):
		if (body.inventory.addItem(item)):
			queue_free()
	if (body.is_in_group("Item")):
		amount += body.amount
		body.queue_free()


func _on_despawn_timer_timeout():
	queue_free()
