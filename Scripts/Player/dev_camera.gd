extends Camera2D

var cameraSpeed : float = 1600.0
var cameraAccel : float = 200.0
var velocity : Vector2

func _ready() -> void:
	get_parent().find_child("TileLayers").worldGenFinished.connect(stopGenCam)

func stopGenCam():
	queue_free()

func _process(delta: float) -> void:
	cameraControl()

func cameraControl():
	var movementVector : Vector2
	movementVector.x = Input.get_axis("Move_Left", "Move_Right")
	movementVector.y = Input.get_axis("Move_Up", "Move_Down")
	
	velocity += movementVector * cameraAccel * get_process_delta_time()
	if (velocity.length() > cameraSpeed):
		velocity = velocity.normalized() * cameraSpeed
	velocity *= 0.9
	
	position += velocity
