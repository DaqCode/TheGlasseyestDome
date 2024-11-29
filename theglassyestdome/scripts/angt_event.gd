class_name TheWatcherAnt
extends Control

@onready var eventPanel := $EventPanel
@onready var eventTimer := $EventTimer
@onready var angt := $WandererAngt
@onready var choiceTimer := $ChoiceTimer
@onready var eventChoice := $EventPanel/PointerAngt  # This is the arrow/picker
@onready var eventText := $EventPanel/MainEvent
@onready var textTimer := $TextTimer
@onready var bede := $EffectTImer

var can_walk := false  # Flag to indicate if flying is allowed
var can_walk_away := false
var event_show := false  # Flag to indicate if the event can be shown
var choice_lock := false

# New flag variables to ensure one-time execution
var event_in_progress := false
var choice_timer_active := false

# Choice variables
var current_choice := 0
	
func start_event() -> void:
	if event_in_progress:  # Ensure the event does not start if already in progress
		print("Event is already in progress. Cannot start a new one.")
		return
	
	print("Starting ang_walking event")
	event_in_progress = true
	can_walk = false
	eventPanel.visible = false
	reset_event_timer()

	eventPanel.visible = false  # Hide the panel initially
	eventTimer.one_shot = true
	eventTimer.wait_time = randi_range(5, 10)
	eventTimer.start()  # Start the event timer
	print("Event timer wait time: ", eventTimer.wait_time)

func _on_event_timer_timeout() -> void:
	can_walk = true  
	print("Abgt can now start crawling")

func _process(delta: float) -> void:
	if can_walk:
		angt.position.x += 25 * delta
		angt.flip_h = true
		if angt.position.x > 140:
			can_walk = false
			show_event_panel() 
	
	if can_walk_away:
		angt.position.x -= 45 * delta
		angt.flip_h = false
		if angt.position.x < -50:
			can_walk_away = false
			angt.flip_h = false
	
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
	can_walk_away = false
	print("Event timer reset for AGBT")

func start_choice_timer() -> void:
	if choice_timer_active:  # Ensure the choice timer only starts once
		print("Choice timer is already active.")
		return

	choice_timer_active = true
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

	if current_choice >= 15:
		confirm_choice()

	print(current_choice)

func confirm_choice() -> void:
	print("CHOICE CONFIRMED")
	choice_lock = true
	choice_timer_active = false  # Reset the choice timer flag
	choiceTimer.stop()  # Stop the choice timer when confirmed
	eventChoice.visible = false
	$EventPanel/Yes.visible = false
	$EventPanel/No.visible = false

	if current_choice % 2 == 0:
		var rand = randi_range(1, 2)
		if rand == 1:
			print("text shows yes and good effect")
			eventText.text = """The Wanderer stares towards you. 
			You sense comfort, luck, and wisdom. The Wanderer tells you 
			that you'll pass. You feel much stronger."""

			Global.breaking_rate = 2500
			bede.wait_time = 30
			bede.start()

		else:
			print("text shows yes, but bad effect")
			eventText.text = """The Wanderer stares towards you. 
			You sense, dread, despair, and unfortune. The Wanderer senses 
			you might fail, but you shouldn't give in. You feel slightly weaker."""

			if Global.breaking_rate == 7500:
				Global.breaking_rate = 10500
			else: 
				Global.breaking_rate = 12750
			bede.wait_time = 20
			bede.start()
	else:
		print("text shows no")
		eventText.text = """The eyes of the Wanderer decieve you. You sense 
		that it might not be worth the risk, and you decide to turn away. 
		The Wanderer then dissapears."""

	textTimer.one_shot = true
	textTimer.wait_time = 7.5  # Wait for 7 seconds
	textTimer.start()
	
func _on_text_timer_timeout() -> void:
	can_walk_away = true
	current_choice = 0

	# Reset the panel and start the timer for the next event
	reset_event_panel()

func reset_event_panel() -> void:
	choice_lock = false
	event_in_progress = false  # Reset event in progress flag
	eventPanel.visible = false
	event_show = false
	choice_timer_active = false  # Reset choice timer flag
	eventText.text = """Wanderer The Ang-T
	"He seems to have waddled his way towards where you are.
	He says his vision will tell you the hopeful truth, or possible lie."
	Take the chance?
	"""

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
	print("YEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	Global.breaking_rate = 10000
	get_parent().get_parent().start_random_event()