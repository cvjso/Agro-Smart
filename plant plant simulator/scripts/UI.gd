extends Control

onready var requester = $HTTPRequest
var processing = 0
var seeds = 0

func _ready():
	requester.connect("request_completed", self, "_on_request_completed")

func _process(delta):
	if not processing:
		requester.request('https://ping-74a1b.firebaseio.com/.json')
		processing = 1

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	update_text(json.result)
	processing = 0

func update_seed(new_value):
	var prev_text = $HBoxContainer.get_node("Seed").get_child(0).bbcode_text
	prev_text = prev_text.split("\n")
	seeds += new_value
	$HBoxContainer.get_node("Seed").get_child(0).bbcode_text = prev_text[0] + "\n" + str(seeds)

func update_text(result):
	for child in $HBoxContainer.get_children():
		var prev_text = child.get_child(0).bbcode_text
		prev_text = prev_text.split("\n")
		var prev_value = prev_text[1].split(" ")
		if child.name in result["parameters"].keys():
			if str(result["parameters"][child.name]) != prev_value[0]:
				var new_value = str(result["parameters"][child.name]) + " " + prev_value[1]
				var new_text = prev_text[0] + "\n" + new_value
				child.get_child(0).bbcode_text = new_text
