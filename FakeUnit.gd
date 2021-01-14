extends Area2D


var selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect('input_event', self, 'on_input_event')
	pass # Replace with function body.


func _input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton && event.pressed == true):
		selected = !selected
	pass
	
func _process(delta):
	if(selected):
		position = get_global_mouse_position()
