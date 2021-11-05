extends Control

onready var requester = $HTTPRequest

func _ready():
	requester.connect("request_completed", self, "_on_request_completed")
	requester.request('https://ping-74a1b.firebaseio.com/.json')

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
