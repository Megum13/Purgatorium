extends Node2D

var rotationSpeed = randf_range(0.0018,0.0025);
var isQeue = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Mozgi.play();
	if randi_range(0,1) == 0: rotationSpeed = -rotationSpeed;
	$RigidBody2D.apply_impulse(Vector2(randi_range(-350,350),-randi_range(-300,450)),Vector2(0,0));
	$RigidBody2D/Node2D.get_children()[randi_range(0,1)].visible = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RigidBody2D/Node2D.rotate(rotationSpeed);
	if $RigidBody2D.position.y >= 1100 and !isQeue:
		isQeue = true;
		queue_free();
		pass;
	pass
