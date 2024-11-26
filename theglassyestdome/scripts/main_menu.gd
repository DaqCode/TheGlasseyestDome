extends Control

@onready var animation_stuff := $AnimationPlayer
@onready var music := $Music

var is_music_playing := false  # Flag to track if music is currently playing

# Starts with begin animation to then slowly progress into the introduction.
func _ready() -> void:
    animation_stuff.current_animation = "begin"
    animation_stuff.play()

# Function to change animations, used in _process to change animations and not create missing backgrounds.
func change_animation(ani_change: StringName) -> void:
    animation_stuff.stop()
    animation_stuff.current_animation = ani_change
    animation_stuff.play()

# Function to check animations being completed, in order to figure out which animation to start next
func _on_animation_stuff_animation_finished(anim_name: StringName) -> void:
    if anim_name == "begin":
        animation_stuff.current_animation = "intro"
        animation_stuff.play()

    elif anim_name == "intro":
        animation_stuff.current_animation = "idle"
        animation_stuff.play()

    elif anim_name == "pressed":
        get_tree().change_scene_to_file("res://scenes/beginning_animation.tscn")
        print("Successful transition")

# Function to check if the current button, ONLY B, is pressed. Otherwise, it'll do nothing.
func _process(_delta: float) -> void:
    if animation_stuff.current_animation == "idle":
        if not is_music_playing:  # Check if music is not already playing
            music.play()
            is_music_playing = true  # Set the flag to true

    else:
        if is_music_playing:  # If the animation is not idle and music is playing
            music.stop()  # Stop the music
            is_music_playing = false  # Reset the flag

    if Input.is_action_just_pressed("press"): 
        # Stop the current animation before starting a new one
        if animation_stuff.current_animation == "begin":
            change_animation("intro")

        elif animation_stuff.current_animation == "intro":
            change_animation("idle")

        elif animation_stuff.current_animation == "idle":
            change_animation("pressed")
