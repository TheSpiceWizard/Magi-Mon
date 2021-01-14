extends Area2D
class_name Piece

#Piece variables
var HP = 20
var SPEED = 1
var PHYATK = 1
var PHYDEF = 1
var SPCATK = 1
var SPCDEF = 1

#UI stuff
var UIMenu = preload("res://Assets/Scenes/Moveselect.tscn")

#Test Move Array
var moves = [
	preload("res://BasicAttack.gd").new(),
	preload("res://BasicAttack.gd").new(),
	preload("res://BasicAttack.gd").new(),
	preload("res://BasicAttack.gd").new()
	
]

#Moves
var moveNames = [
	"Move 1",
	"Move 2",
	"Move 3",
	"Move 4",
]

#State variables
var follow = false
var attack = false
var selected = false
var pieceName = "Default"
var team = 0


var board
var cellPos := Vector2(0,0)
var pastCellPos := Vector2(0,0)
#Direction piece is facing
#Changes where the piece defends
var dir := Vector2(0,0)
var pastDir := Vector2(0,0)


var newPosition
var moveCells = [
	[Vector2(0,1)],
	[Vector2(1,0)],
	[Vector2(-1, 0)],
	[Vector2(0,-1)],
	[Vector2(1,1)],
	[Vector2(-1,1)],
	[Vector2(-1,-1)],
	[Vector2(1,-1)],
	[Vector2(2,0)],
	[Vector2(-2,0)],
	[Vector2(0,2)],
	[Vector2(0,-2)]
]

var defendCells = [
	[Vector2(1,0)]
	]

var attackCells = [
	[Vector2(0,1)],
	[Vector2(1,0)],
	[Vector2(-1, 0)],
	[Vector2(0,-1)],
	[Vector2(1,1)],
	[Vector2(-1,-1)],
	[Vector2(-1,1)],
	[Vector2(1,-1)]
]

var aniCount = 0

signal createOverlay(cells)
signal deleteOverlay
signal clicked(node)
signal moveSelected(move)
signal passMove(move)

func testGl():
	Util.getBoard(self)

func takeDamage(amount):
	HP -= amount
	if(HP <= 0):
		board.killPiece(self)
	$HP.text = str(HP)
		#get_parent().remove_child(self)
		#queue_free()


func _ready():
	#Get refrence to the board for later when it decides which tile it needs to land on
	board = get_parent()
	
	#Input event only gets called when the click is inside an Area2D
	#connect('input_event', self, 'on_input_event')
	connect('createOverlay', board, 'highlightCells')
	connect('deleteOverlay', board, 'unHighlightCells')
	connect('passMove', board ,'onMoveSelect')
	
	for m in moves:
		m.pieceOwner = self
		add_child(m)
	
	#Set position
	cellPos = board.world_to_map(position)
	
	moveInit()
	
	$HP.text = str(HP)
	pass # Replace with function body.

func moveInit():
	for i in range(moves.size()):
		moveNames[i] = moves[i].moveName

func spawnMenu():
	var newMenu = UIMenu.instance()
	add_child(newMenu)
	newMenu.name = "Menu"
	newMenu.setup(moves)
	newMenu.connect("moveSelected", self, "onMoveSelect")
	pass

func despawnMenu():
	$Menu.queue_free()
	remove_child($Menu)
	pass

func onMoveSelect(mNum):
	var sMove = moves[mNum-1]
	emit_signal("passMove", sMove)
	print("Passed move %s" % sMove.moveName)
	despawnMenu()
	pass

func setCellPos(cell):
	pastCellPos = cellPos
	cellPos = cell
	position = board.map_to_world(cellPos) + Vector2(32,32)
	pass
	
func setDir(newDir:Vector2):
	pastDir = dir
	dir = newDir
	pass
	

#Connected to the signal input_event
#Handles logic for when the piece is clicked
func on_input_event(viewport, event, shape_idx):
	return
	if(event is InputEventMouseButton && attack == false):
		selected = true
		follow = !follow
		showValidMove()
		#Just put piece down
		if(follow == false):
			var cellPosition = board.world_to_map(get_global_mouse_position())
			if(isValidMove(cellPosition)):
				var newPosition = board.map_to_world(cellPosition) + Vector2(32,32)
				print("Cell position is %s" % cellPosition)
				print("New position is %s" % newPosition)
				#Move all this code into board script??
				position = newPosition
				board.pieceCells[cellPos.x][cellPos.y] = null
				board.pieceCells[cellPosition.x][cellPosition.y] = self
				cellPos = cellPosition
				attack = true
				emit_signal('deleteOverlay')
				showValidAttack()
			else:
				position = board.map_to_world(cellPos) + Vector2(32,32)
				emit_signal('deleteOverlay')

func attackAction():
	var clickPos = get_global_mouse_position()
	var atkCell = board.world_to_map(clickPos)
	print("Attacking: %s" % atkCell)
	attack = false
	selected = false
	emit_signal('deleteOverlay')
	pass

#Handles other input
func _input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton && event.pressed == true):
		emit_signal("clicked", self)
	pass

func showValidMove():
	var cells = []
	
	for m in moveCells:
		cells.append([])
		for v in m:
			cells.back().append(cellPos + v)
	
	#Pass data to Board for overlay
	emit_signal('createOverlay', cells, 0)
	pass

func isValidMove(cell):
	var cells = []
	
	for m in moveCells:
		for v in m:
			cells.append(cellPos + v)
	
	if(cells.has(cell)):
		print("Valid move")
		return true
	print("Not valid")
	return false
	pass

func showValidAttack():
	var cells = []
	
	for m in attackCells:
		cells.append([])
		for v in m:
			cells.back().append(cellPos + v)
	
	#Pass data to Board for overlay
	emit_signal('createOverlay', cells, 1)
	pass

func _draw():
	pass
	#draw_rect(Rect2(Vector2(-32,-32),Vector2(64, 64)), Color.black)

func _process(delta):
	if(follow):
		position = get_global_mouse_position()
		
#Helper functions
#Probably going to break later on but good for now I think
func getVaildAttacks():
	var toReturn = []
	for c in attackCells:
		for s in c:
			toReturn.append(s+cellPos)
	return toReturn
	

func setColor(color):
	if(color == "B"):
		$Sprite.material.set_shader_param("origin", Color8(172, 50, 50, 255))
		$Sprite.material.set_shader_param("new", Color.lightblue)
		
		$Sprite.material.set_shader_param("origin2", Color8(112, 39, 39, 255))
		$Sprite.material.set_shader_param("new2", Color.blanchedalmond)
		
		$Sprite.material.set_shader_param("origin3", Color8(229, 67, 67, 255))
		$Sprite.material.set_shader_param("new3", Color.lightblue)
		pass
	else:
		$Sprite.set_material(null)
		pass
	pass

func newShake():
	aniCount = 0
	shakeAni()

func shakeAni():
	if(aniCount == 0):
		$AnimationPlayer.play('Shake')
		aniCount+=1
	if(aniCount < 5):
		aniCount+=1
	else:
		$AnimationPlayer.stop()
		$Sprite.offset = Vector2(0,0)
		aniCount = 0
	pass


