extends "res://Piece.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	moveNames = [
		"Wizard 1",
		"Wizard 2",
		"Wizard 3",
		"Wizard 4",
		]
	._ready()

	moveCells = [
	[Vector2(1,1), Vector2(2,2), Vector2(3,3)],
	[Vector2(-1,-1), Vector2(-2,-2), Vector2(-3,-3)],
	[Vector2(1,-1), Vector2(2,-2), Vector2(3,-3)],
	[Vector2(-1,1), Vector2(-2,2), Vector2(-3,3)],
	[Vector2(0,0)]
	]
	
	attackCells = [
	[Vector2(1,1)],
	[Vector2(-1,-1)],
	[Vector2(-1, 1)],
	[Vector2(1,-1)]
	]
	
	pieceName = "Wizard"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
