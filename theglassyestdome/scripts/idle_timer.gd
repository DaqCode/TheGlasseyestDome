extends Node

@onready var timer := $Idle
@onready var timerText := $Countdown

var countdown_time := 60  # Total countdown time in seconds
var is_timer_running := false  # To track if the timer is running

func _ready() -> void:
    timer.wait_time = 1  # Set the timer to tick every second
    timer.start()  # Start the timer
    is_timer_running = true  # Set the timer running flag
    update_timer_text()  # Update the text initially

func _process(_delta: float) -> void:
    if is_timer_running:
        # Update the countdown time and text
        update_timer_text()

    if Input.is_action_just_pressed("press"): 
        # Stop the current animation before starting a new one
        reset_timer()
        print("Timer reset...")

func _on_idle_timeout() -> void:
    countdown_time -= 1  
    if countdown_time <= 0:
        print("60 seconds passed...")
        is_timer_running = false  # Stop the timer when it reaches 0

func update_timer_text() -> void:
    timerText.text = "Idle: " + str(countdown_time)

func reset_timer() -> void:
    countdown_time = 60  # Reset the countdown time to 60 seconds
    update_timer_text()  # Update the text
    if not is_timer_running:
        timer.start()  # Restart the timer if it was stopped
        is_timer_running = true  # Set the timer running flag
