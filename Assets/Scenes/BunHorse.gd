extends "res://Piece.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	
	
	moveCells = [
	[Vector2(2, 1)],
	[Vector2(2, -1)],
	[Vector2(-2, 1)],
	[Vector2(-2, -1)],
	[Vector2(1, 2)],
	[Vector2(1,-2)],
	[Vector2(-1, 2)],
	[Vector2(-1,-2)]
	]
	
	pieceName = "Bun-Horse"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
