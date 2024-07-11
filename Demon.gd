extends Node2D

const eyeLerpSpeed = 4;
var isEyeShaking = false; 
var randomEyeMoving = false;
var eyeMode = -1;
var gunGrabed = false;
var isEnter = false;
var choise = 0; # 0 - player, 1 - demon
var isReadyToFire = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var s = 0; # Demon sin
var d = 0; # delta
var eyesCoordArray = [Vector2(0,-3000),Vector2(3000,3000),Vector2(3000,-3000),Vector2(-3000,-3000),Vector2(3000,-2500),Vector2(0,3000)];  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d+= delta;
	if (!isEyeShaking): eyeUpdate(delta);
	else: if (isEyeShaking): eyeShaking();
	demonMoving(delta);
	
	if (randomEyeMoving and d >= 26):
		d = 0;
		eyeMode = randi_range(0,4);
		pass;
	
	if(eyeMode == 0):
		setEyesCoord(Vector2(randi_range(-800,800),randi_range(-800,800)));
		eyeMode = -1;
		pass;
	else: if(eyeMode == 1):
		setEyesCoord(get_local_mouse_position());
		pass;
	else: if(eyeMode == 2):
		setEyesCoord(Vector2(0,0));
		pass;
	else: if(eyeMode == 3):
		setEyesCoord(Vector2(0,600));
		pass;
	else: if(eyeMode == 4):
		setEyesCoord(Vector2(-600,0));
		pass;
	
	pass;

# 0 - Eye, 1 - CatEye
func eyeSwitch(index):
	if(index == 0):
		$CatEye.visible = false;
		$Eye.visible = true;
	else: if(index == 1):
		$CatEye.visible = true;
		$Eye.visible = false;
	else:
		push_error();
	d = 0;
	setEyesCoord(Vector2(0,0));
	pass
	
func setEyeShaking(b: bool):
	isEyeShaking = b;
	pass;

func eyeShaking():
	var actualaEye = _getActualEye();
	var eyeArray = actualaEye.get_children(false);
	for i in eyeArray:
		i.position = Vector2(randi_range(-1,1),randi_range(-1,1));
		pass;
	pass

func _getActualEye():
	var eyeTree = $CatEye;
	if ($CatEye.visible == false):
		eyeTree = $Eye;
	return eyeTree;

func demonMoving(delta):
	s += delta * 2
	if s >= PI*2:
		s = 0
	position.y = sin(s) * 8
	pass;

func eyeUpdate(delta):
	var actualaEye = _getActualEye();
	var eyeArray = actualaEye.get_children(false);
	for i in len(eyesCoordArray):
		eyeArray[i].position = eyeArray[i].position.lerp(Vector2(eyesCoordArray[i].x / (1920/18), eyesCoordArray[i].y/(1080/18)), delta * eyeLerpSpeed);
		pass;
	pass;

func setEyesCoord(vec2: Vector2):
	for i in len(eyesCoordArray):
		eyesCoordArray[i] = vec2;
		pass;
	pass;

func setEyeCoord(vec2: Vector2, index: int):
	eyesCoordArray[index] = vec2;
	pass;


func _on_node_2d_gun_grabed():
	gunGrabed = true;
	choise = 0;
	pass # Replace with function body.
	
func _on_area_2d_mouse_entered():
	if (!gunGrabed):return;
	isReadyToFire = false;
	choise = 1;
	get_parent().get_node("Player/AnimationPlayer").play("RESET");
	await get_parent().get_node("Player/AnimationPlayer").animation_finished
	get_parent().get_node("Player/AnimationPlayer").play("PlayerToDemon");
	await get_parent().get_node("Player/AnimationPlayer").animation_finished
	isReadyToFire = true;
	pass # Replace with function body.

func _on_area_2d_mouse_exited():
	$Ebaka10.material.set_shader_parameter("on",false);
	if (!gunGrabed):return;
	isReadyToFire = false;
	choise = 0;
	isEnter = false;
	get_parent().get_node("Player/AnimationPlayer").play("RESET");
	await get_parent().get_node("Player/AnimationPlayer").animation_finished
	get_parent().get_node("Player/AnimationPlayer").play("DemonToPlayer");
	await get_parent().get_node("Player/AnimationPlayer").animation_finished
	isReadyToFire = true;
	pass # Replace with function body.

signal choiseSignal
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion and gunGrabed: 
		$Ebaka10.material.set_shader_parameter("on",true);
		$Ebaka10.material.set_shader_parameter("line_thickness",2);
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and gunGrabed and isReadyToFire:
			choiseSignal.emit(choise);
			gunGrabed = false;

func offRedLine():
	$Ebaka10.material.set_shader_parameter("on",false);
	$Ebaka10.material.set_shader_parameter("line_thickness",0);
	pass;
