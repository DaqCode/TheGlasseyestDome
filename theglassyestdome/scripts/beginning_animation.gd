extends Control
@onready var animation := $AnimationPlayer

func _ready():
	animation.current_animation = "intro"
	animation.play()

func _on_animation_finished(anim_name:StringName) -> void:
	if anim_name == "intro":
		print("Play the game boy")