extends Control

var drawing: bool = false

var current_line2d: Line2D
var last_point: Vector2 = Vector2(0,0)
var point_distance_threshold: float = 2.0
var draw_offset: Vector2 = Vector2.ZERO

var pencil_line_tscn = preload("res://scenes/pencil_line.tscn")

var memories: Array[Dictionary] = [
	#{
		#"colour": Color.CORAL,
		#"points": [],
		#"position": Vector2.ZERO
	#}
]

var memory_time_min: float = 8.0
var memory_time_max: float = 10.0
var memory_time_min_current: float = memory_time_min
var memory_time_max_current: float = memory_time_max
var memory_time: float = randf_range(memory_time_min, memory_time_max)
var memory_time_decrease_by_quantity: float = 0.1

@onready var memory_timer: Timer = $MemoryTimer
@onready var audio_stream_player_draw_sfx: AudioStreamPlayer = $AudioStreamPlayerDrawSfx


func _ready() -> void:
	memory_timer.start(1)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		_draw_start()
	if event.is_action_released("click"):
		_draw_end()
		
	if drawing:
		_handle_draw()


func _draw_start() -> void:
	drawing = true
	current_line2d = pencil_line_tscn.instantiate()
	add_child(current_line2d)
	var mouse_position:  Vector2 = get_viewport().get_mouse_position()
	draw_offset = mouse_position
	current_line2d.position = mouse_position
	audio_stream_player_draw_sfx.play()


func _draw_end() -> void:
	current_line2d.complete = true
	drawing = false
	memories.append(
		{
		"colour": current_line2d.default_color,
		"points": current_line2d.points,
		"position": current_line2d.position
		}
	)
	print(current_line2d.points)
	if memories.size() > 100: 
		memories.pop_front()
	audio_stream_player_draw_sfx.stop()


func _handle_draw() -> void:
	var mouse_position:  Vector2 = get_viewport().get_mouse_position() - draw_offset
	if last_point.distance_to(mouse_position) > point_distance_threshold:
		current_line2d.add_point(mouse_position)
		last_point = mouse_position


func _on_memory_timer_timeout() -> void:
	if memories.size() > 0:
		var memory_index: int = randi_range(0, memories.size()-1)
		var memory: Dictionary = memories[memory_index]
		var memory_line2d: PencilLine = pencil_line_tscn.instantiate()
		add_child(memory_line2d)
		memory_line2d.default_color = memory.colour
		memory_line2d.points = memory.points
		memory_line2d.position = memory.position
		memory_line2d.is_memory = true
		memory_line2d.complete = true
	
	memory_time_min_current = clamp(memory_time_min - (memory_time_decrease_by_quantity * memories.size()), 0, memory_time_min)
	memory_time_max_current = clamp(memory_time_max - (memory_time_decrease_by_quantity * memories.size()), 0.2, memory_time_max)
	memory_time = randf_range(memory_time_min_current, memory_time_max_current)
	
	memory_timer.start(memory_time)
