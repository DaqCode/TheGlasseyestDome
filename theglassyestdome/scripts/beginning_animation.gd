extends Control
@onready var animation := $AnimationPlayer

func _ready():
	animation.current_animation = "intro"
	animation.play()

func _on_animation_finished(anim_name:StringName) -> void:
	if anim_name == "intro":
		get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("press"):
		get_tree().change_scene_to_file("res://scenes/main_game.tscn")