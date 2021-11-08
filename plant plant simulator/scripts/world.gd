extends Node2D

onready var tilemap = $TileMap
onready var cursor_block = $"block cursor"
var base_block = preload("res://scenes/base block.tscn")

func _ready():
	pass

func _process(delta):
	if cursor_block.visible:
		var mousePos = get_viewport().get_mouse_position()
		cursor_block.position = mousePos

func add_seed(value):
	$CanvasLayer/UI.update_seed(value)

func _input(event):
	if Input.is_action_just_pressed("r_click"):
		cursor_block.visible = !cursor_block.visible
	
	if Input.is_action_just_pressed("click") and cursor_block.visible:
		var mousePos = get_viewport().get_mouse_position()
		var loc = tilemap.world_to_map(mousePos)
		var cell = tilemap.get_cell(loc.x, loc.y)
		if cell == tilemap.INVALID_CELL:
			tilemap.set_cell(loc.x, loc.y, 0)
			var new_block = base_block.instance()
			$blocks.add_child(new_block)
			new_block.global_position = tilemap.map_to_world(loc)
