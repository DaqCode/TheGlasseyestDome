extends Control

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "lost":
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
