extends Node2D

onready var anim = $toupeira/AnimationPlayer
var seed_scene = preload("res://scenes/seed.tscn")

var empty = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func lose_block():
	empty = false
	$Timer.queue_free()
	if not anim.is_playing():
		anim.play("lose block")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	if empty:
		anim.play("generate seed")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "generate seed":
		var seed_inst = seed_scene.instance()
		get_parent().get_parent().add_child(seed_inst)
		seed_inst.position = position
		if not empty:
			anim.play("lose block")
