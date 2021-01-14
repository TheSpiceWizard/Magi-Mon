extends Node

onready var board = $Board

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

static func unfold2DArray(array):
	var toReturn = []
	for e in array:
		for c in e:
			toReturn.append(c)
	return toReturn

#Doesn't work for some reason...
static func getBoard(n:Node):
	return n.get_tree().get_root().get_node("Board")
	pass
