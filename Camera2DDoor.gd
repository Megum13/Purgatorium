extends Camera2D

var speedY = 0
var s = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	s += delta * 2
	if s >= PI*2:
		s = 0
	
	position.y = sin(s) * 8
	pass
