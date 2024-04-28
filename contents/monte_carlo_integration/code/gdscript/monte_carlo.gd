extends Node

func _ready() -> void:
	var pi_estimate := monte_carlo(100000)
	var percent_error := 100 * abs(PI - pi_estimate) / PI

	print("The estimate of pi is: %.3f" % pi_estimate)
	print("The percent error is: %.3f" % percent_error)

func in_circle(position: Vector2, radius: float = 1) -> bool:
	return position.x * position.x + position.y * position.y < radius

func monte_carlo(sample_count: int, radius: float = 1) -> float:
	var in_circle_count : int = 0

	for i in sample_count:
		var test_pos := Vector2(randf_range(0, radius), randf_range(0, radius))

		if in_circle(test_pos, radius):
			in_circle_count += 1

	var pi_estimate := 4.0 * in_circle_count / float(sample_count)

	return pi_estimate
