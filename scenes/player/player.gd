extends RigidBody3D

@export var Speed: float = 500
@export var Jump: float = 5
@export var JetpackSpeed: float = 10

@export var P_gain: float = 1.0
@export var I_gain: float = 0.0
@export var D_gain: float = 1.0
@export var I_max: float = 300.0
@export var correction_impulse_scaler: float = 1e-2

var _pid : PID_Controller_Vector3 = PID_Controller_Vector3.new(P_gain, I_gain, D_gain, I_max)
#a case where implied type may be best. 

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		apply_central_impulse(Jump * (transform.basis * Vector3.UP) * mass)
		
	var input_direction: Vector2 = Input.get_vector("foreward", "backward", "right", "left")
#	var direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized() # A
#	var direction: Vector3 = transform.basis * Vector3(input_direction.x, 0.0, input_direction.y) # B
	var direction: Vector3 = Vector3(input_direction.x, 0.0, input_direction.y) # C

	var desired_velocity = Speed * direction
	var no_y_linear_velocity = linear_velocity
	no_y_linear_velocity.y = 0.0
	
	
	var correction_force: Vector3 = _pid.update(desired_velocity, no_y_linear_velocity, delta)
#	apply_central_force(correction_force)
	apply_central_force(desired_velocity)
	
	
	
#	var correction_impulse = mass * _pid.update(desired_velocity, no_y_linear_velocity, delta) \
#		* correction_impulse_scaler
	#correction_impulse = correction_impulse.normalized() * min(correction_impulse.length(), 0.5)
#	apply_central_impulse(correction_impulse)

