extends Camera2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	if(Input.is_action_just_pressed("ui_right")):
		position.x += 64 
	if(Input.is_action_just_pressed("ui_left")):
		position.x -= 64 
	if(Input.is_action_just_pressed("ui_down")):
		position.y += 64
	if(Input.is_action_just_pressed("ui_up")):
		position.y -= 64
	pass
