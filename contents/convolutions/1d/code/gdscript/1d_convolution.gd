extends Node

func _ready() -> void:
	var x := create_sawtooth(200)
	var y := create_sawtooth(200)

	normalize(x)
	normalize(y)

	# full convolution, output will be the size of x + y - 1
	var full_linear_output := convolve_linear(x.duplicate(), y.duplicate(), x.size() + y.size() - 1)

	# simple boundaries
	var simple_linear_output := convolve_linear(x.duplicate(), y.duplicate(), x.size())

	# cyclic convolution
	var cyclic_output := convolve_cyclic(x.duplicate(), y.duplicate())

	store_to_file("full_linear.dat", full_linear_output)
	store_to_file("simple_linear.dat", simple_linear_output)
	store_to_file("cyclic.dat", cyclic_output)


func convolve_linear(signal_arr: PackedFloat64Array, filter_arr: PackedFloat64Array, output_size: int) -> PackedFloat64Array:
	var output: PackedFloat64Array = []
	var sum: float = 0
	output.resize(output_size)

	for i in output_size:
		for j in range(max(0, i - filter_arr.size()), i + 1):
			if j < signal_arr.size() and (i - j) < filter_arr.size():
				sum += signal_arr[j] * filter_arr[i - j]
		output[i] = sum
		sum = 0

	return output


func convolve_cyclic(signal_arr: PackedFloat64Array, filter_arr: PackedFloat64Array) -> PackedFloat64Array:
	var output: PackedFloat64Array = []
	var output_size : int = max(signal_arr.size(), filter_arr.size())
	var sum: float = 0
	output.resize(output_size)

	for i in output_size:
		for j in output_size:
			if mod1(i - j, output_size) < filter_arr.size():
				sum += signal_arr[mod1(j - 1, output_size)] * filter_arr[mod1(i - j, output_size)]

		output[i] = sum
		sum = 0

	return output


func create_sawtooth(size: int) -> PackedFloat64Array:
	var output: PackedFloat64Array = []
	output.resize(size)

	for i in size:
		output[i] = (i + 1) / 200.

	return output


# We don't need to return a value, as Arrays are passed by reference in GDScript
func normalize(array: PackedFloat64Array) -> void:
	var norm_value := norm(array)
	for i in array.size():
		array[i] /= norm_value


func norm(array: PackedFloat64Array) -> float:
	var sum: float = 0
	for i in array.size():
		sum += array[i] * array[i]
	return sqrt(sum)


func mod1(x: int, y: int) -> int:
	return ((x % y) + y) % y


func store_to_file(file_name: String, array: PackedFloat64Array) -> void:
	var file := FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(str(array).replace(", ", "\n").replace("[", "").replace("]", ""))
	file.close()
