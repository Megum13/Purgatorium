extends Node2D

var start = false;
var textSpeed = 0.04;
var arrayIndex = 0;

var textArray = [
	"Что ж. Ты проиграл и не вернул желаемого - свою душу.",
	"Одним деревьям суждено зацвести, другим - умереть.",
	"Ваш, людской мир, несправедлив. И ты это знаешь.",
	"Но тут шанс исправиться дается всем. Использовать ли его - дело нечестивых.",
	"Здоровая душа обитает в здоровом теле и в здоровом уме.",
	"Твоя же - не очистилась. Ты вернешься в прах, из которого был сотворен.",
];

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Start");
	await get_tree().create_timer(4).timeout;
	start = true;
	pass # Replace with function body.

var d = 0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!start): return;
	d += delta;
	
	if(d > textSpeed):
		$Control/CanvasLayer/RichTextLabel.visible_characters+=1;
		d = 0;
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if($Control/CanvasLayer/RichTextLabel.visible_ratio >= 0.9):
				arrayIndex += 1;
				if (arrayIndex > len(textArray)-1):
					$AnimationPlayer.play("End");
					await $AnimationPlayer.animation_finished;
					$Control/CanvasLayer2.visible = true;
				else:
					
					$Control/CanvasLayer/RichTextLabel.visible_ratio = 0;
					$Control/CanvasLayer/RichTextLabel.text = textArray[arrayIndex];
				
				

#Restart
func _on_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().change_scene_to_file("res://LandingPage.tscn");
	pass # Replace with function body.

#Exit
func _on_button_2_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().quit();
	pass # Replace with function body.
