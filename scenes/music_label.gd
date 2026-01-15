extends RichTextLabel

var fade_in: bool = false
var fade_in_step: float = 0.005
var fade_in_goal: float = 131


func _process(delta: float) -> void:
	if fade_in:
		if modulate.a < fade_in_goal:
			modulate.a += fade_in_step

func _on_music_label_timer_timeout() -> void:
	fade_in = true
	print("timer done")
