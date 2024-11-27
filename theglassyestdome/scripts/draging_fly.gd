extends Control

@onready var eventPanel := $EventPanel
@onready var eventTimer := $EventTimer
@onready var slypth := $SlypthDragingFly
@onready var choiceTimer := $SelectionChoice
@onready var eventChoice := $EventPanel/PointerDragingFly  # This is the arrow/picker
@onready var eventText := $EventPanel/MainEvent
@onready var textTimer := $TextTimer

var can_fly := false  # Flag to indicate if flying is allowed
var event_show := false  # Flag to indicate if the event can be shown

# Choice variables
var current_choice := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eventPanel.visible = false  # Hide the panel initially
	eventTimer.one_shot = true
	eventTimer.wait_time = randi_range(5, 10)
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

func show_event_panel() -> void:
	eventPanel.visible = true
	event_show = true
	start_choice_timer()  # Start the choice timer
	print("Event panel is now visible, starting choice timer")

func reset_event_timer() -> void:
	eventTimer.wait_time = randi_range(30, 75)
	eventTimer.start()  # Restart the event timer
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
	choiceTimer.stop()  # Stop the choice timer when confirmed
	eventChoice.visible = false
	$EventPanel/Yes.visible = false
	$EventPanel/No.visible = false

	if current_choice % 2 == 0:
		var rand = randi_range(1, 2)
		if rand == 1:
			print("text shows yes and good effect")
			eventText.text = """Slyph grants you assistance. He blesses you with his own abilities.
	For 30 seconds, you feel ever so light. You can now punch even more."""
		else:
			print("text shows yes, but bad effect")
			eventText.text = """Slyph grants you assistance. However, it didn't work as intended.
	For 30 seconds, you feel much weaker. You weren't ready yet."""
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
	if event.is_action_pressed("press") and event_show:
		confirm_choice()