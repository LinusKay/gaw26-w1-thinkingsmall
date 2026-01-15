extends Node

@onready var pause_menu: Control = $Pause


func _unhandled_input(event: InputEvent) -> void:
		
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			pause_menu.show()
			get_tree().paused = true
		else:
			pause_menu.hide()
			get_tree().paused = false
	
	if event.is_action_pressed("photo"):
		var time_string: String = Time.get_datetime_string_from_system().replace(":","")
		get_viewport().get_texture().get_image().save_png("user://" + time_string + '.png')


func _on_button_reset_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
