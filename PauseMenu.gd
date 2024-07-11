extends Control


func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and get_tree().paused and $CanvasLayer.visible:
			get_tree().paused = false;
			$CanvasLayer.visible = false;
			pass;
		else: if event.keycode == KEY_P and get_tree().paused and $CanvasLayer.visible:
			$Burenyy.play();
			get_tree().paused = false;
			await $Burenyy.finished;
			
			get_tree().change_scene_to_file("Main.tscn");
			
	pass;


func _on_button_pressed():
	get_tree().quit();
	pass # Replace with function body.

func _on_button_2_pressed():
	get_tree().paused = false;
	$CanvasLayer.visible = false;
	pass # Replace with function body.


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value));
	AudioServer.set_bus_mute(0, value < 0.01);
	pass # Replace with function body.
