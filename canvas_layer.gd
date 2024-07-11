extends CanvasLayer

var busIndex: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	busIndex = AudioServer.get_bus_index("Master")
	pass


func _on_h_slider_changed():
		AudioServer.set_bus_volume_db(0,linear_to_db($HSlider.value)) 

