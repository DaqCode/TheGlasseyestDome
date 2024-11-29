class_name DraggingFlyEvent
extends Control

@onready var eventPanel := $EventPanel
@onready var eventTimer := $EventTimer
@onready var slypth := $SlypthDragingFly
@onready var choiceTimer := $SelectionChoice
@onready var eventChoice := $EventPanel/PointerDragingFly  # This is the arrow/picker
@onready var eventText := $EventPanel/MainEvent
@onready var textTimer := $TextTimer
@onready var bede := $bede

var can_fly := false  # Flag to indicate if flying is allowed
var event_show := false  # Flag to indicate if the event can be shown
var choice_lock := false


# Choice variables
var current_choice := 0
	
func start_event() -> void:
	print("Starting draging_fly event")
	can_fly = false
	eventPanel.visible = false
	reset_event_timer()

	eventPanel.visible = false  # Hide the panel initially
	eventTimer.one_shot = true
	eventTimer.wait_time = randi_range(15, 30)
	eventTimer.start()  # Start the event timer
	print("Event timer wait time: ", eventTimer.wait_time)

func _on_event_timer_timeout() -> void:
	can_fly = true  # Allow dragging when the timer expires
	print("Dragonfly can now start moving")

func _process(delta: float) -> void:
	if can_fly:
		slypth.position.x += 250 * delta
		if slypth.position.x > 1400:
			can_fly = false
			slypth.position.x = -100
			show_event_panel()  # Show the event panel when the dragonfly completes its travel
	
	if choice_lock:
		if Input.is_action_just_pressed("press"):
			print("NOPE YOU CANT PRESS CUZ YOU CONFIORMED YOUR CHOICE YOU DINGUS")
			pass

func show_event_panel() -> void:
	eventPanel.visible = true
	event_show = true
	start_choice_timer()  # Start the choice timer
	print("Event panel is now visible, starting choice timer")

func reset_event_timer() -> void:
	print("Event timer reset")

func start_choice_timer() -> void:
	choiceTimer.wait_time = 1.0  # Switch choices every second
	choiceTimer.start()
	print("Choice timer started")

func _on_selection_choice_timeout() -> void:
	print("SELECTION TIME OUT")
	current_choice = (current_choice + 1) 
	choiceTimer.wait_time = 1.0
	choiceTimer.start()
	update_choice_position()

func update_choice_position() -> void:
	# Move the arrow/picker to the position corresponding to the current choice
	if current_choice % 2 == 0:
		eventChoice.position = Vector2(157, 137)
		print("Current choice: YES")
	else:
		eventChoice.position = Vector2(417, 137)
		print("Current choice: NO")

	print (current_choice)

func confirm_choice() -> void:
	print("CHOICE CONFIRMED")
	choice_lock = true
	choiceTimer.stop()  # Stop the choice timer when confirmed
	eventChoice.visible = false
	$EventPanel/Yes.visible = false
	$EventPanel/No.visible = false

	# Ensure that the parent nodes and the target node exist before trying to access them
	var buff_containers = get_parent().get_parent().get_node("BuffContainers")
	if buff_containers:
		var sylph_icon = buff_containers.get_node("SlyphIcon")
		if sylph_icon:
			sylph_icon.visible = true


	if current_choice % 2 == 0:
		var rand = randi_range(1, 2)
		if rand == 1:
			print("text shows yes and good effect")
			eventText.text = """Slyph grants you assistance. He blesses you with his own abilities.
	You feel ever so light. You can now punch even more."""

			Global.breaking_rate = 5000
			bede.connect("timeout", Callable(self, "_on_bedu_timer_timeout"))  # Example connection for idle events
			bede.wait_time = 30
			bede.start()
		else:

			print("text shows yes, but bad effect")
			eventText.text = """Slyph grants you assistance. However, it didn't work as intended.
	You feel much weaker. You weren't ready yet."""

			
			if Global.breaking_rate == 7500:
				Global.breaking_rate = 10500
			else: 
				Global.breaking_rate = 12750

			bede.connect("timeout", Callable(self, "_on_bedu_timer_timeout"))  # Example connection for idle events
			bede.wait_time = 20
			bede.start()

	else:
		print("text shows no")
		eventText.text = """You thank Slyph for his help, but decide it's not your chance.
	Slyph then flies off, and you await his return again."""

	textTimer.one_shot = true
	textTimer.wait_time = 7.5  # Wait for 7 seconds
	textTimer.start()
	
	
func _on_text_timer_timeout() -> void:
	# Print the reset time before resetting the event
	var reset_time = randi_range(30, 75)
	print("Resetting event panel in: ", reset_time, " seconds.")

	# Reset the panel and start the timer for the next event
	reset_event_panel()
	eventTimer.wait_time = reset_time
	eventTimer.start()

func reset_event_panel() -> void:
	choice_lock = false
	eventPanel.visible = false
	event_show = false
	eventText.text = """Slyph the Draging-fly
	"You don't know where he came from, but you sense good and bad.
	He promises luck to you, or misfortune. You feel a sense of uncertainty."
	Take the chances?"""

	
	eventChoice.visible = true
	$EventPanel/Yes.visible = true
	$EventPanel/No.visible = true
	print("Event panel hidden and reset")

func _input(event: InputEvent) -> void:
	if choice_lock:  # Ignore input if the choice is locked
		return

	if event.is_action_pressed("press") and event_show:
		confirm_choice()

func _on_bedu_timer_timeout() -> void:
	print("Bede timer timeout")
	Global.breaking_rate = 10000
	var buff_containers = get_parent().get_parent().get_node("BuffContainers")
	if buff_containers:
		var sylph_icon = buff_containers.get_node("SlyphIcon")
		if sylph_icon:
			sylph_icon.visible = false
	get_parent().get_parent().start_random_event()