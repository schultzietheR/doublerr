extends VehicleBody

export var torque = 250
export var steer_angle = .5
export var max_wheel_rpm = 200
export var max_torque = 500

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("steerright","steerleft") * steer_angle, 5*delta)
	var acceleration = Input.get_axis("brake","accelerate")
	var wheel_rpm = abs($rear_left_wheel.get_rpm())
	$rear_left_wheel.engine_force = acceleration * max_torque * (1-wheel_rpm/max_wheel_rpm)
	wheel_rpm = abs($rear_right_wheel.get_rpm())
	$rear_right_wheel.engine_force = acceleration * max_torque * (1-wheel_rpm/max_wheel_rpm)
	engine_force = acceleration * torque
