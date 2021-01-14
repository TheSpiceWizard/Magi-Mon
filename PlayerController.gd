extends Node2D
class_name PlayerController
#This class will assist board and hold various data about pieces

var selected : Piece
var selectedMove : Move
var selCellPos


func _init():
	selected = null
	selCellPos = null
	pass

func setSelected(node):
	selected = node
	selCellPos = node.cellPos
	pass

func clearSelected():
	selected = null
	selCellPos = null
	pass
	
#Returns moveCells after adding piece positon
func getModifiedMoveCells():
	var modCells = []
	for c in selected.moveCells:
		modCells.append([])
		for sc in c:
			modCells.back().append(sc + selCellPos)
	return modCells
	pass
	
#Search move cells for cell
func findMoveCell(cellPos):
	for c in getModifiedMoveCells():
		if(c.has(cellPos)):
			return true
		else:
			return false
