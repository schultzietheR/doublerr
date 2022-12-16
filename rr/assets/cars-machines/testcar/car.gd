# I smashed up some code together from Bastiaan Olij (https://www.youtube.com/c/BastiaanOlij)
# and Jus'ko (https://www.youtube.com/channel/UCI2wrI4NV1zHtZhVMmnj-nQ).

# Problems so far:

# Car doesn't move
# No sound
# No smoke from drifting/oversteer

extends VehicleBody

	###########

export var horsePower = 200

	###########

export(Array, float) var gearRatios = [3.00, 2.50, 2.00, 1.50, 1.00]
export var finalDrive = 3.00
export var reverseRatio = -2.50
var currentGear = 0

export var autotrnsmis = false

func transmission():
	if Input.is_action_just_pressed("shiftup"):
		currentGear += 1
	elif Input.is_action_just_pressed("shiftdown"):
		currentGear -= 1

	for i in (gearRatios):
		i += currentGear
		horsePower *= ((gearRatios[currentGear])/finalDrive)

	if currentGear < 0:
		horsePower = horsePower * reverseRatio
	return horsePower

	###########

export var idleRPM = 800
export var RPMredline = 7000
export var peakRPM = 10000
var engineRPM = idleRPM

func getRPM():
	if Input.is_action_just_pressed("gas"):
		engineRPM +=10
		horsePower = horsePower * (engineRPM/1000)
	elif Input.is_action_just_released("gas"):
		engineRPM -=10
		horsePower = horsePower * (engineRPM/1000)
	elif Input.is_action_just_released("gas") and engineRPM <= idleRPM:
		engineRPM = idleRPM

	###########


export var turbocharger = false
export var p_s_i = false
export var EV_Motor = false
export var EV_Power = false

func turbo():
	var turbopower = Input.get_action_strength("gas")
	if turbocharger:
		horsePower = horsePower + ((p_s_i * turbopower)/2)
		if EV_Motor:
			horsePower = horsePower + (EV_Power + ((p_s_i * turbopower)/2))
	elif EV_Motor:
		horsePower = horsePower + EV_Power
	else:
		horsePower = horsePower
	return horsePower

	###########

export var steerAngle = deg2rad(25)
var steerSpeed = 3

export var brakePower = 40
var brakeSpeed = 40

	###########

var throtMult = 1
var steerMult = 1
var brakeMult = 1

func _physics_process(delta):
	
	###########
	
	var throtInput = Input.get_action_strength("gas")
	var carpower = (engine_force * horsePower * throtInput * delta)
	engine_force = carpower

	###########

	var steerInput = steerMult * (Input.get_action_strength("left")-Input.get_action_strength("right"))
	steering = lerp_angle(steering,steerInput*steerAngle,steerSpeed*delta)

	###########

	var brakeInput = brakeMult * Input.get_action_strength("brake")
	brake = lerp(brake,brakeInput*brakePower,brakeSpeed*delta)

	###########
