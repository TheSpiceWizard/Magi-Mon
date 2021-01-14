extends Node2D


#The only point of this script is to receive input from the Board node about
#Where overlays should go. This is mostly used for showing where pieces can move to.
var overlayCells = []
var draw = true
var overlayColor = Color8(50,80,36,255)
var board

var isShowingDefended = false

var shieldSprite = preload('res://Assets/Scenes/ShieldSprite.tscn')
var redShieldSprite = preload('res://Assets/Scenes/RedShieldSprite.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	board = get_parent()
	pass # Replace with function body.

func undrawOverlay():
	draw = false
	update()
	pass

func drawOverlay(cellPositions, oColor):
	overlayCells = cellPositions
	overlayColor = oColor
	draw = true
	update()
	pass

func drawDefended(CellPositions):
	if(!isShowingDefended):
		for c in CellPositions:
			for sc in c:
				if(sc.size() > 1):
					var newSprite
					if(sc[1] == 2):
						newSprite = shieldSprite.instance()
						newSprite.position = board.map_to_world(Vector2(sc[0].x, sc[0].y))
					if(sc[1] == 1):
						newSprite = redShieldSprite.instance()
						newSprite.position = board.map_to_world(Vector2(sc[0].x, sc[0].y))
					add_child(newSprite)
	else:
		undrawDefended()
	isShowingDefended = !isShowingDefended

func undrawDefended():
	#TODO
	Util.delete_children(self)
	pass

func _draw():
	if(draw):
		var newPosition
		for c in overlayCells:
			newPosition = board.map_to_world(c)
			draw_rect(Rect2(newPosition,Vector2(64,64)), overlayColor)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
