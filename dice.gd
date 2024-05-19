extends RigidBody3D
class_name Dice

@export var start_marker: Marker3D

func random_throw() -> void:
	global_position = start_marker.global_transform.origin
	linear_velocity = Vector3(0, 0, 0)
	angular_velocity = Vector3(0, 0, 0)
	var lateral_variation = .04
	apply_central_impulse(Vector3(randf_range(-.08,-.14), randf_range(-lateral_variation, lateral_variation), randf_range(-lateral_variation, lateral_variation)))
	var angular_variation = .02
	apply_torque_impulse(Vector3(randf_range(-angular_variation, angular_variation),randf_range(-angular_variation, angular_variation),randf_range(-angular_variation, angular_variation)))

func can_be_thrown() -> bool:
	return sleeping

var dice_map := [
	Vector3.UP,
	Vector3.RIGHT,
	Vector3.FORWARD,
	Vector3.BACK,
	Vector3.LEFT,
	Vector3.DOWN
]

func get_value() -> int:
	var rot = Vector3.UP * global_basis
	var closest = -1
	var closest_dist = 1000

	for i in range(6):
		var dist = rot.distance_to(dice_map[i])
		if dist < closest_dist:
			closest = i
			closest_dist = dist

	return closest + 1
