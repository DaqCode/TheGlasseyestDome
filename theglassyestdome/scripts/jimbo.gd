extends Sprite2D

var direction := 1 # 1 for right, -1 for left
var jumps := 0 # Number of consecutive jumps
var timer = null # Timer reference

func _ready() -> void:
	start_timer() # Start the initial timer

func start_timer():
	# Create and start a timer for a random duration
	var wait_time = randi_range(4, 10)
	timer = get_tree().create_timer(wait_time)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	# Determine random values for the jump
	var x_distance = randi_range(10, 25) * direction
	var y_peak = -randi_range(20, 30) # Negative because jumping is upward
	var total_duration = 0.5 # Total time for the jump in seconds
	

	# Animate the jump
	animate_jump(x_distance, y_peak, total_duration)

	# Update direction and jump count
	if jumps == 3 or (position.x + x_distance < 0 or position.x + x_distance > get_viewport_rect().size.x):
		direction *= -1 # Reverse direction
		jumps = 0 # Reset jumps
	else:
		jumps += 1
	
	if direction <= 1:
		flip_h = false
	else:
		flip_h = true

	# Restart the timer after the jump
	start_timer()

func animate_jump(x_distance: float, y_peak: float, duration: float):
	var end_position = position + Vector2(x_distance, 0)
	var mid_position = position + Vector2(x_distance / 2, y_peak)

	# Animate using tween interpolation (smooth motion)
	var tween = create_tween()
	tween.tween_property(self, "position", mid_position, duration / 8)
	tween.tween_property(self, "position", end_position, duration / 4).set_delay(duration / 2)
