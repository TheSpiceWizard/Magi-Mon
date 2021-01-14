extends AnimatedSprite


var clickSound = preload("res://Assets/Sounds/Click.wav")
var oldPos = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	if(get_parent().get_node("Board") != null):
		oldPos = get_position()
	pass # Replace with function body.

func get_position():
	var newPos = get_parent().get_node("Board").world_to_map(get_global_mouse_position())
	newPos = get_parent().get_node("Board").map_to_world(newPos)
	if(oldPos != newPos):
		oldPos = newPos
		$Audio.play()
	return newPos
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_parent().get_node("Board") != null):
		position = get_position()
	pass
