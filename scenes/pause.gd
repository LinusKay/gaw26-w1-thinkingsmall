extends Control


@onready var h_slider_vol_sfx: HSlider = $VBoxContainer/VBoxVolSfx/HSliderVolSfx
@onready var h_slider_vol_music: HSlider = $VBoxContainer/VBoxVolMusic/HSliderVolMusic


func _unhandled_input(event: InputEvent) -> void:
		
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			show()
			h_slider_vol_music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
			h_slider_vol_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(2))
			get_tree().paused = true
		else:
			hide()
			get_tree().paused = false
	
	if event.is_action_pressed("photo"):
		var time_string: String = Time.get_datetime_string_from_system().replace(":","")
		get_viewport().get_texture().get_image().save_png("user://" + time_string + '.png')


func _on_button_reset_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_h_slider_vol_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_h_slider_vol_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
