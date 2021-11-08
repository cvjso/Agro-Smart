extends Node2D

var seed_sc = preload("res://scenes/seed.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var inst = seed_sc.instance()
	add_child(inst)
	inst.position.x = 100
	inst.position.y = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
