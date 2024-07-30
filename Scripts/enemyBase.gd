extends CharacterBody2D

@export var enemyType : Enemy = null

# Movement
var movementVector : Vector2
var speed : float = 150.0
const acceleration : float = 10.0
const near_player_multiplier = 0.5
const starting_speed : float = 150.0
var damageTimer : Timer = Timer.new() # no, we can't use get_tree().create_timer(2.0)
var isDamaging : bool = false 

enum directions{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var dir: directions = directions.DOWN
var moving : bool = false

var player : Player

func _ready():
	if (enemyType):
		player = get_parent().find_child("PlayerCharacter")
		# Sets enemy stats
		scale *= enemyType.scaleMult
		$"EnemySprite".sprite_frames = enemyType.spriteAnim
	else:
		queue_free()
		
	damageTimer.wait_time = 0.5 
	add_sibling.call_deferred(damageTimer)

func _process(delta):
	manageMovement(delta)
	move_and_slide()
	AnimateEnemy()

func manageMovement(delta):
	movementVector = position.direction_to(player.position)
	
	if (movementVector.x < 0):
		dir = directions.LEFT
	else:
		dir = directions.RIGHT
	
	
	speed = starting_speed * enemyType.speedMult
	if position.distance_to(player.position) < 100:
		speed *= near_player_multiplier
		damagePlayer()
	
	# Sets velocity
	velocity = velocity.lerp(movementVector * speed, acceleration * delta)
	fixSpeed()
	

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

func _on_interaction_component_interacted():
	var playerTool : Tool
	if (player.selectedItem && player.selectedItem.relatedTool):
		playerTool = player.selectedItem.relatedTool
	else:
		return
	if (player.toolManager.useTool(-1)):
		$"HealthComponent".damage(playerTool.meleeDmg)
		var particleInstance = load("res://Scenes/particles.tscn").instantiate()
		particleInstance.texture.atlas = preload("res://Sprites/Blood.png")
		particleInstance.position = position
		add_sibling(particleInstance)


func _on_health_component_death():
	for i in range(3):
		var particleInstance = load("res://Scenes/particles.tscn").instantiate()
		particleInstance.texture.atlas = preload("res://Sprites/Blood.png")
		particleInstance.position = position
		add_sibling(particleInstance)
	for drop in enemyType.drops:
		drop.dropItems(position, get_parent().get_parent(), drop)
	queue_free()

func damagePlayer():
	if isDamaging: return
	isDamaging = true
	get_parent().find_child("PlayerCharacter").find_child("HealthComponent").damage(enemyType.meleeDmg)
	damageTimer.start()
	await damageTimer.timeout
	isDamaging = false
