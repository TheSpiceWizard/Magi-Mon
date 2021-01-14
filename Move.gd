extends Node2D
#Parent class for all moves
class_name Move

var moveName = "Default"

var basePP = 10
var currentPP = 10

var damage

var pieceOwner

func _ready():
	pass # Replace with function body.

func moveLogic(board):
	pass


#Utility functions
func getBoard():
	Util.getBoard(self)
