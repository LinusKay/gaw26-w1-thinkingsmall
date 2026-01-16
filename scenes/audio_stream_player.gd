extends AudioStreamPlayer

@onready var songs: Array[Dictionary] = [
	{
		"title": "새눈도둑 Bird's Eye Thief - Flash - 09 Open End",
		"file": preload("res://audio/music/새눈도둑 Bird's Eye Thief - Flash - 09 Open End.mp3")
	},
	{
		"title": "새눈도둑 Bird's Eye Thief - Flash - 03 SPap",
		"file": preload("res://audio/music/새눈도둑 Bird's Eye Thief - Flash - 03 SPap.mp3")
	},
	{
		"title": "새눈바탕 Bird's Eye Batang - 손을 모아 Flood Format - 05 윙윙 Towards",
		"file": preload("res://audio/music/새눈바탕 Bird's Eye Batang - 손을 모아 Flood Format - 05 윙윙 Towards.mp3")
	},
	{
		"title": "새눈바탕 Bird's Eye Batang - 손을 모아 Flood Format - 08 수 Are Your Wings Swept-",
		"file": preload("res://audio/music/새눈바탕 Bird's Eye Batang - 손을 모아 Flood Format - 08 수 Are Your Wings Swept-.mp3")
	},
]
var song_index: int = 0

@onready var music_label: RichTextLabel = $MusicLabel
@onready var music_label_timer: Timer = $MusicLabelTimer


var label_fade_in: bool = false
var label_fade_in_step: float = 0.005
var label_fade_in_goal: float = 0.5
var label_fade_out: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = songs[song_index].file
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if label_fade_in:
		if music_label.modulate.a < label_fade_in_goal:
			print(music_label.modulate.a)
			music_label.modulate.a += label_fade_in_step
		else:
			label_fade_in = false
	if label_fade_out:
		if music_label.modulate.a > 0.0:
			music_label.modulate.a -= label_fade_in_step
		else:
			label_fade_out = false
			music_label.text = "[b][wave freq=2]♪ " + songs[song_index].title + "[/wave][/b]"
			play()
			music_label_timer.start(5.0)


func _on_finished() -> void:
	print("on finished")
	label_fade_out = true
	song_index += 1
	if song_index > songs.size() - 1: song_index = 0
	stream = songs[song_index].file
	


func _on_music_label_timer_timeout() -> void:
	label_fade_in = true
	print("timer done")
