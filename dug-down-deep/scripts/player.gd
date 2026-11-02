extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -900.0
var alive = true
var can_move = true


func _physics_process(delta: float) -> void:
	
	if !alive:
		return
	
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation ="Run"
	else: animated_sprite_2d.animation ="Idle"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation ="Jump"

	if can_move:
		# Handle jump.
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction := Input.get_axis("Backward", "Forward")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

			move_and_slide()
			
			if direction == 1.0:
				animated_sprite_2d.flip_h = false
			elif direction == -1.0:
					animated_sprite_2d.flip_h = true
					
func die() -> void:
	animated_sprite_2d.animation = "Hit"
	alive = false
	
