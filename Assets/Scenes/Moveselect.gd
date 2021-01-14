extends Panel

signal moveSelected(num)

var moves = {
	1:preload("res://BasicAttack.gd").new(),
	2:preload("res://BasicAttack.gd").new(),
	3:preload("res://BasicAttack.gd").new(),
	4:preload("res://BasicAttack.gd").new(),
	
}

func setup(newMoves):
	#Setup movenames
	for n in range(newMoves.size()):
		moves[n+1] = newMoves[n]
	replaceNames()
	#Setup position
	if(rect_global_position.x + rect_size.x > OS.window_size.x):
		rect_global_position.x = OS.window_size.x - rect_size.x
	if(rect_global_position.y + rect_size.y > OS.window_size.y):
		rect_global_position.y = OS.window_size.y - rect_size.y
		
	pass

func replaceNames():
	for children in $Moves.get_children():
		if(children is HBoxContainer):
			children.get_child(0).text = moves[int(children.get_child(0).name[children.get_child(0).name.length() - 1 ])].moveName
			children.get_child(1).text = str(moves[int(children.get_child(0).name[children.get_child(0).name.length() - 1 ])].currentPP)
	pass

func _ready():
	visible = true
	for children in $Moves.get_children():
		if(!(children is Button)):
			children = children.get_child(0)
			
		children.connect("pressed", self, "_on_button_press", [children])
	#	children.text = moveNames[int(children.name[children.name.length() - 1 ])]
	$Close.connect("pressed", self, "_on_close_press")
	pass # Replace with function body.


func _on_button_press(child):
	var mNum = int(child.name[child.name.length() - 1 ])
	#print("Move chosen: %s" % moveNames[int(child.name[child.name.length() - 1 ])])
	emit_signal("moveSelected", mNum)
	pass

func _on_close_press():
	visible = false
	pass
