class_name FissureFrenzyEvent
extends Control

@onready var eventPanel := $EventPanel
@onready var eventTimer := $EventTimer
@onready var eventText := $EventPanel/MainEvent
@onready var crack := $Crack
@onready var buff := $buff
@onready var textTimer := $TextTimer

var event_show := false  # Flag to indicate if the event can be shown

func _ready() -> void:
	crack.visible = false

func start_event() -> void:
	print("Starting fissueFrenzy event")
	eventPanel.visible = false

	eventTimer.one_shot = true
	eventTimer.wait_time = randi_range(15, 30)
	eventTimer.start()  # Start the event timer
	print("Event timer wait time: ", eventTimer.wait_time)

func _on_event_timer_timeout() -> void:
	crack.visible = true
	await get_tree().create_timer(3.5).timeout
	show_event_panel()
	print("Crack shows")


func show_event_panel() -> void:
	eventPanel.visible = true
	event_show = true
	textTimer.wait_time = 7.5
	textTimer.start()
	print("Event panel is now visible, only shown for 7.5 seconds")

func _on_text_timer_timeout() -> void:
	eventPanel.visible = false
	buff.wait_time = 1
	buff.start()

func _on_buff_timeout() -> void:
	print("Permanent breaking rate aand buff works.")
	var buff_containers = get_parent().get_parent().get_node("BuffContainers")
	if buff_containers:
		var fissure_frenzy = buff_containers.get_node("CrackIcon")
		if fissure_frenzy:
			fissure_frenzy.visible = true
	Global.breaking_rate = 7500
	get_parent().get_parent().start_random_event()

