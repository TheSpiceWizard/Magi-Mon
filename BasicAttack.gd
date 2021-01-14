extends "res://Move.gd"

var attk = [[Vector2(0,-1)], [Vector2(0,1)], [Vector2(1,0)], [Vector2(-1,0)]]
var board

var dmg = 10

func _init():
	moveName = "Basic Attack"
	basePP = 20

#This will get called in board?
func moveLogic(board): 
	var currentAtk = [[pieceOwner.cellPos + attk[0][0]]]
	for a in attk:
		for sa in a:
			currentAtk.append([pieceOwner.cellPos + sa])
	
	#Create overlay
	board.highlightCells(currentAtk, 1)
	#Check attack if Input is selected
	if(Input.is_action_just_pressed("left_click")):
		var atkPos = board.world_to_map(get_global_mouse_position())
		for a in currentAtk:
			for sa in a:
				if(sa == atkPos):
					board.unHighlightCells()
					currentPP -= 1
					if(board.pieceCells[atkPos.x][atkPos.y] != null):
						#board.pieceCells[atkPos.x][atkPos.y].get_node("HP").text = str(board.pieceCells[atkPos.x][atkPos.y].HP)
						board.pieceCells[atkPos.x][atkPos.y].takeDamage(dmg)
					board.state = 5
	pass
