extends Node2D

var flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !flag:
		$Logo.modulate.a += delta * 0.8
		if $Logo.modulate.a >= 1:
			if $Timer.is_stopped():
				$Timer.start()
	if flag:
		$Logo.modulate.a -= delta * 0.8
	if $Logo.modulate.a < 0:
		get_tree().change_scene_to_file("Door.tscn")
	pass


func _on_timer_timeout():
	flag = true
	pass # Replace with function body.
