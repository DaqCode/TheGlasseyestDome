class_name GlotchGlitchMoth
extends Control

@onready var eventPanel := $EventPanel
@onready var eventTimer := $EventTimer
@onready var glotch := $GlotchGlitchMoth
@onready var choiceTimer := $SelectionChoice
@onready var eventChoice := $EventPanel/PointerGlitchMoth  # This is the arrow/picker
@onready var eventText := $EventPanel/MainEvent
@onready var textTimer := $TextTimer
@onready var bede := $bede

var can_fly := false  # Flag to indicate if flying is allowed
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
	
	print("Starting glotch flying event")
	event_in_progress = true
	can_fly = false
	reset_event_timer()

	eventPanel.visible = false  # Hide the panel initially
	eventTimer.one_shot = true
	eventTimer.wait_time = randi_range(15, 30)
	eventTimer.start()  # Start the event timer
	print("Event timer wait time: ", eventTimer.wait_time)

func _on_event_timer_timeout() -> void:
	can_fly = true  
	print("Moth can start flying")

func _process(delta: float) -> void:
	if can_fly:
		glotch.position.x -= 250 * delta
		glotch.flip_h = true
		if glotch.position.x < -100:
			can_fly = false
			show_event_panel() 

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
	print("Event timer reset for GlotchMoth")

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
		# If player selects "Yes"
		print("text shows yes")
		eventText.text = """You stare into Glotch's eyes. You sense, disturbance,
		the world you now exist in doesn't seem the same anymore. Corruption 
		is brough into your actions. But, maybe it's a small effect?"""

		get_parent().get_parent().glitch_event = true
		bede.wait_time = 30
		bede.start()

		var buff_containers = get_parent().get_parent().get_node("BuffContainers")
		if buff_containers:
			var fissure_frenzy = buff_containers.get_node("CrackIcon")
			if fissure_frenzy:
				fissure_frenzy.visible = true
	else:
		# If player selects "No"
		print("text shows no")
		eventText.text = """The eyes of Glotch seems untrustworthy. You reject
		the offer, thinking that it'll bring corruption into your world.
		Glotch then slowly flutters away, leaving small glitch particles."""

	textTimer.one_shot = true
	textTimer.wait_time = 7.5  # Wait for 7 seconds
	textTimer.start()

	
func _on_text_timer_timeout() -> void:
	current_choice = 0

	# Reset the panel and start the timer for the next event
	reset_event_panel()

func reset_event_panel() -> void:
	choice_lock = false
	event_in_progress = false  # Reset event in progress flag
	eventPanel.visible = false
	event_show = false
	choice_timer_active = false  # Reset choice timer flag
	eventText.text = """Glotch The Glitch Moth
	"The words coming out of the moth is incomprehensible.
	You can partially tell that he's asking you to take his offer."
	Take the offer?

	"""

	eventChoice.visible = true
	$EventPanel/Yes.visible = true
	$EventPanel/No.visible = true
	glotch.position.x = 1300
	print("Event panel hidden and reset")

func _input(event: InputEvent) -> void:
	if choice_lock:  # Ignore input if the choice is locked
		return

	if event.is_action_pressed("press") and event_show:
		confirm_choice()


func _on_bedu_timer_timeout() -> void:
	print("YEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	Global.breaking_rate = 10000
	var buff_containers = get_parent().get_parent().get_node("BuffContainers")
	if buff_containers:
		var glotch_icon = buff_containers.get_node("GlitchIcon")
		if glotch_icon:
			glotch_icon.visible = false
	get_parent().get_parent().glitch_event = false
	get_parent().get_parent().start_random_event()
