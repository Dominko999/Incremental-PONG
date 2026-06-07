extends RigidBody2D

@export var speed : int = 150 #speed of the ball
@export var hitbox : HitboxComponent
var dir : Vector2 # direction in whitch the ball is moving
signal player_hit
enum FiredBy {ENEMY, PLAYER}
@export var current_state = FiredBy.ENEMY

var collision
var collider

func _ready() -> void:
	manage_states()
	dir = get_direction()
	
func get_direction():
	var new_direction : Vector2
	new_direction.x = -1
	new_direction.y = randf_range(-1,1)
	return new_direction.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	manage_states()
	collision = move_and_collide(dir * speed * delta)

	if collision:
		collider = collision.get_collider()
		if collider.is_in_group('paddles'):
			bounce_from_paddle(collider)
		if collider.is_in_group('walls'):
			dir = dir.bounce(collision.get_normal())
		if collider.is_in_group('left_edge'):
			player_hit.emit()
			queue_free()
	
func manage_states():
	match current_state:
		FiredBy.ENEMY:
			hitbox.shape.disabled = true
		FiredBy.PLAYER:
			hitbox.shape.disabled = false

func bounce_from_paddle(paddle_collider):
	var ball_y = position.y
	var paddle_y = paddle_collider.position.y
	var distance = paddle_y - ball_y
	var paddle_height = paddle_collider.height
	
	current_state = FiredBy.PLAYER
	
	GlobalSoundManager.play_sfx(GlobalEnums.Sounds.BOUNCE, true)
	
	dir.x *= -1
	dir.y = - distance / paddle_height
	dir = dir.normalized()
