extends Node2D


var mouse_entered = false
var seed_value = 5
var SPEED = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	position.y += SPEED * delta

func _input(event):
	if Input.is_action_just_pressed("click") and mouse_entered:
		get_parent().add_seed(seed_value)

func _on_Area2D_mouse_entered():
	mouse_entered = true
	print("mouse entrou")


func _on_Area2D_mouse_exited():
	mouse_entered = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		$AnimationPlayer.play("fade_out")
	elif anim_name == "fade_out":
		queue_free()
