extends Node2D

var start = false;
var textSpeed = 0.04;
var arrayIndex = 0;

var textArray = [
	"Не могу в это поверить. Моя душа снова со мной.",
	"Она еще не окрепла, но я чувствую, как она пульсирует и восстанавливает силы.",
	"Однажды мне сказали, что человеческую природу так просто не изменить.",
	"Смотря на себя, я всегда соглашался с этим утверждением до самой смерти.",
	"Но сейчас мне дали шанс исправить роковые ошибки, и я его использовал.",
	"Теперь я обещаю, что не отступлюсь. И закончу начатое.",
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
