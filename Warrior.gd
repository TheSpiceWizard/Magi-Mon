extends "res://Piece.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	
	
	moveCells = [
	[Vector2(1,0), Vector2(2,0), Vector2(3,0)],
	[Vector2(-1,0), Vector2(-2,0), Vector2(-3,0)],
	[Vector2(0,1), Vector2(0,2), Vector2(0,3)],
	[Vector2(0,-1), Vector2(0,-2), Vector2(0,-3)],
	[Vector2(0,0)]
	]
	
	attackCells = [
	[Vector2(1,0)],
	[Vector2(0,1)],
	[Vector2(-1, 0)],
	[Vector2(0,-1)]
	]
	
	defendCells = [
		[Vector2(1,0)],
		[Vector2(0,-1)],
		[Vector2(0,1)],
	]
	
	pieceName = "Warrior"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
