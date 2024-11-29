class_name MainGame
extends Control

@onready var random_event := $RandomEvent
@onready var idle_timer := $EventCooldown
@onready var sfx_player := $SFX
@onready var dome := $MainContent/Dome
@onready var glitchSFX := $GlitchSFX

#Event list based on onready
@onready var dragging_fly_event := $RandomEvent/DragingFlyEvent
@onready var watcher_ant_event := $RandomEvent/TheWatcherAntEvent
@onready var fissure_frenzy_event := $RandomEvent/FissureFrenzy
@onready var glitch_in_the_system := $RandomEvent/GitchMoth
@onready var resonance_ripple := $RandomEvent/ResonanceRipple

var active_event = null  # Track the currently active event'
var crack_event_activated = false
var glitch_event = false   
var resonance_event_activated = false
var resonance_shake = false
var current_tween: Tween = null  # Store the active tween

@onready var sfx_options = [
	preload("res://resources/audio/sfx/breaking_out/break1.mp3"),
	preload("res://resources/audio/sfx/breaking_out/break2.mp3"),
	preload("res://resources/audio/sfx/breaking_out/break3.mp3")
]

func _ready() -> void:
	$Animation.play("intro")

func _on_animation_animation_finished(anim_name:StringName) -> void:
	if anim_name == "intro":
		idle_timer.connect("timeout", Callable(self, "_on_idle_timeout"))  # Example connection for idle events
		randomize()  # Seed RNG
		start_random_event()

func start_random_event() -> void:
	if active_event:
		print("An event is already active.")
		return

	# Pick a random event
	var events = [
		# dragging_fly_event,
		# watcher_ant_event, 
		# fissure_frenzy_event,
		glitch_in_the_system
		# resonance_ripple
		
	]
	randomize()
	active_event = events.pick_random()
	while (crack_event_activated == true || resonance_event_activated == true)&& active_event == fissure_frenzy_event:
		active_event = events.pick_random()

	active_event.start_event()
	print("Starting random event:", active_event.name)


func reset_random_event() -> void:
	# Reset active event and pick a new one
	active_event.reset_event()
	start_random_event()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("press"):
		var breaking = randi_range(1, Global.breaking_rate)

		if breaking == 1:  # Adjusted for the variable rate
			_vibrate_dome()
			get_tree().change_scene_to_file("res://scenes/ending_scene.tscn")
			pass

		else:
			if glitch_event:
				var rand = randi_range(1, 40)
				if rand == 1:
					glitch_shake()  # Apply glitch effect

			random_sfx()
			print("Not breaking.")
			
			if resonance_shake:
				_vibrate_dome_but_more()
			else:
				_vibrate_dome()


func random_sfx() -> void:
	sfx_player.set_stream(sfx_options.pick_random())
	sfx_player.playing = true

func _on_event_cooldown_timeout() -> void:
	print("Idle timeout triggered. Resetting random event...")
	reset_random_event()

func _vibrate_dome() -> void:
	var tween = get_tree().create_tween()
	
	# Define the base position
	var base_position = Vector2(-331, -167)

	# Create small random offsets for the vibration
	for _i in range(randi_range(1,3)):  # Number of shakes
		tween.tween_property(
			dome, 
			"position", 
			base_position + Vector2(randf_range(-10, 10), randf_range(-10, 10)), 
			0.05
		)

	# Return to the original position
	tween.tween_property(dome, "position", base_position, 0.05)

func _vibrate_dome_but_more() -> void:
	if dome:
		# Stop and remove the existing tween if it exists
		if current_tween:
			current_tween.stop()
			current_tween = null

		# Create a new tween
		current_tween = get_tree().create_tween()
		var base_position = Vector2(-331, -167)

		# Create small random offsets for the vibration
		for _i in range(randi_range(5, 10)):  # Number of shakes
			current_tween.tween_property(
				dome, 
				"position", 
				base_position + Vector2(randf_range(-50, 50), randf_range(-50, 50)), 
				0.01
			)

		# Return to the original position
		current_tween.tween_property(dome, "position", base_position, 0.05)
	else:
		print("Error: Dome is null.")

func glitch_shake() -> void:
	var parent_node = $MainContent  # Directly reference MainContent
	if not parent_node:
		print("Error: parent_node is null.")
		return

	# Quick shakes using a tween
	var tween = get_tree().create_tween()
	var original_position = parent_node.position

	# Shake the parent node with random offsets
	for _i in range(10):  # Increase the number for more intense shaking
		tween.tween_property(
			parent_node,
			"position",
			original_position + Vector2(randf_range(-20, 20), randf_range(-20, 20)),
			0.03  # Short duration for rapid shakes
		)

	# Reset to original position at the end
	tween.tween_property(parent_node, "position", original_position, 0.05)

	# Modulate the screen to give a glitchy effect
	modulate_screen_glitch($MainContent)

	# Add a sound effect or particle effect if desired for an enhanced glitch effect
	play_glitch_sfx()

	# Optionally trigger a coroutine to reset any changes after some time
	await get_tree().create_timer(0.5).timeout
	reset_glitch_effect(parent_node)


# Helper function to modulate the screen
func modulate_screen_glitch(screen_modulation: Node) -> void:
	if not screen_modulation:
		print("Error: screen_modulation node is null.")
		return

	# Alternate between random modulations to create the effect
	for _i in range(10):  # Number of modulations
		screen_modulation.modulate = Color(
			randf_range(0.5, 1),  # Random red intensity
			randf_range(0.5, 1),  # Random green intensity
			randf_range(0.5, 1),  # Random blue intensity,
			1  # Keep alpha at 1
		)
		await get_tree().create_timer(0.05).timeout

	# Reset modulation to original
	screen_modulation.modulate = Color(1,1,1,1)


# Helper function to play glitchy sound effects
func play_glitch_sfx() -> void:
	var glitch_random = [
		preload("res://resources/audio/sfx/glitch/glitch1.mp3"),
		preload("res://resources/audio/sfx/glitch/glitch1.mp3")
	]

	glitchSFX.set_stream(glitch_random.pick_random())
	glitchSFX.volume_db = randf_range(-15, -12.5)
	glitchSFX.pitch_scale = randf_range(0.9, 1.1)

	glitchSFX.playing = true

# Helper function to reset any residual effects
func reset_glitch_effect(node: Node) -> void:
	node.position = Vector2(576, 324)  # Reset to base position
	node.modulate = Color(1, 1, 1, 1)  # Reset to default color
