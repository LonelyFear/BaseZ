extends Control

var player : Player = null
var tileMap : TileMap
const tweenStep : float = 0.2
var tweenTarget : float = 0
var tween : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if (player):
		player = get_parent().get_parent().find_child("PlayerCharacter")
		player.find_child("HealthComponent").healthChanged.connect(update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tween:
		tween = false
		if tweenTarget > $HealthBar.value:
			return # TODO: tween upwards
		else:
			while $HealthBar.value != tweenTarget:
				$HealthBar.value -= tweenStep
				await get_tree().create_timer(delta).timeout

func update(health):
	tweenTarget = health
	tween = true
	$HealthBar/HealthText.text = str(health) + "/10"
