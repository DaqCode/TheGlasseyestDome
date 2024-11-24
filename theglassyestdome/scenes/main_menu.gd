extends Control

@onready var animation_stuff := $AnimationStuff

func _ready() -> void:
	animation_stuff.current_animation = "begin"
	animation_stuff.play()

func _on_animation_stuff_animation_finished(anim_name: StringName) -> void:
	if anim_name == "begin":
		animation_stuff.current_animation = "intro"
		animation_stuff.play()

	elif anim_name == "intro":
		animation_stuff.current_animation = "idle"
		animation_stuff.play()

func change_animation(ani_change: StringName) -> void:
	animation_stuff.stop()
	animation_stuff.current_animation = ani_change
	animation_stuff.play()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("press"): 

		# Stop the current animation before starting a new one

		if animation_stuff.current_animation == "begin":
			change_animation("intro")

		elif animation_stuff.current_animation == "intro":
			change_animation("idle")

		elif animation_stuff.current_animation == "idle":
			change_animation("pressed")

	else:
		print("NOT PRESSED!")
