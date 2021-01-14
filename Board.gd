extends TileMap

#Variables
var pieces
var size
var pieceCells = []
var iostartPlacement = [
	[4,3,2,5,6,2,3,4],
	[1,1,1,1,1,1,1,1],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[8,8,8,8,8,8,8,8],
	[11,10,9,12,13,9,10,11],
]

var startPlacement = [
	[0,0,0,6,4,5,0,0],
	[0,0,0,2,1,3,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,8,9,10,0,0],
	[0,0,0,11,12,13,0,0],
]

var horseScene = preload("res://Assets/Scenes/BunHorse.tscn")
var warScene = preload("res://Assets/Scenes/Warrior.tscn")
var wizardScene = preload("res://Assets/Scenes/Wizard.tscn")
var golemScene = preload("res://Assets/Scenes/Golem.tscn")
var kingScene = preload("res://Assets/Scenes/King.tscn")
var queenScene = preload("res://Assets/Scenes/Queen.tscn")

var pieceDict ={
	1:warScene,
	2:horseScene,
	3:wizardScene,
	4:golemScene,
	5:kingScene,
	6:queenScene,
	8:warScene,
	9:horseScene,
	10:wizardScene,
	11:golemScene,
	12:kingScene,
	13:queenScene
	}
#DefendedCells
var defendedCells = []
#Holds the state for current action
#state 0 = idle
#state 1 = moving piece
#state 2 = attacking with piece
var state = 0

#Which of the players turn it is
var playerTurn = 2
var turnCount = 0

var Controller : PlayerController

var searchTest

#Signals
signal callDefended(cells)
signal uncallDefended()

signal callOverlay(cells)
signal uncallOverlay
signal moveSelectPopup

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_used_rect().size

	#Connecting signals to the overlayer
	connect('callOverlay', $Overlayer, 'drawOverlay')
	connect('uncallOverlay', $Overlayer, 'undrawOverlay')
	#For showing defended cells
	connect('callDefended', $Overlayer, 'drawDefended')
	connect('uncallDefended', $Overlayer, 'undrawDefended')
	
	#Setting up the board
	setupCells()
	newSpawnPieces()
	defendedCellsInit()
	#Syncing sprite animations
	pieces = get_tree().get_nodes_in_group("Piece")
	for piece in pieces:
		piece.get_node("Sprite").frame = 0
		
	#Creating PlayerController
	#Player controller holds a lot of important variables for unit selection and movement
	Controller = PlayerController.new()
	searchTest = []
	SearchFromPoint(Vector2(4,4), 3)
	
	pass # Replace with function body.

#Generates a list of points for the point within range taking in to account units
func SearchFromPoint(point : Vector2, ran : int):
	var newPoints = []
	for i in range(-1,1):
			newPoints.append(point+Vector2(i,0))
			newPoints.append(point+Vector2(0,i))
	searchTest.append(newPoints)
	#For each point call search from point with ran - 1
	if(ran - 1 > 0):
		for p in newPoints:
			SearchFromPoint(p, ran - 1)
	if(ran - 1 == 0):
		return
	pass

func killPiece(toDel : Piece):
	removeDefDied(toDel)
	toDel.queue_free()
	remove_child(toDel)
	pieceCells[toDel.cellPos.x][toDel.cellPos.y] = null
	pass

func onMoveSelect(move:Move):
	print("Called")
	Controller.selectedMove = move
	pass

func setupCells():
	for i in range(size.x):
		pieceCells.append([])
		for j in range (size.y):
			pieceCells[i].append(null)
	pass

func newSpawnPieces():
	for x in range(startPlacement.size()):
		for y in range(startPlacement.size()):
			var pieceID = startPlacement[x][y]
			if(pieceID != 0):
				var newPiece = pieceDict[pieceID].instance()
				if(pieceID < 8):
					newPiece.team = 1
					newPiece.setColor('R')
					newPiece.setDir(Vector2(0,1))
				else:
					newPiece.team = 2
					newPiece.setColor('B')
					newPiece.setDir(Vector2(0,-1))
				newPiece.position = map_to_world(Vector2(y,x)) + Vector2(32,32)
				newPiece.cellPos = Vector2(x, y)
				newPiece.connect("clicked", self, "handle_piece_click")
				newPiece.connect("moveSelected",self,"handle_move_select")
				pieceCells[y][x] = newPiece
				add_child(newPiece)
	pass

func _spawnPieces():
	var newPiece
	
	#Player 1
	for i in range(16):
		if(i < 4):
			newPiece = horseScene.instance()
			newPiece.position = map_to_world(Vector2(i,0)) + Vector2(32,32)
			newPiece.cellPos = Vector2(i,0)
			pieceCells[i][0] = newPiece
		if(i >= 4 && i < 8):
			newPiece = wizardScene.instance()
			newPiece.position = map_to_world(Vector2(i,0)) + Vector2(32,32)
			newPiece.cellPos = Vector2(i,0)
			pieceCells[i][0] = newPiece
		if(8 <= i && i < 16):
			newPiece = warScene.instance()
			newPiece.position = map_to_world(Vector2(i%8,1)) + Vector2(32,32)
			newPiece.cellPos = Vector2(i%8,1)
			pieceCells[i%8][1] = newPiece
		newPiece.connect("clicked", self, "handle_piece_click")
		newPiece.setDir(Vector2(0,1))
		newPiece.setColor("B")
		newPiece.team = 2
		add_child(newPiece)
			
	#Player 2
	for i in range(16):
		if(i < 8):
			newPiece = warScene.instance()
			newPiece.position = map_to_world(Vector2(i,6)) + Vector2(32,32)
			newPiece.cellPos = Vector2(i,6)
			pieceCells[i][6] = newPiece
		if(8 <= i && i < 16):
			newPiece = horseScene.instance()
			newPiece.position = map_to_world(Vector2(i%8,7)) + Vector2(32,32)
			newPiece.cellPos = Vector2(i%8,7)
			pieceCells[i%8][7] = newPiece
		newPiece.connect("clicked", self, "handle_piece_click")
		newPiece.setDir(Vector2(0,-1))
		newPiece.setColor("R")
		newPiece.team = 1
		add_child(newPiece)
	pass


#Checks movement squares for highlightSquares function
func moveCheck(cells):
	var toRemove = []
	var rmAll = false
	for c in cells:
		for sc in c:
			if(sc.x >= size.x or sc.y >= size.y or pieceCells[sc.x][sc.y] != null or rmAll):
				toRemove.append(sc)
				rmAll = true
		rmAll = false
	for r in toRemove:
		for sc in cells:
			sc.erase(r)

#Takes a group of cells to highlight with a overlay
#Used to show the player where he can move with a given piece
func highlightCells(toHighlight, type):
	if(type == 0):
		moveCheck(toHighlight)
	var formatHighlight = []
	for a in toHighlight:
		for v in a:
			formatHighlight.append(v)
	if type == 0:
		emit_signal("callOverlay", formatHighlight, Color(.2,.8, .2, .9))
	if type == 1:
		emit_signal("callOverlay", formatHighlight, Color.red)
	pass

func unHighlightCells():
	emit_signal('uncallOverlay')
	pass


#These functions implement logic for defending cells
#Create overlay for defended cells
func showDefendedCells():
	emit_signal("callDefended", defendedCells)
	pass
	
func unshowDefendedCells():
	pass
	
#Initialize defnded cells array
func defendedCellsInit():
	#Set up array of arrays
	for i in range(size.x):
		defendedCells.append([])
		for j in range(size.y):
			defendedCells[i].append([])
			defendedCells[i][j].append(Vector2(i,j))
	var pieceList = get_tree().get_nodes_in_group('Piece')
	for p in pieceList:
		addDef(p)
		#for c in p.defendCells:
		#	for sc in c:
		#		var newDef = Vector2(p.cellPos + p.dir)
		#		if(newDef.x >= 8 or newDef.y >= 8):
		#			pass
		#		else:
		#			defendedCells[newDef.x][newDef.y].append(p.team)
	pass

func updateDef(p: Piece):
	removeDef(p)
	addDef(p)
	pass

func addTeamDef(cellDef, team):
	
	pass

#TEST FUNCTION
func findAngleOfDir(dir):
	var angle = atan2(dir.y, dir.x)
	#print("Angle Of Dir is %s" % angle)
	return angle
	pass

func findNewDef(p: Piece, defCell):
	var def : Vector2
	var rotate = findAngleOfDir(p.dir)
	var newDefCell = defCell.rotated(rotate)
	def = Vector2(p.cellPos + newDefCell)
	def = def.round()
	#print("Adding is %s" % def)
	return def

func findOldDef(p: Piece, defCell):
	var def : Vector2
	var rotate = findAngleOfDir(p.pastDir)
	var newDefCell = defCell.rotated(rotate)
	def = Vector2(p.pastCellPos + newDefCell)
	def = def.round()
	print("Deleting %s" % def)
	return def

func addDef(p: Piece):
	for c in p.defendCells:
		for sc in c:
			var newDef = findNewDef(p, sc)
			if(newDef.x < 8 && newDef.y < 8):
				defendedCells[newDef.x][newDef.y].append(p.team)
	pass

func removeDef(p: Piece):
	for c in p.defendCells:
		for sc in c:
			var newDef = findOldDef(p, sc)
			if(newDef.x < 8 && newDef.y < 8):
				defendedCells[newDef.x][newDef.y].erase(p.team)
	pass

func removeDefDied(p: Piece):
	for c in p.defendCells:
		for sc in c:
			var newDef = findNewDef(p, sc)
			defendedCells[newDef.x][newDef.y].erase(p.team)
	pass

func handle_piece_click(node:Piece):
	#If state == 0 (meaning idle) select current piece
	if((state == 0 or state == 1) && node.team == playerTurn):
		Controller.setSelected(node)
		print("%s on square %s has been selected!" % [Controller.selected.pieceName, Controller.selected.cellPos])
		highlightCells(Controller.getModifiedMoveCells(), 0)
		state = 3
		Controller.selected.newShake()
		$BAudio.play()
		pass

#Check if position is in current units attack range
func checkAttack(unit: Piece, pos: Vector2):
	var attackCells = unit.getVaildAttacks()
	if(attackCells.has(pos)):
		return true
	else:
		return false
		
	pass
	
func killCheck():
	pass

func switchTurn():
	if(playerTurn == 1):
		playerTurn = 2
	else:
		playerTurn = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Idle wait for signal from piece
	if(state == 0):
		pass
	#Moving Piece UNUSED??
	elif(state == 1):
		if(Input.is_action_just_pressed("left_click")):
			var newPos = world_to_map(get_global_mouse_position())
			var copy = Controller.getModifiedMoveCells()
			moveCheck(copy)
			for c in copy:
				if(c.has(newPos)):
					print("Valid move to %s" % newPos)
					pieceCells[Controller.selected.cellPos.x][Controller.selected.cellPos.y] = null
					pieceCells[newPos.x][newPos.y] = Controller.selected
					Controller.selected.newShake()
					Controller.selected.position = map_to_world(newPos) + Vector2(32,32)
					Controller.selected.setCellPos(newPos)
					$BAudio.play()
					#TO DO make a change state function for handling logic between states (creating attack overlay)
					unHighlightCells()
					#emit_signal("callOverlay", Controller.selected.getVaildAttacks(), Color(1,0,0,.8))
					Controller.selected.spawnMenu()
					state = 4
		pass
	#Attacking with piece
	elif(state == 2):
		
		if(Input.is_action_just_pressed("left_click")):
			#Get where mouse clicked on board
			var atkPos = world_to_map(get_global_mouse_position())
			#Check if valid pos if not loop around
			#Check is based on selected piece attack vector
			if(checkAttack(Controller.selected, atkPos)):
				var kill = true
				#Check to see if theres a piece of the enemy there
				#TODO remvoe unit funcction
				if(defendedCells[Controller.selected.cellPos.x][Controller.selected.cellPos.y].has(1) && Controller.selected.team !=1):
					kill = false
					pass
				if(defendedCells[Controller.selected.cellPos.x][Controller.selected.cellPos.y].has(2) && Controller.selected.team !=2):
					kill = false
					pass
				
				if(pieceCells[atkPos.x][atkPos.y] != null && (pieceCells[atkPos.x][atkPos.y].team != playerTurn) && kill == true):
					$DAudio.play()
					var toDel = pieceCells[atkPos.x][atkPos.y]
					removeDefDied(toDel)
					toDel.queue_free()
					remove_child(toDel)
					pieceCells[atkPos.x][atkPos.y] = null
				var newDir = atkPos - Controller.selected.cellPos
				print("newDir %s" % newDir)
				Controller.selected.setDir(atkPos - Controller.selected.cellPos)
				updateDef(Controller.selected)
				state = 0
				if(playerTurn == 1):
					playerTurn = 2
				else:
					playerTurn = 1
				unHighlightCells()
			else:
				pass
		pass
	
	#Transition state
	elif(state == 3):
		state = 1
		pass
	#TEST STATE as of right now
	#Used for resolving moves
	#Make sure to set selected move back to null after resolved
	elif(state == 4):
		if(!Controller.selectedMove == null):
			#Pass self to move because reasons????
			Controller.selectedMove.moveLogic(self)
		pass
	elif(state == 5):
		Controller.selectedMove = null
		switchTurn()
		state = 0
	
	
	#if(Input.is_action_just_pressed("undo")):
		#state = 0
		#unHighlightCells()
		#pass
	#Show all defended squares
	if(Input.is_action_just_pressed("ui_show")):
		showDefendedCells()
	if(Input.is_action_just_released("ui_show")):
		showDefendedCells()
		pass
	pass
