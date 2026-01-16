class_name PencilLine extends Line2D

var max_line_width: float = 300

var is_memory: bool = false

var complete: bool = false:
	set(_complete):
		complete = _complete
		_draw_complete()
var resizing: bool = false
var resize_goal: float
var resize_step: float = 0.05

var ttl: float = randf_range(4.0, 7.0)

var fading: bool = false
var fade_step: float = 0.05
var alpha: float = 255

var colours: Array[Color] = [
	Color.ROYAL_BLUE,
	Color.AQUAMARINE,
	Color.CORAL,
	Color.DODGER_BLUE,
	Color.LIGHT_SALMON,
	Color.LIGHT_SEA_GREEN,
	Color.LIGHT_PINK,
	Color.LIGHT_GREEN,
	Color.ORCHID
]


@onready var ttl_timer: Timer = $TtlTimer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var sfx_wall: AudioStream = preload("res://audio/sfx/wall.wav")
@onready var sfx_part: AudioStream = preload("res://audio/sfx/part.wav")


func _ready() -> void:
	modulate = colours.pick_random()
	

func _draw_complete() -> void:
	if is_memory:
		audio_stream_player.stream = sfx_wall
	else:
		audio_stream_player.stream = sfx_part
	audio_stream_player.pitch_scale = randf_range(0.7,1.3)
	audio_stream_player.play()
	_calc_resize()


func _process(_delta: float) -> void:
	if complete:
		if ttl_timer.is_stopped():
			ttl_timer.start(ttl)
			
		if resizing:
			if scale.x > resize_goal:
				scale.x = lerp(scale.x, resize_goal, resize_step)
				scale.y = lerp(scale.y, resize_goal, resize_step)
			else:
				resizing = false
	
		if fading:
			position.y += .1
			alpha = lerp(alpha, 0.0, fade_step)
			modulate.a = alpha
			
			if alpha <= 0.0: 
				queue_free()


func _calc_resize() -> void:
	var line_width: float = _calc_width()
	if line_width > max_line_width:
		resize_goal = max_line_width/line_width
		resizing = true

func _calc_width() -> float:
	var left_most: Vector2
	var right_most: Vector2
	for point_index in points.size():
		var point = points[point_index]
		if point_index == 0:
			left_most = point
			right_most = point
			continue
		if point.x < left_most.x:
			left_most = point
		if point.x > right_most.x:
			right_most = point
	var line_width: float = right_most.x - left_most.x
	return line_width


func _on_ttl_timer_timeout() -> void:
	fading = true
