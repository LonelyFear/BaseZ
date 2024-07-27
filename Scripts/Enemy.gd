extends CharacterBody2D
class_name Enemy

# Movement
var movementVector : Vector2
const speed : float = 150.0
const acceleration : float = 10.0
const near_player_multiplier = 0.5
enum directions{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var dir: directions = directions.DOWN
var moving : bool = false

var player : Player = null
var playerenemyarea : Area2D = null


func _ready():
	player = get_parent().find_child("PlayerCharacter")
	playerenemyarea = player.find_child("EnemyArea")
	
func _process(delta):
	manageMovement(delta)
	move_and_slide()
	AnimateEnemy()

func manageMovement(delta):
	movementVector = position.direction_to(player.position)
	if (movementVector.x < 0):
		dir = directions.LEFT
	elif (movementVector.x > 0):
		dir = directions.RIGHT
		
	if movementVector.x < movementVector.y:
		if (movementVector.y < 0):
			dir = directions.UP
		elif (movementVector.y > 0):
			dir = directions.DOWN
			
	# Sets velocity
	velocity = velocity.lerp(movementVector * speed, acceleration * delta)
	fixSpeed()
	if playerenemyarea.get_overlapping_bodies().has(self):
		velocity *= near_player_multiplier
		return
func fixSpeed():
	# Detects if the velocity is greater than the max player speed
	if velocity.length() > speed:
		# Forces the velocity to be the speed
		velocity = velocity.normalized() * speed
		
# Animates the player
func AnimateEnemy():
	# Saves player sprite as var
	var sprite : AnimatedSprite2D = $"EnemySprite"
	# sets if moving variable
	moving = false
	if (abs(movementVector.length()) > 0):
		moving = true
	
	# Flips the animation direction beforehand so we dont need to worry about doing it later
	sprite.flip_h = false
	
	match dir:
		directions.LEFT:
			# Moving left, flips sprite
			sprite.flip_h = true
			if (moving):
				sprite.play("Walk_Side")
			else:
				sprite.play("Idle_Side")
		directions.RIGHT:
			# Moving right
			if (moving):
				sprite.play("Walk_Side")
			else:
				sprite.play("Idle_Side")
		directions.UP:
			# Moving up
			if (moving):
				sprite.play("Walk_Up")
			else:
				sprite.play("Idle_Up")
		directions.DOWN:
			# Moving down
			if (moving):
				sprite.play("Walk_Down")
			else:
				sprite.play("Idle_Down")
