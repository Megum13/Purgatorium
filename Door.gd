extends Node2D

var startDelta = 2.5 # Секунды до начала  
var isCameraZoomAnimation = false 
var zoom = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasGroup.modulate.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if startDelta >0:
		startDelta -= delta
	if $CanvasGroup.modulate.a < 1 and startDelta < 0:
		$CanvasGroup.modulate.a += delta * 0.4
	if isCameraZoomAnimation:
		$Camera2D.zoom = Vector2(zoom,zoom)
		zoom += delta * 1.8 
	pass

func _input(event):
	if $CanvasGroup.modulate.a >= 0.15 and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$AnimationPlayer.play("MoveStart");
			await $AnimationPlayer.animation_finished;
			get_tree().change_scene_to_file("Main.tscn")
	pass
