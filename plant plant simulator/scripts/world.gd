extends Node

onready var tilemap = $TileMap
onready var cursor_block = $"block cursor"
var base_block = preload("res://scenes/base block.tscn")
var ending = preload("res://scenes/End.tscn")
var block_value = 10
var limit = 300
var ended = false

func _ready():
	pass

func _process(delta):
	if cursor_block.visible:
		var mousePos = get_viewport().get_mouse_position()
		cursor_block.position = mousePos
		cursor_block.position.y -= 10
	if $UI.seeds >= limit and not ended:
		ended = true
		var end_inst = ending.instance()
		add_child(end_inst)

func add_seed(value):
	$UI.update_seed(value)

func _input(event):
	if Input.is_action_just_pressed("r_click"):
		cursor_block.visible = !cursor_block.visible
	
	if Input.is_action_just_pressed("teste"):
		var all_blocks = $blocks.get_children()
		for rand_block in all_blocks:
			if rand_block.empty:
				rand_block.lose_block()
				break
	
	if Input.is_action_just_pressed("click") and cursor_block.visible:
		var mousePos = get_viewport().get_mouse_position()
		var loc = tilemap.world_to_map(mousePos)
		var cell = tilemap.get_cell(loc.x, loc.y)
		if cell == tilemap.INVALID_CELL:
			tilemap.set_cell(loc.x, loc.y, 0)
			var new_block = base_block.instance()
			$blocks.add_child(new_block)
			new_block.global_position = tilemap.map_to_world(loc)
			$UI.update_seed(-block_value)
