extends RefCounted

## A PID Controller based off of theory and examples. This version is for Vector3 control.
##
## A PID controller continuously calculates an error value e ( t ) e(t) as the difference between 
## a desired setpoint (SP) and a measured process variable (PV) and applies a correction based on 
## proportional, integral, and derivative terms (denoted P, I, and D respectively), hence the name. 
## [br]
## I am "making" this one, mostly for good practice [br]
## includes links to said examples
##
## @tutorial(Wikipedia on PID): https://en.wikipedia.org/wiki/PID_controller
## @tutorial(Game Fabric Example): https://www.youtube.com/watch?v=zTp7bWnlicY 
## @tutorial(DarkEngineer Example): https://github.com/fire/godot-pid/tree/master
## @tutorial(): 

class_name PID_Controller_Vector3

var _proportional: float
var _integral: float
var _derivative: float

var _prev_error: Vector3 = Vector3.ZERO
var _error_integral: Vector3 = Vector3.ZERO
var _integral_max: Vector3

func _init(p: float, i: float, d: float, i_max: float) -> void:
	_proportional = p
	_integral = i
	_derivative = d
	_integral_max = Vector3(i_max, i_max, i_max)

## Main controller formula, returning the output vector
func update(setpoint: Vector3, process_variable: Vector3, delta: float) -> Vector3:
	var error = setpoint - process_variable
	var P_out = _proportional * error
	
	_error_integral += error * delta
	var I_out = _integral * _error_integral
	
	var error_derivative = (error - _prev_error) / delta
	var D_out = _derivative * error_derivative
	var output = P_out + I_out + D_out
	
	_error_integral = _error_integral.clamp(-_integral_max, _integral_max)
	
	_prev_error = error
	
	return output
	
## A function to reset internal "error integral"
func reset_integral():
	_error_integral = Vector3.ZERO
