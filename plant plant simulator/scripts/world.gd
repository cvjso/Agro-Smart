extends Node2D

onready var tilemap = $TileMap

func _ready():
	pass

func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	var loc = tilemap.world_to_map(mousePos)
	var cell = tilemap.get_cell(loc.x, loc.y)
	print(tilemap.tile_set.tile_get_name(cell), " ", loc.x, " ", loc.y)

func _input(event):
	if Input.is_action_just_pressed("click"):
		var mousePos = get_viewport().get_mouse_position()
		var loc = tilemap.world_to_map(mousePos)
		var cell = tilemap.get_cell(loc.x, loc.y)
		tilemap.set_cell(loc.x, loc.y, 0)
